# `trg_eliminarDetallePedido`

Script: [`instalacion/07-DetallePedido/04-trg-eliminar-detalle-pedido.sql`](../../instalacion/07-DetallePedido/04-trg-eliminar-detalle-pedido.sql)

| Tabla | Momento | Eventos |
|-------|---------|---------|
| `DetallePedido` | `AFTER` | `DELETE` |

Completa a [`trg_insertarDetallePedido`](trg_insertarDetallePedido.md): cuando se **quita** una línea, recalcula `CantidadArticulos` y `Total` del pedido con las líneas que le quedan.

## Cómo lo hace

En un `DELETE`, `inserted` está vacía: la línea eliminada **solo está en `deleted`**. De ahí sale el pedido que hay que recalcular.

1. Toma `@idPedido` de `deleted`. Si es `NULL`, el `DELETE` no encontró ninguna línea: sale con `RETURN`.
2. Cuenta y suma las líneas que **le quedan** al pedido. Como es un trigger `AFTER`, la línea eliminada ya no está en `DetallePedido`.
3. Actualiza la cabecera.

## Por qué ISNULL

```sql
@Total = ISNULL(SUM(PrecioUnitario * Cantidad), 0)
```

Cuando se quita la **última** línea del pedido, no queda ninguna fila que sumar:

| Función | Sobre 0 filas regresa |
|---------|-----------------------|
| `COUNT(idDetallePedido)` | `0` |
| `SUM(PrecioUnitario * Cantidad)` | **`NULL`** |

`Pedido.Total` es `NOT NULL`. Sin el `ISNULL`, el `UPDATE` del trigger falla:

```
Msg 515: Cannot insert the value NULL into column 'Total', table 'TiendaDB.dbo.Pedido';
column does not allow nulls. UPDATE fails.
```

Y como el error ocurre dentro del trigger, SQL Server **deshace también el `DELETE`**: la línea vuelve a quedar en el pedido. El trigger de `INSERT` no lo necesita, porque cuando se ejecuta el pedido tiene por lo menos la línea que se acaba de insertar.

## Resultados (pruebas 9, 11 y 12 de [`pruebas.sql`](../../pruebas.sql))

| Sentencia | Cabecera del pedido 1 |
|-----------|-----------------------|
| Se quita la línea del artículo 12 | De 3 líneas y $348.00 a 2 líneas y $284.00 |
| Se quita la última línea | 0 líneas y $0.00 |
| `DELETE … WHERE idDetallePedido = 999` | No cambia |

## Limitación

Guarda `deleted` en una variable: si un solo `DELETE` quita líneas de **varios** pedidos, solo recalcula uno.
