# PIA StrikeMax — Objeto 03 de 11: `usp_insertarPista`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Procedimiento almacenado `usp_insertarPista`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** dar de alta una pista nueva, **para** que empiece a acumular juegos.

## Contexto

Cada pista es de **un solo** tipo de pista y tiene un número de pista que **no se repite**. Solo se dan de alta pistas de un tipo de pista que el negocio **sigue manejando**. Una pista nueva siempre se registra **activa**.

Quien registra conoce el **nombre** del tipo de pista, no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarPista` que valide las reglas de arriba y, si todo es correcto, registre la pista.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoPista` | `varchar(30)` | Nombre del tipo de pista |
| `@p_NumeroPista` | `int` | Número de pista |
| `@p_FechaInstalacion` | `date` | Fecha de instalación |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de pista existe | `000001` | El tipo de pista no existe |
| 2 | El tipo de pista está activo | `000002` | El tipo de pista está dado de baja |
| 3 | El número de pista no existe | `000003` | El número de pista ya existe |
| 4 | Todo correcto | `000000` | Pista registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarPista` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de pista existe → `000001` *El tipo de pista no existe*.
- [ ] Valida: el tipo de pista está activo → `000002` *El tipo de pista está dado de baja*.
- [ ] Valida: el número de pista no existe → `000003` *El número de pista ya existe*.
- [ ] El número de pista de una pista dada de baja tampoco se reutiliza.
- [ ] Si todo es correcto, inserta la pista con el id del tipo de pista que encontró, **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Pista registrada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de pista y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una pista nueva
EXEC usp_insertarPista @p_NombreTipoPista = 'Infantil', @p_NumeroPista = 20, @p_FechaInstalacion = '2026-11-01'

-- 000001: el tipo de pista 'Otro' no existe
EXEC usp_insertarPista @p_NombreTipoPista = 'Otro', @p_NumeroPista = 20, @p_FechaInstalacion = '2026-11-01'

-- 000003: 1 ya existe
EXEC usp_insertarPista @p_NombreTipoPista = 'Infantil', @p_NumeroPista = 1, @p_FechaInstalacion = '2026-11-01'

-- 000003: 6 está dada de baja, pero sigue siendo suyo
EXEC usp_insertarPista @p_NombreTipoPista = 'Infantil', @p_NumeroPista = 6, @p_FechaInstalacion = '2026-11-01'

-- 000002: el tipo de pista dado de baja. Como ningún procedimiento da de baja los tipos de pista,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDePista> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'VIP'
EXEC usp_insertarPista @p_NombreTipoPista = 'VIP', @p_NumeroPista = 21, @p_FechaInstalacion = '2026-11-01'
UPDATE <TuTablaDeTiposDePista> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'VIP'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una pista nueva | `000000` | Pista registrada |
| El tipo de pista 'Otro' no existe | `000001` | El tipo de pista no existe |
| 1 ya existe | `000003` | El número de pista ya existe |
| 6 está dada de baja, pero sigue siendo suyo | `000003` | El número de pista ya existe |
| El tipo de pista dado de baja. Como ningún procedimiento da de baja los tipos de pista | `000002` | El tipo de pista está dado de baja |
