# Tabla `TipoServicio`

Script: [`instalacion/03-create-table-tiposervicio.sql`](../../instalacion/03-create-table-tiposervicio.sql)

Catálogo de tipos de servicio que ofrece el taller (afinación, cambio de aceite, frenos, …), con su costo vigente.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idTipoServicio` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Descripcion` | `VARCHAR(100)` | No | — | Nombre del servicio |
| `Costo` | `DECIMAL(10,2)` | No | — | Costo vigente del servicio |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idTipoServicio)` | Llave primaria | Identifica cada tipo de servicio. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Servicio`](Servicio.md) — la referencia por `idTipoServicio` (1:N).
