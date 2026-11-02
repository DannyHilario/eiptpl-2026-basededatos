# PIA GameZone — Objeto 05 de 11: `usp_registrarSesion`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Procedimiento almacenado `usp_registrarSesion`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** registrar una sesión, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **número de estación** y el **gamertag**; el procedimiento busca a la estación y al jugador. Solo se registran sesiones con estaciones y jugadores **activos**.

La sesión se cobra con la **tarifa por hora vigente** del tipo de la estación, en el momento de registrarla. Ese precio se **copia** a la sesión: si mañana cambia, la sesión conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, horas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/06-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarSesion` que valide las reglas de abajo y, si todo es correcto, registre la sesión con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroEstacion` | `varchar(10)` | Número de estación |
| `@p_Gamertag` | `varchar(30)` | Gamertag |
| `@p_FechaSesion` | `date` | Fecha de la sesión |
| `@p_Horas` | `int` | Horas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La estación existe | `000001` | La estación no existe |
| 2 | La estación está activa | `000002` | La estación está dada de baja |
| 3 | El jugador existe | `000003` | El jugador no existe |
| 4 | El jugador está activo | `000004` | El jugador está dado de baja |
| 5 | Todo correcto | `000000` | Sesión registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarSesion` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la estación existe → `000001` *La estación no existe*.
- [ ] Valida: la estación está activa → `000002` *La estación está dada de baja*.
- [ ] Valida: el jugador existe → `000003` *El jugador no existe*.
- [ ] Valida: el jugador está activo → `000004` *El jugador está dado de baja*.
- [ ] El `INSERT` de la sesión va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Sesión registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id de la estación, si está activa y la **tarifa por hora vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md), [`usp_darDeBajaJugador`](02-procedimiento-usp_darDeBajaJugador.md).

```sql
-- Preparación: el jugador de prueba
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15

-- 000000: 'E-01', $60.00
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2

-- 000001: no existe una estación 'NoExiste'
EXEC usp_registrarSesion @p_NumeroEstacion = 'NoExiste', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2

-- 000002: 'E-10' está dada de baja
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-10', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2

-- 000003: no existe un jugador con ese gamertag
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'NoExiste99', @p_FechaSesion = '2026-12-01', @p_Horas = 2

-- 999999: horas = 6; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 6

-- 000004: el jugador dado de baja
EXEC usp_darDeBajaJugador @p_Gamertag = 'Prueba01'
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-03', @p_Horas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El jugador de prueba | `000000` | Jugador registrado |
| 'E-01', $60.00 | `000000` | Sesión registrada |
| No existe una estación 'NoExiste' | `000001` | La estación no existe |
| 'E-10' está dada de baja | `000002` | La estación está dada de baja |
| No existe un jugador con ese gamertag | `000003` | El jugador no existe |
| Horas = 6 | `999999` | Error 547: … |
| El jugador dado de baja | `000000` | Jugador dado de baja |
| El jugador dado de baja | `000004` | El jugador está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
