# Tabla `TipoMovimiento`

Script: [`instalacion/05-TipoMovimiento/01-create-table.sql`](../../instalacion/05-TipoMovimiento/01-create-table.sql)

Catálogo de tipos de movimiento que se pueden hacer con una tarjeta. La columna `EsCargo` indica si el movimiento aumenta o disminuye el saldo de la tarjeta.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTipoMovimiento` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre del tipo de movimiento |
| `EsCargo` | `BIT` | No | — | `1` = cargo (aumenta el saldo), `0` = abono (disminuye el saldo) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTipoMovimiento)` | Llave primaria | Identifica cada tipo de movimiento de forma única. |
| `UNIQUE (Nombre)` | Único | No puede haber dos tipos con el mismo nombre. |
| `DEFAULT 1` en `Activo` | Default | Todo tipo nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Datos iniciales

| idTipoMovimiento | Nombre | EsCargo | Efecto en el saldo |
|---|---|---|---|
| 1 | Compra | 1 | Aumenta |
| 2 | Disposición de efectivo | 1 | Aumenta |
| 3 | Anualidad | 1 | Aumenta |
| 4 | Pago | 0 | Disminuye |
| 5 | Devolución | 0 | Disminuye |

## Relacionada con

[`Movimiento`](Movimiento.md) — los movimientos de este tipo (1:N).
