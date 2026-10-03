# Tabla `Servicio`

Script: [`instalacion/05-create-table-servicio.sql`](../../instalacion/05-create-table-servicio.sql)

Hecho — cada visita al taller: un [`TipoServicio`](TipoServicio.md) realizado a un [`Vehiculo`](Vehiculo.md) en una fecha.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idServicio` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idVehiculo` | `INT` | No | — | FK a `Vehiculo` |
| `idTipoServicio` | `INT` | No | — | FK a `TipoServicio` |
| `FechaIngreso` | `DATE` | No | — | Fecha en que el vehículo ingresó al taller |
| `CostoServicio` | `DECIMAL(10,2)` | No | — | Costo cobrado, copiado de `TipoServicio.Costo` al registrar el servicio |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idServicio)` | Llave primaria | Identifica cada servicio. |
| `fk_Servicio_Vehiculo`: `FOREIGN KEY (idVehiculo)` → `Vehiculo(idVehiculo)` | Llave foránea | Solo permite referenciar registros de `Vehiculo` que existan. |
| `fk_Servicio_TipoServicio`: `FOREIGN KEY (idTipoServicio)` → `TipoServicio(idTipoServicio)` | Llave foránea | Solo permite referenciar registros de `TipoServicio` que existan. |

No tiene `Activo`: es una tabla de hechos, no un catálogo. El cliente se obtiene a través del vehículo (`Servicio` → `Vehiculo` → `Cliente`).

## `CostoServicio` — por qué se copia

Es una *foto* del costo al momento del servicio: si después cambia `TipoServicio.Costo`, los servicios ya registrados conservan lo que realmente se cobró. Por eso no se calcula con un `JOIN` a `TipoServicio`.

## Relacionada con

- [`Vehiculo`](Vehiculo.md) — por `idVehiculo` (N:1).
- [`TipoServicio`](TipoServicio.md) — por `idTipoServicio` (N:1).
