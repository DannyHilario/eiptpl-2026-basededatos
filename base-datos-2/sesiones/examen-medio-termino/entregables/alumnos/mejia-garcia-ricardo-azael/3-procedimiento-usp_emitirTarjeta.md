# Examen de Medio Término — Ejercicio 3 de 3: `usp_emitirTarjeta`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Procedimiento almacenado `usp_emitirTarjeta`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de crédito, **quiero** emitir una tarjeta nueva para un cliente, **para** darle un producto de crédito respetando las reglas del banco.

## Contexto

Emitir una tarjeta es dar de alta un renglón en `Tarjeta`. Antes, el banco revisa varias reglas de negocio:

- El cliente debe existir y estar activo.
- El producto (`TipoTarjetaCredito`) debe existir.
- Un cliente **no puede tener dos tarjetas del mismo producto** (README, *Tarjetas por cliente*).
- El límite de crédito debe estar **dentro del rango del producto**: entre su `LimiteCreditoMinimo` y su `LimiteCreditoMaximo` (incluidos ambos extremos). Por ejemplo, una Banquito Gold solo puede tener un límite de 30,000.00 a 100,000.00.
- El número de tarjeta no puede repetirse.

Una tarjeta nueva se emite hoy y vence en 5 años. Nace sin deuda y activa (`SaldoActual` y `Activo` tienen valores por defecto en la tabla).

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_emitirTarjeta` que valide las reglas de arriba y, si todo es correcto, inserte la tarjeta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente titular |
| `@p_idTipoTarjetaCredito` | `int` | Id del producto (1 Básica, 2 Gold, 3 Platinum) |
| `@p_NumeroTarjeta` | `char(16)` | Número de la tarjeta nueva (16 dígitos) |
| `@p_LimiteCredito` | `decimal(12,2)` | Límite de crédito a otorgar |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El cliente existe | `000001` | El cliente no existe |
| 2 | El cliente está activo (`Activo = 1`) | `000002` | El cliente está dado de baja |
| 3 | El producto existe | `000003` | El producto no existe |
| 4 | El cliente no tiene ya una tarjeta de ese producto | `000004` | El cliente ya tiene una tarjeta de ese producto |
| 5 | El límite está entre `LimiteCreditoMinimo` y `LimiteCreditoMaximo` del producto | `000005` | El límite de crédito está fuera del rango del producto |
| 6 | El número de tarjeta no existe ya en `Tarjeta` | `000006` | El número de tarjeta ya existe |
| 7 | Todo correcto | `000000` | Tarjeta emitida |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_emitirTarjeta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el cliente existe → `000001` *El cliente no existe*.
- [ ] Valida: el cliente está activo (`Activo = 1`) → `000002` *El cliente está dado de baja*.
- [ ] Valida: el producto existe → `000003` *El producto no existe*.
- [ ] Valida: el cliente no tiene ya una tarjeta de ese producto → `000004` *El cliente ya tiene una tarjeta de ese producto*.
- [ ] Valida: el límite está entre `LimiteCreditoMinimo` y `LimiteCreditoMaximo` del producto → `000005` *El límite de crédito está fuera del rango del producto*.
- [ ] Valida: el número de tarjeta no existe ya en `Tarjeta` → `000006` *El número de tarjeta ya existe*.
- [ ] Para la validación de rango, obtén `LimiteCreditoMinimo` y `LimiteCreditoMaximo` del producto en variables (puedes hacerlo en la misma consulta con la que validas que el producto existe).
- [ ] Si todo es correcto, inserta la tarjeta en `Tarjeta` con `FechaEmision = GETDATE()` y `FechaVencimiento = DATEADD(YEAR, 5, GETDATE())` (5 años después). `SaldoActual` y `Activo` toman su valor por defecto (`0` y `1`).
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tarjeta emitida'`.

## Ejemplo de salida esperada

`EXEC usp_emitirTarjeta @p_idCliente = 26, @p_idTipoTarjetaCredito = 1, @p_NumeroTarjeta = '1111000000000041', @p_LimiteCredito = 10000.00`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Tarjeta emitida |

Después, `SELECT * FROM Tarjeta WHERE idTarjeta = 41` muestra la tarjeta nueva de Andrea Gutiérrez (cliente 26), Banquito Básica, límite 10,000.00, saldo 0.00, activa, emitida hoy y con vencimiento dentro de 5 años.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: la clienta 26 no tiene tarjetas; Básica con límite 10,000 (rango 5,000 a 30,000)
EXEC usp_emitirTarjeta @p_idCliente = 26, @p_idTipoTarjetaCredito = 1, @p_NumeroTarjeta = '1111000000000041', @p_LimiteCredito = 10000.00
SELECT idTarjeta, idCliente, idTipoTarjetaCredito, NumeroTarjeta, FechaEmision,
    FechaVencimiento, LimiteCredito, SaldoActual, Activo
FROM Tarjeta
WHERE NumeroTarjeta = '1111000000000041'

-- 000001: el cliente no existe
EXEC usp_emitirTarjeta @p_idCliente = 9999, @p_idTipoTarjetaCredito = 1, @p_NumeroTarjeta = '1111000000000042', @p_LimiteCredito = 10000.00

-- 000002: cliente dado de baja (en los datos iniciales todos están activos; primero da de baja al 30)
UPDATE Cliente SET Activo = 0 WHERE idCliente = 30
EXEC usp_emitirTarjeta @p_idCliente = 30, @p_idTipoTarjetaCredito = 1, @p_NumeroTarjeta = '1111000000000042', @p_LimiteCredito = 10000.00

-- 000003: el producto no existe
EXEC usp_emitirTarjeta @p_idCliente = 26, @p_idTipoTarjetaCredito = 9, @p_NumeroTarjeta = '1111000000000042', @p_LimiteCredito = 10000.00

-- 000004: el cliente 1 ya tiene una Banquito Básica (tarjeta 1)
EXEC usp_emitirTarjeta @p_idCliente = 1, @p_idTipoTarjetaCredito = 1, @p_NumeroTarjeta = '1111000000000042', @p_LimiteCredito = 10000.00

-- 000005: Gold con límite de 150,000 (el rango de Gold es 30,000 a 100,000)
EXEC usp_emitirTarjeta @p_idCliente = 26, @p_idTipoTarjetaCredito = 2, @p_NumeroTarjeta = '2222000000000042', @p_LimiteCredito = 150000.00

-- 000006: el número 1111000000000001 ya es de la tarjeta 1
EXEC usp_emitirTarjeta @p_idCliente = 26, @p_idTipoTarjetaCredito = 2, @p_NumeroTarjeta = '1111000000000001', @p_LimiteCredito = 50000.00
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_MejiaGarciaRicardoAzael_2253586_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
