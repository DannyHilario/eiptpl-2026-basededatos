# PIA RecorreMTY — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio del precio por persona de un recorrido: el recorrido, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarPrecioRecorrido`](04-procedimiento-usp_actualizarPrecioRecorrido.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de recorridos: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de recorridos, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de recorridos |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de recorridos.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del recorrido.
- [ ] Inserta **una fila en el histórico por cada recorrido cuyo precio cambió**, con el recorrido, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'Barrio Antiguo', de $250.00 a $300.00 y luego a $275.00, el histórico tiene:

| Recorrido | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| Barrio Antiguo | 250.00 | 300.00 | *(la del momento del cambio)* |
| Barrio Antiguo | 300.00 | 275.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarPrecioRecorrido`](04-procedimiento-usp_actualizarPrecioRecorrido.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'Barrio Antiguo' con el procedimiento
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Barrio Antiguo', @p_PrecioNuevo = 300.00
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Barrio Antiguo', @p_PrecioNuevo = 275.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeRecorridos> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Paseo Santa Lucía'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeRecorridos> SET <ColumnaPrecioPorPersona> = <ColumnaPrecioPorPersona> + 20 WHERE <ColumnaNombre> IN ('Paseo Santa Lucía', 'Parque Fundidora')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: Barrio Antiguo 250.00 → 300.00 y Barrio Antiguo 300.00 → 275.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más Paseo Santa Lucía 200.00 → 220.00 y Parque Fundidora 300.00 → 320.00 (en cualquier orden) |
