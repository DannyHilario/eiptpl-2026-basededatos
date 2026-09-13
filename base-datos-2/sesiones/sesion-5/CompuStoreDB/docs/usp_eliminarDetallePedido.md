# `usp_eliminarDetallePedido`

Script: [`instalacion/07-DetallePedido/03-usp-eliminar.sql`](../instalacion/07-DetallePedido/03-usp-eliminar.sql)

Elimina una línea de un pedido (`DELETE` físico — `DetallePedido` no tiene columna `Activo`).

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idDetallePedido` | `int` | Id de la línea a eliminar |

## Validaciones (orden en que se evalúan)

1. La línea debe existir.
2. El pedido al que pertenece esa línea no debe estar entregado (`Cerrado = 1`, ver [`usp_entregarPedido`](usp_entregarPedido.md)) — el SP resuelve el `idPedido` de la línea internamente para hacer esta validación.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La línea de pedido no existe | `idDetallePedido` inválido |
| `000002` | El pedido ya fue entregado y no admite cambios en sus líneas | El `Pedido` dueño de la línea tiene `Cerrado = 1` |
| `000000` | Eliminación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_eliminarDetallePedido @p_idDetallePedido = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido de prueba con una línea
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1
DECLARE @idDetallePrueba int = (SELECT MAX(idDetallePedido) FROM DetallePedido WHERE idPedido = @idPedidoPrueba)

-- Éxito
EXEC usp_eliminarDetallePedido @p_idDetallePedido = @idDetallePrueba

-- Línea no existe
EXEC usp_eliminarDetallePedido @p_idDetallePedido = 9999

-- Pedido ya entregado (preparar otra línea, entregar el pedido, e intentar quitarla)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 1
DECLARE @idDetallePrueba2 int = (SELECT MAX(idDetallePedido) FROM DetallePedido WHERE idPedido = @idPedidoPrueba)
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba
EXEC usp_eliminarDetallePedido @p_idDetallePedido = @idDetallePrueba2
```
