# Tabla `Tarjeta`

Script: [`instalacion/04-Tarjeta/01-create-table.sql`](../../instalacion/04-Tarjeta/01-create-table.sql)

Tarjetas de crédito emitidas. Relaciona a un `Cliente` con un `TipoTarjetaCredito` (relación N:M) y guarda los datos propios de cada tarjeta.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTarjeta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCliente` | `INT` | No | — | FK → `Cliente` — titular de la tarjeta |
| `idTipoTarjetaCredito` | `INT` | No | — | FK → `TipoTarjetaCredito` — producto de la tarjeta |
| `NumeroTarjeta` | `CHAR(16)` | No | — | Número de 16 dígitos (ficticio) |
| `FechaEmision` | `DATE` | No | — | Fecha en que se emitió la tarjeta |
| `FechaVencimiento` | `DATE` | No | — | Fecha en que vence la tarjeta (emisión + 5 años) |
| `LimiteCredito` | `DECIMAL(12,2)` | No | — | Límite de crédito otorgado a esta tarjeta |
| `SaldoActual` | `DECIMAL(12,2)` | No | `0` | Lo que el cliente debe actualmente en esta tarjeta (= cargos − abonos de sus movimientos) |
| `Activo` | `BIT` | No | `1` | `1` = activa, `0` = cancelada (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTarjeta)` | Llave primaria | Identifica cada tarjeta de forma única. |
| `fk_Tarjeta_Cliente` | Llave foránea | La tarjeta debe pertenecer a un cliente existente. |
| `fk_Tarjeta_TipoTarjetaCredito` | Llave foránea | La tarjeta debe ser de un producto existente. |
| `UNIQUE (NumeroTarjeta)` | Único | No puede haber dos tarjetas con el mismo número. |
| `UNIQUE (idCliente, idTipoTarjetaCredito)` | Único | Un cliente no puede tener dos tarjetas del mismo producto (por eso el máximo es 3 tarjetas por cliente). |
| `CHECK (LimiteCredito > 0)` | Check | El límite debe ser positivo. |
| `CHECK (SaldoActual >= 0 AND SaldoActual <= LimiteCredito)` | Check | El saldo no puede ser negativo ni rebasar el límite. |
| `CHECK (FechaVencimiento > FechaEmision)` | Check | La tarjeta no puede vencer antes de emitirse. |
| `DEFAULT 0` en `SaldoActual` | Default | Toda tarjeta nueva nace sin deuda. |
| `DEFAULT 1` en `Activo` | Default | Toda tarjeta nueva nace activa. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

> Que el `LimiteCredito` quede dentro del rango `LimiteCreditoMinimo`–`LimiteCreditoMaximo` de su producto **no** se puede validar con un `CHECK` (son tablas distintas): es una regla de negocio que se valida en los procedimientos almacenados.

## Estado de una tarjeta

No hay una columna de estatus: el estado se deduce de `Activo` y `FechaVencimiento`. Ver la regla completa en el [README de la sesión](../../../README.md#estado-de-una-tarjeta).

## Datos iniciales

40 tarjetas: 14 Básica, 14 Gold y 12 Platinum.

- **Por cliente:** clientes 1-12 tienen 1 tarjeta, 13-20 tienen 2, 21-24 tienen 3 (una de cada producto) y 25-30 no tienen ninguna.
- **Por estado:** 34 vigentes, 4 vencidas (tarjetas 3, 9, 15 y 29) y 2 canceladas (tarjetas 6 y 24).
- **Saldo:** varias tarjetas en `0` y varias al tope de su límite (`SaldoActual = LimiteCredito`).
- **Numeración:** los primeros 4 dígitos identifican el producto (`1111` Básica, `2222` Gold, `3333` Platinum), seguidos de `0000` y el `idTarjeta` a 8 dígitos.

## Relacionada con

- [`Cliente`](Cliente.md) — titular de la tarjeta (N:1).
- [`TipoTarjetaCredito`](TipoTarjetaCredito.md) — producto de la tarjeta (N:1).
- [`Movimiento`](Movimiento.md) — movimientos de la tarjeta (1:N).
