# Tabla `Empleado`

Script: [`instalacion/02-create-table-empleado.sql`](../../instalacion/02-create-table-empleado.sql)

Catálogo de empleados de la empresa, por departamento.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idEmpleado` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (opcional: no todos los empleados tienen dos apellidos) |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) |
| `Departamento` | `VARCHAR(50)` | No | — | Departamento donde trabaja (Producción, Administración, Recursos Humanos, …). Se guarda como texto, no como catálogo |
| `CURP` | `CHAR(18)` | **Sí** | — | CURP del empleado (opcional) |
| `Sexo` | `CHAR(1)` | No | — | `'M'` o `'F'` |
| `FechaNacimiento` | `DATE` | No | — | Fecha de nacimiento |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idEmpleado)` | Llave primaria | Identifica cada empleado. |
| `chk_Empleado_Sexo`: `CHECK (Sexo IN ('M', 'F'))` | Check | Restringe `Sexo` a esos dos valores: el motor rechaza cualquier otro carácter. |

No tiene `Activo`: el modelo del examen no contempla bajas de empleados.

## Relacionada con

- [`Servicio`](Servicio.md) — la referencia por `idEmpleado` (1:N).
