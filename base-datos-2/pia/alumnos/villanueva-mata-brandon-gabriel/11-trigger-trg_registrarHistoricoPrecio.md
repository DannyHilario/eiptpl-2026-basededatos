# PIA ImprimeYa — Objeto 11 de 11: `trg_registrarHistoricoPrecio`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Trigger `trg_registrarHistoricoPrecio`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** que cada cambio de precio quede registrado solo, **para** conocer la historia de mis precios sin depender de que alguien se acuerde de anotarla.

## Contexto

El [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) guarda, por cada cambio del precio por paquete de un producto: el producto, el precio anterior, el precio nuevo y la fecha y hora del cambio.

El precio puede cambiar por [`usp_actualizarPrecioProducto`](04-procedimiento-usp_actualizarPrecioProducto.md) o por un `UPDATE` escrito a mano. Por eso el registro **no** lo hace el procedimiento, sino un trigger sobre la tabla de productos: se dispara con **cualquier** `UPDATE`, venga de donde venga.

Dentro del trigger, `deleted` tiene las filas **como estaban antes** del `UPDATE` (el precio anterior) e `inserted` **como quedaron** (el precio nuevo) ([Uso de la tabla Inserted y Deleted](../../../temas/Etapa-3/03-InsertedDeleted.md)).

## Tu tarea

Crea un trigger llamado exactamente `trg_registrarHistoricoPrecio`, sobre tu tabla de productos, que registre en el histórico cada cambio de precio.

## Definición del trigger

| Característica | Valor |
|---|---|
| Tabla | Tu tabla de productos |
| Momento | `AFTER` |
| Evento | `UPDATE` |
| Escribe en | Tu tabla del histórico de precios |

## Criterios de aceptación

- [ ] El trigger se llama exactamente `trg_registrarHistoricoPrecio` y es `AFTER UPDATE` sobre la tabla de productos.
- [ ] Obtiene el precio anterior de `deleted` y el precio nuevo de `inserted`, uniéndolas por el id del producto.
- [ ] Inserta **una fila en el histórico por cada producto cuyo precio cambió**, con el producto, el precio anterior, el precio nuevo y la fecha y hora del cambio.
- [ ] Si el `UPDATE` no cambia el precio (por ejemplo, solo cambia si está activo), **no** inserta nada.
- [ ] Funciona con un `UPDATE` que cambia **varias filas** a la vez: inserta una fila por cada una que cambió (usa `INSERT INTO ... SELECT`, no variables de una sola fila).
- [ ] La fecha y hora del cambio la pone la base de datos (`GETDATE()` o un `DEFAULT`), no quien hace el `UPDATE`.

## Ejemplo de salida esperada

Después de dos cambios de precio de 'Tarjetas de presentación', de $250.00 a $300.00 y luego a $275.00, el histórico tiene:

| Producto | Precio anterior | Precio nuevo | Fecha y hora del cambio |
|---|---|---|---|
| Tarjetas de presentación | 250.00 | 300.00 | *(la del momento del cambio)* |
| Tarjetas de presentación | 300.00 | 275.00 | *(la del momento del cambio)* |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_actualizarPrecioProducto`](04-procedimiento-usp_actualizarPrecioProducto.md). Cambia `<TuTablaDeHistorico>` y los demás nombres por los de tu modelo.

```sql
-- 1. Arranca vacío
SELECT * FROM <TuTablaDeHistorico>

-- 2. Dos cambios de precio de 'Tarjetas de presentación' con el procedimiento
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Tarjetas de presentación', @p_PrecioNuevo = 300.00
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Tarjetas de presentación', @p_PrecioNuevo = 275.00
SELECT * FROM <TuTablaDeHistorico>

-- 3. Un UPDATE que no cambia el precio: no agrega nada
UPDATE <TuTablaDeProductos> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Volantes media carta'
SELECT * FROM <TuTablaDeHistorico>

-- 4. Un UPDATE escrito a mano, de varias filas: +$20.00 a dos a la vez
UPDATE <TuTablaDeProductos> SET <ColumnaPrecioPorPaquete> = <ColumnaPrecioPorPaquete> + 20 WHERE <ColumnaNombre> IN ('Volantes media carta', 'Menús enmicados')
SELECT * FROM <TuTablaDeHistorico>
```

| Caso | Resultado esperado en el histórico |
|---|---|
| 1. Instalación limpia | 0 filas |
| 2. Dos cambios con el procedimiento | 2 filas: Tarjetas de presentación 250.00 → 300.00 y Tarjetas de presentación 300.00 → 275.00 |
| 3. `UPDATE` sin cambio de precio | Siguen siendo 2 filas |
| 4. `UPDATE` de dos a la vez | 4 filas: las 2 anteriores, más Volantes media carta 450.00 → 470.00 y Menús enmicados 380.00 → 400.00 (en cualquier orden) |
