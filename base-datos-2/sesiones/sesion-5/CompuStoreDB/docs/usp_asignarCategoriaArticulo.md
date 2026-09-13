# `usp_asignarCategoriaArticulo`

Script: [`instalacion/03-ArticuloCategoria/03-usp-asignar.sql`](../instalacion/03-ArticuloCategoria/03-usp-asignar.sql)

Asigna una categoría a un artículo (inserta el renglón en la tabla puente `ArticuloCategoria`). Un artículo puede tener varias categorías (N:N).

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idArticulo` | `int` | Id del artículo |
| `@p_idCategoria` | `int` | Id de la categoría a asignar |

## Validaciones (orden en que se evalúan)

1. El artículo debe existir.
2. La categoría debe existir.
3. Esa combinación artículo-categoría no debe existir ya (mismo criterio que el `UNIQUE (idArticulo, idCategoria)` de la tabla).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El artículo no existe | `idArticulo` inválido |
| `000002` | La categoría no existe | `idCategoria` inválido |
| `000003` | El artículo ya está asignado a esa categoría | Relación duplicada |
| `000000` | Asignación correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3

-- Artículo no existe
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 9999, @p_idCategoria = 3

-- Categoría no existe
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 9999

-- Relación duplicada (correr el primero dos veces)
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 3
```
