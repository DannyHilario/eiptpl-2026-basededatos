# `usp_habilitarCliente`

Script: [`instalacion/05-Cliente/05-usp-habilitar.sql`](../instalacion/05-Cliente/05-usp-habilitar.sql)

Reactiva (`Activo = 1`) un cliente que había sido dado de baja con `usp_eliminarCliente`.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente a reactivar |

## Validaciones

1. El cliente debe existir.
2. El cliente debe estar actualmente dado de baja (`Activo = 0`) — no se puede "habilitar" a alguien ya activo.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El cliente no existe | `idCliente` inválido |
| `000002` | El cliente ya está activo | Ya estaba `Activo = 1` |
| `000000` | Habilitación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_habilitarCliente @p_idCliente = 1
```

## Casos de prueba sugeridos

```sql
-- Preparar: dar de baja primero
EXEC usp_eliminarCliente @p_idCliente = 1

-- Éxito
EXEC usp_habilitarCliente @p_idCliente = 1

-- Ya está activo (correrlo dos veces seguidas)
EXEC usp_habilitarCliente @p_idCliente = 1

-- Cliente no existe
EXEC usp_habilitarCliente @p_idCliente = 9999
```
