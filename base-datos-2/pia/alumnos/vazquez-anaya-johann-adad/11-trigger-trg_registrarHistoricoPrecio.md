# PIA StrikeMax — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio de la tarifa por línea de un tipo de pista: el tipo de pista, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarTarifaTipoPista`](04-procedimiento-usp_actualizarTarifaTipoPista.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de tipos de pista: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de tipos de pista, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de tipos de pista |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de tipos de pista.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del tipo de pista.
- [ ] Inserta **una fila en el histórico por cada tipo de pista cuyo precio cambió**, con el tipo de pista, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'Normal', de $90.00 a $110.00 y luego a $100.00, el histórico tiene:

| Tipo de pista | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| Normal | 90.00 | 110.00 | *(la del momento del cambio)* |
| Normal | 110.00 | 100.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarTarifaTipoPista`](04-procedimiento-usp_actualizarTarifaTipoPista.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'Normal' con el procedimiento
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'Normal', @p_PrecioNuevo = 110.00
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'Normal', @p_PrecioNuevo = 100.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeTiposDePista> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Infantil'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeTiposDePista> SET <ColumnaTarifaPorLinea> = <ColumnaTarifaPorLinea> + 20 WHERE <ColumnaNombre> IN ('Infantil', 'VIP')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: Normal 90.00 → 110.00 y Normal 110.00 → 100.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más Infantil 70.00 → 90.00 y VIP 150.00 → 170.00 (en cualquier orden) |
