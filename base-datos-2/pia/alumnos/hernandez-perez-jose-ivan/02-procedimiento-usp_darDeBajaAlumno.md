# PIA AsesorPro — Objeto 02 de 11: `usp_darDeBajaAlumno`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaAlumno`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** dar de baja al alumno que ya no regresa, **para** que ya no se le registren asesorías sin perder su historial.

## Contexto

En AsesorPro un alumno **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **correo electrónico**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaAlumno` que valide las reglas de abajo y, si todo es correcto, marque al alumno como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoAlumno` | `varchar(100)` | Correo electrónico del alumno |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El alumno existe | `000001` | El alumno no existe |
| 2 | El alumno está activo | `000002` | El alumno ya está dado de baja |
| 3 | Todo correcto | `000000` | Alumno dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaAlumno` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el alumno existe → `000001` *El alumno no existe*.
- [ ] Valida: el alumno está activo → `000002` *El alumno ya está dado de baja*.
- [ ] Si todo es correcto, marca al alumno como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Alumno dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del alumno y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el correo electrónico.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarAlumno`](01-procedimiento-usp_insertarAlumno.md).

```sql
-- Preparación: el alumno de prueba
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000001: no existe un alumno con ese correo electrónico
EXEC usp_darDeBajaAlumno @p_CorreoAlumno = 'noexiste@correo.com'

-- 000000: se da de baja
EXEC usp_darDeBajaAlumno @p_CorreoAlumno = 'prueba1@correo.com'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaAlumno @p_CorreoAlumno = 'prueba1@correo.com'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El alumno de prueba | `000000` | Alumno registrado |
| No existe un alumno con ese correo electrónico | `000001` | El alumno no existe |
| Se da de baja | `000000` | Alumno dado de baja |
| Ya estaba dado de baja | `000002` | El alumno ya está dado de baja |
