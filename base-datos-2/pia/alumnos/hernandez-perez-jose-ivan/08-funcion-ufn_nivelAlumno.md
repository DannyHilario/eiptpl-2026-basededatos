# PIA AsesorPro — Objeto 08 de 11: `ufn_nivelAlumno`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Función escalar `ufn_nivelAlumno`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** saber qué tan seguido viene un alumno, **para** ofrecerle una promoción según su nivel.

## Contexto

AsesorPro clasifica a sus alumnos según **cuántas asesorías** tienen en total:

| Asesorías | Nivel |
|---|---|
| 0 | **Sin asesorías** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al alumno por su **correo electrónico**. Un alumno dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelAlumno` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoAlumno` | `varchar(100)` | Correo electrónico del alumno |

**Regresa:** `varchar(20)` — `'Sin asesorías'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelAlumno` y recibe `@p_CorreoAlumno varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un alumno con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las asesorías del alumno, aunque esté dado de baja.
- [ ] Regresa `'Sin asesorías'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarAlumno`](01-procedimiento-usp_insertarAlumno.md), [`usp_registrarAsesoria`](05-procedimiento-usp_registrarAsesoria.md).

```sql
-- Preparación: el alumno de prueba
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 asesorías: Sin asesorías
SELECT dbo.ufn_nivelAlumno('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelAlumno('noexiste@correo.com') AS Nivel
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'laura.garza@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2

-- 1 asesoría: Ocasional
SELECT dbo.ufn_nivelAlumno('prueba1@correo.com') AS Nivel
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'jorge.trevino@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-02', @p_Horas = 3

-- 2 asesorías: Ocasional
SELECT dbo.ufn_nivelAlumno('prueba1@correo.com') AS Nivel
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'laura.garza@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-03', @p_Horas = 1

-- 3 asesorías: Frecuente
SELECT dbo.ufn_nivelAlumno('prueba1@correo.com') AS Nivel
```
