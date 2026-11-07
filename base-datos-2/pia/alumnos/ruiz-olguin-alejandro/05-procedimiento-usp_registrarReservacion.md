# PIA RecorreMTY — Objeto 05 de 11: `usp_registrarReservacion`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_registrarReservacion`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** registrar una reservación, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de recorrido** y el **correo electrónico**; el procedimiento busca al recorrido y al turista. Solo se registran reservaciones con recorridos y turistas **activos**.

La reservación se cobra con el **precio por persona vigente** del recorrido, en el momento de registrarla. Ese precio se **copia** a la reservación: si mañana cambia, la reservación conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, personas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarReservacion` que valide las reglas de abajo y, si todo es correcto, registre la reservación con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreRecorrido` | `varchar(50)` | Nombre de recorrido |
| `@p_CorreoTurista` | `varchar(100)` | Correo electrónico |
| `@p_FechaRecorrido` | `date` | Fecha de la reservación |
| `@p_Personas` | `int` | Personas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El recorrido existe | `000001` | El recorrido no existe |
| 2 | El recorrido está activo | `000002` | El recorrido está dado de baja |
| 3 | El turista existe | `000003` | El turista no existe |
| 4 | El turista está activo | `000004` | El turista está dado de baja |
| 5 | Todo correcto | `000000` | Reservación registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarReservacion` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el recorrido existe → `000001` *El recorrido no existe*.
- [ ] Valida: el recorrido está activo → `000002` *El recorrido está dado de baja*.
- [ ] Valida: el turista existe → `000003` *El turista no existe*.
- [ ] Valida: el turista está activo → `000004` *El turista está dado de baja*.
- [ ] El `INSERT` de la reservación va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Reservación registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id del recorrido, si está activo y el **precio por persona vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md), [`usp_darDeBajaTurista`](02-procedimiento-usp_darDeBajaTurista.md).

```sql
-- Preparación: el turista de prueba
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000000: 'Barrio Antiguo', $250.00
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2

-- 000001: no existe un recorrido 'NoExiste'
EXEC usp_registrarReservacion @p_NombreRecorrido = 'NoExiste', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2

-- 000002: el recorrido dado de baja. Como ningún procedimiento da de baja los recorridos,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeRecorridos> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Paseo Santa Lucía'
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Paseo Santa Lucía', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2
UPDATE <TuTablaDeRecorridos> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Paseo Santa Lucía'

-- 000003: no existe un turista con ese correo electrónico
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'noexiste@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2

-- 999999: personas = 11; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 11

-- 000004: el turista dado de baja
EXEC usp_darDeBajaTurista @p_CorreoTurista = 'prueba1@correo.com'
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-03', @p_Personas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El turista de prueba | `000000` | Turista registrado |
| 'Barrio Antiguo', $250.00 | `000000` | Reservación registrada |
| No existe un recorrido 'NoExiste' | `000001` | El recorrido no existe |
| El recorrido dado de baja. Como ningún procedimiento da de baja los recorridos | `000002` | El recorrido está dado de baja |
| No existe un turista con ese correo electrónico | `000003` | El turista no existe |
| Personas = 11 | `999999` | Error 547: … |
| El turista dado de baja | `000000` | Turista dado de baja |
| El turista dado de baja | `000004` | El turista está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
