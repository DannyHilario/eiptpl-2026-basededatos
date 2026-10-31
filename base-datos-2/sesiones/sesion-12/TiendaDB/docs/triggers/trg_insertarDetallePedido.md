# `trg_insertarDetallePedido`

Script: [`instalacion/07-DetallePedido/02-trg-insertar-detalle-pedido.sql`](../../instalacion/07-DetallePedido/02-trg-insertar-detalle-pedido.sql)

| Tabla | Momento | Eventos |
|-------|---------|---------|
| `DetallePedido` | `AFTER` | `INSERT` |

Mantiene la **cabecera** del pedido al día: cada vez que se le agrega una línea, recalcula `Pedido.CantidadArticulos` (cuántas líneas tiene) y `Pedido.Total` (la suma de `Cantidad × PrecioUnitario` de sus líneas, sin el envío).

## Cómo lo hace

1. Toma de `inserted` el pedido al que se le agregó la línea.
2. Cuenta y suma **todas** las líneas de ese pedido, no solo la nueva:

   ```sql
   SELECT
   	@CantidadArticulos = COUNT(idDetallePedido),
   	@Total = SUM(PrecioUnitario * Cantidad)
   FROM DetallePedido
   WHERE idPedido = @idPedido
   ```

   Como es un trigger `AFTER`, la línea nueva **ya está** en `DetallePedido` cuando se ejecuta este `SELECT`.
3. Actualiza la cabecera, incluida su `FechaUltimaModificacion`.

Recalcular todo, en lugar de sumarle al total el importe de la línea nueva, evita que la cabecera se desfase si alguna vez quedó mal.

## El error de la primera versión

La primera versión de clase, además de recalcular, hacía un `INSERT INTO DetallePedido` con el precio vigente del artículo. Cualquier línea nueva fallaba:

```
Violation of UNIQUE KEY constraint 'uq_DetallePedido_Pedido_Articulo'.
```

**Por qué.** En un trigger `AFTER INSERT`, la fila **ya se insertó**. El `INSERT` del trigger metía **otra vez** la misma combinación de pedido y artículo, y eso viola la llave única. Como el error ocurre dentro del trigger, SQL Server deshace **también** el `INSERT` original: por eso parecía que el problema era la sentencia que escribía el usuario.

**La regla:** un trigger `AFTER INSERT` no inserta la fila, porque ya existe. Si hay que modificarla (por ejemplo, ponerle el precio vigente), se hace con un `UPDATE` sobre las filas de `inserted`; si hay que insertarla de otra manera, se usa un trigger `INSTEAD OF INSERT`.

## Resultados (pruebas 5 a 7 de [`pruebas.sql`](../../pruebas.sql))

| Sentencia | Cabecera del pedido 1 |
|-----------|-----------------------|
| Pedido recién creado | 0 líneas, $0.00 |
| Línea del artículo 9 (3 × $16.00) | 1 línea, $48.00 |
| Líneas de los artículos 12 (2 × $32.00) y 38 (5 × $44.00) | 3 líneas, $332.00 |
| Otra vez el artículo 9 | Error de llave única; la cabecera no cambia |

## Los otros eventos

Este trigger solo atiende `INSERT`. Cuando se **modifica** o se **quita** una línea, la cabecera la recalculan [`trg_actualizarDetallePedido`](trg_actualizarDetallePedido.md) y [`trg_eliminarDetallePedido`](trg_eliminarDetallePedido.md), que se desarrollaron después de clase.

## Limitaciones

- **Varias filas.** Guarda `inserted` en una variable, así que solo funciona si todas las líneas de la sentencia son del **mismo** pedido.
- **El precio de la línea.** Lo trae el `INSERT`; el trigger no verifica que sea el precio vigente del artículo.
