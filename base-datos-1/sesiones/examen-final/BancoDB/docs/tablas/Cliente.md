# Tabla `Cliente`

Script: [`instalacion/02-create-table-cliente.sql`](../../instalacion/02-create-table-cliente.sql)

Catálogo de clientes del banco.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (opcional: no todos los clientes tienen dos apellidos) |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) |
| `FechaNacimiento` | `DATE` | No | — | Fecha de nacimiento |
| `CURP` | `CHAR(18)` | **Sí** | — | CURP (opcional) |
| `RFC` | `CHAR(13)` | **Sí** | — | RFC (opcional) |
| `Sexo` | `CHAR(1)` | No | — | `'M'` o `'F'` |
| `Telefono` | `VARCHAR(15)` | **Sí** | — | Teléfono de contacto (opcional) |
| `CorreoElectronico` | `VARCHAR(100)` | **Sí** | — | Correo electrónico (opcional) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada cliente. |
| `chk_Cliente_Sexo`: `CHECK (Sexo IN ('M', 'F'))` | Check | Restringe `Sexo` a esos dos valores: el motor rechaza cualquier otro carácter. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Transaccion`](Transaccion.md) — la referencia por `idCliente` (1:N).
