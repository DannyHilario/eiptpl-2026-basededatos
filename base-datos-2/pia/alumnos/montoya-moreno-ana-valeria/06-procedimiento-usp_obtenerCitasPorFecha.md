# PIA SpaZen — Objeto 06 de 11: `usp_obtenerCitasPorFecha`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerCitasPorFecha`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** ver las citas de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las citas de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerCitasPorFecha` que valide el rango y regrese las citas.

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
| `FechaCita` | Fecha de la cita |
| `Servicio` | Servicio |
| `Cliente` | Nombre del cliente |
| `Calificacion` | Calificación |
| `PrecioCobrado` | Precio con el que se cobró la cita |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerCitasPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaCita` y, en un mismo día, por `Servicio`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerCitasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaCita | Servicio | Cliente | Calificacion | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | Masaje relajante | Cliente de Prueba | 4 | 750.00 |
| 2026-12-02 | Facial hidratante | Cliente de Prueba | 5 | 600.00 |
| 2026-12-02 | Masaje con piedras calientes | Cliente de Prueba | 3 | 1100.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarCita`](05-procedimiento-usp_registrarCita.md).

```sql
-- Preparación: el cliente de prueba y tres citas de diciembre, registradas en desorden
EXEC usp_insertarCliente @p_NombreZona = 'Norte', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarCita @p_NombreServicio = 'Facial hidratante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 5
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 4
EXEC usp_registrarCita @p_NombreServicio = 'Masaje con piedras calientes', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 3

-- Todo diciembre: 3 filas
EXEC usp_obtenerCitasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerCitasPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerCitasPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerCitasPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
