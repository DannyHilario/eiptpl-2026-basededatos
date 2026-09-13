# `usp_eliminarCliente`

Script: [`instalacion/05-Cliente/04-usp-eliminar.sql`](../instalacion/05-Cliente/04-usp-eliminar.sql)

Baja lógica de un cliente (`Activo = 0`). No borra el registro físicamente.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente a dar de baja |

## Validaciones

1. El cliente debe existir.

## Efecto

`UPDATE Cliente SET Activo = 0, FechaUltimaModificacion = GETDATE() WHERE idCliente = @p_idCliente`

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El cliente no existe | `idCliente` inválido |
| `000000` | Eliminación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_eliminarCliente @p_idCliente = 1
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarCliente @p_idCliente = 1
SELECT Activo FROM Cliente WHERE idCliente = 1 -- debe ser 0

-- Cliente no existe
EXEC usp_eliminarCliente @p_idCliente = 9999
```
