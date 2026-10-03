# Tabla `Cliente`

Script: [`instalacion/02-create-table-cliente.sql`](../../instalacion/02-create-table-cliente.sql)

Catálogo de clientes del taller: los dueños de los vehículos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (opcional: no todos los clientes tienen dos apellidos) |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) |
| `Telefono` | `VARCHAR(15)` | No | — | Teléfono de contacto |
| `Correo` | `VARCHAR(100)` | No | — | Correo electrónico |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada cliente. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Vehiculo`](Vehiculo.md) — la referencia por `idCliente` (1:N).
