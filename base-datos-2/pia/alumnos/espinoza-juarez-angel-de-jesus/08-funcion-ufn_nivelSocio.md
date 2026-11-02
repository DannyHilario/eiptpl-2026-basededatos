# PIA FitZone — Objeto 08 de 11: `ufn_nivelSocio`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Función escalar `ufn_nivelSocio`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** saber qué tan seguido viene un socio, **para** ofrecerle una promoción según su nivel.

## Contexto

FitZone clasifica a sus socios según **cuántas asistencias** tienen en total:

| Asistencias | Nivel |
|---|---|
| 0 | **Sin asistencias** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al socio por su **correo electrónico**. Un socio dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelSocio` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoSocio` | `varchar(100)` | Correo electrónico del socio |

**Regresa:** `varchar(20)` — `'Sin asistencias'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelSocio` y recibe `@p_CorreoSocio varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un socio con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las asistencias del socio, aunque esté dado de baja.
- [ ] Regresa `'Sin asistencias'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md), [`usp_registrarAsistencia`](05-procedimiento-usp_registrarAsistencia.md).

```sql
-- Preparación: el socio de prueba
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'

-- 0 asistencias: Sin asistencias
SELECT dbo.ufn_nivelSocio('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelSocio('noexiste@correo.com') AS Nivel
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'

-- 1 asistencia: Ocasional
SELECT dbo.ufn_nivelSocio('prueba1@correo.com') AS Nivel
EXEC usp_registrarAsistencia @p_NombreClase = 'Yoga', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-02'

-- 2 asistencias: Ocasional
SELECT dbo.ufn_nivelSocio('prueba1@correo.com') AS Nivel
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-03'

-- 3 asistencias: Frecuente
SELECT dbo.ufn_nivelSocio('prueba1@correo.com') AS Nivel
```
