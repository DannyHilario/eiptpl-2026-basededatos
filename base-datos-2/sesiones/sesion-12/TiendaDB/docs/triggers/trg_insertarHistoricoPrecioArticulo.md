# `trg_insertarHistoricoPrecioArticulo`

Script: [`instalacion/05-HistoricoPrecioArticulo/02-trg-insertar-historico-precio.sql`](../../instalacion/05-HistoricoPrecioArticulo/02-trg-insertar-historico-precio.sql)

| Tabla | Momento | Eventos |
|-------|---------|---------|
| `Articulo` | `AFTER` | `UPDATE` |

Cada vez que se modifica un artículo y su **precio cambió**, registra en `HistoricoPrecioArticulo` el precio anterior y el nuevo. Así, `Articulo.PrecioUnitario` siempre tiene el precio vigente y el histórico guarda cómo llegó ahí. El script vive en la carpeta del histórico porque necesita que esa tabla ya exista.

## Cómo lo hace

En un `UPDATE`, las dos tablas especiales tienen la misma fila, con valores distintos:

| Tabla | Qué tiene | Se usa para |
|-------|-----------|-------------|
| `deleted` | La fila **antes** del `UPDATE` | `@PrecioAnterior` y `@idArticulo` |
| `inserted` | La fila **después** del `UPDATE` | `@PrecioNuevo` |

```sql
SELECT
	@PrecioAnterior = PrecioUnitario,
	@idArticulo = idArticulo
FROM deleted

SELECT
	@PrecioNuevo = PrecioUnitario
FROM inserted
```

Después revisa dos casos en los que **no** hay nada que registrar y sale con `RETURN`:

| Caso | Por qué ocurre |
|------|----------------|
| `@PrecioAnterior = @PrecioNuevo` | El trigger se dispara con **cualquier** `UPDATE` de `Articulo`, aunque solo cambie el nombre o `Activo`. Si el precio no cambió, no es un cambio de precio. Además, la tabla tiene un `CHECK (PrecioNuevo <> PrecioAnterior)` que rechazaría ese registro |
| `@PrecioAnterior IS NULL OR @PrecioNuevo IS NULL` | El `UPDATE` no afectó ninguna fila (por ejemplo, `WHERE idArticulo = 999`): el trigger se dispara igual, con `inserted` y `deleted` vacíos, y las variables se quedan en `NULL` |

Si pasa las dos revisiones, inserta el renglón en el histórico.

## Resultados (pruebas 1 a 3 de [`pruebas.sql`](../../pruebas.sql))

| Sentencia | Renglones nuevos en el histórico |
|-----------|----------------------------------|
| Instalación (40 `INSERT` de artículos) | Ninguno: es un trigger de `UPDATE` |
| Precio del artículo 27 de 13.00 a 14.50 | 1 (27: 13.00 → 14.50) |
| `UPDATE` del artículo 27 que no cambia el precio | Ninguno |

## Limitación de esta versión

Guarda `deleted` e `inserted` en **variables**, y una variable solo puede tener **un** valor. Si un `UPDATE` cambia el precio de varios artículos en una sola sentencia (por ejemplo, subir 10 % toda una clasificación), el trigger registra **uno solo**. La forma que funciona con cualquier número de filas es insertar directamente desde la unión de las dos tablas:

```sql
INSERT INTO HistoricoPrecioArticulo (idArticulo, PrecioAnterior, PrecioNuevo)
SELECT D.idArticulo, D.PrecioUnitario, I.PrecioUnitario
FROM deleted D
INNER JOIN inserted I ON I.idArticulo = D.idArticulo
WHERE D.PrecioUnitario <> I.PrecioUnitario
```
