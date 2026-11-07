# PIA RutaNorte — Objeto 05 de 11: `usp_registrarBoleto`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_registrarBoleto`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** registrar un boleto, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce la **clave de ruta** y el **correo electrónico**; el procedimiento busca a la ruta y al pasajero. Solo se registran boletos con rutas y pasajeros **activos**.

El boleto se cobra con el **precio vigente** de la ruta, en el momento de registrarlo. Ese precio se **copia** al boleto: si mañana cambia, el boleto conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, asiento fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarBoleto` que valide las reglas de abajo y, si todo es correcto, registre el boleto con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_ClaveRuta` | `varchar(10)` | Clave de ruta |
| `@p_CorreoPasajero` | `varchar(100)` | Correo electrónico |
| `@p_FechaViaje` | `date` | Fecha del boleto |
| `@p_Asiento` | `int` | Asiento |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La ruta existe | `000001` | La ruta no existe |
| 2 | La ruta está activa | `000002` | La ruta está dada de baja |
| 3 | El pasajero existe | `000003` | El pasajero no existe |
| 4 | El pasajero está activo | `000004` | El pasajero está dado de baja |
| 5 | Todo correcto | `000000` | Boleto registrado |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarBoleto` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la ruta existe → `000001` *La ruta no existe*.
- [ ] Valida: la ruta está activa → `000002` *La ruta está dada de baja*.
- [ ] Valida: el pasajero existe → `000003` *El pasajero no existe*.
- [ ] Valida: el pasajero está activo → `000004` *El pasajero está dado de baja*.
- [ ] El `INSERT` del boleto va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Boleto registrado'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id de la ruta, si está activa y el **precio vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md), [`usp_darDeBajaPasajero`](02-procedimiento-usp_darDeBajaPasajero.md).

```sql
-- Preparación: el pasajero de prueba
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000000: 'MTY-SAL', $180.00
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12

-- 000001: no existe una ruta 'NoExiste'
EXEC usp_registrarBoleto @p_ClaveRuta = 'NoExiste', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12

-- 000002: la ruta dada de baja. Como ningún procedimiento da de baja las rutas,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésala a activa al terminar
UPDATE <TuTablaDeRutas> SET <ColumnaActivo> = 0 WHERE <ColumnaClave> = 'MTY-REY'
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-REY', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12
UPDATE <TuTablaDeRutas> SET <ColumnaActivo> = 1 WHERE <ColumnaClave> = 'MTY-REY'

-- 000003: no existe un pasajero con ese correo electrónico
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'noexiste@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12

-- 999999: asiento = 41; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 41

-- 000004: el pasajero dado de baja
EXEC usp_darDeBajaPasajero @p_CorreoPasajero = 'prueba1@correo.com'
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-03', @p_Asiento = 12
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El pasajero de prueba | `000000` | Pasajero registrado |
| 'MTY-SAL', $180.00 | `000000` | Boleto registrado |
| No existe una ruta 'NoExiste' | `000001` | La ruta no existe |
| La ruta dada de baja. Como ningún procedimiento da de baja las rutas | `000002` | La ruta está dada de baja |
| No existe un pasajero con ese correo electrónico | `000003` | El pasajero no existe |
| Asiento = 41 | `999999` | Error 547: … |
| El pasajero dado de baja | `000000` | Pasajero dado de baja |
| El pasajero dado de baja | `000004` | El pasajero está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
