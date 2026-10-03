# Tabla `Reservacion`

Script: [`instalacion/02-create-tables.sql`](../../instalacion/02-create-tables.sql)

Hecho — la reservación de un [`Huesped`](Huesped.md) en una [`Habitacion`](Habitacion.md) a partir de una fecha, por un número de noches.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idReservacion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idHuesped` | `INT` | No | — | FK a `Huesped` |
| `idHabitacion` | `INT` | No | — | FK a `Habitacion` |
| `FechaIngreso` | `DATE` | No | — | Fecha de llegada |
| `NumeroNoches` | `INT` | No | — | Noches reservadas |
| `PrecioAlMomento` | `DECIMAL(10,2)` | No | — | Precio por noche al reservar, copiado de `TipoHabitacion.PrecioPorNoche` |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idReservacion)` | Llave primaria | Identifica cada reservación. |
| `fk_Reservacion_Huesped`: `FOREIGN KEY (idHuesped)` → `Huesped(idHuesped)` `ON DELETE CASCADE ON UPDATE CASCADE` | Llave foránea | Solo permite reservar a nombre de un huésped que exista. Con `ON DELETE CASCADE`, borrar un huésped borra sus reservaciones. |
| `fk_Reservacion_Habitacion`: `FOREIGN KEY (idHabitacion)` → `Habitacion(idHabitacion)` `ON DELETE NO ACTION ON UPDATE CASCADE` | Llave foránea | Solo permite reservar una habitación que exista. Con `ON DELETE NO ACTION`, no se puede borrar una habitación que tenga reservaciones. |
| `chk_Reservacion_NumeroNoches`: `CHECK (NumeroNoches > 0)` | Check | Una reservación es de al menos una noche. |
| `chk_Reservacion_PrecioAlMomento`: `CHECK (PrecioAlMomento > 0)` | Check | El precio debe ser mayor a cero. |

No tiene `Activo`: es una tabla de hechos, no un catálogo. `PrecioAlMomento` es una foto del precio al reservar: si después cambia el precio del tipo de habitación, la reservación conserva el suyo.

## Relacionada con

- [`Huesped`](Huesped.md) — por `idHuesped` (N:1).
- [`Habitacion`](Habitacion.md) — por `idHabitacion` (N:1).
