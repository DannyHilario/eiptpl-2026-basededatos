# Tabla `Servicio`

Script: [`instalacion/04-create-table-servicio.sql`](../../instalacion/04-create-table-servicio.sql)

Hecho — el consumo de un [`Platillo`](Platillo.md) por un [`Empleado`](Empleado.md) en una fecha.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idServicio` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idEmpleado` | `INT` | No | — | FK a `Empleado` |
| `idPlatillo` | `INT` | No | — | FK a `Platillo` |
| `FechaServicio` | `DATE` | No | — | Fecha del consumo |
| `Precio` | `DECIMAL(8,2)` | No | — | Precio cobrado ese día; puede ser distinto del precio vigente en `Platillo` |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idServicio)` | Llave primaria | Identifica cada servicio. |
| `fk_Servicio_Empleado`: `FOREIGN KEY (idEmpleado)` → `Empleado(idEmpleado)` | Llave foránea | Solo permite referenciar registros de `Empleado` que existan. |
| `fk_Servicio_Platillo`: `FOREIGN KEY (idPlatillo)` → `Platillo(idPlatillo)` | Llave foránea | Solo permite referenciar registros de `Platillo` que existan. |
| `chk_Servicio_Precio`: `CHECK (Precio > 0)` | Check | El precio cobrado debe ser mayor a cero. |

No tiene `Activo`: es una tabla de hechos, no un catálogo.

## `Precio` — por qué se guarda en el servicio

El precio de un platillo cambia con el tiempo (en los datos, algunos platillos costaron distinto en abril que en mayo de 2026). `Servicio.Precio` guarda lo que realmente se cobró ese día; `Platillo.Precio` es solo el precio vigente. Por eso no se calcula con un `JOIN` a `Platillo`.

## Relacionada con

- [`Empleado`](Empleado.md) — por `idEmpleado` (N:1).
- [`Platillo`](Platillo.md) — por `idPlatillo` (N:1).
