# PIA EspacioUno — Objeto 05 de 11: `usp_registrarReserva`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Procedimiento almacenado `usp_registrarReserva`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** registrar una reserva, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de espacio** y el **correo electrónico**; el procedimiento busca al espacio y al miembro. Solo se registran reservas con espacios y miembros **activos**.

La reserva se cobra con la **tarifa por hora vigente** del tipo del espacio, en el momento de registrarla. Ese precio se **copia** a la reserva: si mañana cambia, la reserva conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, horas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/06-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarReserva` que valide las reglas de abajo y, si todo es correcto, registre la reserva con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreEspacio` | `varchar(50)` | Nombre de espacio |
| `@p_CorreoMiembro` | `varchar(100)` | Correo electrónico |
| `@p_FechaReserva` | `date` | Fecha de la reserva |
| `@p_Horas` | `int` | Horas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El espacio existe | `000001` | El espacio no existe |
| 2 | El espacio está activo | `000002` | El espacio está dado de baja |
| 3 | El miembro existe | `000003` | El miembro no existe |
| 4 | El miembro está activo | `000004` | El miembro está dado de baja |
| 5 | Todo correcto | `000000` | Reserva registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarReserva` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el espacio existe → `000001` *El espacio no existe*.
- [ ] Valida: el espacio está activo → `000002` *El espacio está dado de baja*.
- [ ] Valida: el miembro existe → `000003` *El miembro no existe*.
- [ ] Valida: el miembro está activo → `000004` *El miembro está dado de baja*.
- [ ] El `INSERT` de la reserva va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Reserva registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id del espacio, si está activo y la **tarifa por hora vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md), [`usp_darDeBajaMiembro`](02-procedimiento-usp_darDeBajaMiembro.md).

```sql
-- Preparación: el miembro de prueba
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'

-- 000000: 'Escritorio Ventana', $80.00
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2

-- 000001: no existe un espacio 'NoExiste'
EXEC usp_registrarReserva @p_NombreEspacio = 'NoExiste', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2

-- 000002: 'Oficina Mitras' está dado de baja
EXEC usp_registrarReserva @p_NombreEspacio = 'Oficina Mitras', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2

-- 000003: no existe un miembro con ese correo electrónico
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'noexiste@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2

-- 999999: horas = 9; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 9

-- 000004: el miembro dado de baja
EXEC usp_darDeBajaMiembro @p_CorreoMiembro = 'prueba1@correo.com'
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-03', @p_Horas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El miembro de prueba | `000000` | Miembro registrado |
| 'Escritorio Ventana', $80.00 | `000000` | Reserva registrada |
| No existe un espacio 'NoExiste' | `000001` | El espacio no existe |
| 'Oficina Mitras' está dado de baja | `000002` | El espacio está dado de baja |
| No existe un miembro con ese correo electrónico | `000003` | El miembro no existe |
| Horas = 9 | `999999` | Error 547: … |
| El miembro dado de baja | `000000` | Miembro dado de baja |
| El miembro dado de baja | `000004` | El miembro está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
