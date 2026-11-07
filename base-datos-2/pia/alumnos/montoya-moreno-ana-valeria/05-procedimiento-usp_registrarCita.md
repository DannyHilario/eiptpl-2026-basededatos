# PIA SpaZen — Objeto 05 de 11: `usp_registrarCita`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Procedimiento almacenado `usp_registrarCita`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** registrar una cita, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de servicio** y el **correo electrónico**; el procedimiento busca al servicio y al cliente. Solo se registran citas con servicios y clientes **activos**.

La cita se cobra con el **precio vigente** del servicio, en el momento de registrarla. Ese precio se **copia** a la cita: si mañana cambia, la cita conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, calificación fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarCita` que valide las reglas de abajo y, si todo es correcto, registre la cita con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreServicio` | `varchar(50)` | Nombre de servicio |
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico |
| `@p_FechaCita` | `date` | Fecha de la cita |
| `@p_Calificacion` | `int` | Calificación |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El servicio existe | `000001` | El servicio no existe |
| 2 | El servicio está activo | `000002` | El servicio está dado de baja |
| 3 | El cliente existe | `000003` | El cliente no existe |
| 4 | El cliente está activo | `000004` | El cliente está dado de baja |
| 5 | Todo correcto | `000000` | Cita registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarCita` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el servicio existe → `000001` *El servicio no existe*.
- [ ] Valida: el servicio está activo → `000002` *El servicio está dado de baja*.
- [ ] Valida: el cliente existe → `000003` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000004` *El cliente está dado de baja*.
- [ ] El `INSERT` de la cita va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cita registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id del servicio, si está activo y el **precio vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_darDeBajaCliente`](02-procedimiento-usp_darDeBajaCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreZona = 'Norte', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000000: 'Masaje relajante', $750.00
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5

-- 000001: no existe un servicio 'NoExiste'
EXEC usp_registrarCita @p_NombreServicio = 'NoExiste', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5

-- 000002: el servicio dado de baja. Como ningún procedimiento da de baja los servicios,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeServicios> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Masaje con piedras calientes'
EXEC usp_registrarCita @p_NombreServicio = 'Masaje con piedras calientes', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5
UPDATE <TuTablaDeServicios> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Masaje con piedras calientes'

-- 000003: no existe un cliente con ese correo electrónico
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'noexiste@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5

-- 999999: calificación = 6; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 6

-- 000004: el cliente dado de baja
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'prueba1@correo.com'
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-03', @p_Calificacion = 5
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| 'Masaje relajante', $750.00 | `000000` | Cita registrada |
| No existe un servicio 'NoExiste' | `000001` | El servicio no existe |
| El servicio dado de baja. Como ningún procedimiento da de baja los servicios | `000002` | El servicio está dado de baja |
| No existe un cliente con ese correo electrónico | `000003` | El cliente no existe |
| Calificación = 6 | `999999` | Error 547: … |
| El cliente dado de baja | `000000` | Cliente dado de baja |
| El cliente dado de baja | `000004` | El cliente está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
