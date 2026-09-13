# `usp_actualizarPedido`

Script: [`instalacion/06-Pedido/04-usp-actualizar.sql`](../instalacion/06-Pedido/04-usp-actualizar.sql)

Actualiza la `Fecha` de un pedido existente. No permite reasignar `idCliente` — si el pedido es de otro cliente, se elimina y se crea uno nuevo.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido a actualizar |
| `@p_Fecha` | `date` | Fecha nueva |

## Validaciones (orden en que se evalúan)

1. El pedido debe existir.
2. El pedido no debe estar entregado (`Cerrado = 1`, ver [`usp_entregarPedido`](usp_entregarPedido.md)) — un pedido ya entregado queda congelado, no se le puede seguir modificando la fecha.
3. `Fecha` no puede ser pasada (`@p_Fecha < GETDATE()`), igual que en `usp_insertarPedido`.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |
| `000002` | El pedido ya fue entregado y no puede modificarse | `Cerrado = 1` |
| `000003` | La fecha no puede ser pasada | `Fecha` fuera de rango |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_actualizarPedido @p_idPedido = 1, @p_Fecha = '2026-09-20'
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido de prueba
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)

-- Éxito
EXEC usp_actualizarPedido @p_idPedido = @idPedidoPrueba, @p_Fecha = '2026-09-20'

-- Pedido no existe
EXEC usp_actualizarPedido @p_idPedido = 9999, @p_Fecha = '2026-09-20'

-- Fecha fuera de rango
EXEC usp_actualizarPedido @p_idPedido = @idPedidoPrueba, @p_Fecha = '2020-01-01'

-- Pedido ya entregado (requiere al menos una línea, ver usp_entregarPedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
EXEC usp_actualizarPedido @p_idPedido = @idPedidoPrueba, @p_Fecha = '2026-09-25'

-- Limpieza (el pedido ya entregado no se puede eliminar con usp_eliminarPedido; ver docs de ese SP)
```
