# Tabla `Cliente`

Script: [`instalacion/05-Cliente/01-create-table.sql`](../../instalacion/05-Cliente/01-create-table.sql)

Catálogo de clientes.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre del cliente |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (único campo opcional de la tabla; no todos los clientes tienen dos apellidos) |
| `Sexo` | `CHAR(1)` | No | — | `'M'` o `'F'` |
| `Telefono` | `VARCHAR(20)` | Sí | — | Teléfono; puede repetirse `NULL` en varios clientes, pero si tiene valor debe ser único |
| `Correo` | `VARCHAR(100)` | Sí | — | Correo; mismo criterio que `Telefono` |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada cliente. |
| `UNIQUE (Telefono)` | Único | No permite que dos clientes compartan el mismo teléfono. En SQL Server, `UNIQUE` **sí permite varios `NULL`** (un `NULL` nunca es igual a otro `NULL`), por eso puede haber varios clientes sin teléfono capturado. |
| `UNIQUE (Correo)` | Único | Mismo criterio que `Telefono`. |
| `CHECK (Sexo IN ('M', 'F'))` | Check | Restringe el dominio de `Sexo` a solo esos dos valores — el motor rechaza cualquier otro carácter aunque alguien haga un `INSERT`/`UPDATE` directo sin pasar por el SP. |
| `DEFAULT 1` en `Activo` | Default | Todo cliente nuevo nace activo. |
| `DEFAULT GETDATE()` en fechas de auditoría | Default | Igual que en las demás tablas. |

## SPs relacionados

[`usp_insertarCliente`](../usp_insertarCliente.md) · [`usp_eliminarCliente`](../usp_eliminarCliente.md) · [`usp_habilitarCliente`](../usp_habilitarCliente.md) · [`usp_actualizarCliente`](../usp_actualizarCliente.md)
