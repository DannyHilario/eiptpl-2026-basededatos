# `vw_ArticuloConCategorias`

Script: [`instalacion/08-Vistas/02-vw-articulo-con-categorias.sql`](../../instalacion/08-Vistas/02-vw-articulo-con-categorias.sql)

Un renglón por cada combinación artículo-categoría asignada. No fusiona las categorías de un artículo en una sola celda (eso requeriría `STRING_AGG`/`FOR XML PATH`, fuera del temario de BD2) — si un artículo tiene 3 categorías, aparece en 3 renglones.

Solo incluye artículos que **sí tienen** al menos una categoría asignada (`INNER JOIN`); un artículo sin categorías no aparece en esta vista.

## Columnas

| Columna | Origen | Descripción |
|---------|--------|-------------|
| `idArticulo` | `Articulo` | Id del artículo |
| `Articulo` | `Articulo.Nombre` | Nombre del artículo |
| `Marca` | `Articulo` | Marca del artículo |
| `PrecioUnitario` | `Articulo` | Precio de lista vigente |
| `idCategoria` | `Categoria` | Id de la categoría asignada |
| `Categoria` | `Categoria.Nombre` | Nombre de la categoría asignada |

## Ejemplo de uso

```sql
-- Todas las categorías de un artículo
SELECT Categoria FROM vw_ArticuloConCategorias WHERE idArticulo = 1

-- Todos los artículos de una categoría
SELECT Articulo, Marca FROM vw_ArticuloConCategorias WHERE idCategoria = 1
```

## Casos de prueba sugeridos

```sql
-- Un artículo con 2 categorías asignadas debe aparecer en 2 renglones
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 1
EXEC usp_asignarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 2
SELECT * FROM vw_ArticuloConCategorias WHERE idArticulo = 1

-- Quitar una asignación: debe bajar a 1 renglón
EXEC usp_quitarCategoriaArticulo @p_idArticulo = 1, @p_idCategoria = 2
SELECT * FROM vw_ArticuloConCategorias WHERE idArticulo = 1
```
