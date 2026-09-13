# `usp_eliminarCategoria`

Script: [`instalacion/01-Categoria/04-usp-eliminar.sql`](../instalacion/01-Categoria/04-usp-eliminar.sql)

Baja lógica de una categoría (`Activo = 0`). No borra el registro físicamente.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCategoria` | `int` | Id de la categoría a dar de baja |

## Validaciones

1. La categoría debe existir.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La categoría no existe | `idCategoria` inválido |
| `000000` | Eliminación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_eliminarCategoria @p_idCategoria = 1
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarCategoria @p_idCategoria = 1
SELECT Activo FROM Categoria WHERE idCategoria = 1 -- debe ser 0

-- Categoría no existe
EXEC usp_eliminarCategoria @p_idCategoria = 9999
```
