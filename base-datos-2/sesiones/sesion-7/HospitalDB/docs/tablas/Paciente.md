# Tabla `Paciente`

Script: [`instalacion/04-Paciente/01-create-table.sql`](../../instalacion/04-Paciente/01-create-table.sql)

Catálogo de pacientes.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idPaciente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre(s) del paciente |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | No | — | Segundo apellido |
| `Sexo` | `CHAR(1)` | No | — | `M` o `F` |
| `Telefono` | `VARCHAR(20)` | No | — | Teléfono de contacto |
| `Correo` | `VARCHAR(100)` | No | — | Correo electrónico |
| `FechaNacimiento` | `DATE` | No | — | Fecha de nacimiento |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idPaciente)` | Llave primaria | Identifica cada paciente de forma única. |
| `CHECK (Sexo IN ('M', 'F'))` | Check | Solo permite los dos valores válidos, con mensaje amigable desde el SP en vez del error crudo del motor. |
| `UNIQUE (Telefono)` / `UNIQUE (Correo)` | Único | Evita que dos pacientes compartan el mismo teléfono o correo. |
| `DEFAULT 1` en `Activo` | Default | Todo paciente nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Relacionada con

[`Consulta`](Consulta.md) — las consultas que ha tenido (1:N).
