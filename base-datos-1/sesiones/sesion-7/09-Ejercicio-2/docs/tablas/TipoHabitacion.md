# Tabla `TipoHabitacion`

Script: [`instalacion/02-create-tables.sql`](../../instalacion/02-create-tables.sql)

Catálogo de tipos de habitación (Sencilla, Doble, Suite), con su precio por noche vigente.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTipoHabitacion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `TipoHabitacion` | `VARCHAR(50)` | No | — | Nombre del tipo de habitación |
| `PrecioPorNoche` | `DECIMAL(10,2)` | No | — | Precio vigente por noche |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTipoHabitacion)` | Llave primaria | Identifica cada tipo de habitación. |
| `UNIQUE (TipoHabitacion)` | Único | No permite repetir el nombre del tipo. |
| `chk_TipoHabitacion_PrecioPorNoche`: `CHECK (PrecioPorNoche > 0)` | Check | El precio por noche debe ser mayor a cero. |

## Relacionada con

- [`Habitacion`](Habitacion.md) — la referencia por `idTipoHabitacion` (1:N).
