# PIA BiciRuta — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio de la tarifa por hora de un tipo de bicicleta: el tipo de bicicleta, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarTarifaTipoBicicleta`](04-procedimiento-usp_actualizarTarifaTipoBicicleta.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de tipos de bicicleta: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de tipos de bicicleta, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de tipos de bicicleta |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de tipos de bicicleta.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del tipo de bicicleta.
- [ ] Inserta **una fila en el histórico por cada tipo de bicicleta cuyo precio cambió**, con el tipo de bicicleta, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'Urbana', de $45.00 a $55.00 y luego a $50.00, el histórico tiene:

| Tipo de bicicleta | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| Urbana | 45.00 | 55.00 | *(la del momento del cambio)* |
| Urbana | 55.00 | 50.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarTarifaTipoBicicleta`](04-procedimiento-usp_actualizarTarifaTipoBicicleta.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'Urbana' con el procedimiento
EXEC usp_actualizarTarifaTipoBicicleta @p_NombreTipoBicicleta = 'Urbana', @p_PrecioNuevo = 55.00
EXEC usp_actualizarTarifaTipoBicicleta @p_NombreTipoBicicleta = 'Urbana', @p_PrecioNuevo = 50.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeTiposDeBicicleta> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Montaña'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeTiposDeBicicleta> SET <ColumnaTarifaPorHora> = <ColumnaTarifaPorHora> + 20 WHERE <ColumnaNombre> IN ('Montaña', 'Eléctrica')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: Urbana 45.00 → 55.00 y Urbana 55.00 → 50.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más Montaña 60.00 → 80.00 y Eléctrica 95.00 → 115.00 (en cualquier orden) |
