# PIA GuardaTodo — Objeto 09 de 11: `vw_DetalleContrato`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Vista `vw_DetalleContrato`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** ver cada contrato completo con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratos o más caros que el precio actual.

## Contexto

Cada contrato guarda el **precio cobrado**, y el tipo de bodega tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleContrato` que muestre **todos** los contratos con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaInicio` | Fecha del contrato |
| `NumeroBodega` | Número de bodega |
| `TipoBodega` | Nombre del tipo de bodega |
| `Cliente` | Nombre del cliente |
| `Meses` | Meses |
| `PrecioCobrado` | Precio que guarda el contrato |
| `PrecioActual` | Precio actual del tipo de bodega |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleContrato`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de contratos con bodegas, tipos de bodega y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por contrato**: el número de filas de la vista es igual al de tu tabla de contratos.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleContrato WHERE FechaInicio >= '2026-12-01' ORDER BY FechaInicio`, después de la preparación de los casos de prueba:

| FechaInicio | NumeroBodega | TipoBodega | Cliente | Meses | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | B-104 | Grande | Cliente de Prueba | 2 | 2400.00 | 2640.00 | Subió |
| 2026-12-02 | B-104 | Grande | Cliente de Prueba | 3 | 2880.00 | 2640.00 | Bajó |
| 2026-12-03 | B-104 | Grande | Cliente de Prueba | 1 | 2640.00 | 2640.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarPrecioTipoBodega`](04-procedimiento-usp_actualizarPrecioTipoBodega.md), [`usp_registrarContrato`](05-procedimiento-usp_registrarContrato.md).

```sql
-- Preparación: tres contratos de 'B-104', cada uno con un precio distinto
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'
EXEC usp_registrarContrato @p_NumeroBodega = 'B-104', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-01', @p_Meses = 2
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Grande', @p_PrecioNuevo = 2880.00
EXEC usp_registrarContrato @p_NumeroBodega = 'B-104', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-02', @p_Meses = 3
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Grande', @p_PrecioNuevo = 2640.00
EXEC usp_registrarContrato @p_NumeroBodega = 'B-104', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-03', @p_Meses = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleContrato WHERE FechaInicio >= '2026-12-01' ORDER BY FechaInicio

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleContrato
SELECT COUNT(*) AS Total FROM <TuTablaDeContratos>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus contratos más las 3 de prueba |
| Tus contratos inventados | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
