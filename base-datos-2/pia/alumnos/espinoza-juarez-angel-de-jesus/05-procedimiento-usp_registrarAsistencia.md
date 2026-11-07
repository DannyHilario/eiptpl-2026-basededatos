# PIA FitZone — Objeto 05 de 11: `usp_registrarAsistencia`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_registrarAsistencia`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** registrar una asistencia, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de clase** y el **correo electrónico**; el procedimiento busca a la clase y al socio. Solo se registran asistencias con clases y socios **activos**.

La asistencia se cobra con el **precio por clase vigente** de la clase, en el momento de registrarla. Ese precio se **copia** a la asistencia: si mañana cambia, la asistencia conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, una fecha vacía (`NOT NULL`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarAsistencia` que valide las reglas de abajo y, si todo es correcto, registre la asistencia con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreClase` | `varchar(50)` | Nombre de clase |
| `@p_CorreoSocio` | `varchar(100)` | Correo electrónico |
| `@p_FechaAsistencia` | `date` | Fecha de la asistencia |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La clase existe | `000001` | La clase no existe |
| 2 | La clase está activa | `000002` | La clase está dada de baja |
| 3 | El socio existe | `000003` | El socio no existe |
| 4 | El socio está activo | `000004` | El socio está dado de baja |
| 5 | Todo correcto | `000000` | Asistencia registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarAsistencia` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la clase existe → `000001` *La clase no existe*.
- [ ] Valida: la clase está activa → `000002` *La clase está dada de baja*.
- [ ] Valida: el socio existe → `000003` *El socio no existe*.
- [ ] Valida: el socio está activo → `000004` *El socio está dado de baja*.
- [ ] El `INSERT` de la asistencia va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Asistencia registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id de la clase, si está activa y el **precio por clase vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md), [`usp_darDeBajaSocio`](02-procedimiento-usp_darDeBajaSocio.md).

```sql
-- Preparación: el socio de prueba
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'

-- 000000: 'Spinning', $90.00
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'

-- 000001: no existe una clase 'NoExiste'
EXEC usp_registrarAsistencia @p_NombreClase = 'NoExiste', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'

-- 000002: la clase dada de baja. Como ningún procedimiento da de baja las clases,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésala a activa al terminar
UPDATE <TuTablaDeClases> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Yoga'
EXEC usp_registrarAsistencia @p_NombreClase = 'Yoga', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'
UPDATE <TuTablaDeClases> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Yoga'

-- 000003: no existe un socio con ese correo electrónico
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'noexiste@correo.com', @p_FechaAsistencia = '2026-12-01'

-- 999999: sin fecha; no hay validación con IF, la detiene el NOT NULL y la atrapa el CATCH
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = NULL

-- 000004: el socio dado de baja
EXEC usp_darDeBajaSocio @p_CorreoSocio = 'prueba1@correo.com'
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-03'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El socio de prueba | `000000` | Socio registrado |
| 'Spinning', $90.00 | `000000` | Asistencia registrada |
| No existe una clase 'NoExiste' | `000001` | La clase no existe |
| La clase dada de baja. Como ningún procedimiento da de baja las clases | `000002` | La clase está dada de baja |
| No existe un socio con ese correo electrónico | `000003` | El socio no existe |
| Sin fecha | `999999` | Error 515: … |
| El socio dado de baja | `000000` | Socio dado de baja |
| El socio dado de baja | `000004` | El socio está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **515**.
