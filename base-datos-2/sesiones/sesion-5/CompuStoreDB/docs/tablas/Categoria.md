# Tabla `Categoria`

Script: [`instalacion/01-Categoria/01-create-table.sql`](../../instalacion/01-Categoria/01-create-table.sql)

Catálogo de categorías de artículos (Laptops, Monitores, Teclados, etc.).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCategoria` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre de la categoría |
| `Activo` | `BIT` | No | `1` | `1` = activa, `0` = dada de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCategoria)` | Llave primaria | Identifica cada categoría de forma única; `IDENTITY(1,1)` hace que SQL Server asigne el siguiente número automáticamente, sin que el `INSERT` tenga que calcularlo. |
| `UNIQUE (Nombre)` | Único | Evita registrar dos veces la misma categoría con el mismo nombre (p. ej. dos filas `'Laptops'`). Es la regla que valida `usp_insertarCategoria`/`usp_actualizarCategoria` antes de dejar pasar el cambio, con un mensaje amigable en vez de dejar que falle el `INSERT` con el error crudo del motor. |
| `DEFAULT 1` en `Activo` | Default | Toda categoría nueva nace activa; nadie tiene que acordarse de mandar `1` explícitamente al insertar. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática: queda registrado cuándo se creó/modificó el renglón sin que el `INSERT`/`UPDATE` tenga que calcular la fecha. |

## SPs relacionados

[`usp_insertarCategoria`](../usp_insertarCategoria.md) · [`usp_eliminarCategoria`](../usp_eliminarCategoria.md) · [`usp_habilitarCategoria`](../usp_habilitarCategoria.md) · [`usp_actualizarCategoria`](../usp_actualizarCategoria.md)
