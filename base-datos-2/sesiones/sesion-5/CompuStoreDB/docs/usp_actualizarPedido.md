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
2. `Fecha` no puede ser pasada (`@p_Fecha < GETDATE()`), igual que en `usp_insertarPedido`.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |
| `000002` | La fecha no puede ser pasada | `Fecha` fuera de rango |
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

-- Limpieza
EXEC usp_eliminarPedido @p_idPedido = @idPedidoPrueba
```
