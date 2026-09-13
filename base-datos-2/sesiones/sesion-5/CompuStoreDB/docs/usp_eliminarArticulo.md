# `usp_eliminarArticulo`

Script: [`instalacion/02-Articulo/04-usp-eliminar.sql`](../instalacion/02-Articulo/04-usp-eliminar.sql)

Baja lógica de un artículo (`Activo = 0`). No borra el registro físicamente.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo a dar de baja |

## Validaciones

1. El artículo debe existir.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no existe | `idArticulo` inválido |
| `000000` | Eliminación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_eliminarArticulo @p_idArticulo = 1
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarArticulo @p_idArticulo = 1
SELECT Activo FROM Articulo WHERE idArticulo = 1 -- debe ser 0

-- Artículo no existe
EXEC usp_eliminarArticulo @p_idArticulo = 9999
```
