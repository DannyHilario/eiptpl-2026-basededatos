# Tabla `Platillo`

Script: [`instalacion/03-create-table-platillo.sql`](../../instalacion/03-create-table-platillo.sql)

Catálogo de platillos del comedor subsidiado, con su precio vigente.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idPlatillo` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre del platillo |
| `Descripcion` | `VARCHAR(200)` | **Sí** | — | Descripción del platillo (opcional) |
| `Precio` | `DECIMAL(8,2)` | No | — | Precio vigente del platillo |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idPlatillo)` | Llave primaria | Identifica cada platillo. |
| `chk_Platillo_Precio`: `CHECK (Precio > 0)` | Check | El precio vigente debe ser mayor a cero. |

## Relacionada con

- [`Servicio`](Servicio.md) — la referencia por `idPlatillo` (1:N).
