# PIA GameZone — Objeto 09 de 11: `vw_DetalleSesion`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Vista `vw_DetalleSesion`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** ver cada sesión completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada sesión guarda el **precio cobrado**, y el tipo de consola tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleSesion` que muestre **todas** las sesiones con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaSesion` | Fecha de la sesión |
| `NumeroEstacion` | Número de estación |
| `TipoConsola` | Nombre del tipo de consola |
| `Jugador` | Nombre del jugador |
| `Horas` | Horas |
| `PrecioCobrado` | Precio que guarda la sesión |
| `PrecioActual` | Precio actual del tipo de consola |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleSesion`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de sesiones con estaciones, tipos de consola y jugadores (`INNER JOIN`).
- [ ] Tiene **una fila por sesión**: el número de filas de la vista es igual al de tu tabla de sesiones.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleSesion WHERE FechaSesion >= '2026-12-01' ORDER BY FechaSesion`, después de la preparación de los casos de prueba:

| FechaSesion | NumeroEstacion | TipoConsola | Jugador | Horas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | E-07 | Nintendo Switch | Jugador de Prueba | 2 | 45.00 | 50.00 | Subió |
| 2026-12-02 | E-07 | Nintendo Switch | Jugador de Prueba | 3 | 55.00 | 50.00 | Bajó |
| 2026-12-03 | E-07 | Nintendo Switch | Jugador de Prueba | 1 | 50.00 | 50.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md), [`usp_actualizarTarifaTipoConsola`](04-procedimiento-usp_actualizarTarifaTipoConsola.md), [`usp_registrarSesion`](05-procedimiento-usp_registrarSesion.md).

```sql
-- Preparación: tres sesiones de 'E-07', cada una con un precio distinto
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-07', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2
EXEC usp_actualizarTarifaTipoConsola @p_NombreTipoConsola = 'Nintendo Switch', @p_PrecioNuevo = 55.00
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-07', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 3
EXEC usp_actualizarTarifaTipoConsola @p_NombreTipoConsola = 'Nintendo Switch', @p_PrecioNuevo = 50.00
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-07', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-03', @p_Horas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleSesion WHERE FechaSesion >= '2026-12-01' ORDER BY FechaSesion

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleSesion
SELECT COUNT(*) AS Total FROM <TuTablaDeSesiones>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus sesiones más las 3 de prueba |
| Tus sesiones inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
