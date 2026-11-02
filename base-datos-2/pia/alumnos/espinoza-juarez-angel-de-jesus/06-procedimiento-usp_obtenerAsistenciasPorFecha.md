# PIA FitZone — Objeto 06 de 11: `usp_obtenerAsistenciasPorFecha`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerAsistenciasPorFecha`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** ver las asistencias de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las asistencias de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerAsistenciasPorFecha` que valide el rango y regrese las asistencias.

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
| `FechaAsistencia` | Fecha de la asistencia |
| `Clase` | Clase |
| `Socio` | Nombre del socio |
| `PrecioCobrado` | Precio con el que se cobró la asistencia |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerAsistenciasPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 4 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaAsistencia` y, en un mismo día, por `Clase`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerAsistenciasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaAsistencia | Clase | Socio | PrecioCobrado |
|---|---|---|---|
| 2026-12-01 | Spinning | Socio de Prueba | 90.00 |
| 2026-12-02 | Box | Socio de Prueba | 100.00 |
| 2026-12-02 | Yoga | Socio de Prueba | 80.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md), [`usp_registrarAsistencia`](05-procedimiento-usp_registrarAsistencia.md).

```sql
-- Preparación: el socio de prueba y tres asistencias de diciembre, registradas en desorden
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'
EXEC usp_registrarAsistencia @p_NombreClase = 'Box', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-02'
EXEC usp_registrarAsistencia @p_NombreClase = 'Spinning', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'
EXEC usp_registrarAsistencia @p_NombreClase = 'Yoga', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-02'

-- Todo diciembre: 3 filas
EXEC usp_obtenerAsistenciasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerAsistenciasPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerAsistenciasPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerAsistenciasPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
