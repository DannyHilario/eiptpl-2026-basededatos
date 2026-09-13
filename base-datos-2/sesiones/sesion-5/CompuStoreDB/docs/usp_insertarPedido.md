# `usp_insertarPedido`

Script: [`instalacion/06-Pedido/02-usp-insertar.sql`](../instalacion/06-Pedido/02-usp-insertar.sql)

Alta de un pedido.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente que hace el pedido |
| `@p_Fecha` | `date` | Fecha del pedido |

## Validaciones (orden en que se evalúan)

1. El cliente debe existir.
2. El cliente debe estar activo (`Activo = 1`) — no tiene sentido levantar un pedido a un cliente dado de baja.
3. `Fecha` no puede ser futura (`@p_Fecha < GETDATE()`).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El cliente no existe | `idCliente` inválido |
| `000002` | El cliente está dado de baja | Cliente con `Activo = 0` |
| `000003` | La fecha no puede ser pasada | `Fecha` fuera de rango |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'

-- Cliente no existe
EXEC usp_insertarPedido @p_idCliente = 9999, @p_Fecha = '2026-09-15'

-- Cliente dado de baja (requiere UPDATE previo)
UPDATE Cliente SET Activo = 0 WHERE idCliente = 2
EXEC usp_insertarPedido @p_idCliente = 2, @p_Fecha = '2026-09-15'
UPDATE Cliente SET Activo = 1 WHERE idCliente = 2 -- dejar como estaba

-- Fecha fuera de rango
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2020-01-01'
```
