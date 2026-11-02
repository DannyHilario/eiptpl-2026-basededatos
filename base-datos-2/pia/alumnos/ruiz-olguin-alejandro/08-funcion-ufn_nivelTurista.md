# PIA RecorreMTY — Objeto 08 de 11: `ufn_nivelTurista`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Función escalar `ufn_nivelTurista`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** saber qué tan seguido viene un turista, **para** ofrecerle una promoción según su nivel.

## Contexto

RecorreMTY clasifica a sus turistas según **cuántas reservaciones** tienen en total:

| Reservaciones | Nivel |
|---|---|
| 0 | **Sin reservaciones** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al turista por su **correo electrónico**. Un turista dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelTurista` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoTurista` | `varchar(100)` | Correo electrónico del turista |

**Regresa:** `varchar(20)` — `'Sin reservaciones'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelTurista` y recibe `@p_CorreoTurista varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un turista con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las reservaciones del turista, aunque esté dado de baja.
- [ ] Regresa `'Sin reservaciones'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md), [`usp_registrarReservacion`](05-procedimiento-usp_registrarReservacion.md).

```sql
-- Preparación: el turista de prueba
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 reservaciones: Sin reservaciones
SELECT dbo.ufn_nivelTurista('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelTurista('noexiste@correo.com') AS Nivel
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2

-- 1 reservación: Ocasional
SELECT dbo.ufn_nivelTurista('prueba1@correo.com') AS Nivel
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Paseo Santa Lucía', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 3

-- 2 reservaciones: Ocasional
SELECT dbo.ufn_nivelTurista('prueba1@correo.com') AS Nivel
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-03', @p_Personas = 1

-- 3 reservaciones: Frecuente
SELECT dbo.ufn_nivelTurista('prueba1@correo.com') AS Nivel
```
