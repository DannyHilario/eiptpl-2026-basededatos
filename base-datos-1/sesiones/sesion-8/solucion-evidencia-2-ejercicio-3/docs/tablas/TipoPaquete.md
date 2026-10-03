# Tabla `TipoPaquete`

Script: [`instalacion/02-tablas.sql`](../../instalacion/02-tablas.sql)

Catálogo de tipos de paquete (luna de miel, aventura, crucero, …), con su precio vigente.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTipoPaquete` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `NombrePaquete` | `VARCHAR(100)` | No | — | Nombre del tipo de paquete |
| `PrecioActual` | `DECIMAL(10,2)` | No | — | Precio vigente del paquete |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTipoPaquete)` | Llave primaria | Identifica cada tipo de paquete. |
| `chk_TipoPaquete_PrecioActual`: `CHECK (PrecioActual > 0)` | Check | El precio vigente debe ser mayor a cero. |

## Relacionada con

- [`Destino`](Destino.md) — la referencia por `idTipoPaquete` (1:N).
