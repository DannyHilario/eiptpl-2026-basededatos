# PIA QuintaSol — Objeto 05 de 11: `usp_registrarEvento`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Procedimiento almacenado `usp_registrarEvento`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** registrar un evento, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de quinta** y el **teléfono**; el procedimiento busca a la quinta y al cliente. Solo se registran eventos con quintas y clientes **activos**.

El evento se cobra con el **precio por día vigente** del tipo de la quinta, en el momento de registrarlo. Ese precio se **copia** al evento: si mañana cambia, el evento conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, invitados fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarEvento` que valide las reglas de abajo y, si todo es correcto, registre el evento con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreQuinta` | `varchar(50)` | Nombre de quinta |
| `@p_TelefonoCliente` | `varchar(15)` | Teléfono |
| `@p_FechaEvento` | `date` | Fecha del evento |
| `@p_Invitados` | `int` | Invitados |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La quinta existe | `000001` | La quinta no existe |
| 2 | La quinta está activa | `000002` | La quinta está dada de baja |
| 3 | El cliente existe | `000003` | El cliente no existe |
| 4 | El cliente está activo | `000004` | El cliente está dado de baja |
| 5 | Todo correcto | `000000` | Evento registrado |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarEvento` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la quinta existe → `000001` *La quinta no existe*.
- [ ] Valida: la quinta está activa → `000002` *La quinta está dada de baja*.
- [ ] Valida: el cliente existe → `000003` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000004` *El cliente está dado de baja*.
- [ ] El `INSERT` del evento va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Evento registrado'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id de la quinta, si está activa y el **precio por día vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_darDeBajaCliente`](02-procedimiento-usp_darDeBajaCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'

-- 000000: 'Los Nogales', $5,500.00
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80

-- 000001: no existe una quinta 'NoExiste'
EXEC usp_registrarEvento @p_NombreQuinta = 'NoExiste', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80

-- 000002: 'Los Álamos' está dada de baja
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Álamos', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80

-- 000003: no existe un cliente con ese teléfono
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199999999', @p_FechaEvento = '2026-12-01', @p_Invitados = 80

-- 999999: invitados = 201; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 201

-- 000004: el cliente dado de baja
EXEC usp_darDeBajaCliente @p_TelefonoCliente = '8199990001'
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-03', @p_Invitados = 80
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| 'Los Nogales', $5,500.00 | `000000` | Evento registrado |
| No existe una quinta 'NoExiste' | `000001` | La quinta no existe |
| 'Los Álamos' está dada de baja | `000002` | La quinta está dada de baja |
| No existe un cliente con ese teléfono | `000003` | El cliente no existe |
| Invitados = 201 | `999999` | Error 547: … |
| El cliente dado de baja | `000000` | Cliente dado de baja |
| El cliente dado de baja | `000004` | El cliente está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
