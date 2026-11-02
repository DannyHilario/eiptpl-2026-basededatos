# PIA VeloKart — Objeto 06 de 11: `usp_obtenerCarrerasPorFecha`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerCarrerasPorFecha`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** ver las carreras de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las carreras de ese rango, **incluidos los dos extremos**, con el número del kart y el nombre del piloto. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerCarrerasPorFecha` que valide el rango y regrese las carreras.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_FechaInicio` | `date` | Primer día del rango |
| `@p_FechaFin` | `date` | Último día del rango |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La fecha inicial no es posterior a la final | `000001` | La fecha inicial es posterior a la fecha final |

**Columnas del resultado**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaCarrera` | Día de la carrera |
| `NumeroKart` | Número del kart |
| `Piloto` | Nombre del piloto |
| `MejorVuelta` | Mejor vuelta, en segundos |
| `PrecioCobrado` | Precio con el que se cobró la carrera |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerCarrerasPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye las carreras del primer y del último día del rango.
- [ ] Ordena por `FechaCarrera` y, en un mismo día, por `NumeroKart`.
- [ ] Si no hay carreras en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerCarrerasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaCarrera | NumeroKart | Piloto | MejorVuelta | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | K-07 | Piloto de Prueba | 41.80 | 250.00 |
| 2026-12-02 | K-01 | Piloto de Prueba | 52.30 | 180.00 |
| 2026-12-02 | K-12 | Piloto de Prueba | 38.40 | 350.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPiloto`](01-procedimiento-usp_insertarPiloto.md) y [`usp_registrarCarrera`](05-procedimiento-usp_registrarCarrera.md).

```sql
-- Preparación: el piloto de prueba y tres carreras de diciembre, registradas en desorden
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175
EXEC usp_registrarCarrera @p_NumeroKart = 'K-12', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 38.40
EXEC usp_registrarCarrera @p_NumeroKart = 'K-07', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 41.80
EXEC usp_registrarCarrera @p_NumeroKart = 'K-01', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 52.30

-- Todo diciembre: 3 filas, ordenadas por fecha y número de kart
EXEC usp_obtenerCarrerasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día (inicio = fin): 2 filas, K-01 y K-12
EXEC usp_obtenerCarrerasPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerCarrerasPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerCarrerasPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Solo el 02/12/2026 | 2 filas: `K-01` ($180.00) y `K-12` ($350.00) |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
