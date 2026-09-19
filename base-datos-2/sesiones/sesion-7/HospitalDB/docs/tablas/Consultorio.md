# Tabla `Consultorio`

Script: [`instalacion/05-Consultorio/01-create-table.sql`](../../instalacion/05-Consultorio/01-create-table.sql)

Catálogo de consultorios — la ubicación física donde ocurre una consulta.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idConsultorio` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre/identificador del consultorio (ej. "Consultorio 1") |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idConsultorio)` | Llave primaria | Identifica cada consultorio de forma única. |
| `UNIQUE (Nombre)` | Único | Evita registrar dos veces el mismo consultorio. |
| `DEFAULT 1` en `Activo` | Default | Todo consultorio nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Relacionada con

[`Consulta`](Consulta.md) — las consultas que se atienden ahí (1:N).
