# PIA StrikeMax — Objeto 07 de 11: `ufn_totalCobradoPista`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Función escalar `ufn_totalCobradoPista`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** saber cuánto se ha cobrado en total por cada pista, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una pista es la **suma de lo cobrado** en todas sus juegos: en cada uno, el precio cobrado × líneas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La pista tiene juegos | La suma de lo cobrado |
| La pista existe pero no tiene juegos | `0.00` |
| La pista no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoPista` que reciba el número de una pista y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NumeroPista` | `int` | Número de la pista |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoPista` y recibe `@p_NumeroPista int`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una pista con ese número, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada juego, no el precio actual), multiplicado por líneas.
- [ ] Si la pista existe pero no tiene juegos, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarPista`](03-procedimiento-usp_insertarPista.md), [`usp_actualizarTarifaTipoPista`](04-procedimiento-usp_actualizarTarifaTipoPista.md), [`usp_registrarJuego`](05-procedimiento-usp_registrarJuego.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'

-- Preparación: una pista nueva, 20 (Infantil, $70.00)
EXEC usp_insertarPista @p_NombreTipoPista = 'Infantil', @p_NumeroPista = 20, @p_FechaInstalacion = '2026-11-01'

-- Sin juegos: 0.00
SELECT dbo.ufn_totalCobradoPista(20) AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoPista(999) AS TotalCobrado
EXEC usp_registrarJuego @p_NumeroPista = 20, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 2
EXEC usp_registrarJuego @p_NumeroPista = 20, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-02', @p_Lineas = 3

-- Dos juegos: 350.00
SELECT dbo.ufn_totalCobradoPista(20) AS TotalCobrado

-- Sube el precio a $80.00 y se registra otro; los anteriores conservan lo que se cobró
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'Infantil', @p_PrecioNuevo = 80.00
EXEC usp_registrarJuego @p_NumeroPista = 20, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-03', @p_Lineas = 1

-- Tres juegos: 430.00
SELECT dbo.ufn_totalCobradoPista(20) AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 20 sin juegos | 0.00 |
| No existe | NULL |
| Con 2 juegos | 350.00 |
| Con 3 juegos, uno con el precio nuevo | 430.00 |
