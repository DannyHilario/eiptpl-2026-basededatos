# Examen de Medio Término — Ejercicio 1 de 3: `ufn_totalCargosTarjeta`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Función escalar `ufn_totalCargosTarjeta`
**Valor:** 20 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** analista de crédito, **quiero** conocer el total de cargos que ha tenido una tarjeta, **para** saber cuánto ha usado el cliente su crédito a lo largo del tiempo.

## Contexto

Cada movimiento de una tarjeta es un **cargo** (el cliente usa el crédito y le debe más al banco: compra, disposición de efectivo, anualidad) o un **abono** (el cliente le paga al banco y le debe menos: pago, devolución). Lo que distingue a uno de otro es la columna `TipoMovimiento.EsCargo`: `1` para cargos y `0` para abonos.

Tu función suma solo los cargos de una tarjeta. Para saber si un movimiento es cargo necesitas cruzar `Movimiento` con `TipoMovimiento`.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCargosTarjeta` que reciba el id de una tarjeta y regrese la suma del `Monto` de todos sus movimientos que sean cargo.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Regresa:** `decimal(12,2)` — la suma de los montos de los cargos de la tarjeta.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCargosTarjeta` y recibe `@p_idTarjeta int`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Usa `INNER JOIN` entre `Movimiento` y `TipoMovimiento` y suma (`SUM`) solo los movimientos con `EsCargo = 1`.
- [ ] Si la tarjeta no tiene cargos, o no tiene movimientos, regresa `0.00` (no `NULL`; usa `ISNULL`).
- [ ] Si el `idTarjeta` no existe, regresa `0.00` (no genera error).

## Ejemplo de salida esperada

| Tarjeta | Sus movimientos | Resultado esperado |
|---|---|---|
| 31 | 6 cargos y 1 pago | **253199.68** (el pago de 3,199.68 no se suma) |
| 1 | 3 cargos y 1 abono | **3331.69** |
| 7 | No tiene movimientos | **0.00** |
| 9999 | No existe | **0.00** |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT dbo.ufn_totalCargosTarjeta(31) AS TotalCargos    -- esperado: 253199.68
SELECT dbo.ufn_totalCargosTarjeta(1) AS TotalCargos     -- esperado: 3331.69
SELECT dbo.ufn_totalCargosTarjeta(7) AS TotalCargos     -- esperado: 0.00
SELECT dbo.ufn_totalCargosTarjeta(9999) AS TotalCargos  -- esperado: 0.00

-- Para comprobar: los movimientos de la tarjeta 31 con su tipo
SELECT M.idMovimiento, TM.Nombre, TM.EsCargo, M.Monto
FROM Movimiento M
INNER JOIN TipoMovimiento TM ON TM.idTipoMovimiento = M.idTipoMovimiento
WHERE M.idTarjeta = 31
```

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_EspinozaJuarezAngelDeJesus_2253562_Ejercicio1.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 1 | Funciones*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
