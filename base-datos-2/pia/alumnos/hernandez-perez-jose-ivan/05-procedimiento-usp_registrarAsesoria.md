# PIA AsesorPro — Objeto 05 de 11: `usp_registrarAsesoria`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Procedimiento almacenado `usp_registrarAsesoria`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** registrar una asesoría, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **correo electrónico** y el **correo electrónico**; el procedimiento busca al asesor y al alumno. Solo se registran asesorías con asesores y alumnos **activos**.

La asesoría se cobra con la **tarifa por hora vigente** del asesor, en el momento de registrarla. Ese precio se **copia** a la asesoría: si mañana cambia, la asesoría conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, horas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/06-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarAsesoria` que valide las reglas de abajo y, si todo es correcto, registre la asesoría con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoAsesor` | `varchar(100)` | Correo electrónico |
| `@p_CorreoAlumno` | `varchar(100)` | Correo electrónico |
| `@p_FechaAsesoria` | `date` | Fecha de la asesoría |
| `@p_Horas` | `int` | Horas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El asesor existe | `000001` | El asesor no existe |
| 2 | El asesor está activo | `000002` | El asesor está dado de baja |
| 3 | El alumno existe | `000003` | El alumno no existe |
| 4 | El alumno está activo | `000004` | El alumno está dado de baja |
| 5 | Todo correcto | `000000` | Asesoría registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarAsesoria` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el asesor existe → `000001` *El asesor no existe*.
- [ ] Valida: el asesor está activo → `000002` *El asesor está dado de baja*.
- [ ] Valida: el alumno existe → `000003` *El alumno no existe*.
- [ ] Valida: el alumno está activo → `000004` *El alumno está dado de baja*.
- [ ] El `INSERT` de la asesoría va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Asesoría registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id del asesor, si está activo y la **tarifa por hora vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarAlumno`](01-procedimiento-usp_insertarAlumno.md), [`usp_darDeBajaAlumno`](02-procedimiento-usp_darDeBajaAlumno.md).

```sql
-- Preparación: el alumno de prueba
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000000: 'laura.garza@asesorpro.mx', $250.00
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'laura.garza@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2

-- 000001: no existe un asesor 'NoExiste'
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'NoExiste', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2

-- 000002: el asesor dado de baja. Como ningún procedimiento da de baja los asesores,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeAsesores> SET <ColumnaActivo> = 0 WHERE <ColumnaCorreoElectronico> = 'jorge.trevino@asesorpro.mx'
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'jorge.trevino@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2
UPDATE <TuTablaDeAsesores> SET <ColumnaActivo> = 1 WHERE <ColumnaCorreoElectronico> = 'jorge.trevino@asesorpro.mx'

-- 000003: no existe un alumno con ese correo electrónico
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'laura.garza@asesorpro.mx', @p_CorreoAlumno = 'noexiste@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2

-- 999999: horas = 4; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'laura.garza@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-02', @p_Horas = 4

-- 000004: el alumno dado de baja
EXEC usp_darDeBajaAlumno @p_CorreoAlumno = 'prueba1@correo.com'
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'laura.garza@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-03', @p_Horas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El alumno de prueba | `000000` | Alumno registrado |
| 'laura.garza@asesorpro.mx', $250.00 | `000000` | Asesoría registrada |
| No existe un asesor 'NoExiste' | `000001` | El asesor no existe |
| El asesor dado de baja. Como ningún procedimiento da de baja los asesores | `000002` | El asesor está dado de baja |
| No existe un alumno con ese correo electrónico | `000003` | El alumno no existe |
| Horas = 4 | `999999` | Error 547: … |
| El alumno dado de baja | `000000` | Alumno dado de baja |
| El alumno dado de baja | `000004` | El alumno está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
