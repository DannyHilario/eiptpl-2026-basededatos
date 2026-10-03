# Tabla `TipoSala`

Script: [`instalacion/02-create-table-tiposala.sql`](../../instalacion/02-create-table-tiposala.sql)

Catálogo de tipos de sala (2D, 3D, IMAX, VIP), cada uno con el precio base del boleto.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTipoSala` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Descripcion` | `VARCHAR(50)` | No | — | Nombre del tipo de sala: `2D`, `3D`, `IMAX` o `VIP` |
| `Precio` | `DECIMAL(10,2)` | No | — | Precio vigente del boleto para las salas de este tipo |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTipoSala)` | Llave primaria | Identifica cada tipo de sala. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Sala`](Sala.md) — la referencia por `idTipoSala` (1:N).
