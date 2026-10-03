# Tabla `Genero`

Script: [`instalacion/04-create-table-genero.sql`](../../instalacion/04-create-table-genero.sql)

Catálogo de géneros cinematográficos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idGenero` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre del género (Acción, Comedia, Drama, …) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idGenero)` | Llave primaria | Identifica cada género. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Pelicula`](Pelicula.md) — la referencia por `idGenero` (1:N).
