# PIA EnigmaRoom — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio del precio por partida de una sala de escape: la sala de escape, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarPrecioSalaEscape`](04-procedimiento-usp_actualizarPrecioSalaEscape.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de salas de escape: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de salas de escape, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de salas de escape |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de salas de escape.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id de la sala de escape.
- [ ] Inserta **una fila en el histórico por cada sala de escape cuyo precio cambió**, con la sala de escape, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'El Laboratorio', de $900.00 a $1,080.00 y luego a $990.00, el histórico tiene:

| Sala de escape | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| El Laboratorio | 900.00 | 1080.00 | *(la del momento del cambio)* |
| El Laboratorio | 1080.00 | 990.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarPrecioSalaEscape`](04-procedimiento-usp_actualizarPrecioSalaEscape.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'El Laboratorio' con el procedimiento
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Laboratorio', @p_PrecioNuevo = 1080.00
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Laboratorio', @p_PrecioNuevo = 990.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeSalasDeEscape> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'La Cripta'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeSalasDeEscape> SET <ColumnaPrecio> = <ColumnaPrecio> + 20 WHERE <ColumnaNombre> IN ('La Cripta', 'El Gran Robo')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: El Laboratorio 900.00 → 1080.00 y El Laboratorio 1080.00 → 990.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más La Cripta 1100.00 → 1120.00 y El Gran Robo 1000.00 → 1020.00 (en cualquier orden) |
