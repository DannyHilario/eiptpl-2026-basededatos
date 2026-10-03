# Tabla `Sala`

Script: [`instalacion/06-create-table-sala.sql`](../../instalacion/06-create-table-sala.sql)

Catálogo de salas físicas del cine; cada una es de un [`TipoSala`](TipoSala.md), que define el precio del boleto.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idSala` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idTipoSala` | `INT` | No | — | FK a `TipoSala` |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre de la sala (`Sala 1`, `IMAX Norte`, `VIP Lounge`, …) |
| `Capacidad` | `INT` | No | — | Número de asientos |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idSala)` | Llave primaria | Identifica cada sala. |
| `fk_Sala_TipoSala`: `FOREIGN KEY (idTipoSala)` → `TipoSala(idTipoSala)` | Llave foránea | Solo permite asignar un tipo de sala que exista en el catálogo. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`TipoSala`](TipoSala.md) — por `idTipoSala` (N:1).
- [`Funcion`](Funcion.md) — la referencia por `idSala` (1:N).
