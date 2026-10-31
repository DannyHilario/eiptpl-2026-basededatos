# Tabla `EstatusPedido`

Scripts: [`instalacion/02-EstatusPedido/`](../../instalacion/02-EstatusPedido)

Catálogo de los estatus por los que pasa un pedido.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idEstatusPedido` | `INT` | No | — | Llave primaria: 1 Creado, 2 Enviado, 3 Cancelado, 4 Entregado |
| `Nombre` | `VARCHAR(30)` | No | — | Nombre del estatus |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idEstatusPedido)` | Llave primaria | Identifica cada registro. |
| `UNIQUE (Nombre)` | Único | No puede repetirse entre registros. |
| `DEFAULT 1` en `Activo` | Default | Todo registro nuevo nace activo. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |

## Por qué no tiene IDENTITY

Los números son parte de las reglas de negocio: el `DEFAULT 1` de `Pedido.idEstatusPedido` y las transiciones permitidas (1 → 2, 2 → 3 y 2 → 4) dependen de ellos. Con `IDENTITY`, los números dependerían del orden en que se insertaran; sin él, el `INSERT` los escribe explícitamente.

| idEstatusPedido | Nombre | Puede pasar a |
|---|---|---|
| 1 | Creado | 2 Enviado |
| 2 | Enviado | 3 Cancelado o 4 Entregado |
| 3 | Cancelado | — (final) |
| 4 | Entregado | — (final) |

## Relacionada con

- [`Pedido`](Pedido.md) — la referencia por `idEstatusPedido` (1:N).
- [`BitacoraEstatusPedido`](BitacoraEstatusPedido.md) — la referencia por `idEstatusPedido` (1:N).
