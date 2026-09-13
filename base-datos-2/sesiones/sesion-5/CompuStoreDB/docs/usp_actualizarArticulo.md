# `usp_actualizarArticulo`

Script: [`instalacion/02-Articulo/07-usp-actualizar.sql`](../instalacion/02-Articulo/07-usp-actualizar.sql)

Actualiza `Nombre` y `Marca` de un artículo existente. No toca `PrecioUnitario` — para eso está [`usp_actualizarPrecioArticulo`](usp_actualizarPrecioArticulo.md).

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo a actualizar |
| `@p_Nombre` | `varchar(100)` | Nombre nuevo |
| `@p_Marca` | `varchar(50)` | Marca nueva |

## Validaciones (orden en que se evalúan)

1. El artículo debe existir.
2. La combinación `Nombre`+`Marca` no debe estar registrada por **otro** artículo (`idArticulo <> @p_idArticulo` — el mismo artículo sí puede "actualizar" con los valores que ya tenía).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no existe | `idArticulo` inválido |
| `000002` | Ya existe otro artículo registrado con ese nombre y marca | `Nombre`+`Marca` duplicado |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_actualizarArticulo @p_idArticulo = 1, @p_Nombre = 'Mouse inalámbrico Pro', @p_Marca = 'Logitech'
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarArticulo @p_idArticulo = 1, @p_Nombre = 'Mouse inalámbrico Pro', @p_Marca = 'Logitech'

-- Artículo no existe
EXEC usp_actualizarArticulo @p_idArticulo = 9999, @p_Nombre = 'X', @p_Marca = 'Y'

-- Nombre+Marca de otro artículo (usa los de idArticulo = 2)
DECLARE @Nombre2 varchar(100), @Marca2 varchar(50)
SELECT @Nombre2 = Nombre, @Marca2 = Marca FROM Articulo WHERE idArticulo = 2
EXEC usp_actualizarArticulo @p_idArticulo = 1, @p_Nombre = @Nombre2, @p_Marca = @Marca2
```
