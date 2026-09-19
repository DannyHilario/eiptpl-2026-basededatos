# Tabla `Especialidad`

Script: [`instalacion/01-Especialidad/01-create-table.sql`](../../instalacion/01-Especialidad/01-create-table.sql)

Catálogo de especialidades médicas (Medicina General, Pediatría, Cardiología, etc.).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idEspecialidad` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre de la especialidad |
| `Activo` | `BIT` | No | `1` | `1` = activa, `0` = dada de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idEspecialidad)` | Llave primaria | Identifica cada especialidad de forma única. |
| `UNIQUE (Nombre)` | Único | Evita registrar dos veces la misma especialidad. |
| `DEFAULT 1` en `Activo` | Default | Toda especialidad nueva nace activa. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Relacionada con

[`MedicoEspecialidad`](MedicoEspecialidad.md) — tabla puente de la relación N:M con `Medico`.
