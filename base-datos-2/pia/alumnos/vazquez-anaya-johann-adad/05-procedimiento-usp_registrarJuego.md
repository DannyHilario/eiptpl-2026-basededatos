# PIA StrikeMax — Objeto 05 de 11: `usp_registrarJuego`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Procedimiento almacenado `usp_registrarJuego`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** registrar un juego, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **número de pista** y el **teléfono**; el procedimiento busca a la pista y al cliente. Solo se registran juegos con pistas y clientes **activos**.

El juego se cobra con la **tarifa por línea vigente** del tipo de la pista, en el momento de registrarlo. Ese precio se **copia** al juego: si mañana cambia, el juego conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, líneas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarJuego` que valide las reglas de abajo y, si todo es correcto, registre el juego con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroPista` | `int` | Número de pista |
| `@p_TelefonoCliente` | `varchar(15)` | Teléfono |
| `@p_FechaJuego` | `date` | Fecha del juego |
| `@p_Lineas` | `int` | Líneas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La pista existe | `000001` | La pista no existe |
| 2 | La pista está activa | `000002` | La pista está dada de baja |
| 3 | El cliente existe | `000003` | El cliente no existe |
| 4 | El cliente está activo | `000004` | El cliente está dado de baja |
| 5 | Todo correcto | `000000` | Juego registrado |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarJuego` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la pista existe → `000001` *La pista no existe*.
- [ ] Valida: la pista está activa → `000002` *La pista está dada de baja*.
- [ ] Valida: el cliente existe → `000003` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000004` *El cliente está dado de baja*.
- [ ] El `INSERT` del juego va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Juego registrado'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id de la pista, si está activa y la **tarifa por línea vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_darDeBajaCliente`](02-procedimiento-usp_darDeBajaCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'

-- 000000: 1, $70.00
EXEC usp_registrarJuego @p_NumeroPista = 1, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 2

-- 000001: no existe una pista 'NoExiste'
EXEC usp_registrarJuego @p_NumeroPista = 999, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 2

-- 000002: 6 está dada de baja
EXEC usp_registrarJuego @p_NumeroPista = 6, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 2

-- 000003: no existe un cliente con ese teléfono
EXEC usp_registrarJuego @p_NumeroPista = 1, @p_TelefonoCliente = '8199999999', @p_FechaJuego = '2026-12-01', @p_Lineas = 2

-- 999999: líneas = 6; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarJuego @p_NumeroPista = 1, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-02', @p_Lineas = 6

-- 000004: el cliente dado de baja
EXEC usp_darDeBajaCliente @p_TelefonoCliente = '8199990001'
EXEC usp_registrarJuego @p_NumeroPista = 1, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-03', @p_Lineas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| 1, $70.00 | `000000` | Juego registrado |
| No existe una pista 'NoExiste' | `000001` | La pista no existe |
| 6 está dada de baja | `000002` | La pista está dada de baja |
| No existe un cliente con ese teléfono | `000003` | El cliente no existe |
| Líneas = 6 | `999999` | Error 547: … |
| El cliente dado de baja | `000000` | Cliente dado de baja |
| El cliente dado de baja | `000004` | El cliente está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
