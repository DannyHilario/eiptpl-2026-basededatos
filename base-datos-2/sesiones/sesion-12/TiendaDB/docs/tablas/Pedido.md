# Tabla `Pedido`

Scripts: [`instalacion/06-Pedido/`](../../instalacion/06-Pedido)

**Cabecera** del pedido: quién lo pidió, en qué estatus está, a dónde se envía y cuánto suma.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idPedido` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCliente` | `INT` | No | — | FK a `Cliente` |
| `idEstatusPedido` | `INT` | No | `1` | FK a `EstatusPedido`: el estatus **vigente** |
| `FechaPedido` | `DATETIME` | No | `GETDATE()` | Fecha y hora del pedido |
| `DireccionEntrega` | `VARCHAR(200)` | No | — | Dirección a la que se envía este pedido |
| `CostoEnvio` | `DECIMAL(10,2)` | No | `0` | Costo del envío, por pedido |
| `CantidadArticulos` | `INT` | No | `0` | Número de líneas del pedido; lo mantienen los triggers de `DetallePedido` |
| `Total` | `DECIMAL(12,2)` | No | `0` | Suma de `Cantidad × PrecioUnitario` de sus líneas, sin el envío; lo mantienen los triggers de `DetallePedido` |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idPedido)` | Llave primaria | Identifica cada registro. |
| `DEFAULT 1` en `idEstatusPedido` | Default | Todo pedido nace en estatus Creado. |
| `DEFAULT GETDATE()` en `FechaPedido` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT 0` en `CostoEnvio` | Default | Si no se indica, el envío es gratis. |
| `DEFAULT 0` en `CantidadArticulos` | Default | El pedido nace vacío; los triggers lo actualizan. |
| `DEFAULT 0` en `Total` | Default | El pedido nace vacío; los triggers lo actualizan. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `fk_Pedido_Cliente`: `FOREIGN KEY (idCliente)` → `Cliente(idCliente)` | Llave foránea | Solo permite referenciar registros de `Cliente` que existan. |
| `fk_Pedido_EstatusPedido`: `FOREIGN KEY (idEstatusPedido)` → `EstatusPedido(idEstatusPedido)` | Llave foránea | Solo permite referenciar registros de `EstatusPedido` que existan. |
| `chk_Pedido_CostoEnvio`: `CHECK (CostoEnvio >= 0)` | Check | Evita valores imposibles para el negocio. |
| `chk_Pedido_CantidadArticulos`: `CHECK (CantidadArticulos >= 0)` | Check | Evita valores imposibles para el negocio. |
| `chk_Pedido_Total`: `CHECK (Total >= 0)` | Check | Evita valores imposibles para el negocio. |

## La cabecera la mantienen los triggers

`CantidadArticulos` y `Total` nacen en 0 y **nadie los escribe a mano**: cada vez que se agrega, modifica o quita una línea en [`DetallePedido`](DetallePedido.md), un trigger los recalcula ([`trg_insertarDetallePedido`](../triggers/trg_insertarDetallePedido.md), [`trg_actualizarDetallePedido`](../triggers/trg_actualizarDetallePedido.md) y [`trg_eliminarDetallePedido`](../triggers/trg_eliminarDetallePedido.md)).

## El estatus vigente y la bitácora

`idEstatusPedido` es una copia del estatus **actual**, para no tener que buscarlo en la bitácora cada vez. El historial completo de estatus está en [`BitacoraEstatusPedido`](BitacoraEstatusPedido.md).

## Por qué la dirección de entrega está aquí

Cada pedido guarda la dirección a la que se envió. Si estuviera en `Cliente`, al mudarse el cliente todos sus pedidos anteriores aparecerían enviados a la dirección nueva.

## Relacionada con

- [`Cliente`](Cliente.md) — por `idCliente` (N:1).
- [`EstatusPedido`](EstatusPedido.md) — por `idEstatusPedido` (N:1).
- [`DetallePedido`](DetallePedido.md) — la referencia por `idPedido` (1:N).
- [`BitacoraEstatusPedido`](BitacoraEstatusPedido.md) — la referencia por `idPedido` (1:N).
