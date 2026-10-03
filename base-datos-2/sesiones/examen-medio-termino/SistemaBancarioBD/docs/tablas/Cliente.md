# Tabla `Cliente`

Script: [`instalacion/02-Cliente/01-create-table.sql`](../../instalacion/02-Cliente/01-create-table.sql)

Catálogo de clientes del banco.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idSucursal` | `INT` | No | — | FK → `Sucursal` — sucursal donde se dio de alta el cliente |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) del cliente |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | No | — | Segundo apellido |
| `FechaNacimiento` | `DATE` | No | — | Fecha de nacimiento |
| `Sexo` | `CHAR(1)` | No | — | `M` o `F` |
| `CURP` | `CHAR(18)` | No | — | Clave Única de Registro de Población |
| `RFC` | `CHAR(13)` | No | — | RFC de persona física, con homoclave |
| `Telefono` | `VARCHAR(15)` | No | — | Teléfono de contacto a 10 dígitos |
| `CorreoElectronico` | `VARCHAR(100)` | No | — | Correo electrónico |
| `Direccion` | `VARCHAR(200)` | No | — | Domicilio completo en un solo campo (calle, número, colonia, municipio) |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada cliente de forma única. |
| `fk_Cliente_Sucursal` | Llave foránea | El cliente debe pertenecer a una sucursal existente. |
| `CHECK (Sexo IN ('M', 'F'))` | Check | Solo permite los dos valores válidos. |
| `UNIQUE (CURP)` / `UNIQUE (RFC)` | Único | Dos clientes no pueden compartir la misma CURP ni el mismo RFC. |
| `UNIQUE (Telefono)` / `UNIQUE (CorreoElectronico)` | Único | Evita que dos clientes compartan el mismo teléfono o correo. |
| `DEFAULT 1` en `Activo` | Default | Todo cliente nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Datos iniciales

30 clientes, todos activos, nacidos entre 1986 y 1989 (todos mayores de edad), con domicilio en el área metropolitana de Monterrey.

Por sucursal: Centro 10, San Pedro 8, Cumbres 7, Apodaca 5 y Guadalupe 0.

La CURP sigue la estructura oficial: 4 letras iniciales, fecha `AAMMDD`, sexo (`H`/`M`), entidad (`NL`), 3 consonantes internas, diferenciador `0` (nacidos antes del 2000) y dígito verificador calculado con el algoritmo oficial. El RFC comparte las 10 primeras posiciones con la CURP más una homoclave de 3 caracteres. Todos los datos son ficticios.

## Relacionada con

- [`Sucursal`](Sucursal.md) — sucursal donde se dio de alta (N:1).
- [`Tarjeta`](Tarjeta.md) — las tarjetas de crédito del cliente (1:N, de 0 a 3 tarjetas).
