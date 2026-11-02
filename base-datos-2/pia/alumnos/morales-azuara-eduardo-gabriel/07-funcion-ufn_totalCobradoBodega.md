# PIA GuardaTodo — Objeto 07 de 11: `ufn_totalCobradoBodega`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Función escalar `ufn_totalCobradoBodega`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** saber cuánto se ha cobrado en total por cada bodega, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una bodega es la **suma de lo cobrado** en todas sus contratos: en cada uno, el precio cobrado × meses, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La bodega tiene contratos | La suma de lo cobrado |
| La bodega existe pero no tiene contratos | `0.00` |
| La bodega no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoBodega` que reciba el número de una bodega y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroBodega` | `varchar(10)` | Número de la bodega |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoBodega` y recibe `@p_NumeroBodega varchar(10)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una bodega con ese número, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada contrato, no el precio actual), multiplicado por meses.
- [ ] Si la bodega existe pero no tiene contratos, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarBodega`](03-procedimiento-usp_insertarBodega.md), [`usp_actualizarPrecioTipoBodega`](04-procedimiento-usp_actualizarPrecioTipoBodega.md), [`usp_registrarContrato`](05-procedimiento-usp_registrarContrato.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- Preparación: una bodega nueva, 'B-120' (Mediana, $1,500.00)
EXEC usp_insertarBodega @p_NombreTipoBodega = 'Mediana', @p_NumeroBodega = 'B-120', @p_FechaApertura = '2026-11-01'

-- Sin contratos: 0.00
SELECT dbo.ufn_totalCobradoBodega('B-120') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoBodega('NoExiste') AS TotalCobrado
EXEC usp_registrarContrato @p_NumeroBodega = 'B-120', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-01', @p_Meses = 2
EXEC usp_registrarContrato @p_NumeroBodega = 'B-120', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-02', @p_Meses = 3

-- Dos contratos: 7500.00
SELECT dbo.ufn_totalCobradoBodega('B-120') AS TotalCobrado

-- Sube el precio a $1,800.00 y se registra otro; los anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Mediana', @p_PrecioNuevo = 1800.00
EXEC usp_registrarContrato @p_NumeroBodega = 'B-120', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-03', @p_Meses = 1

-- Tres contratos: 9300.00
SELECT dbo.ufn_totalCobradoBodega('B-120') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'B-120' sin contratos | 0.00 |
| No existe | NULL |
| Con 2 contratos | 7500.00 |
| Con 3 contratos, uno con el precio nuevo | 9300.00 |
