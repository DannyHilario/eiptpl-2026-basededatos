# PIA EnigmaRoom — Objeto 05 de 11: `usp_registrarPartida`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Procedimiento almacenado `usp_registrarPartida`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** registrar una partida, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de sala** y el **correo electrónico**; el procedimiento busca a la sala de escape y al cliente. Solo se registran partidas con salas de escape y clientes **activos**.

La partida se cobra con el **precio por partida vigente** de la sala de escape, en el momento de registrarla. Ese precio se **copia** a la partida: si mañana cambia, la partida conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, jugadores fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarPartida` que valide las reglas de abajo y, si todo es correcto, registre la partida con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreSalaEscape` | `varchar(50)` | Nombre de sala |
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico |
| `@p_FechaPartida` | `date` | Fecha de la partida |
| `@p_Jugadores` | `int` | Jugadores |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La sala de escape existe | `000001` | La sala de escape no existe |
| 2 | La sala de escape está activa | `000002` | La sala de escape está dada de baja |
| 3 | El cliente existe | `000003` | El cliente no existe |
| 4 | El cliente está activo | `000004` | El cliente está dado de baja |
| 5 | Todo correcto | `000000` | Partida registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarPartida` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la sala de escape existe → `000001` *La sala de escape no existe*.
- [ ] Valida: la sala de escape está activa → `000002` *La sala de escape está dada de baja*.
- [ ] Valida: el cliente existe → `000003` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000004` *El cliente está dado de baja*.
- [ ] El `INSERT` de la partida va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Partida registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id de la sala de escape, si está activa y el **precio por partida vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_darDeBajaCliente`](02-procedimiento-usp_darDeBajaCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreMedio = 'Redes sociales', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000000: 'El Laboratorio', $900.00
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4

-- 000001: no existe una sala de escape 'NoExiste'
EXEC usp_registrarPartida @p_NombreSalaEscape = 'NoExiste', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4

-- 000002: la sala de escape dada de baja. Como ningún procedimiento da de baja las salas de escape,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésala a activa al terminar
UPDATE <TuTablaDeSalasDeEscape> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'La Cripta'
EXEC usp_registrarPartida @p_NombreSalaEscape = 'La Cripta', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4
UPDATE <TuTablaDeSalasDeEscape> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'La Cripta'

-- 000003: no existe un cliente con ese correo electrónico
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'noexiste@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4

-- 999999: jugadores = 7; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 7

-- 000004: el cliente dado de baja
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'prueba1@correo.com'
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-03', @p_Jugadores = 4
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| 'El Laboratorio', $900.00 | `000000` | Partida registrada |
| No existe una sala de escape 'NoExiste' | `000001` | La sala de escape no existe |
| La sala de escape dada de baja. Como ningún procedimiento da de baja las salas de escape | `000002` | La sala de escape está dada de baja |
| No existe un cliente con ese correo electrónico | `000003` | El cliente no existe |
| Jugadores = 7 | `999999` | Error 547: … |
| El cliente dado de baja | `000000` | Cliente dado de baja |
| El cliente dado de baja | `000004` | El cliente está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
