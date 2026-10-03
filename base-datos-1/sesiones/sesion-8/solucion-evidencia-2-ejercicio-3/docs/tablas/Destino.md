# Tabla `Destino`

Script: [`instalacion/02-tablas.sql`](../../instalacion/02-tablas.sql)

Destinos que ofrece la agencia: cada uno combina un [`Pais`](Pais.md) con un [`TipoPaquete`](TipoPaquete.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idDestino` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idPais` | `INT` | No | — | FK a `Pais` |
| `idTipoPaquete` | `INT` | No | — | FK a `TipoPaquete` |
| `NombreDestino` | `VARCHAR(100)` | No | — | Nombre del destino (Cancún, Barcelona, …) |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idDestino)` | Llave primaria | Identifica cada destino. |
| `fk_Destino_Pais`: `FOREIGN KEY (idPais)` → `Pais(idPais)` `ON DELETE CASCADE ON UPDATE CASCADE` | Llave foránea | Solo permite un país que exista. Con `ON DELETE CASCADE`, borrar un país borra sus destinos. |
| `fk_Destino_TipoPaquete`: `FOREIGN KEY (idTipoPaquete)` → `TipoPaquete(idTipoPaquete)` `ON DELETE CASCADE ON UPDATE CASCADE` | Llave foránea | Solo permite un tipo de paquete que exista. Con `ON DELETE CASCADE`, borrar un tipo borra sus destinos. |

## Relacionada con

- [`Pais`](Pais.md) — por `idPais` (N:1).
- [`TipoPaquete`](TipoPaquete.md) — por `idTipoPaquete` (N:1).
- [`Reservacion`](Reservacion.md) — la referencia por `idDestino` (1:N).
