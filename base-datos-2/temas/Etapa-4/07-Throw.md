# THROW

Hasta ahora, los errores los generaba SQL Server: una llave repetida, un `CHECK`, un `NULL`. `THROW` permite **generar un error propio** cuando el código detecta algo que el negocio no permite. Es la pieza que le faltaba a un trigger para **rechazar** un cambio.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4. Parte de [Errores y TRY CATCH](03-Errores.md) y de [Transacciones](05-Transacciones.md).

---

## Lanzar un error propio

```sql
THROW número, 'mensaje', estado;
```

| Parte | Regla |
|-------|-------|
| `número` | De **50000** en adelante. Del 1 al 49999 son de SQL Server |
| `'mensaje'` | El texto que verá quien ejecutó |
| `estado` | Un número de 0 a 255, para distinguir en qué parte del código se lanzó; normalmente `1` |

```sql
THROW 50001, 'El pedido no existe', 1;

PRINT 'Esto no se imprime: THROW termina el lote'
```

```
Msg 50001, Level 16, State 1, Line 1
El pedido no existe
```

Se ve igual que un error de SQL Server, con severidad **16**, y **termina el lote**: el `PRINT` no se ejecuta.

### El punto y coma

La instrucción **anterior** a `THROW` debe terminar con `;`:

```sql
PRINT 'Mensaje'
THROW 50001, 'Sin punto y coma antes', 1;
```

```
Msg 102, Level 15, State 1, Line 2
Incorrect syntax near 'THROW'.
```

Es un error de sintaxis, así que ni siquiera el `PRINT` se ejecuta. Por eso en los ejemplos de este tema todas las instrucciones terminan con `;`.

---

## Relanzar un error desde el CATCH

Dentro de un `CATCH`, `THROW` **sin parámetros** vuelve a lanzar el error que se atrapó, con su número y su mensaje originales. Sirve cuando el `CATCH` hace algo (deshacer una transacción, registrar, avisar) pero el error debe llegar a quien ejecutó:

```sql
BEGIN TRY
	INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
	VALUES (5, 2, 1, 18.00);
END TRY
BEGIN CATCH
	PRINT 'Se registra el error y se vuelve a lanzar';
	THROW;
END CATCH
```

```
Se registra el error y se vuelve a lanzar
Msg 2627, Level 14, State 1, Line 2
Violation of UNIQUE KEY constraint 'uq_DetallePedido_Pedido_Articulo'. ...
```

> **`THROW` o `RAISERROR`.** En código anterior a SQL Server 2012 vas a encontrar `RAISERROR`, que también lanza errores. `THROW` es el recomendado: su sintaxis es más simple y siempre termina la ejecución.

---

## Un trigger que rechaza un cambio

En TiendaDB, nada impide un cambio de estatus inválido. La regla del negocio: de **Creado** (1) solo se pasa a **Enviado** (2), y de Enviado a **Cancelado** (3) o a **Entregado** (4). Nunca hacia atrás.

Un procedimiento almacenado puede validar la regla, pero un `UPDATE` directo se lo salta. Un trigger, no: se dispara con **cualquier** `UPDATE`. Lo que le faltaba al trigger era una forma de **rechazar**, y esa forma es `THROW`:

```sql
CREATE TRIGGER trg_validarEstatusPedido
ON Pedido
AFTER UPDATE
AS
BEGIN

	DECLARE @TransicionesInvalidas int

	-- Cuenta los pedidos cuyo estatus cambió a uno no permitido.
	-- deleted tiene el estatus anterior e inserted el nuevo

	SELECT
		@TransicionesInvalidas = COUNT(I.idPedido)
	FROM inserted I
	INNER JOIN deleted D ON D.idPedido = I.idPedido
	WHERE I.idEstatusPedido <> D.idEstatusPedido
		AND NOT (D.idEstatusPedido = 1 AND I.idEstatusPedido = 2)
		AND NOT (D.idEstatusPedido = 2 AND I.idEstatusPedido IN (3, 4));

	IF @TransicionesInvalidas > 0 BEGIN
		THROW 50001, 'Transición de estatus no permitida: solo de Creado a Enviado y de Enviado a Cancelado o Entregado', 1;
	END

END
```

Cómo se lee la condición:

