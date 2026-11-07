# PIA GameZone — Objeto 08 de 11: `ufn_nivelJugador`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Función escalar `ufn_nivelJugador`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** saber qué tan seguido viene un jugador, **para** ofrecerle una promoción según su nivel.

## Contexto

GameZone clasifica a sus jugadores según **cuántas sesiones** tienen en total:

| Sesiones | Nivel |
|---|---|
| 0 | **Sin sesiones** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al jugador por su **gamertag**. Un jugador dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelJugador` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Gamertag` | `varchar(30)` | Gamertag del jugador |

**Regresa:** `varchar(20)` — `'Sin sesiones'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelJugador` y recibe `@p_Gamertag varchar(30)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un jugador con ese gamertag, regresa `NULL`.
- [ ] Cuenta las sesiones del jugador, aunque esté dado de baja.
- [ ] Regresa `'Sin sesiones'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md), [`usp_registrarSesion`](05-procedimiento-usp_registrarSesion.md).

```sql
-- Preparación: el jugador de prueba
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15

-- 0 sesiones: Sin sesiones
SELECT dbo.ufn_nivelJugador('Prueba01') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelJugador('NoExiste99') AS Nivel
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2

-- 1 sesión: Ocasional
SELECT dbo.ufn_nivelJugador('Prueba01') AS Nivel
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-02', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 3

-- 2 sesiones: Ocasional
SELECT dbo.ufn_nivelJugador('Prueba01') AS Nivel
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-03', @p_Horas = 1

-- 3 sesiones: Frecuente
SELECT dbo.ufn_nivelJugador('Prueba01') AS Nivel
```
