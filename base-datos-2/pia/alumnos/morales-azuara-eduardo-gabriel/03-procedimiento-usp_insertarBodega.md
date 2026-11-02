# PIA GuardaTodo — Objeto 03 de 11: `usp_insertarBodega`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Procedimiento almacenado `usp_insertarBodega`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** dar de alta una bodega nueva, **para** que empiece a acumular contratos.

## Contexto

Cada bodega es de **un solo** tipo de bodega y tiene un número de bodega que **no se repite**. Solo se dan de alta bodegas de un tipo de bodega que el negocio **sigue manejando**. Una bodega nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de bodega, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarBodega` que valide las reglas de arriba y, si todo es correcto, registre la bodega.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoBodega` | `varchar(30)` | Nombre del tipo de bodega |
| `@p_NumeroBodega` | `varchar(10)` | Número de bodega |
| `@p_FechaApertura` | `date` | Fecha de apertura |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de bodega existe | `000001` | El tipo de bodega no existe |
| 2 | El tipo de bodega está activo | `000002` | El tipo de bodega está dado de baja |
| 3 | El número de bodega no existe | `000003` | El número de bodega ya existe |
| 4 | Todo correcto | `000000` | Bodega registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarBodega` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de bodega existe → `000001` *El tipo de bodega no existe*.
- [ ] Valida: el tipo de bodega está activo → `000002` *El tipo de bodega está dado de baja*.
- [ ] Valida: el número de bodega no existe → `000003` *El número de bodega ya existe*.
- [ ] El número de bodega de una bodega dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la bodega con el id del tipo de bodega que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Bodega registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de bodega y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una bodega nueva
EXEC usp_insertarBodega @p_NombreTipoBodega = 'Mediana', @p_NumeroBodega = 'B-120', @p_FechaApertura = '2026-11-01'

-- 000001: el tipo de bodega 'Otro' no existe
EXEC usp_insertarBodega @p_NombreTipoBodega = 'Otro', @p_NumeroBodega = 'B-120', @p_FechaApertura = '2026-11-01'

-- 000003: 'B-101' ya existe
EXEC usp_insertarBodega @p_NombreTipoBodega = 'Mediana', @p_NumeroBodega = 'B-101', @p_FechaApertura = '2026-11-01'

-- 000003: 'B-105' está dada de baja, pero sigue siendo suyo
EXEC usp_insertarBodega @p_NombreTipoBodega = 'Mediana', @p_NumeroBodega = 'B-105', @p_FechaApertura = '2026-11-01'

-- 000002: el tipo de bodega dado de baja. Como ningún procedimiento da de baja los tipos de bodega,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeBodega> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Grande'
EXEC usp_insertarBodega @p_NombreTipoBodega = 'Grande', @p_NumeroBodega = 'B-120B', @p_FechaApertura = '2026-11-01'
UPDATE <TuTablaDeTiposDeBodega> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Grande'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una bodega nueva | `000000` | Bodega registrada |
| El tipo de bodega 'Otro' no existe | `000001` | El tipo de bodega no existe |
| 'B-101' ya existe | `000003` | El número de bodega ya existe |
| 'B-105' está dada de baja, pero sigue siendo suyo | `000003` | El número de bodega ya existe |
| El tipo de bodega dado de baja. Como ningún procedimiento da de baja los tipos de bodega | `000002` | El tipo de bodega está dado de baja |
