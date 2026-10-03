# Tabla `Transaccion`

Script: [`instalacion/04-create-table-transaccion.sql`](../../instalacion/04-create-table-transaccion.sql)

Hecho — un movimiento financiero (depósito, retiro o transferencia) sobre una [`Cuenta`](Cuenta.md), realizado por un [`Cliente`](Cliente.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTransaccion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCuenta` | `INT` | No | — | FK a `Cuenta` |
| `idCliente` | `INT` | No | — | FK a `Cliente` |
| `TipoTransaccion` | `VARCHAR(20)` | No | — | `'Depósito'`, `'Retiro'` o `'Transferencia'` |
| `Monto` | `DECIMAL(12,2)` | No | — | Monto del movimiento (siempre positivo; el tipo indica si entra o sale dinero) |
| `FechaTransaccion` | `DATE` | No | — | Fecha del movimiento |
| `HoraTransaccion` | `TIME` | No | — | Hora del movimiento |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTransaccion)` | Llave primaria | Identifica cada transacción. |
| `fk_Transaccion_Cuenta`: `FOREIGN KEY (idCuenta)` → `Cuenta(idCuenta)` | Llave foránea | Solo permite referenciar registros de `Cuenta` que existan. |
| `fk_Transaccion_Cliente`: `FOREIGN KEY (idCliente)` → `Cliente(idCliente)` | Llave foránea | Solo permite referenciar registros de `Cliente` que existan. |
| `chk_Transaccion_Tipo`: `CHECK (TipoTransaccion IN ('Depósito', 'Retiro', 'Transferencia'))` | Check | Restringe `TipoTransaccion` a los tres tipos de movimiento. |
| `chk_Transaccion_Monto`: `CHECK (Monto > 0)` | Check | El monto debe ser mayor a cero. |

No tiene `Activo`: es una tabla de hechos, no un catálogo. Registrar una transacción no actualiza `Cuenta.SaldoActual`: el modelo no lo sincroniza.

## Relacionada con

- [`Cuenta`](Cuenta.md) — por `idCuenta` (N:1).
- [`Cliente`](Cliente.md) — por `idCliente` (N:1).
