# Tabla `Consulta`

Script: [`instalacion/07-Consulta/01-create-table.sql`](../../instalacion/07-Consulta/01-create-table.sql)

Hecho — una consulta médica, que une [`Paciente`](Paciente.md), [`Medico`](Medico.md) y [`Consultorio`](Consultorio.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idConsulta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idPaciente` | `INT` | No | — | FK a `Paciente` |
| `idMedico` | `INT` | No | — | FK a `Medico` |
| `idConsultorio` | `INT` | No | — | FK a `Consultorio` |
| `Fecha` | `DATETIME` | No | — | Fecha y hora de la consulta |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idConsulta)` | Llave primaria | Identifica cada consulta de forma única. |
| `FOREIGN KEY (idPaciente)` / `(idMedico)` / `(idConsultorio)` | Llave foránea | Solo permite referenciar registros que existan en sus catálogos. |

No tiene `Activo`: es una tabla de hechos, no un catálogo.

## Relacionada con

[`Receta`](Receta.md) — la receta que genera (1:1).
