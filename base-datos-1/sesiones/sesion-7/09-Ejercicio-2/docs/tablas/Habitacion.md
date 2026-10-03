# Tabla `Habitacion`

Script: [`instalacion/02-create-tables.sql`](../../instalacion/02-create-tables.sql)

Habitaciones del hotel; cada una es de un [`TipoHabitacion`](TipoHabitacion.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idHabitacion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idTipoHabitacion` | `INT` | No | — | FK a `TipoHabitacion` |
| `NumeroHabitacion` | `VARCHAR(10)` | No | — | Número de la habitación (`101`, `201`, …) |
| `DescripcionHabitacion` | `VARCHAR(200)` | **Sí** | — | Descripción (opcional) |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idHabitacion)` | Llave primaria | Identifica cada habitación. |
| `fk_Habitacion_TipoHabitacion`: `FOREIGN KEY (idTipoHabitacion)` → `TipoHabitacion(idTipoHabitacion)` `ON DELETE CASCADE ON UPDATE CASCADE` | Llave foránea | Solo permite asignar un tipo que exista. Con `ON DELETE CASCADE`, borrar un tipo borra sus habitaciones; con `ON UPDATE CASCADE`, cambiar su id se propaga. |
| `uq_Habitacion_NumeroHabitacion`: `UNIQUE (NumeroHabitacion)` | Único compuesto | No puede haber dos habitaciones con el mismo número. |

## Relacionada con

- [`TipoHabitacion`](TipoHabitacion.md) — por `idTipoHabitacion` (N:1).
- [`Reservacion`](Reservacion.md) — la referencia por `idHabitacion` (1:N).
