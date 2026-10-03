# Tabla `Pelicula`

Script: [`instalacion/07-create-table-pelicula.sql`](../../instalacion/07-create-table-pelicula.sql)

Catálogo de películas; cada una tiene una [`Clasificacion`](Clasificacion.md) y un [`Genero`](Genero.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idPelicula` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idClasificacion` | `INT` | No | — | FK a `Clasificacion` |
| `idGenero` | `INT` | No | — | FK a `Genero` |
| `Nombre` | `VARCHAR(200)` | No | — | Título de la película |
| `Duracion` | `INT` | No | — | Duración en minutos |
| `Director` | `VARCHAR(150)` | No | — | Nombre del director |
| `AnioEstreno` | `INT` | No | — | Año de estreno |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idPelicula)` | Llave primaria | Identifica cada película. |
| `fk_Pelicula_Clasificacion`: `FOREIGN KEY (idClasificacion)` → `Clasificacion(idClasificacion)` | Llave foránea | Solo permite referenciar registros de `Clasificacion` que existan. |
| `fk_Pelicula_Genero`: `FOREIGN KEY (idGenero)` → `Genero(idGenero)` | Llave foránea | Solo permite referenciar registros de `Genero` que existan. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Clasificacion`](Clasificacion.md) — por `idClasificacion` (N:1).
- [`Genero`](Genero.md) — por `idGenero` (N:1).
- [`Funcion`](Funcion.md) — la referencia por `idPelicula` (1:N).
