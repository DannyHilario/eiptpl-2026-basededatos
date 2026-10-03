# Tabla `Movimiento`

Script: [`instalacion/06-Movimiento/01-create-table.sql`](../../instalacion/06-Movimiento/01-create-table.sql)

Movimientos realizados con una tarjeta de crédito: compras, disposiciones de efectivo, cobros de anualidad, pagos y devoluciones.

**Los movimientos nuevos se registran únicamente con [`usp_registrarMovimiento`](../procedimientos/usp_registrarMovimiento.md)**, que además actualiza `Tarjeta.SaldoActual`. Un `INSERT` directo en esta tabla deja el saldo de la tarjeta desfasado.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idMovimiento` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idTarjeta` | `INT` | No | — | FK → `Tarjeta` — tarjeta afectada |
| `idTipoMovimiento` | `INT` | No | — | FK → `TipoMovimiento` — tipo de movimiento |
| `Monto` | `DECIMAL(12,2)` | No | — | Importe del movimiento, siempre positivo (si suma o resta lo decide `TipoMovimiento.EsCargo`) |
| `FechaMovimiento` | `DATETIME` | No | — | Fecha y hora del movimiento |
| `Descripcion` | `VARCHAR(100)` | No | — | Dónde o cómo se hizo (`Supermercado`, `Pago en línea`, `Retiro en cajero`, …) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

`Movimiento` no tiene columna `Activo`: un movimiento no se da de baja; si hay un error, se corrige con otro movimiento (por ejemplo, una devolución).

No tiene `idCliente`: el cliente se obtiene a través de la tarjeta (`Movimiento` → `Tarjeta` → `Cliente`).

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idMovimiento)` | Llave primaria | Identifica cada movimiento de forma única. |
| `fk_Movimiento_Tarjeta` | Llave foránea | El movimiento debe pertenecer a una tarjeta existente. |
| `fk_Movimiento_TipoMovimiento` | Llave foránea | El movimiento debe ser de un tipo existente. |
| `CHECK (Monto > 0)` | Check | El monto siempre es positivo; el signo lo da el tipo de movimiento. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Datos iniciales

164 movimientos entre 2024 y septiembre de 2026 (104 de ellos en 2026): 78 compras, 27 disposiciones de efectivo, 21 cobros de anualidad, 33 pagos y 5 devoluciones.

- **Cuadran con el saldo:** para cada tarjeta, la suma de sus cargos menos la suma de sus abonos es igual a su `Tarjeta.SaldoActual`, y el saldo nunca fue negativo ni rebasó el límite en ningún momento.
- **Fechas válidas:** ningún movimiento es anterior a la emisión de su tarjeta ni posterior a su vencimiento.
- **Anualidades:** solo en tarjetas Gold y Platinum, por el monto de `TipoTarjetaCredito.Anualidad`.
- **Tarjetas sin movimientos:** 36 de las 40 tarjetas tienen movimientos; las tarjetas 7, 11, 18 y 37 (vigentes, saldo `0`) no tienen ninguno. Los clientes 7 y 11 tienen tarjeta, pero nunca la han usado.

## Relacionada con

- [`Tarjeta`](Tarjeta.md) — tarjeta afectada (N:1).
- [`TipoMovimiento`](TipoMovimiento.md) — tipo de movimiento (N:1).
