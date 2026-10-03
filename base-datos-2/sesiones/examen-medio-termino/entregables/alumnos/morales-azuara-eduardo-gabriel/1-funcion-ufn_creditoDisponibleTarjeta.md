# Examen de Medio Término — Ejercicio 1 de 3: `ufn_creditoDisponibleTarjeta`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Función escalar `ufn_creditoDisponibleTarjeta`
**Valor:** 20 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** saber cuánto crédito le queda disponible a una tarjeta, **para** responderle al cliente cuánto puede gastar todavía sin rebasar su límite.

## Contexto

El **crédito disponible** es lo que el cliente todavía puede gastar con su tarjeta: la diferencia entre lo que el banco le presta (`LimiteCredito`) y lo que ya debe (`SaldoActual`). Por ejemplo, una tarjeta con límite de 15,000.00 y saldo de 3,250.00 tiene 11,750.00 disponibles.

Hoy ese cálculo se hace a mano cada vez. Tu función lo resuelve en una sola llamada.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_creditoDisponibleTarjeta` que reciba el id de una tarjeta y regrese su crédito disponible.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Regresa:** `decimal(12,2)` — el crédito disponible de la tarjeta (`LimiteCredito − SaldoActual`).

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_creditoDisponibleTarjeta` y recibe `@p_idTarjeta int`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] El resultado es `LimiteCredito − SaldoActual` de la tarjeta indicada, tomando ambos valores de la tabla `Tarjeta`.
- [ ] Si la tarjeta está al tope de su límite, regresa `0.00`.
- [ ] Si el `idTarjeta` no existe, regresa `NULL` (no genera error).

## Ejemplo de salida esperada

| Tarjeta | LimiteCredito | SaldoActual | Resultado esperado |
|---|---|---|---|
| 1 | 15,000.00 | 3,250.00 | **11750.00** |
| 13 | 30,000.00 | 30,000.00 | **0.00** (está al tope) |
| 31 | 500,000.00 | 250,000.00 | **250000.00** |
| 9999 | — | — | **NULL** (no existe) |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT dbo.ufn_creditoDisponibleTarjeta(1) AS CreditoDisponible     -- esperado: 11750.00
SELECT dbo.ufn_creditoDisponibleTarjeta(13) AS CreditoDisponible    -- esperado: 0.00
SELECT dbo.ufn_creditoDisponibleTarjeta(31) AS CreditoDisponible    -- esperado: 250000.00
SELECT dbo.ufn_creditoDisponibleTarjeta(9999) AS CreditoDisponible  -- esperado: NULL
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 1**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
