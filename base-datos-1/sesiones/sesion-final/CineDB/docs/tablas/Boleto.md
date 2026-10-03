# Tabla `Boleto`

Script: [`instalacion/09-create-table-boleto.sql`](../../instalacion/09-create-table-boleto.sql)

Hecho — un boleto comprado por un [`Cliente`](Cliente.md) para una [`Funcion`](Funcion.md). Un cliente con acompañantes compra un boleto por asiento.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idBoleto` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idFuncion` | `INT` | No | — | FK a `Funcion` |
| `idCliente` | `INT` | No | — | FK a `Cliente` |
| `FechaPago` | `DATE` | No | — | Fecha en que se pagó el boleto |
| `HoraPago` | `TIME` | No | — | Hora en que se pagó |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idBoleto)` | Llave primaria | Identifica cada boleto. |
| `fk_Boleto_Funcion`: `FOREIGN KEY (idFuncion)` → `Funcion(idFuncion)` | Llave foránea | Solo permite referenciar registros de `Funcion` que existan. |
| `fk_Boleto_Cliente`: `FOREIGN KEY (idCliente)` → `Cliente(idCliente)` | Llave foránea | Solo permite referenciar registros de `Cliente` que existan. |

No tiene `Activo`: es una tabla de hechos, no un catálogo. El precio pagado es el `Precio` de su `Funcion`.

## Relacionada con

- [`Funcion`](Funcion.md) — por `idFuncion` (N:1).
- [`Cliente`](Cliente.md) — por `idCliente` (N:1).
