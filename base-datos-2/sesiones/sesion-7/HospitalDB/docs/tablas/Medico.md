# Tabla `Medico`

Script: [`instalacion/02-Medico/01-create-table.sql`](../../instalacion/02-Medico/01-create-table.sql)

Catálogo de médicos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idMedico` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre(s) del médico |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | Sí | — | Segundo apellido (opcional) |
| `Cedula` | `VARCHAR(20)` | No | — | Cédula profesional |
| `Telefono` | `VARCHAR(20)` | Sí | — | Teléfono de contacto |
| `Correo` | `VARCHAR(100)` | Sí | — | Correo electrónico |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idMedico)` | Llave primaria | Identifica cada médico de forma única. |
| `UNIQUE (Cedula)` | Único | Una cédula profesional identifica a un solo médico; evita registrarlo dos veces. |
| `UNIQUE (Telefono)` / `UNIQUE (Correo)` | Único | Evita que dos médicos compartan el mismo teléfono o correo. |
| `DEFAULT 1` en `Activo` | Default | Todo médico nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Relacionada con

[`MedicoEspecialidad`](MedicoEspecialidad.md) — sus especialidades (N:M). [`Consulta`](Consulta.md) — las consultas que atiende (1:N).