| Parte | Significa |
|-------|-----------|
| `I.idEstatusPedido <> D.idEstatusPedido` | El estatus **cambió**. Los `UPDATE` que no lo tocan, como los que hacen los triggers de `DetallePedido` al recalcular la cabecera, no se revisan |
| `NOT (D… = 1 AND I… = 2)` | No es la transición Creado → Enviado |
| `NOT (D… = 2 AND I… IN (3, 4))` | No es Enviado → Cancelado ni Enviado → Entregado |

Si un pedido cumple las tres, su cambio no está en la lista de permitidos. Como se cuentan **todas** las filas de `inserted`, el trigger funciona aunque un solo `UPDATE` cambie muchos pedidos.

### Qué pasa al lanzar el error

El trigger corre **dentro de la transacción** del `UPDATE` ([Transacciones](05-Transacciones.md#los-triggers-van-dentro-de-la-transacción)). Al lanzar el error, SQL Server **deshace el `UPDATE`** completo y termina el lote.

| Prueba | Antes | Resultado |
|--------|-------|-----------|
| `UPDATE Pedido SET idEstatusPedido = 4 WHERE idPedido = 3;` | Enviado | ✅ Pasa a Entregado |
| `UPDATE Pedido SET idEstatusPedido = 1 WHERE idPedido = 1;` | Entregado | ❌ `Msg 50001`; sigue en Entregado |
| `UPDATE Pedido SET idEstatusPedido = 4 WHERE idPedido = 5;` | Creado | ❌ `Msg 50001`: no se puede saltar de Creado a Entregado |
| `INSERT` de una línea en el pedido 5 | Creado, $320.00 | ✅ La cabecera se recalcula a $342.00: el estatus no cambió, así que el trigger no rechaza nada |
| `UPDATE Pedido SET idEstatusPedido = 2 WHERE idEstatusPedido = 1;` | Pedidos 5, 6 y 8 en Creado | ✅ Los tres pasan a Enviado |
| `UPDATE Pedido SET idEstatusPedido = 3 WHERE idPedido IN (1, 5);` | 1 Entregado, 5 Enviado | ❌ `Msg 50001`. **Ninguno** cambia, aunque el del pedido 5 era válido |

La última prueba muestra que la transacción es de **todo o nada**: si una de las filas del `UPDATE` no es válida, se deshace la sentencia completa.

### Atraparlo desde fuera

Quien hace el `UPDATE` puede atrapar el error del trigger con `TRY … CATCH`, como cualquier otro:

```sql
BEGIN TRY
	UPDATE Pedido
	SET idEstatusPedido = 1
	WHERE idPedido = 2;
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS Numero, ERROR_PROCEDURE() AS Procedimiento, ERROR_MESSAGE() AS Mensaje;
END CATCH
```

| Numero | Procedimiento | Mensaje |
|--------|---------------|---------|
| 50001 | trg_validarEstatusPedido | Transición de estatus no permitida: solo de Creado a Enviado y de Enviado a Cancelado o Entregado |

`ERROR_PROCEDURE()` dice que el error vino del trigger, aunque el código solo escribió un `UPDATE`.

> Este trigger es un ejemplo de estudio y **no** forma parte de la instalación de TiendaDB. Para quitarlo: `DROP TRIGGER trg_validarEstatusPedido`.

---

## Procedimiento o trigger

Con `THROW`, la misma regla se puede poner en un procedimiento almacenado o en un trigger:

| | Procedimiento almacenado | Trigger con `THROW` |
|---|---|---|
| ¿Se puede saltar? | Sí: basta con hacer el `UPDATE` directo | No: cualquier `UPDATE` lo dispara |
| ¿Cómo responde? | Con `ErrCodigo` y `ErrMensaje` | Con un error que hay que atrapar |
| ¿Se ve la regla al leer el código? | Sí | No: está escondida en el trigger |

Una regla que **nunca** debe romperse, como no regresar un pedido a un estatus anterior, va en el trigger. El procedimiento puede validar lo mismo para dar un mensaje amable, pero quien protege la regla es el trigger.

---

## Resumen

- `THROW número, 'mensaje', estado;` lanza un error propio; el número va de 50000 en adelante.
- La instrucción anterior a `THROW` debe terminar con `;`.
- `THROW` termina el lote. Dentro de un `CATCH`, `THROW;` sin parámetros relanza el error atrapado.
- En un trigger, `THROW` deshace la instrucción que lo disparó, completa: es la forma de que un trigger **rechace** un cambio.
- Una regla que nunca debe romperse va en un trigger; un procedimiento puede validarla además, pero se puede saltar.
