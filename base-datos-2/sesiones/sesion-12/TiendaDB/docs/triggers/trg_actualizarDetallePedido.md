# `trg_actualizarDetallePedido`

Script: [`instalacion/07-DetallePedido/03-trg-actualizar-detalle-pedido.sql`](../../instalacion/07-DetallePedido/03-trg-actualizar-detalle-pedido.sql)

| Tabla | Momento | Eventos |
|-------|---------|---------|
| `DetallePedido` | `AFTER` | `UPDATE` |

Completa a [`trg_insertarDetallePedido`](trg_insertarDetallePedido.md): cuando se **modifica** una línea (por ejemplo, el cliente pide más piezas), recalcula `CantidadArticulos` y `Total` del pedido.

## Cómo lo hace

En un `UPDATE`, la línea está en las dos tablas especiales:

| Tabla | Qué tiene | Se usa para |
|-------|-----------|-------------|
| `inserted` | La línea como **quedó** | `@idPedido`: el pedido que hay que recalcular |
| `deleted` | La línea como **estaba** | `@idPedidoAnterior`: el pedido al que pertenecía antes |

1. Si `@idPedido` es `NULL`, el `UPDATE` no encontró ninguna línea: sale con `RETURN`.
2. Recalcula la cabecera de `@idPedido`, igual que el trigger de `INSERT`.
3. Si `@idPedidoAnterior <> @idPedido`, la línea **se movió de pedido**: el pedido del que salió también cambió, así que lo recalcula.

```sql
IF @idPedidoAnterior <> @idPedido BEGIN

	SELECT
		@CantidadArticulos = COUNT(idDetallePedido),
		@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
	FROM DetallePedido
	WHERE idPedido = @idPedidoAnterior

	UPDATE Pedido
	...
	WHERE idPedido = @idPedidoAnterior

END
```

Es el caso en el que **se necesitan las dos tablas**: `inserted` dice a dónde llegó la línea y `deleted`, de dónde salió.

El `ISNULL` hace falta para el pedido del que salió la línea: si era la única, ese pedido se queda sin líneas y `SUM` regresa `NULL` (ver [`trg_eliminarDetallePedido`](trg_eliminarDetallePedido.md#por-qué-isnull)).

## Resultados (pruebas 8, 10 y 12 de [`pruebas.sql`](../../pruebas.sql))

| Sentencia | Cabeceras |
|-----------|-----------|
| La línea del artículo 9 pasa de 3 a 4 piezas | Pedido 1: de $332.00 a $348.00 |
| La línea del artículo 38 se mueve del pedido 1 al 2 | Pedido 1: de 2 líneas y $284.00 a 1 línea y $64.00; pedido 2: de 0 a 1 línea y $220.00 |
| `UPDATE … WHERE idDetallePedido = 999` | Ninguna cambia |

## Limitación

Como los triggers de clase, guarda `inserted` y `deleted` en variables: si un solo `UPDATE` modifica líneas de **varios** pedidos, solo recalcula uno.

Tampoco revisa el precio. Si alguien cambia el **artículo** de una línea, la línea se queda con el precio del artículo anterior. Esa validación, como la de que solo se modifiquen pedidos en estatus Creado, corresponde a un procedimiento almacenado.
