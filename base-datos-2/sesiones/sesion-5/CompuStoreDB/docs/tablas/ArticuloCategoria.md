# Tabla `ArticuloCategoria`

Script: [`instalacion/03-ArticuloCategoria/01-create-table.sql`](../../instalacion/03-ArticuloCategoria/01-create-table.sql)

Tabla puente que resuelve la relación **N:N** entre `Articulo` y `Categoria` (un artículo puede estar en varias categorías, una categoría tiene varios artículos).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idArticuloCategoria` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria propia de la tabla puente (no es compuesta) |
| `idArticulo` | `INT` | No | — | FK a `Articulo` |
| `idCategoria` | `INT` | No | — | FK a `Categoria` |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se asignó la categoría al artículo |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | No suele cambiar — no hay un "actualizar" de esta tabla, solo asignar/quitar |

No tiene `Activo`: no es un catálogo, y no necesita baja lógica — quitar una asignación es un `DELETE` físico (ver [`usp_quitarCategoriaArticulo`](../usp_quitarCategoriaArticulo.md)).

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idArticuloCategoria)` | Llave primaria | Identifica cada asignación por su propio id, en vez de usar `(idArticulo, idCategoria)` como llave compuesta — más simple de referenciar desde otro lado si hiciera falta. |
| `FOREIGN KEY (idArticulo) REFERENCES Articulo` | Llave foránea | No se puede asignar una categoría a un artículo que no existe. |
| `FOREIGN KEY (idCategoria) REFERENCES Categoria` | Llave foránea | No se puede asignar una categoría que no existe. |
| `UNIQUE (idArticulo, idCategoria)` | Único | **Esta es la constraint que resuelve la N:N correctamente**: sin ella, nada impediría insertar la misma combinación artículo+categoría dos veces (dos renglones idénticos con distinto `idArticuloCategoria`). `usp_asignarCategoriaArticulo` valida lo mismo antes, con mensaje amigable. |

## SPs relacionados

[`usp_asignarCategoriaArticulo`](../usp_asignarCategoriaArticulo.md) · [`usp_quitarCategoriaArticulo`](../usp_quitarCategoriaArticulo.md)
