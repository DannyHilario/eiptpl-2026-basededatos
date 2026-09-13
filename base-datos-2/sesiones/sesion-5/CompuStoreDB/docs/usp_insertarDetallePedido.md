# `usp_insertarDetallePedido`

Script: [`instalacion/07-DetallePedido/02-usp-insertar.sql`](../instalacion/07-DetallePedido/02-usp-insertar.sql)

Agrega una línea (artículo + cantidad) a un pedido existente. **Si el artículo ya está en ese pedido, no crea una línea duplicada: suma la cantidad a la línea existente.**

**El precio no se recibe como parámetro.** Al crear una línea nueva, el SP toma `Articulo.PrecioUnitario` vigente en ese momento y lo copia a `DetallePedido.PrecioUnitario` — así queda congelado el precio real de esa venta aunque el precio de lista cambie después (mismo criterio que `usp_insertarHistoricoPrecioArticulo` con `PrecioAnterior`). Nadie puede insertar una línea con un precio inventado. Cuando se fusiona con una línea existente, el `PrecioUnitario` de esa línea **no se toca** — es el precio que quedó pactado la primera vez que se agregó ese artículo a este pedido; agregar más unidades después no lo cambia.

La tabla tiene `UNIQUE(idPedido, idArticulo)` — la fusión en el SP es lo que hace posible respetar esa restricción sin que el `INSERT` falle por duplicado.

No se valida contra existencias/inventario: el modelo de `CompuStoreDB` no tiene una columna de stock en `Articulo`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido al que se agrega la línea |
| `@p_idArticulo` | `int` | Id del artículo |
| `@p_Cantidad` | `int` | Cantidad a agregar (se suma a la línea existente si ya había una para ese artículo) |

## Validaciones (orden en que se evalúan)

1. El pedido debe existir.
2. El pedido no debe estar entregado (`Cerrado = 1`, ver [`usp_entregarPedido`](usp_entregarPedido.md)).
3. El artículo debe existir.
4. El artículo debe estar activo (`Activo = 1`) — no se debe poder vender algo dado de baja.
5. `Cantidad` debe ser mayor a cero.
6. Si ya existe una línea con ese `idPedido`+`idArticulo`, se fusiona (`UPDATE Cantidad = Cantidad + @p_Cantidad`) en vez de insertar.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |
| `000002` | El pedido ya fue entregado y no admite nuevas líneas | `Cerrado = 1` |
| `000003` | El artículo no existe | `idArticulo` inválido |
| `000004` | El artículo está dado de baja | Artículo con `Activo = 0` |
| `000005` | La cantidad debe ser mayor a cero | `Cantidad <= 0` |
| `000000` | Inserción correcta | Éxito — línea nueva |
| `000000` | Cantidad sumada a la línea existente | Éxito — se fusionó con una línea que ya existía |

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

-- Fusión: repetir el mismo artículo suma a la línea existente, no crea una segunda línea
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 3
SELECT COUNT(*) AS NumeroDeLineas, SUM(Cantidad) AS CantidadTotal
FROM DetallePedido WHERE idPedido = @idPedidoPrueba AND idArticulo = 1
-- Debe dar NumeroDeLineas = 1, CantidadTotal = 5 (2 + 3)

-- Pedido ya entregado
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1
```
