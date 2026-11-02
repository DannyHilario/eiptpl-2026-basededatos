# PIA SalaRock — Objeto 05 de 11: `usp_registrarEnsayo`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Procedimiento almacenado `usp_registrarEnsayo`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** registrar un ensayo, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de sala** y el **nombre de banda**; el procedimiento busca a la sala y a la banda. Solo se registran ensayos con salas y bandas **activas**.

El ensayo se cobra con la **tarifa por hora vigente** del tipo de la sala, en el momento de registrarlo. Ese precio se **copia** al ensayo: si mañana cambia, el ensayo conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, horas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/06-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarEnsayo` que valide las reglas de abajo y, si todo es correcto, registre el ensayo con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreSala` | `varchar(50)` | Nombre de sala |
| `@p_NombreBanda` | `varchar(50)` | Nombre de banda |
| `@p_FechaEnsayo` | `date` | Fecha del ensayo |
| `@p_Horas` | `int` | Horas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La sala existe | `000001` | La sala no existe |
| 2 | La sala está activa | `000002` | La sala está dada de baja |
| 3 | La banda existe | `000003` | La banda no existe |
| 4 | La banda está activa | `000004` | La banda está dada de baja |
| 5 | Todo correcto | `000000` | Ensayo registrado |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarEnsayo` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la sala existe → `000001` *La sala no existe*.
- [ ] Valida: la sala está activa → `000002` *La sala está dada de baja*.
- [ ] Valida: la banda existe → `000003` *La banda no existe*.
- [ ] Valida: la banda está activa → `000004` *La banda está dada de baja*.
- [ ] El `INSERT` del ensayo va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Ensayo registrado'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id de la sala, si está activa y la **tarifa por hora vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md), [`usp_darDeBajaBanda`](02-procedimiento-usp_darDeBajaBanda.md).

```sql
-- Preparación: la banda de prueba
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'

-- 000000: 'Sala Hendrix', $150.00
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2

-- 000001: no existe una sala 'NoExiste'
EXEC usp_registrarEnsayo @p_NombreSala = 'NoExiste', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2

-- 000002: 'Sala Bowie' está dada de baja
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Bowie', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2

-- 000003: no existe una banda con ese nombre de banda
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'NoExiste99', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2

-- 999999: horas = 5; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 5

-- 000004: la banda dada de baja
EXEC usp_darDeBajaBanda @p_NombreBanda = 'Banda de Prueba'
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-03', @p_Horas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| La banda de prueba | `000000` | Banda registrada |
| 'Sala Hendrix', $150.00 | `000000` | Ensayo registrado |
| No existe una sala 'NoExiste' | `000001` | La sala no existe |
| 'Sala Bowie' está dada de baja | `000002` | La sala está dada de baja |
| No existe una banda con ese nombre de banda | `000003` | La banda no existe |
| Horas = 5 | `999999` | Error 547: … |
| La banda dada de baja | `000000` | Banda dada de baja |
| La banda dada de baja | `000004` | La banda está dada de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
