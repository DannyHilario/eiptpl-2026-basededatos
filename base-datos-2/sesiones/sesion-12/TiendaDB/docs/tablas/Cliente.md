# Tabla `Cliente`

Scripts: [`instalacion/01-Cliente/`](../../instalacion/01-Cliente)

Catálogo de los clientes que hacen pedidos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre(s) del cliente |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | No | — | Segundo apellido |
| `Telefono` | `VARCHAR(15)` | No | — | Teléfono a 10 dígitos; identifica al cliente |
| `Correo` | `VARCHAR(100)` | No | — | Correo electrónico; identifica al cliente |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada registro. |
| `UNIQUE (Telefono)` | Único | No puede repetirse entre registros. |
| `UNIQUE (Correo)` | Único | No puede repetirse entre registros. |
| `DEFAULT 1` en `Activo` | Default | Todo registro nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |

## Por qué el teléfono y el correo son únicos

Con cualquiera de los dos se busca al cliente cuando hace un pedido. Si dos clientes compartieran teléfono, no se sabría de quién es el pedido.

## Por qué la dirección no está aquí

La dirección de entrega se guarda en cada [`Pedido`](Pedido.md): si el cliente se muda, sus pedidos anteriores siguen diciendo a dónde se enviaron.

## Relacionada con

- [`Pedido`](Pedido.md) — la referencia por `idCliente` (1:N).
