# Tabla `Alumno`

Script: [`instalacion/02-create-table-alumno.sql`](../../instalacion/02-create-table-alumno.sql)

Alumnos del curso (Ejercicio 1: primera tabla creada con DDL, sin relaciones).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idAlumno` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (opcional: no todos los alumnos tienen dos apellidos) |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) |
| `FechaNacimiento` | `DATE` | No | — | Fecha de nacimiento |
| `Edad` | `INT` | **Sí** | — | Edad en años (opcional). Es un dato derivado de `FechaNacimiento`: se guarda para practicar consultas, pero puede quedar desactualizado |
| `CorreoElectronico` | `VARCHAR(100)` | **Sí** | — | Correo electrónico (opcional) |
| `Ciudad` | `VARCHAR(50)` | **Sí** | — | Ciudad de residencia (opcional) |
| `Sexo` | `CHAR(1)` | No | — | `'M'` (masculino) o `'F'` (femenino), igual que en los modelos posteriores del curso; aquí todavía sin `CHECK` |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idAlumno)` | Llave primaria | Identifica cada alumno. |

Es la primera tabla del curso: solo tiene llave primaria, sin `CHECK`, `UNIQUE` ni `DEFAULT`; esos constraints se ven en el Ejercicio 2.
