# `usp_eliminarPedido`

Script: [`instalacion/06-Pedido/03-usp-eliminar.sql`](../instalacion/06-Pedido/03-usp-eliminar.sql)

`Pedido` no tiene columna `Activo` (no es catálogo), así que esto es un `DELETE` físico, no baja lógica.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPedido` | `int` | Id del pedido a eliminar |

## Validaciones (orden en que se evalúan)

1. El pedido debe existir.
2. El pedido no debe tener líneas registradas en `DetallePedido` — para no violar la FK `fk_DetallePedido_Pedido` ni borrar información silenciosamente.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El pedido no existe | `idPedido` inválido |
| `000002` | El pedido tiene líneas registradas y no puede eliminarse | Existen renglones en `DetallePedido` |
| `000000` | Eliminación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_eliminarPedido @p_idPedido = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar un pedido de prueba
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)

-- Éxito
EXEC usp_eliminarPedido @p_idPedido = @idPedidoPrueba

-- Pedido no existe
EXEC usp_eliminarPedido @p_idPedido = 9999

-- Pedido con líneas en DetallePedido (requiere insertar un renglón primero)
```
