# PIA RutaNorte — Objeto 06 de 11: `usp_obtenerBoletosPorFecha`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerBoletosPorFecha`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** ver los boletos de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa los boletos de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerBoletosPorFecha` que valide el rango y regrese los boletos.

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
| `FechaViaje` | Fecha del boleto |
| `ClaveRuta` | Ruta |
| `Pasajero` | Nombre del pasajero |
| `Asiento` | Asiento |
| `PrecioCobrado` | Precio con el que se cobró el boleto |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerBoletosPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaViaje` y, en un mismo día, por `ClaveRuta`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerBoletosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaViaje | ClaveRuta | Pasajero | Asiento | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | MTY-SAL | Pasajero de Prueba | 20 | 180.00 |
| 2026-12-02 | MTY-NLD | Pasajero de Prueba | 12 | 450.00 |
| 2026-12-02 | MTY-REY | Pasajero de Prueba | 5 | 420.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md), [`usp_registrarBoleto`](05-procedimiento-usp_registrarBoleto.md).

```sql
-- Preparación: el pasajero de prueba y tres boletos de diciembre, registrados en desorden
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-NLD', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 12
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 20
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-REY', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 5

-- Todo diciembre: 3 filas
EXEC usp_obtenerBoletosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerBoletosPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerBoletosPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerBoletosPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
