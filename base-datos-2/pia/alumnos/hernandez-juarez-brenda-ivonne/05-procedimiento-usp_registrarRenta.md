# PIA CampoVerde — Objeto 05 de 11: `usp_registrarRenta`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Procedimiento almacenado `usp_registrarRenta`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** registrar una renta, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **código** y el **teléfono**; el procedimiento busca a la casa de campaña y al campista. Solo se registran rentas con casas de campaña y campistas **activos**.

La renta se cobra con el **precio por noche vigente** del tipo de la casa de campaña, en el momento de registrarla. Ese precio se **copia** a la renta: si mañana cambia, la renta conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, noches fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarRenta` que valide las reglas de abajo y, si todo es correcto, registre la renta con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CodigoTienda` | `varchar(10)` | Código |
| `@p_TelefonoCampista` | `varchar(15)` | Teléfono |
| `@p_FechaLlegada` | `date` | Fecha de la renta |
| `@p_Noches` | `int` | Noches |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La casa de campaña existe | `000001` | La casa de campaña no existe |
| 2 | La casa de campaña está activa | `000002` | La casa de campaña está dada de baja |
| 3 | El campista existe | `000003` | El campista no existe |
| 4 | El campista está activo | `000004` | El campista está dado de baja |
| 5 | Todo correcto | `000000` | Renta registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarRenta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la casa de campaña existe → `000001` *La casa de campaña no existe*.
- [ ] Valida: la casa de campaña está activa → `000002` *La casa de campaña está dada de baja*.
- [ ] Valida: el campista existe → `000003` *El campista no existe*.
- [ ] Valida: el campista está activo → `000004` *El campista está dado de baja*.
- [ ] El `INSERT` de la renta va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Renta registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id de la casa de campaña, si está activa y el **precio por noche vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCampista`](01-procedimiento-usp_insertarCampista.md), [`usp_darDeBajaCampista`](02-procedimiento-usp_darDeBajaCampista.md).

```sql
-- Preparación: el campista de prueba
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'

-- 000000: 'T-01', $250.00
EXEC usp_registrarRenta @p_CodigoTienda = 'T-01', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2

-- 000001: no existe una casa de campaña 'NoExiste'
EXEC usp_registrarRenta @p_CodigoTienda = 'NoExiste', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2

-- 000002: 'T-07' está dada de baja
EXEC usp_registrarRenta @p_CodigoTienda = 'T-07', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2

-- 000003: no existe un campista con ese teléfono
EXEC usp_registrarRenta @p_CodigoTienda = 'T-01', @p_TelefonoCampista = '8199999999', @p_FechaLlegada = '2026-12-01', @p_Noches = 2

-- 999999: noches = 8; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarRenta @p_CodigoTienda = 'T-01', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-02', @p_Noches = 8

-- 000004: el campista dado de baja
EXEC usp_darDeBajaCampista @p_TelefonoCampista = '8199990001'
EXEC usp_registrarRenta @p_CodigoTienda = 'T-01', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-03', @p_Noches = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El campista de prueba | `000000` | Campista registrado |
| 'T-01', $250.00 | `000000` | Renta registrada |
| No existe una casa de campaña 'NoExiste' | `000001` | La casa de campaña no existe |
| 'T-07' está dada de baja | `000002` | La casa de campaña está dada de baja |
| No existe un campista con ese teléfono | `000003` | El campista no existe |
| Noches = 8 | `999999` | Error 547: … |
| El campista dado de baja | `000000` | Campista dado de baja |
| El campista dado de baja | `000004` | El campista está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
