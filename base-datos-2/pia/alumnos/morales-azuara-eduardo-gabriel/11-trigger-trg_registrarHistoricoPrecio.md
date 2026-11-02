# PIA GuardaTodo — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio del precio por mes de un tipo de bodega: el tipo de bodega, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarPrecioTipoBodega`](04-procedimiento-usp_actualizarPrecioTipoBodega.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de tipos de bodega: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de tipos de bodega, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de tipos de bodega |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de tipos de bodega.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del tipo de bodega.
- [ ] Inserta **una fila en el histórico por cada tipo de bodega cuyo precio cambió**, con el tipo de bodega, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'Chica', de $900.00 a $1,080.00 y luego a $990.00, el histórico tiene:

| Tipo de bodega | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| Chica | 900.00 | 1080.00 | *(la del momento del cambio)* |
| Chica | 1080.00 | 990.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarPrecioTipoBodega`](04-procedimiento-usp_actualizarPrecioTipoBodega.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'Chica' con el procedimiento
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Chica', @p_PrecioNuevo = 1080.00
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Chica', @p_PrecioNuevo = 990.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeTiposDeBodega> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Mediana'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeTiposDeBodega> SET <ColumnaPrecioPorMes> = <ColumnaPrecioPorMes> + 20 WHERE <ColumnaNombre> IN ('Mediana', 'Grande')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: Chica 900.00 → 1080.00 y Chica 1080.00 → 990.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más Mediana 1500.00 → 1520.00 y Grande 2400.00 → 2420.00 (en cualquier orden) |
