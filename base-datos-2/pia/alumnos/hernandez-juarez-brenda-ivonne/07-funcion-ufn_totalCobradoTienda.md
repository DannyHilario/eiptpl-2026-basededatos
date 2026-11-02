# PIA CampoVerde — Objeto 07 de 11: `ufn_totalCobradoTienda`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Función escalar `ufn_totalCobradoTienda`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** saber cuánto se ha cobrado en total por cada casa de campaña, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una casa de campaña es la **suma de lo cobrado** en todas sus rentas: en cada una, el precio cobrado × noches, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La casa de campaña tiene rentas | La suma de lo cobrado |
| La casa de campaña existe pero no tiene rentas | `0.00` |
| La casa de campaña no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoTienda` que reciba el código de una casa de campaña y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CodigoTienda` | `varchar(10)` | Código de la casa de campaña |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoTienda` y recibe `@p_CodigoTienda varchar(10)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una casa de campaña con ese código, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada renta, no el precio actual), multiplicado por noches.
- [ ] Si la casa de campaña existe pero no tiene rentas, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCampista`](01-procedimiento-usp_insertarCampista.md), [`usp_insertarTienda`](03-procedimiento-usp_insertarTienda.md), [`usp_actualizarPrecioTipoTienda`](04-procedimiento-usp_actualizarPrecioTipoTienda.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: el campista de prueba
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'

-- Preparación: una casa de campaña nueva, 'T-20' (4 personas, $380.00)
EXEC usp_insertarTienda @p_NombreTipoTienda = '4 personas', @p_CodigoTienda = 'T-20', @p_FechaCompra = '2026-11-01'

-- Sin rentas: 0.00
SELECT dbo.ufn_totalCobradoTienda('T-20') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoTienda('NoExiste') AS TotalCobrado
EXEC usp_registrarRenta @p_CodigoTienda = 'T-20', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2
EXEC usp_registrarRenta @p_CodigoTienda = 'T-20', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-02', @p_Noches = 3

-- Dos rentas: 1900.00
SELECT dbo.ufn_totalCobradoTienda('T-20') AS TotalCobrado

-- Sube el precio a $460.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '4 personas', @p_PrecioNuevo = 460.00
EXEC usp_registrarRenta @p_CodigoTienda = 'T-20', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-03', @p_Noches = 1

-- Tres rentas: 2360.00
SELECT dbo.ufn_totalCobradoTienda('T-20') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'T-20' sin rentas | 0.00 |
| No existe | NULL |
| Con 2 rentas | 1900.00 |
| Con 3 rentas, una con el precio nuevo | 2360.00 |
