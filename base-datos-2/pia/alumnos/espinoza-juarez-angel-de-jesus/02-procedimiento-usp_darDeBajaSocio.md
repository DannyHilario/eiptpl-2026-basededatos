# PIA FitZone — Objeto 02 de 11: `usp_darDeBajaSocio`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaSocio`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** dar de baja al socio que ya no regresa, **para** que ya no se le registren asistencias sin perder su historial.

## Contexto

En FitZone un socio **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **correo electrónico**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaSocio` que valide las reglas de abajo y, si todo es correcto, marque al socio como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoSocio` | `varchar(100)` | Correo electrónico del socio |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El socio existe | `000001` | El socio no existe |
| 2 | El socio está activo | `000002` | El socio ya está dado de baja |
| 3 | Todo correcto | `000000` | Socio dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaSocio` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el socio existe → `000001` *El socio no existe*.
- [ ] Valida: el socio está activo → `000002` *El socio ya está dado de baja*.
- [ ] Si todo es correcto, marca al socio como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Socio dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del socio y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el correo electrónico.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md).

```sql
-- Preparación: el socio de prueba
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'

-- 000001: no existe un socio con ese correo electrónico
EXEC usp_darDeBajaSocio @p_CorreoSocio = 'noexiste@correo.com'

-- 000000: se da de baja
EXEC usp_darDeBajaSocio @p_CorreoSocio = 'prueba1@correo.com'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaSocio @p_CorreoSocio = 'prueba1@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El socio de prueba | `000000` | Socio registrado |
| No existe un socio con ese correo electrónico | `000001` | El socio no existe |
| Se da de baja | `000000` | Socio dado de baja |
| Ya estaba dado de baja | `000002` | El socio ya está dado de baja |
