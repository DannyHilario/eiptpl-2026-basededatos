# Tabla `MedicoEspecialidad`

Script: [`instalacion/03-MedicoEspecialidad/01-create-table.sql`](../../instalacion/03-MedicoEspecialidad/01-create-table.sql)

Tabla puente — relación **N:M** entre [`Medico`](Medico.md) y [`Especialidad`](Especialidad.md): un médico puede tener varias especialidades, y una especialidad puede tenerla varios médicos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idMedicoEspecialidad` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idMedico` | `INT` | No | — | FK a `Medico` |
| `idEspecialidad` | `INT` | No | — | FK a `Especialidad` |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idMedicoEspecialidad)` | Llave primaria | Identifica cada relación médico-especialidad. |
| `FOREIGN KEY (idMedico)` | Llave foránea | Solo permite referenciar médicos que existan. |
| `FOREIGN KEY (idEspecialidad)` | Llave foránea | Solo permite referenciar especialidades que existan. |
| `UNIQUE (idMedico, idEspecialidad)` | Único | Evita asignar la misma especialidad dos veces al mismo médico. |

No tiene `Activo`: es una tabla de relación, no un catálogo — quitar la relación es un `DELETE` físico del renglón, no una baja lógica.
