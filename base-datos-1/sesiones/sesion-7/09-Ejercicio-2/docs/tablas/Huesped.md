# Tabla `Huesped`

Script: [`instalacion/02-create-tables.sql`](../../instalacion/02-create-tables.sql)

Catálogo de huéspedes del hotel.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idHuesped` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | No | — | Segundo apellido |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre(s) |
| `Telefono` | `VARCHAR(20)` | **Sí** | — | Teléfono de contacto (opcional) |
| `Correo` | `VARCHAR(100)` | **Sí** | — | Correo electrónico (opcional; si tiene valor, debe ser único) |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idHuesped)` | Llave primaria | Identifica cada huésped. |
| `UNIQUE (Correo)` | Único | No permite que dos huéspedes compartan el mismo correo. `UNIQUE` sí permite varios `NULL`, así que puede haber varios huéspedes sin correo. |

## Relacionada con

- [`Reservacion`](Reservacion.md) — la referencia por `idHuesped` (1:N).
