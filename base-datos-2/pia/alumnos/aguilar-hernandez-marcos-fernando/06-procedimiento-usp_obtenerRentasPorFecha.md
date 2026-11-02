# PIA BiciRuta — Objeto 06 de 11: `usp_obtenerRentasPorFecha`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerRentasPorFecha`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** ver las rentas de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las rentas de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerRentasPorFecha` que valide el rango y regrese las rentas.

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
| `FechaRenta` | Fecha de la renta |
| `NumeroSerie` | Bicicleta |
| `Cliente` | Nombre del cliente |
| `Horas` | Horas |
| `PrecioCobrado` | Precio con el que se cobró la renta |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerRentasPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaRenta` y, en un mismo día, por `NumeroSerie`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerRentasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaRenta | NumeroSerie | Cliente | Horas | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | MT-0007 | Cliente de Prueba | 3 | 60.00 |
| 2026-12-02 | EL-0001 | Cliente de Prueba | 2 | 95.00 |
| 2026-12-02 | UR-0001 | Cliente de Prueba | 1 | 45.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: el cliente de prueba y tres rentas de diciembre, registradas en desorden
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'
EXEC usp_registrarRenta @p_NumeroSerie = 'EL-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 2
EXEC usp_registrarRenta @p_NumeroSerie = 'MT-0007', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 3
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerRentasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerRentasPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerRentasPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerRentasPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
