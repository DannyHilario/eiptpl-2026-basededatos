# Tabla `Vehiculo`

Script: [`instalacion/04-create-table-vehiculo.sql`](../../instalacion/04-create-table-vehiculo.sql)

Vehículos registrados en el taller; cada uno pertenece a un [`Cliente`](Cliente.md), que puede tener varios.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idVehiculo` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCliente` | `INT` | No | — | FK a `Cliente` |
| `Marca` | `VARCHAR(50)` | No | — | Marca del vehículo |
| `Modelo` | `VARCHAR(50)` | No | — | Modelo del vehículo |
| `Anio` | `INT` | No | — | Año del modelo |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idVehiculo)` | Llave primaria | Identifica cada vehículo. |
| `fk_Vehiculo_Cliente`: `FOREIGN KEY (idCliente)` → `Cliente(idCliente)` | Llave foránea | Solo permite registrar el vehículo a nombre de un cliente que exista. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Cliente`](Cliente.md) — por `idCliente` (N:1).
- [`Servicio`](Servicio.md) — la referencia por `idVehiculo` (1:N).
