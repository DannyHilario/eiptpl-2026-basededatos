# `usp_actualizarDetallePedido`

Script: [`instalacion/07-DetallePedido/04-usp-actualizar.sql`](../instalacion/07-DetallePedido/04-usp-actualizar.sql)

Actualiza únicamente la `Cantidad` de una línea de pedido existente.

**No permite cambiar** `idPedido`, `idArticulo` ni `PrecioUnitario`: cambiar de artículo o de pedido es conceptualmente "otra línea" (mismo criterio que `usp_actualizarPedido` no reasigna `idCliente`), y el precio queda congelado al momento de la venta — es el registro histórico de cuánto se cobró, no se debe poder editar después.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idDetallePedido` | `int` | Id de la línea a actualizar |
| `@p_Cantidad` | `int` | Cantidad nueva |

## Validaciones (orden en que se evalúan)

1. La línea debe existir.
2. El pedido al que pertenece esa línea no debe estar entregado (`Cerrado = 1`, ver [`usp_entregarPedido`](usp_entregarPedido.md)).
3. `Cantidad` nueva debe ser mayor a cero.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La línea de pedido no existe | `idDetallePedido` inválido |
| `000002` | El pedido ya fue entregado y no admite cambios en sus líneas | El `Pedido` dueño de la línea tiene `Cerrado = 1` |
| `000003` | La cantidad debe ser mayor a cero | `Cantidad <= 0` |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_actualizarDetallePedido @p_idDetallePedido = 1, @p_Cantidad = 5
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido de prueba con una línea
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1
DECLARE @idDetallePrueba int = (SELECT MAX(idDetallePedido) FROM DetallePedido WHERE idPedido = @idPedidoPrueba)

-- Éxito
EXEC usp_actualizarDetallePedido @p_idDetallePedido = @idDetallePrueba, @p_Cantidad = 5

-- Línea no existe
EXEC usp_actualizarDetallePedido @p_idDetallePedido = 9999, @p_Cantidad = 1

-- Cantidad inválida
EXEC usp_actualizarDetallePedido @p_idDetallePedido = @idDetallePrueba, @p_Cantidad = 0

-- Pedido ya entregado
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
EXEC usp_actualizarDetallePedido @p_idDetallePedido = @idDetallePrueba, @p_Cantidad = 10
```
