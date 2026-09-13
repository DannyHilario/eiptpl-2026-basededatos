# Tabla `DetallePedido`

Script: [`instalacion/07-DetallePedido/01-create-table.sql`](../../instalacion/07-DetallePedido/01-create-table.sql)

Líneas de un pedido (artículo, cantidad, precio al momento de la venta) — **1:N** con `Pedido`, **N:1** con `Articulo`.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idDetallePedido` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idPedido` | `INT` | No | — | FK a `Pedido` |
| `idArticulo` | `INT` | No | — | FK a `Articulo` |
| `Cantidad` | `INT` | No | — | Cantidad de ese artículo en el pedido |
| `PrecioUnitario` | `DECIMAL(10,2)` | No | — | Precio **congelado** al momento de agregar la línea — no es el precio de lista vigente de `Articulo`, es el que se pactó en esa venta (ver [`usp_insertarDetallePedido`](../usp_insertarDetallePedido.md)) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se agregó la línea |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez (p. ej. al fusionar cantidad) |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idDetallePedido)` | Llave primaria | Identifica cada línea. |
| `FOREIGN KEY (idPedido) REFERENCES Pedido` | Llave foránea | No se puede crear una línea de un pedido que no existe. |
| `FOREIGN KEY (idArticulo) REFERENCES Articulo` | Llave foránea | No se puede vender un artículo que no existe. |
| `CHECK (Cantidad > 0)` | Check | Una línea con cantidad `0` o negativa no tiene sentido — el motor la rechaza aunque alguien la inserte sin pasar por el SP. |
| `CHECK (PrecioUnitario > 0)` | Check | Mismo criterio que en `Articulo`: un precio de venta en cero o negativo no es válido. |
| `UNIQUE (idPedido, idArticulo)` | Único | **Es la constraint que hace posible la lógica de "fusionar cantidades"**: un artículo solo puede aparecer **una vez** por pedido. `usp_insertarDetallePedido` la respeta buscando primero si ya existe esa combinación — si existe, hace `UPDATE Cantidad = Cantidad + @p_Cantidad` en vez de `INSERT`, para nunca violar esta constraint. Sin ella, nada impediría tener dos líneas del mismo artículo en el mismo pedido con cantidades separadas. |

## SPs relacionados

[`usp_insertarDetallePedido`](../usp_insertarDetallePedido.md) · [`usp_eliminarDetallePedido`](../usp_eliminarDetallePedido.md) · [`usp_actualizarDetallePedido`](../usp_actualizarDetallePedido.md)
