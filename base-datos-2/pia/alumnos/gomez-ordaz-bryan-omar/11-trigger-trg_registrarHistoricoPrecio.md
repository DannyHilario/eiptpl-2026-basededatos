# PIA VeloKart — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio de precio de un tipo de kart: el tipo, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarPrecioTipoKart`](04-procedimiento-usp_actualizarPrecioTipoKart.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de tipos de kart: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, la tabla `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` las tiene **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de tipos de kart, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de tipos de kart |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de tipos de kart.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del tipo de kart.
- [ ] Inserta **una fila en el histórico por cada tipo de kart cuyo precio cambió**, con el tipo, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si el tipo está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada tipo que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio del Infantil, de $180.00 a $200.00 y luego a $190.00, el histórico tiene:

| Tipo de kart | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| Infantil | 180.00 | 200.00 | *(la del momento del cambio)* |
| Infantil | 200.00 | 190.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarPrecioTipoKart`](04-procedimiento-usp_actualizarPrecioTipoKart.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. El histórico arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio con el procedimiento: 2 filas
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Infantil', @p_PrecioNuevo = 200.00
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Infantil', @p_PrecioNuevo = 190.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeTiposDeKart> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Estándar'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a Estándar y Profesional; agrega 2 filas
UPDATE <TuTablaDeTiposDeKart> SET <ColumnaPrecio> = <ColumnaPrecio> + 20 WHERE <ColumnaNombre> IN ('Estándar', 'Profesional')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios del Infantil | 2 filas: Infantil 180.00 → 200.00 y Infantil 200.00 → 190.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos tipos a la vez | 4 filas: las 2 anteriores, más Estándar 250.00 → 270.00 y Profesional 350.00 → 370.00 (estas dos pueden salir en cualquier orden) |
