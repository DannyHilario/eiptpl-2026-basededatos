# Tabla `TipoTarjetaCredito`

Script: [`instalacion/03-TipoTarjetaCredito/01-create-table.sql`](../../instalacion/03-TipoTarjetaCredito/01-create-table.sql)

Catálogo de productos de tarjeta de crédito. Funciona también como tabla de parámetros: define el rango de límite de crédito que se puede otorgar con cada producto, su anualidad y su tasa de interés.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTipoTarjetaCredito` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre comercial del producto |
| `LimiteCreditoMinimo` | `DECIMAL(12,2)` | No | — | Límite de crédito más bajo que se puede otorgar con este producto |
| `LimiteCreditoMaximo` | `DECIMAL(12,2)` | No | — | Límite de crédito más alto que se puede otorgar con este producto |
| `Anualidad` | `DECIMAL(10,2)` | No | — | Cuota anual del producto |
| `TasaInteresAnual` | `DECIMAL(5,2)` | No | — | Tasa de interés anual, en porcentaje (`45.00` = 45%) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTipoTarjetaCredito)` | Llave primaria | Identifica cada producto de forma única. |
| `UNIQUE (Nombre)` | Único | No puede haber dos productos con el mismo nombre. |
| `CHECK (LimiteCreditoMinimo > 0)` | Check | El límite mínimo debe ser positivo. |
| `CHECK (LimiteCreditoMaximo > LimiteCreditoMinimo)` | Check | El rango de límites debe ser coherente. |
| `CHECK (Anualidad >= 0)` / `CHECK (TasaInteresAnual >= 0)` | Check | No se permiten montos ni tasas negativas. |
| `DEFAULT 1` en `Activo` | Default | Todo producto nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Datos iniciales

| idTipoTarjetaCredito | Nombre | LimiteCreditoMinimo | LimiteCreditoMaximo | Anualidad | TasaInteresAnual |
|---|---|---|---|---|---|
| 1 | Banquito Básica | 5,000.00 | 30,000.00 | 0.00 | 55.00 |
| 2 | Banquito Gold | 30,000.00 | 100,000.00 | 1,200.00 | 45.00 |
| 3 | Banquito Platinum | 100,000.00 | 500,000.00 | 3,500.00 | 35.00 |

## Relacionada con

[`Tarjeta`](Tarjeta.md) — las tarjetas emitidas de este producto (1:N).
