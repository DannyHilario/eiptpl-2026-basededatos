# Tabla `DetallePedido`

Scripts: [`instalacion/07-DetallePedido/`](../../instalacion/07-DetallePedido)

**Líneas** del pedido: qué artículos lleva, cuántos y a qué precio. Resuelve la relación N:M entre [`Pedido`](Pedido.md) y [`Articulo`](Articulo.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idDetallePedido` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idPedido` | `INT` | No | — | FK a `Pedido` |
| `idArticulo` | `INT` | No | — | FK a `Articulo` |
| `Cantidad` | `INT` | No | — | Piezas del artículo |
| `PrecioUnitario` | `DECIMAL(10,2)` | No | — | Precio **con el que se vendió**, copiado de `Articulo.PrecioUnitario` |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se creó el registro |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Auditoría: cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idDetallePedido)` | Llave primaria | Identifica cada registro. |
| `DEFAULT GETDATE()` en `FechaCreacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `DEFAULT GETDATE()` en `FechaUltimaModificacion` | Default | Se llena sola con la fecha y hora del servidor. |
| `fk_DetallePedido_Pedido`: `FOREIGN KEY (idPedido)` → `Pedido(idPedido)` | Llave foránea | Solo permite referenciar registros de `Pedido` que existan. |
| `fk_DetallePedido_Articulo`: `FOREIGN KEY (idArticulo)` → `Articulo(idArticulo)` | Llave foránea | Solo permite referenciar registros de `Articulo` que existan. |
| `chk_DetallePedido_Cantidad`: `CHECK (Cantidad > 0)` | Check | Evita valores imposibles para el negocio. |
| `chk_DetallePedido_PrecioUnitario`: `CHECK (PrecioUnitario > 0)` | Check | Evita valores imposibles para el negocio. |
| `uq_DetallePedido_Pedido_Articulo`: `UNIQUE (idPedido, idArticulo)` | Único compuesto | La combinación no puede repetirse. |

## Por qué se copia el precio

Si mañana sube el refresco, los pedidos de ayer deben seguir diciendo a cuánto se vendió. Por eso la línea guarda su propio precio en lugar de consultarlo en `Articulo`.

## Por qué un artículo una sola vez por pedido

El `UNIQUE (idPedido, idArticulo)` obliga a que, si el cliente quiere más piezas, se cambie la `Cantidad` de su línea en lugar de agregar otra.

## Sin columna de importe

`Cantidad × PrecioUnitario` se calcula: guardarlo sería un dato más que mantener sincronizado.

## Triggers

| Evento | Trigger |
|---|---|
| `INSERT` | [`trg_insertarDetallePedido`](../triggers/trg_insertarDetallePedido.md) |
| `UPDATE` | [`trg_actualizarDetallePedido`](../triggers/trg_actualizarDetallePedido.md) |
| `DELETE` | [`trg_eliminarDetallePedido`](../triggers/trg_eliminarDetallePedido.md) |

Los tres recalculan la cabecera del pedido.

## Relacionada con

- [`Pedido`](Pedido.md) — por `idPedido` (N:1).
- [`Articulo`](Articulo.md) — por `idArticulo` (N:1).
