# PIA VeloKart — Objeto 05 de 11: `usp_registrarCarrera`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_registrarCarrera`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** encargado de la pista, **quiero** registrar una carrera al terminar, **para** que quede guardado quién corrió, en qué kart, su mejor vuelta y cuánto se le cobró.

## Contexto

Es el paso 4 del [flujo de negocio](README.md#flujo-de-negocio). El encargado conoce el **número** del kart y el **teléfono** del piloto; el procedimiento busca a los dos. Solo corren karts y pilotos **activos**.

La carrera se cobra con el **precio por carrera vigente** del tipo del kart, en el momento de registrarla. Ese precio se **copia** a la carrera: si mañana cambia el precio del tipo, la carrera conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, la mejor vuelta debe ser mayor a cero (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarCarrera` que valide las reglas de abajo y, si todo es correcto, registre la carrera con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_NumeroKart` | `varchar(10)` | Número del kart, por ejemplo `K-07` |
| `@p_TelefonoPiloto` | `varchar(15)` | Teléfono del piloto |
| `@p_FechaCarrera` | `date` | Día de la carrera |
| `@p_MejorVuelta` | `decimal(5,2)` | Mejor vuelta, en segundos |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El kart existe | `000001` | El kart no existe |
| 2 | El kart está activo | `000002` | El kart está dado de baja |
| 3 | El piloto existe | `000003` | El piloto no existe |
| 4 | El piloto está activo | `000004` | El piloto está dado de baja |
| 5 | Todo correcto | `000000` | Carrera registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarCarrera` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones 1 a 4 son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el kart existe → `000001` *El kart no existe*.
- [ ] Valida: el kart está activo → `000002` *El kart está dado de baja*.
- [ ] Valida: el piloto existe (buscándolo por teléfono) → `000003` *El piloto no existe*.
- [ ] Valida: el piloto está activo → `000004` *El piloto está dado de baja*.
- [ ] El `INSERT` de la carrera va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Carrera registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id del kart, si está activo y el **precio por carrera vigente** de su tipo.

## Ejemplo de salida esperada

`EXEC usp_registrarCarrera @p_NumeroKart = 'K-07', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Carrera registrada |

Después, en tu tabla de carreras aparece la carrera del 01/12/2026 del `K-07` (Estándar) con mejor vuelta de 41.80 segundos y **precio cobrado de $250.00**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPiloto`](01-procedimiento-usp_insertarPiloto.md) y [`usp_darDeBajaPiloto`](02-procedimiento-usp_darDeBajaPiloto.md).

```sql
-- Preparación: el piloto de prueba
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175

-- 000000: el K-07 es Estándar, $250.00
EXEC usp_registrarCarrera @p_NumeroKart = 'K-07', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80

-- 000001: no hay kart K-99
EXEC usp_registrarCarrera @p_NumeroKart = 'K-99', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80

-- 000002: el K-09 está dado de baja
EXEC usp_registrarCarrera @p_NumeroKart = 'K-09', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80

-- 000003: nadie tiene ese teléfono
EXEC usp_registrarCarrera @p_NumeroKart = 'K-07', @p_TelefonoPiloto = '8199999999', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80

-- 999999: mejor vuelta de 0; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarCarrera @p_NumeroKart = 'K-07', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 0

-- 000004: piloto dado de baja
EXEC usp_darDeBajaPiloto @p_Telefono = '8199990001'
EXEC usp_registrarCarrera @p_NumeroKart = 'K-07', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-03', @p_MejorVuelta = 41.80
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| `K-07`, piloto de prueba | `000000` | Carrera registrada |
| `K-99` | `000001` | El kart no existe |
| `K-09` | `000002` | El kart está dado de baja |
| Teléfono que no existe | `000003` | El piloto no existe |
| Mejor vuelta 0 | `999999` | Error 547: The INSERT statement conflicted with the CHECK constraint "…". … |
| Piloto dado de baja | `000004` | El piloto está dado de baja |

En el `999999`, el nombre de la restricción y de la tabla que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.

Al final, tu tabla de carreras tiene **una sola** carrera nueva: la del 01/12/2026, cobrada a $250.00.
