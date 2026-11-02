# PIA RecorreMTY — Objeto 02 de 11: `usp_darDeBajaTurista`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaTurista`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** dar de baja al turista que ya no regresa, **para** que ya no se le registren reservaciones sin perder su historial.

## Contexto

En RecorreMTY un turista **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **correo electrónico**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaTurista` que valide las reglas de abajo y, si todo es correcto, marque al turista como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoTurista` | `varchar(100)` | Correo electrónico del turista |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El turista existe | `000001` | El turista no existe |
| 2 | El turista está activo | `000002` | El turista ya está dado de baja |
| 3 | Todo correcto | `000000` | Turista dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaTurista` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el turista existe → `000001` *El turista no existe*.
- [ ] Valida: el turista está activo → `000002` *El turista ya está dado de baja*.
- [ ] Si todo es correcto, marca al turista como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Turista dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del turista y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el correo electrónico.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md).

```sql
-- Preparación: el turista de prueba
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000001: no existe un turista con ese correo electrónico
EXEC usp_darDeBajaTurista @p_CorreoTurista = 'noexiste@correo.com'

-- 000000: se da de baja
EXEC usp_darDeBajaTurista @p_CorreoTurista = 'prueba1@correo.com'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaTurista @p_CorreoTurista = 'prueba1@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El turista de prueba | `000000` | Turista registrado |
| No existe un turista con ese correo electrónico | `000001` | El turista no existe |
| Se da de baja | `000000` | Turista dado de baja |
| Ya estaba dado de baja | `000002` | El turista ya está dado de baja |
