# PIA BiciRuta — Objeto 07 de 11: `ufn_totalCobradoBicicleta`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Función escalar `ufn_totalCobradoBicicleta`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** saber cuánto se ha cobrado en total por cada bicicleta, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una bicicleta es la **suma de lo cobrado** en todas sus rentas: en cada una, el precio cobrado × horas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La bicicleta tiene rentas | La suma de lo cobrado |
| La bicicleta existe pero no tiene rentas | `0.00` |
| La bicicleta no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoBicicleta` que reciba el número de serie de una bicicleta y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroSerie` | `varchar(20)` | Número de serie de la bicicleta |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoBicicleta` y recibe `@p_NumeroSerie varchar(20)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una bicicleta con ese número de serie, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada renta, no el precio actual), multiplicado por horas.
- [ ] Si la bicicleta existe pero no tiene rentas, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarBicicleta`](03-procedimiento-usp_insertarBicicleta.md), [`usp_actualizarTarifaTipoBicicleta`](04-procedimiento-usp_actualizarTarifaTipoBicicleta.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- Preparación: una bicicleta nueva, 'UR-0020' (Montaña, $60.00)
EXEC usp_insertarBicicleta @p_NombreTipoBicicleta = 'Montaña', @p_NumeroSerie = 'UR-0020', @p_FechaAlta = '2026-11-01'

-- Sin rentas: 0.00
SELECT dbo.ufn_totalCobradoBicicleta('UR-0020') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoBicicleta('NoExiste') AS TotalCobrado
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0020', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0020', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 3

-- Dos rentas: 300.00
SELECT dbo.ufn_totalCobradoBicicleta('UR-0020') AS TotalCobrado

-- Sube el precio a $70.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarTarifaTipoBicicleta @p_NombreTipoBicicleta = 'Montaña', @p_PrecioNuevo = 70.00
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0020', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-03', @p_Horas = 1

-- Tres rentas: 370.00
SELECT dbo.ufn_totalCobradoBicicleta('UR-0020') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'UR-0020' sin rentas | 0.00 |
| No existe | NULL |
| Con 2 rentas | 300.00 |
| Con 3 rentas, una con el precio nuevo | 370.00 |
