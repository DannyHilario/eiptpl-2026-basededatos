# Errores y TRY CATCH

Hasta ahora, cuando una instrucción fallaba, SQL Server mostraba un mensaje en rojo y uno lo leía. En un procedimiento almacenado o en un trigger no hay nadie leyendo: el código tiene que **darse cuenta** del error y decidir qué hacer. Este tema explica cómo se ve un error, qué pasa con el resto del código cuando ocurre y cómo atraparlo con `TRY … CATCH`.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4.

---

## Cómo se ve un error

```
Msg 2627, Level 14, State 1, Line 3
Violation of UNIQUE KEY constraint 'uq_DetallePedido_Pedido_Articulo'. Cannot insert duplicate
key in object 'dbo.DetallePedido'. The duplicate key value is (5, 2).
```

| Parte | Qué dice | En el ejemplo |
|-------|----------|---------------|
| `Msg` | El **número** del error: identifica qué tipo de error es | `2627`: llave única repetida |
| `Level` | La **severidad**, de 0 a 25 | `14`: error del usuario |
| `State` | Un dato interno de dónde se generó; ayuda al soporte de SQL Server | `1` |
| `Line` | La línea **del lote** donde ocurrió | `3` |
| Mensaje | La explicación | La llave repetida es `(5, 2)` |

| Severidad | Significa |
|-----------|-----------|
| 0 a 10 | Mensajes informativos; no son errores |
| 11 a 16 | Errores que **puede corregir el usuario**: datos inválidos, objetos que no existen, sintaxis |
| 17 a 25 | Errores del servidor o del hardware; los atiende el administrador |

Los errores que aparecen al trabajar con TiendaDB son de severidad 11 a 16:

| Msg | Cuándo | Ejemplo en TiendaDB |
|-----|--------|---------------------|
| 2627 | Se repite un valor `UNIQUE` | El mismo artículo dos veces en un pedido |
| 547 | Se viola un `CHECK` o una llave foránea | Una línea con cantidad 0; un pedido de un cliente que no existe |
| 515 | Se intenta guardar `NULL` en una columna `NOT NULL` | Un pedido sin `DireccionEntrega` |
| 8134 | División entre cero | `SELECT 10 / 0` |
| 137 | Variable no declarada | Usar una variable después de `GO` |
| 102 | Error de sintaxis | Una palabra mal escrita |

---

## Qué pasa con el resto del lote

Estos cinco errores de datos, en un mismo lote:

```sql
INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
VALUES (5, 2, 1, 18.00)                                        -- artículo repetido

PRINT 'El lote sigue después del error de llave única'

INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
VALUES (5, 3, 0, 22.00)                                        -- cantidad 0

INSERT INTO Pedido (idCliente, DireccionEntrega)
VALUES (99, 'Sin cliente')                                     -- cliente que no existe

INSERT INTO Pedido (idCliente)
VALUES (1)                                                     -- sin dirección

SELECT 10 / 0                                                  -- división entre cero

PRINT 'Sigue después de todo'
```

```
Msg 2627, Level 14 ... The duplicate key value is (5, 2).
The statement has been terminated.
El lote sigue después del error de llave única
Msg 547, Level 16 ... conflicted with the CHECK constraint "chk_DetallePedido_Cantidad".
Msg 547, Level 16 ... conflicted with the FOREIGN KEY constraint "fk_Pedido_Cliente".
Msg 515, Level 16 ... Cannot insert the value NULL into column 'DireccionEntrega'.
Msg 8134, Level 16 ... Divide by zero error encountered.
Sigue después de todo
```

**La instrucción que falla se cancela, y el lote sigue con la siguiente.** "The statement has been terminated" significa justo eso: se canceló **esa** instrucción.

Por eso un error no basta para detener un procedimiento. Si un procedimiento inserta un pedido y después sus líneas, y la tercera línea falla, el pedido y las primeras dos líneas **se quedan**. Eso se resuelve en [Transacciones](05-Transacciones.md).

