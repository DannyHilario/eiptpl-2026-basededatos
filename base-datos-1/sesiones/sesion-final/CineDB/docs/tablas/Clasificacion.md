# Tabla `Clasificacion`

Script: [`instalacion/03-create-table-clasificacion.sql`](../../instalacion/03-create-table-clasificacion.sql)

Catálogo de clasificaciones por edad de las películas.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idClasificacion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(10)` | No | — | Clave de la clasificación: `AA`, `A`, `B` o `C` |
| `Descripcion` | `VARCHAR(100)` | No | — | Público al que está dirigida (por ejemplo, *Mayores de 15 años*) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idClasificacion)` | Llave primaria | Identifica cada clasificación. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Pelicula`](Pelicula.md) — la referencia por `idClasificacion` (1:N).
