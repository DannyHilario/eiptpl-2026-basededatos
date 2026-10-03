# Tabla `Alumno`

Script: [`instalacion/03-create-table-alumno.sql`](../../instalacion/03-create-table-alumno.sql)

Alumnos inscritos; cada uno pertenece a una [`Tecnica`](Tecnica.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idAlumno` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idTecnica` | `INT` | No | — | FK a `Tecnica` |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (opcional: no todos los alumnos tienen dos apellidos) |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) |
| `Edad` | `INT` | **Sí** | — | Edad en años (opcional). Es un dato derivado de `FechaNacimiento`: se guarda para practicar consultas, pero puede quedar desactualizado |
| `Sexo` | `CHAR(1)` | No | — | `'M'` o `'F'` |
| `CURP` | `CHAR(18)` | **Sí** | — | CURP del alumno (opcional) |
| `FechaNacimiento` | `DATE` | No | — | Fecha de nacimiento |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idAlumno)` | Llave primaria | Identifica cada alumno. |
| `fk_Alumno_Tecnica`: `FOREIGN KEY (idTecnica)` → `Tecnica(idTecnica)` | Llave foránea | Solo permite inscribir al alumno en una carrera técnica que exista en el catálogo. |
| `chk_Alumno_Sexo`: `CHECK (Sexo IN ('M', 'F'))` | Check | Restringe `Sexo` a esos dos valores: el motor rechaza cualquier otro carácter. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Tecnica`](Tecnica.md) — por `idTecnica` (N:1).
