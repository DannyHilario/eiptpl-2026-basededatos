# `usp_actualizarCategoria`

Script: [`instalacion/01-Categoria/06-usp-actualizar.sql`](../instalacion/01-Categoria/06-usp-actualizar.sql)

Actualiza el nombre de una categoría existente.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCategoria` | `int` | Id de la categoría a actualizar |
| `@p_Nombre` | `varchar(50)` | Nombre nuevo |

## Validaciones (orden en que se evalúan)

1. La categoría debe existir.
2. `Nombre` no debe estar registrado por **otra** categoría (`idCategoria <> @p_idCategoria` — la misma categoría sí puede "actualizar" con el nombre que ya tenía).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La categoría no existe | `idCategoria` inválido |
| `000002` | El nombre ya está registrado por otra categoría | `Nombre` duplicado |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_actualizarCategoria @p_idCategoria = 1, @p_Nombre = 'Laptops y Ultrabooks'
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarCategoria @p_idCategoria = 1, @p_Nombre = 'Laptops y Ultrabooks'

-- Categoría no existe
EXEC usp_actualizarCategoria @p_idCategoria = 9999, @p_Nombre = 'X'

-- Nombre de otra categoría (usa el nombre de idCategoria = 2)
DECLARE @NombreCategoria2 varchar(50) = (SELECT Nombre FROM Categoria WHERE idCategoria = 2)
EXEC usp_actualizarCategoria @p_idCategoria = 1, @p_Nombre = @NombreCategoria2
```
