# PIA RecorreMTY — Objeto 06 de 11: `usp_obtenerReservacionesPorFecha`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerReservacionesPorFecha`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** ver las reservaciones de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las reservaciones de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerReservacionesPorFecha` que valide el rango y regrese las reservaciones.

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
| `FechaRecorrido` | Fecha de la reservación |
| `Recorrido` | Recorrido |
| `Turista` | Nombre del turista |
| `Personas` | Personas |
| `PrecioCobrado` | Precio con el que se cobró la reservación |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerReservacionesPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaRecorrido` y, en un mismo día, por `Recorrido`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerReservacionesPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaRecorrido | Recorrido | Turista | Personas | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | Barrio Antiguo | Turista de Prueba | 3 | 250.00 |
| 2026-12-02 | Parque Fundidora | Turista de Prueba | 2 | 300.00 |
| 2026-12-02 | Paseo Santa Lucía | Turista de Prueba | 1 | 200.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md), [`usp_registrarReservacion`](05-procedimiento-usp_registrarReservacion.md).

```sql
-- Preparación: el turista de prueba y tres reservaciones de diciembre, registradas en desorden
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Parque Fundidora', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 2
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Barrio Antiguo', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 3
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Paseo Santa Lucía', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerReservacionesPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerReservacionesPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerReservacionesPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerReservacionesPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
