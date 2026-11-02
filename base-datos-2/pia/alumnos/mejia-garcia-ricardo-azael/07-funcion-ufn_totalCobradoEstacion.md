# PIA GameZone — Objeto 07 de 11: `ufn_totalCobradoEstacion`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Función escalar `ufn_totalCobradoEstacion`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** saber cuánto se ha cobrado en total por cada estación, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una estación es la **suma de lo cobrado** en todas sus sesiones: en cada una, el precio cobrado × horas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La estación tiene sesiones | La suma de lo cobrado |
| La estación existe pero no tiene sesiones | `0.00` |
| La estación no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoEstacion` que reciba el número de una estación y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroEstacion` | `varchar(10)` | Número de la estación |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoEstacion` y recibe `@p_NumeroEstacion varchar(10)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una estación con ese número, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada sesión, no el precio actual), multiplicado por horas.
- [ ] Si la estación existe pero no tiene sesiones, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md), [`usp_insertarEstacion`](03-procedimiento-usp_insertarEstacion.md), [`usp_actualizarTarifaTipoConsola`](04-procedimiento-usp_actualizarTarifaTipoConsola.md), [`usp_registrarSesion`](05-procedimiento-usp_registrarSesion.md).

```sql
-- Preparación: el jugador de prueba
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15

-- Preparación: una estación nueva, 'E-20' (Xbox Series X, $55.00)
EXEC usp_insertarEstacion @p_NombreTipoConsola = 'Xbox Series X', @p_NumeroEstacion = 'E-20', @p_FechaInstalacion = '2026-11-01'

-- Sin sesiones: 0.00
SELECT dbo.ufn_totalCobradoEstacion('E-20') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoEstacion('NoExiste') AS TotalCobrado
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-20', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-20', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 3

-- Dos sesiones: 275.00
SELECT dbo.ufn_totalCobradoEstacion('E-20') AS TotalCobrado

-- Sube el precio a $65.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarTarifaTipoConsola @p_NombreTipoConsola = 'Xbox Series X', @p_PrecioNuevo = 65.00
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-20', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-03', @p_Horas = 1

-- Tres sesiones: 340.00
SELECT dbo.ufn_totalCobradoEstacion('E-20') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'E-20' sin sesiones | 0.00 |
| No existe | NULL |
| Con 2 sesiones | 275.00 |
| Con 3 sesiones, una con el precio nuevo | 340.00 |
