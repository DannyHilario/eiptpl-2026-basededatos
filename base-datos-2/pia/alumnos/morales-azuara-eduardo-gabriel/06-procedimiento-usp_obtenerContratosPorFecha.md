# PIA GuardaTodo — Objeto 06 de 11: `usp_obtenerContratosPorFecha`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerContratosPorFecha`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** ver los contratos de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa los contratos de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerContratosPorFecha` que valide el rango y regrese los contratos.

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
| `FechaInicio` | Fecha del contrato |
| `NumeroBodega` | Bodega |
| `Cliente` | Nombre del cliente |
| `Meses` | Meses |
| `PrecioCobrado` | Precio con el que se cobró el contrato |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerContratosPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaInicio` y, en un mismo día, por `NumeroBodega`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerContratosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaInicio | NumeroBodega | Cliente | Meses | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | B-103 | Cliente de Prueba | 3 | 1500.00 |
| 2026-12-02 | B-101 | Cliente de Prueba | 1 | 900.00 |
| 2026-12-02 | B-104 | Cliente de Prueba | 2 | 2400.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarContrato`](05-procedimiento-usp_registrarContrato.md).

```sql
-- Preparación: el cliente de prueba y tres contratos de diciembre, registrados en desorden
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'
EXEC usp_registrarContrato @p_NumeroBodega = 'B-104', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-02', @p_Meses = 2
EXEC usp_registrarContrato @p_NumeroBodega = 'B-103', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-01', @p_Meses = 3
EXEC usp_registrarContrato @p_NumeroBodega = 'B-101', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-02', @p_Meses = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerContratosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerContratosPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerContratosPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerContratosPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
