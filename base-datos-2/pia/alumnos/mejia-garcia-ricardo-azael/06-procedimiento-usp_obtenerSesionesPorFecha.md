# PIA GameZone — Objeto 06 de 11: `usp_obtenerSesionesPorFecha`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerSesionesPorFecha`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** ver las sesiones de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las sesiones de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerSesionesPorFecha` que valide el rango y regrese las sesiones.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_FechaInicio` | `date` | Primer día del rango |
| `@p_FechaFin` | `date` | Último día del rango |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La fecha inicial no es posterior a la final | `000001` | La fecha inicial es posterior a la fecha final |

**Columnas del resultado**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaSesion` | Fecha de la sesión |
| `NumeroEstacion` | Estación |
| `Jugador` | Nombre del jugador |
| `Horas` | Horas |
| `PrecioCobrado` | Precio con el que se cobró la sesión |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerSesionesPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaSesion` y, en un mismo día, por `NumeroEstacion`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerSesionesPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaSesion | NumeroEstacion | Jugador | Horas | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | E-05 | Jugador de Prueba | 3 | 55.00 |
| 2026-12-02 | E-01 | Jugador de Prueba | 1 | 60.00 |
| 2026-12-02 | E-07 | Jugador de Prueba | 2 | 45.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md), [`usp_registrarSesion`](05-procedimiento-usp_registrarSesion.md).

```sql
-- Preparación: el jugador de prueba y tres sesiones de diciembre, registradas en desorden
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-07', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 2
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-05', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 3
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-01', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerSesionesPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerSesionesPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerSesionesPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerSesionesPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
