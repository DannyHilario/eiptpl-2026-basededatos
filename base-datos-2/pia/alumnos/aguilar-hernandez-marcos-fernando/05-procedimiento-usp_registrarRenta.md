# PIA BiciRuta — Objeto 05 de 11: `usp_registrarRenta`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Procedimiento almacenado `usp_registrarRenta`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** registrar una renta, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **número de serie** y el **correo electrónico**; el procedimiento busca a la bicicleta y al cliente. Solo se registran rentas con bicicletas y clientes **activos**.

La renta se cobra con la **tarifa por hora vigente** del tipo de la bicicleta, en el momento de registrarla. Ese precio se **copia** a la renta: si mañana cambia, la renta conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, horas fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/06-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarRenta` que valide las reglas de abajo y, si todo es correcto, registre la renta con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroSerie` | `varchar(20)` | Número de serie |
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico |
| `@p_FechaRenta` | `date` | Fecha de la renta |
| `@p_Horas` | `int` | Horas |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La bicicleta existe | `000001` | La bicicleta no existe |
| 2 | La bicicleta está activa | `000002` | La bicicleta está dada de baja |
| 3 | El cliente existe | `000003` | El cliente no existe |
| 4 | El cliente está activo | `000004` | El cliente está dado de baja |
| 5 | Todo correcto | `000000` | Renta registrada |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarRenta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la bicicleta existe → `000001` *La bicicleta no existe*.
- [ ] Valida: la bicicleta está activa → `000002` *La bicicleta está dada de baja*.
- [ ] Valida: el cliente existe → `000003` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000004` *El cliente está dado de baja*.
- [ ] El `INSERT` de la renta va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Renta registrada'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE` (con `JOIN`), el id de la bicicleta, si está activa y la **tarifa por hora vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_darDeBajaCliente`](02-procedimiento-usp_darDeBajaCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- 000000: 'UR-0001', $45.00
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2

-- 000001: no existe una bicicleta 'NoExiste'
EXEC usp_registrarRenta @p_NumeroSerie = 'NoExiste', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2

-- 000002: 'MT-0010' está dada de baja
EXEC usp_registrarRenta @p_NumeroSerie = 'MT-0010', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2

-- 000003: no existe un cliente con ese correo electrónico
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'noexiste@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2

-- 999999: horas = 9; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 9

-- 000004: el cliente dado de baja
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'prueba1@correo.com'
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-03', @p_Horas = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| 'UR-0001', $45.00 | `000000` | Renta registrada |
| No existe una bicicleta 'NoExiste' | `000001` | La bicicleta no existe |
| 'MT-0010' está dada de baja | `000002` | La bicicleta está dada de baja |
| No existe un cliente con ese correo electrónico | `000003` | El cliente no existe |
| Horas = 9 | `999999` | Error 547: … |
| El cliente dado de baja | `000000` | Cliente dado de baja |
| El cliente dado de baja | `000004` | El cliente está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
