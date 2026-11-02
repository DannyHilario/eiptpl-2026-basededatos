# PIA GameZone — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio de la tarifa por hora de un tipo de consola: el tipo de consola, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarTarifaTipoConsola`](04-procedimiento-usp_actualizarTarifaTipoConsola.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de tipos de consola: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de tipos de consola, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de tipos de consola |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de tipos de consola.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del tipo de consola.
- [ ] Inserta **una fila en el histórico por cada tipo de consola cuyo precio cambió**, con el tipo de consola, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'PlayStation 5', de $60.00 a $70.00 y luego a $65.00, el histórico tiene:

| Tipo de consola | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| PlayStation 5 | 60.00 | 70.00 | *(la del momento del cambio)* |
| PlayStation 5 | 70.00 | 65.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarTarifaTipoConsola`](04-procedimiento-usp_actualizarTarifaTipoConsola.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'PlayStation 5' con el procedimiento
EXEC usp_actualizarTarifaTipoConsola @p_NombreTipoConsola = 'PlayStation 5', @p_PrecioNuevo = 70.00
EXEC usp_actualizarTarifaTipoConsola @p_NombreTipoConsola = 'PlayStation 5', @p_PrecioNuevo = 65.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeTiposDeConsola> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Xbox Series X'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeTiposDeConsola> SET <ColumnaTarifaPorHora> = <ColumnaTarifaPorHora> + 20 WHERE <ColumnaNombre> IN ('Xbox Series X', 'Nintendo Switch')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: PlayStation 5 60.00 → 70.00 y PlayStation 5 70.00 → 65.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más Xbox Series X 55.00 → 75.00 y Nintendo Switch 45.00 → 65.00 (en cualquier orden) |
