# Tabla `Pais`

Script: [`instalacion/02-tablas.sql`](../../instalacion/02-tablas.sql)

Catálogo de países destino.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idPais` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `NombrePais` | `VARCHAR(100)` | No | — | Nombre del país |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idPais)` | Llave primaria | Identifica cada país. |
| `UNIQUE (NombrePais)` | Único | No permite repetir un país en el catálogo. |

## Relacionada con

- [`Destino`](Destino.md) — la referencia por `idPais` (1:N).
