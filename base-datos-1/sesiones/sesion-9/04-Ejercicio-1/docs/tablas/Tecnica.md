# Tabla `Tecnica`

Script: [`instalacion/02-create-table-tecnica.sql`](../../instalacion/02-create-table-tecnica.sql)

Catálogo de carreras técnicas de la escuela, con baja lógica.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTecnica` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Descripcion` | `VARCHAR(100)` | No | — | Nombre de la carrera técnica (Sistemas Computacionales, Diseño de Imagen, …) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTecnica)` | Llave primaria | Identifica cada carrera técnica. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Alumno`](Alumno.md) — la referencia por `idTecnica` (1:N).
