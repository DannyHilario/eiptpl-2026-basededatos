# Tabla `Cuenta`

Script: [`instalacion/03-create-table-cuenta.sql`](../../instalacion/03-create-table-cuenta.sql)

Cuentas bancarias (Débito, Nómina o Ahorro). Una cuenta cancelada no se borra: se marca inactiva y se registra su fecha de cancelación.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCuenta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `NumeroCuenta` | `CHAR(10)` | No | — | Número de cuenta (10 caracteres) |
| `TipoCuenta` | `VARCHAR(20)` | No | — | `'Débito'`, `'Nómina'` o `'Ahorro'` |
| `FechaApertura` | `DATE` | No | — | Fecha en que se abrió la cuenta |
| `FechaCancelacion` | `DATE` | **Sí** | — | Fecha en que se canceló; `NULL` mientras la cuenta sigue activa |
| `SaldoActual` | `DECIMAL(12,2)` | No | `0` | Saldo de la cuenta |
| `Activo` | `BIT` | No | `1` | `1` = activa, `0` = cancelada (junto con `FechaCancelacion`) |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCuenta)` | Llave primaria | Identifica cada cuenta. |
| `uq_Cuenta_NumeroCuenta`: `UNIQUE (NumeroCuenta)` | Único compuesto | No puede haber dos cuentas con el mismo número. |
| `chk_Cuenta_TipoCuenta`: `CHECK (TipoCuenta IN ('Débito', 'Nómina', 'Ahorro'))` | Check | Restringe `TipoCuenta` a los tres tipos que ofrece el banco. |
| `chk_Cuenta_Saldo`: `CHECK (SaldoActual >= 0)` | Check | El saldo no puede ser negativo. |
| `DEFAULT 0` en `SaldoActual` | Default | Toda cuenta nueva empieza en cero. |
| `DEFAULT 1` en `Activo` | Default | Toda cuenta nueva nace activa. |

No tiene `idCliente`: el modelo no registra al titular de la cuenta. La relación entre clientes y cuentas solo existe a través de `Transaccion` (ver *Limitaciones conocidas del modelo* en el README).

## Relacionada con

- [`Transaccion`](Transaccion.md) — la referencia por `idCuenta` (1:N).
