# Transacciones con TRY CATCH

Un pedido son varias instrucciones: el `INSERT` del pedido, su primer estatus en la bitácora y un `INSERT` por cada línea. Como se vio en [Errores y TRY CATCH](03-Errores.md#qué-pasa-con-el-resto-del-lote), si una falla, las demás **se quedan**. Una **transacción** agrupa varias instrucciones para que se guarden **todas o ninguna**.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4.

---

## El problema: un pedido a medias

Se crea el pedido del cliente 8 con tres líneas. La tercera trae cantidad 0, que el `CHECK` de `DetallePedido` rechaza:

```sql
DECLARE @idPedido int

INSERT INTO Pedido (idCliente, DireccionEntrega, CostoEnvio)
VALUES (8, 'Washington 300 Ote., Col. Centro, CP 64000', 35.00)

SELECT @idPedido = SCOPE_IDENTITY()

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido)
VALUES (@idPedido, 1)

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT @idPedido, idArticulo, 2, PrecioUnitario
FROM Articulo
WHERE idArticulo = 1

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT @idPedido, idArticulo, 1, PrecioUnitario
FROM Articulo
WHERE idArticulo = 6

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT @idPedido, idArticulo, 0, PrecioUnitario
FROM Articulo
WHERE idArticulo = 11

SELECT idPedido, idCliente, CantidadArticulos, Total
FROM Pedido
WHERE idPedido = @idPedido
```

```
Msg 547, Level 16 ... conflicted with the CHECK constraint "chk_DetallePedido_Cantidad".
The statement has been terminated.
```

| idPedido | idCliente | CantidadArticulos | Total |
|----------|-----------|-------------------|-------|
| 9 | 8 | 2 | 74.00 |

El pedido 9 **quedó guardado** con dos de sus tres líneas. Para el negocio es un pedido incorrecto: el cliente pidió tres artículos.

---

## Qué es una transacción

Una **transacción** es un grupo de instrucciones que SQL Server trata como **una sola**: o se guardan todas, o no se guarda ninguna.

| Instrucción | Qué hace |
|-------------|----------|
| `BEGIN TRANSACTION` | Empieza la transacción. Desde aquí, los cambios quedan **pendientes** |
| `COMMIT TRANSACTION` | Confirma: todos los cambios pendientes se guardan definitivamente |
| `ROLLBACK TRANSACTION` | Cancela: todos los cambios pendientes se deshacen, como si nunca hubieran pasado |

`@@TRANCOUNT` dice cuántas transacciones hay abiertas: `0` si ninguna.

> Sin `BEGIN TRANSACTION`, cada instrucción es su propia transacción: se confirma en cuanto termina. Por eso el pedido 9 se quedó a medias.

---

## Transacción con TRY CATCH

El patrón junta las dos cosas: si todo sale bien, `COMMIT` al final del `TRY`; si algo falla, el `CATCH` hace `ROLLBACK`.

```sql
DECLARE @idPedido int

BEGIN TRY

	BEGIN TRANSACTION

	INSERT INTO Pedido (idCliente, DireccionEntrega, CostoEnvio)
	VALUES (9, 'Juárez 120 Nte., Col. Centro, CP 64000', 35.00)

	SELECT @idPedido = SCOPE_IDENTITY()

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido)
	VALUES (@idPedido, 1)

	INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
	SELECT @idPedido, idArticulo, 2, PrecioUnitario
	FROM Articulo
	WHERE idArticulo = 1

	INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
	SELECT @idPedido, idArticulo, 1, PrecioUnitario
	FROM Articulo
	WHERE idArticulo = 6

	INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
	SELECT @idPedido, idArticulo, 0, PrecioUnitario
	FROM Articulo
	WHERE idArticulo = 11

	COMMIT TRANSACTION

	PRINT 'Pedido guardado'

END TRY
BEGIN CATCH

	PRINT 'TRANCOUNT en el CATCH: ' + CONVERT(varchar(5), @@TRANCOUNT)

	IF @@TRANCOUNT > 0 BEGIN
		ROLLBACK TRANSACTION
	END

	PRINT 'No se guardó el pedido: ' + ERROR_MESSAGE()

END CATCH
```

```
TRANCOUNT en el CATCH: 1
No se guardó el pedido: The INSERT statement conflicted with the CHECK constraint "chk_DetallePedido_Cantidad". ...
```

```sql
SELECT idPedido, idCliente, CantidadArticulos, Total
FROM Pedido
WHERE idCliente = 9
```

| idPedido | idCliente | CantidadArticulos | Total |
|----------|-----------|-------------------|-------|
| *(ninguna fila)* | | | |

Ni el pedido, ni su bitácora, ni las dos líneas que sí se habían insertado: **todo se deshizo**.

Cómo se lee el patrón:

1. `BEGIN TRANSACTION` va **dentro** del `TRY`.
2. `COMMIT` es la **última** instrucción del `TRY`: solo se llega a ella si nada falló.
3. En el `CATCH`, `IF @@TRANCOUNT > 0` revisa que haya una transacción abierta antes de hacer `ROLLBACK`. Si el error ocurrió antes del `BEGIN TRANSACTION`, no hay nada que deshacer, y un `ROLLBACK` sin transacción abierta también marca error.

---

## Lo que el ROLLBACK no devuelve

Si después del ejemplo anterior se crea otro pedido:

```sql
INSERT INTO Pedido (idCliente, DireccionEntrega, CostoEnvio)
VALUES (9, 'Juárez 120 Nte., Col. Centro, CP 64000', 35.00)

SELECT idPedido, idCliente
FROM Pedido
WHERE idCliente = 9
```

| idPedido | idCliente |
|----------|-----------|
| 11 | 9 |

Recibe el **11**, no el 10. El pedido que se deshizo ya había tomado el 10, y el `ROLLBACK` no lo devuelve: los números de `IDENTITY` no se reutilizan. Un hueco en la numeración no es un error; es la huella de una transacción que se deshizo.

---

## Los triggers van dentro de la transacción

Un trigger se ejecuta **dentro de la misma transacción** que la instrucción que lo disparó. Por eso, cuando el trigger falla, se deshace también la instrucción: eso pasó en la sesión 12 con el [error de la primera versión](../../sesiones/sesion-12/README.md#el-error-de-la-primera-versión) del trigger de cabecera y con el [`ISNULL`](04-ValoresNulos.md#el-caso-real-el-trigger-de-la-sesión-12) del trigger de `DELETE`. Y es lo que se aprovecha en [THROW](07-Throw.md) para que un trigger **rechace** un cambio.

---

## Resumen

- Sin transacción, cada instrucción se guarda en cuanto termina: si una falla, las anteriores se quedan.
- `BEGIN TRANSACTION` agrupa; `COMMIT TRANSACTION` guarda todo; `ROLLBACK TRANSACTION` deshace todo.
- El patrón: `BEGIN TRANSACTION` y `COMMIT` dentro del `TRY`; en el `CATCH`, `IF @@TRANCOUNT > 0 ROLLBACK`.
- El `ROLLBACK` no devuelve los números de `IDENTITY`.
- Un trigger corre dentro de la transacción de la instrucción que lo disparó: si falla, la deshace.
