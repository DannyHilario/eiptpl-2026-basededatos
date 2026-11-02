# PIA RutaNorte — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio del precio de una ruta: la ruta, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarPrecioRuta`](04-procedimiento-usp_actualizarPrecioRuta.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de rutas: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de rutas, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de rutas |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de rutas.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id de la ruta.
- [ ] Inserta **una fila en el histórico por cada ruta cuyo precio cambió**, con la ruta, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'MTY-SAL', de $180.00 a $220.00 y luego a $200.00, el histórico tiene:

| Ruta | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| MTY-SAL | 180.00 | 220.00 | *(la del momento del cambio)* |
| MTY-SAL | 220.00 | 200.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarPrecioRuta`](04-procedimiento-usp_actualizarPrecioRuta.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'MTY-SAL' con el procedimiento
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-SAL', @p_PrecioNuevo = 220.00
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-SAL', @p_PrecioNuevo = 200.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeRutas> SET <ColumnaActivo> = 1 WHERE <ColumnaClave> = 'MTY-REY'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeRutas> SET <ColumnaPrecio> = <ColumnaPrecio> + 20 WHERE <ColumnaClave> IN ('MTY-REY', 'MTY-NLD')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: MTY-SAL 180.00 → 220.00 y MTY-SAL 220.00 → 200.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más MTY-REY 420.00 → 440.00 y MTY-NLD 450.00 → 470.00 (en cualquier orden) |
