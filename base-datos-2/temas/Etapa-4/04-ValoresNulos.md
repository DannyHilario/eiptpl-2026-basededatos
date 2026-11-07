# Errores de valor nulo

`NULL` significa "no hay valor". No es cero ni texto vacío: es la **ausencia** de dato. Por sí mismo no es un error, pero se cuela en los cálculos sin avisar y termina en un error cuando se intenta guardar en una columna que no lo acepta. Este tema muestra de dónde sale, cómo atrapar el error con `TRY … CATCH` y, sobre todo, cómo evitarlo.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4. Parte de [Errores y TRY CATCH](03-Errores.md).

---

## NULL contagia

Cualquier operación con `NULL` da `NULL`:

```sql
SELECT 5 + NULL AS Suma, 'Pedido ' + NULL AS Texto
```

| Suma | Texto |
|------|-------|
| NULL | NULL |

No hay error: el resultado simplemente se vuelve `NULL`. Ahí está el peligro, porque nada avisa.

## De dónde sale un NULL sin que nadie lo escriba

El pedido 8 de los datos de ejemplo no tiene líneas:

```sql
SELECT COUNT(idDetallePedido) AS Lineas, SUM(Cantidad * PrecioUnitario) AS Total
FROM DetallePedido
WHERE idPedido = 8
```

| Lineas | Total |
|--------|-------|
| 0 | NULL |

| Función | Sobre **cero** filas regresa |
|---------|------------------------------|
| `COUNT` | `0` |
| `SUM`, `AVG`, `MIN`, `MAX` | `NULL` |

Tiene lógica: "cuántas líneas hay" tiene respuesta (ninguna), pero "cuánto suman las líneas" no la tiene, porque no hay nada que sumar.

Otras fuentes comunes de `NULL`:

- Una variable declarada y nunca asignada.
- Un `SELECT @variable = …` que no encuentra filas: la variable **conserva el valor que tenía**, que al principio es `NULL`.
- Un `LEFT JOIN` que no encuentra pareja.

## Cuando el NULL se vuelve error

El error aparece al **guardar** ese `NULL` en una columna `NOT NULL`. Aquí se atrapa con `TRY … CATCH`:

```sql
DECLARE @Total decimal(12,2)

SELECT
	@Total = SUM(Cantidad * PrecioUnitario)
FROM DetallePedido
WHERE idPedido = 8

BEGIN TRY
	UPDATE Pedido
	SET Total = @Total
	WHERE idPedido = 8
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS Numero, ERROR_MESSAGE() AS Mensaje
END CATCH
```

| Numero | Mensaje |
|--------|---------|
| 515 | Cannot insert the value NULL into column 'Total', table 'TiendaDB.dbo.Pedido'; column does not allow nulls. UPDATE fails. |

El `CATCH` evita que el error se muestre en rojo, pero **el total no se guardó**. Atrapar el error es útil para avisar; lo correcto es que no ocurra.

## Prevenir: ISNULL

`ISNULL(valor, reemplazo)` regresa el valor y, si es `NULL`, regresa el reemplazo:

```sql
SELECT
	@Total = ISNULL(SUM(Cantidad * PrecioUnitario), 0)
FROM DetallePedido
WHERE idPedido = 8

UPDATE Pedido
SET Total = @Total
WHERE idPedido = 8
```

| idPedido | Total |
|----------|-------|
| 8 | 0.00 |

Ahora un pedido sin líneas tiene total 0, que es lo que significa para el negocio.

## El caso real: el trigger de la sesión 12

Este error apareció en TiendaDB. El trigger [`trg_eliminarDetallePedido`](../../sesiones/sesion-12/TiendaDB/docs/triggers/trg_eliminarDetallePedido.md) recalcula la cabecera cuando se quita una línea. Al quitar la **última** línea de un pedido, `SUM` regresaba `NULL`, el `UPDATE` de la cabecera fallaba con el mismo `Msg 515` y, como el error ocurría dentro de un trigger, **se deshacía también el `DELETE`**: la línea no se podía quitar. La solución fue la misma: `ISNULL(SUM(...), 0)`.

> **Regla práctica:** cada vez que el resultado de `SUM`, `AVG`, `MIN` o `MAX` se guarde en una columna `NOT NULL`, pregúntate qué pasa si no hay filas. Si la respuesta es "debería ser 0", usa `ISNULL`.

---

## Resumen

- `NULL` es la ausencia de valor; cualquier operación con `NULL` da `NULL`, sin error.
- `COUNT` sobre cero filas da `0`; `SUM`, `AVG`, `MIN` y `MAX` dan `NULL`.
- El error aparece al guardar `NULL` en una columna `NOT NULL`: `Msg 515`.
- `TRY … CATCH` lo atrapa, pero el dato no se guarda. Lo correcto es prevenirlo con `ISNULL(valor, reemplazo)`.
