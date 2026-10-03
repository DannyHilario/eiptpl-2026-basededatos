# Tabla `Cliente`

Script: [`instalacion/02-tablas.sql`](../../instalacion/02-tablas.sql)

Catálogo de clientes de la agencia.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | No | — | Segundo apellido |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre(s) |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada cliente. |

## Relacionada con

- [`Reservacion`](Reservacion.md) — la referencia por `idCliente` (1:N).
