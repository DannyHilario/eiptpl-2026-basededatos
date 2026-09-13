# `usp_insertarDetallePedido`

Script: [`instalacion/07-DetallePedido/02-usp-insertar.sql`](../instalacion/07-DetallePedido/02-usp-insertar.sql)

Agrega una línea (artículo + cantidad) a un pedido existente.

**El precio no se recibe como parámetro.** El SP toma `Articulo.PrecioUnitario` vigente en el momento de la inserción y lo copia a `DetallePedido.PrecioUnitario` — así queda congelado el precio real de esa venta aunque el precio de lista cambie después (mismo criterio que `usp_insertarHistoricoPrecioArticulo` con `PrecioAnterior`). Nadie puede insertar una línea con un precio inventado.

El mismo artículo puede aparecer en varias líneas del mismo pedido — no se fusionan cantidades automáticamente; cada `EXEC` crea una línea nueva.

No se valida contra existencias/inventario: el modelo de `CompuStoreDB` no tiene una columna de stock en `Articulo`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido al que se agrega la línea |
| `@p_idArticulo` | `int` | Id del artículo |
| `@p_Cantidad` | `int` | Cantidad de ese artículo |

## Validaciones (orden en que se evalúan)

1. El pedido debe existir.
2. El pedido no debe estar entregado (`Cerrado = 1`, ver [`usp_entregarPedido`](usp_entregarPedido.md)).
3. El artículo debe existir.
4. El artículo debe estar activo (`Activo = 1`) — no se debe poder vender algo dado de baja.
5. `Cantidad` debe ser mayor a cero.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |
| `000002` | El pedido ya fue entregado y no admite nuevas líneas | `Cerrado = 1` |
| `000003` | El artículo no existe | `idArticulo` inválido |
| `000004` | El artículo está dado de baja | Artículo con `Activo = 0` |
| `000005` | La cantidad debe ser mayor a cero | `Cantidad <= 0` |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarDetallePedido @p_idPedido = 1, @p_idArticulo = 1, @p_Cantidad = 2
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido de prueba
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)

-- Éxito (verificar que el PrecioUnitario copiado coincide con el de Articulo)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 2
SELECT dp.PrecioUnitario, a.PrecioUnitario AS PrecioArticuloActual
FROM DetallePedido dp JOIN Articulo a ON a.idArticulo = dp.idArticulo
WHERE dp.idPedido = @idPedidoPrueba

-- Pedido no existe
EXEC usp_insertarDetallePedido @p_idPedido = 9999, @p_idArticulo = 1, @p_Cantidad = 1

-- Artículo no existe
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 9999, @p_Cantidad = 1

-- Artículo dado de baja (requiere UPDATE previo)
UPDATE Articulo SET Activo = 0 WHERE idArticulo = 2
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 2, @p_Cantidad = 1
UPDATE Articulo SET Activo = 1 WHERE idArticulo = 2 -- dejar como estaba

-- Cantidad inválida
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 0

-- Pedido ya entregado
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1
```
