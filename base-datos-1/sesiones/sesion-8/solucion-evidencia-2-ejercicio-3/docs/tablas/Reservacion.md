# Tabla `Reservacion`

Script: [`instalacion/02-tablas.sql`](../../instalacion/02-tablas.sql)

Hecho — la reservación de un [`Cliente`](Cliente.md) para un [`Destino`](Destino.md), con su precio y total.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idReservacion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCliente` | `INT` | No | — | FK a `Cliente` |
| `idDestino` | `INT` | No | — | FK a `Destino` |
| `FechaSalida` | `DATE` | No | — | Fecha de salida del viaje |
| `NumeroNoches` | `INT` | No | — | Noches del viaje |
| `PrecioAlMomento` | `DECIMAL(10,2)` | No | — | Precio por noche al reservar, copiado de `TipoPaquete.PrecioActual` del destino |
| `TotalAPagar` | `DECIMAL(10,2)` | No | — | `PrecioAlMomento × NumeroNoches` |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idReservacion)` | Llave primaria | Identifica cada reservación. |
| `fk_Reservacion_Cliente`: `FOREIGN KEY (idCliente)` → `Cliente(idCliente)` `ON DELETE CASCADE ON UPDATE CASCADE` | Llave foránea | Solo permite reservar a nombre de un cliente que exista. Con `ON DELETE CASCADE`, borrar un cliente borra sus reservaciones. |
| `fk_Reservacion_Destino`: `FOREIGN KEY (idDestino)` → `Destino(idDestino)` `ON DELETE NO ACTION ON UPDATE CASCADE` | Llave foránea | Solo permite reservar un destino que exista. Con `ON DELETE NO ACTION`, no se puede borrar un destino con reservaciones. |
| `chk_Reservacion_NumeroNoches`: `CHECK (NumeroNoches > 0)` | Check | Una reservación es de al menos una noche. |
| `chk_Reservacion_PrecioAlMomento`: `CHECK (PrecioAlMomento > 0)` | Check | El precio debe ser mayor a cero. |
| `chk_Reservacion_TotalAPagar`: `CHECK (TotalAPagar > 0)` | Check | El total debe ser mayor a cero. |

No tiene `Activo`: es una tabla de hechos, no un catálogo. `PrecioAlMomento` es una foto del precio al reservar; `TotalAPagar` se guarda calculado (el modelo no lo recalcula si cambian las noches).

## Relacionada con

- [`Cliente`](Cliente.md) — por `idCliente` (N:1).
- [`Destino`](Destino.md) — por `idDestino` (N:1).