> No todos los errores se comportan igual. Un error de sintaxis o una variable no declarada (`Msg 102`, `Msg 137`) impiden que el lote **empiece**, como se vio en [T-SQL como lenguaje de programación](01-ProgramacionTSQL.md#lotes-y-go). Y un error dentro de un **trigger** cancela todo el lote, no solo la instrucción.

---

## TRY … CATCH

`TRY … CATCH` ejecuta un bloque de instrucciones y, **si una falla**, salta a otro bloque en lugar de mostrar el error:

```sql
BEGIN TRY
	-- instrucciones que pueden fallar
END TRY
BEGIN CATCH
	-- qué hacer si alguna falló
END CATCH
```

- Si nada falla, el bloque `CATCH` **no se ejecuta**.
- En cuanto una instrucción del `TRY` falla, las que siguen dentro del `TRY` **ya no se ejecutan**: el control pasa al `CATCH`.
- El error ya no aparece en rojo: el `CATCH` decide qué hacer con él.

### Las funciones ERROR

Dentro del `CATCH` se puede saber **qué** error ocurrió:

| Función | Regresa |
|---------|---------|
| `ERROR_NUMBER()` | El número (`Msg`) |
| `ERROR_MESSAGE()` | El mensaje completo |
| `ERROR_SEVERITY()` | La severidad (`Level`) |
| `ERROR_STATE()` | El estado (`State`) |
| `ERROR_LINE()` | La línea donde ocurrió |
| `ERROR_PROCEDURE()` | El procedimiento o trigger donde ocurrió; `NULL` si fue en el lote |

```sql
BEGIN TRY
	INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
	VALUES (5, 2, 1, 18.00)

	PRINT 'Esto no se imprime'
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS Numero, ERROR_SEVERITY() AS Severidad, ERROR_STATE() AS Estado,
	       ERROR_LINE() AS Linea, ERROR_PROCEDURE() AS Procedimiento

	SELECT ERROR_MESSAGE() AS Mensaje
END CATCH

SELECT ERROR_NUMBER() AS FueraDelCatch
```

| Numero | Severidad | Estado | Linea | Procedimiento |
|--------|-----------|--------|-------|---------------|
| 2627 | 14 | 1 | 2 | NULL |

| Mensaje |
|---------|
| Violation of UNIQUE KEY constraint 'uq_DetallePedido_Pedido_Articulo'. Cannot insert duplicate key in object 'dbo.DetallePedido'. The duplicate key value is (5, 2). |

| FueraDelCatch |
|---------------|
| NULL |

- El `PRINT` no se ejecutó: el `INSERT` falló y el control pasó al `CATCH`.
- `ERROR_PROCEDURE()` es `NULL` porque el error ocurrió en el lote, no dentro de un procedimiento.
- **Fuera del `CATCH`, las funciones `ERROR` regresan `NULL`.** Solo funcionan dentro de él.

### Lo que TRY CATCH no atrapa

Los errores que impiden que el lote **empiece** (sintaxis, variables no declaradas) no llegan al `CATCH`, porque el `TRY` nunca se ejecuta. `TRY … CATCH` atrapa los errores que ocurren **al ejecutar**: datos inválidos, restricciones, divisiones entre cero.

---

## Resumen

- Un error tiene número (`Msg`), severidad (`Level`), estado (`State`), línea y mensaje. Los de severidad 11 a 16 los puede corregir el usuario.
- Por omisión, la instrucción que falla se cancela y **el lote sigue**. Un error no detiene un procedimiento por sí solo.
- `BEGIN TRY … END TRY BEGIN CATCH … END CATCH`: si algo del `TRY` falla, se salta al `CATCH`.
- Dentro del `CATCH`, las funciones `ERROR_NUMBER()`, `ERROR_MESSAGE()`, `ERROR_LINE()`, `ERROR_PROCEDURE()`, `ERROR_SEVERITY()` y `ERROR_STATE()` dicen qué falló. Fuera del `CATCH` regresan `NULL`.
- `TRY … CATCH` no atrapa errores de sintaxis: esos impiden que el lote empiece.
