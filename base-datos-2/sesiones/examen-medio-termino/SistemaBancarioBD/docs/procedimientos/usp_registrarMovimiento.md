# `usp_registrarMovimiento`

Script: [`instalacion/06-Movimiento/03-usp-registrar.sql`](../../instalacion/06-Movimiento/03-usp-registrar.sql)

**Este es el SP que debe usarse para registrar cualquier movimiento de una tarjeta.** Nunca se debe hacer un `INSERT` directo en `Movimiento`: el SP es el único que, además de guardar el movimiento, actualiza el saldo de la tarjeta.

---

## En palabras simples

Cada vez que un cliente usa su tarjeta (compra algo, retira efectivo, le cobran la anualidad) o la paga (hace un pago, recibe una devolución), el banco tiene que hacer **dos cosas**:

1. **Anotar el movimiento** en `Movimiento`: qué tarjeta, qué tipo de movimiento, cuánto, cuándo y dónde.
2. **Actualizar lo que debe el cliente** en `Tarjeta.SaldoActual`: subirlo si fue un cargo o bajarlo si fue un abono.

> Recordatorio: el **saldo** es lo que el cliente le debe al banco. Un **cargo** (compra) hace que le deba más y el saldo sube; un **abono** (pago) hace que le deba menos y el saldo baja. Ver [Conceptos básicos: saldo, cargo y abono](../../../README.md#conceptos-básicos-saldo-cargo-y-abono) en el README.

Si solo se hace la primera y se olvida la segunda, la tarjeta queda con un saldo que ya no corresponde a sus movimientos. Este SP hace las dos cosas en una sola llamada, para que nunca quede una sin la otra.

Antes de registrar nada, el SP revisa que el movimiento tenga sentido. Por ejemplo, no se puede comprar con una tarjeta cancelada, no se puede gastar más del crédito disponible y no se puede pagar más de lo que se debe.

---

## Por qué existe este SP

En `SistemaBancarioBD` el saldo de cada tarjeta se guarda en una columna (`Tarjeta.SaldoActual`) y no se calcula al momento. Esa columna debe ser siempre igual a:

> **SaldoActual = suma de cargos − suma de abonos** (de todos los movimientos de la tarjeta)

En los datos iniciales esa igualdad se cumple para las 40 tarjetas. La única forma de que se siga cumpliendo después de agregar movimientos es que **todos** se registren con este SP. Un `INSERT INTO Movimiento` hecho a mano agrega el movimiento pero no toca `SaldoActual`, y la tarjeta queda desfasada.

---

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta afectada |
| `@p_idTipoMovimiento` | `int` | Id del tipo de movimiento (ver tabla abajo) |
| `@p_Monto` | `decimal(12,2)` | Importe del movimiento, **siempre positivo**. El SP decide si suma o resta según el tipo |
| `@p_Descripcion` | `varchar(100)` | Dónde o cómo se hizo el movimiento (`Supermercado`, `Pago en línea`, `Retiro en cajero`, …) |

La fecha **no** es un parámetro: el SP usa `GETDATE()`, es decir, el movimiento queda registrado con la fecha y hora en que se ejecuta el SP.

### Tipos de movimiento disponibles

| `@p_idTipoMovimiento` | Nombre | `EsCargo` | Efecto en `SaldoActual` |
|---|---|---|---|
| 1 | Compra | 1 | Suma el monto |
| 2 | Disposición de efectivo | 1 | Suma el monto |
| 3 | Anualidad | 1 | Suma el monto |
| 4 | Pago | 0 | Resta el monto |
| 5 | Devolución | 0 | Resta el monto |

---

## Validaciones (orden en que se evalúan)

El SP revisa las validaciones **una por una, en este orden**. En cuanto una falla, regresa su código de error y **termina sin modificar nada**: no inserta el movimiento ni cambia el saldo. Si un movimiento tiene varios problemas a la vez, solo se reporta el primero de la lista.

### 1. La tarjeta debe existir

Busca la tarjeta en `Tarjeta` y guarda en variables su `Activo`, `FechaVencimiento`, `LimiteCredito` y `SaldoActual`, porque las siguientes validaciones los necesitan. Si no encuentra la tarjeta, las variables se quedan en `NULL`.

```sql
SELECT @ActivoTarjeta = Activo,
	@FechaVencimiento = FechaVencimiento,
	@LimiteCredito = LimiteCredito,
	@SaldoActual = SaldoActual
FROM Tarjeta
WHERE idTarjeta = @p_idTarjeta

IF @ActivoTarjeta IS NULL BEGIN
	-- 000001 La tarjeta no existe
```

### 2. La tarjeta no debe estar cancelada

Una tarjeta cancelada tiene `Activo = 0`. Ya no se puede usar ni para cargos ni para abonos.

### 3. La tarjeta no debe estar vencida

Una tarjeta está vencida cuando su `FechaVencimiento` es anterior a la fecha de hoy. La comparación es contra la **fecha sin hora** (`CAST(GETDATE() AS date)`), así que una tarjeta que vence hoy todavía se puede usar durante todo el día.

Estas dos validaciones aplican la regla de [Estado de una tarjeta](../../../README.md#estado-de-una-tarjeta) del README: **solo se registran movimientos en tarjetas vigentes**.

### 4. El tipo de movimiento debe existir

Busca el tipo en `TipoMovimiento` y guarda su `EsCargo` en una variable. Ese valor se usa más adelante para decidir si el saldo sube o baja.

### 5. El monto debe ser mayor a cero

El monto siempre se envía en positivo, también para pagos y devoluciones: el signo lo pone el tipo de movimiento, no el monto. Un monto de `0`, negativo o `NULL` se rechaza.

### 6. Si es cargo: no debe exceder el crédito disponible

El **crédito disponible** es lo que le queda por gastar al cliente: `LimiteCredito − SaldoActual`. Un cargo se rechaza si, después de aplicarlo, el saldo quedaría por encima del límite:

```sql
IF @EsCargo = 1 AND @SaldoActual + @p_Monto > @LimiteCredito BEGIN
	-- 000006 El cargo excede el crédito disponible
```

Un cargo que deja el saldo **exactamente** en el límite sí se permite.

### 7. Si es abono: no debe ser mayor que el saldo

No se puede pagar más de lo que se debe, porque el saldo quedaría negativo:

```sql
IF @EsCargo = 0 AND @p_Monto > @SaldoActual BEGIN
	-- 000007 El abono es mayor que el saldo de la tarjeta
```

Un abono por el saldo **exacto** sí se permite: la tarjeta queda en `0` (liquidada).

---

## Qué hace, en orden

1. Corre las 7 validaciones de arriba (con `RETURN` si alguna falla).
2. Inserta el movimiento en `Movimiento`, con `FechaMovimiento = GETDATE()`:

   ```sql
   INSERT INTO Movimiento (idTarjeta, idTipoMovimiento, Monto, FechaMovimiento, Descripcion)
   VALUES (@p_idTarjeta, @p_idTipoMovimiento, @p_Monto, GETDATE(), @p_Descripcion)
   ```

3. Actualiza el saldo de la tarjeta. Usa un `IF` sobre `EsCargo` para elegir entre sumar o restar:

   ```sql
   IF @EsCargo = 1 BEGIN
   	UPDATE Tarjeta
   	SET
   		SaldoActual = SaldoActual + @p_Monto,
   		FechaUltimaModificacion = GETDATE()
   	WHERE idTarjeta = @p_idTarjeta
   END
   ELSE BEGIN
   	UPDATE Tarjeta
   	SET
   		SaldoActual = SaldoActual - @p_Monto,
   		FechaUltimaModificacion = GETDATE()
   	WHERE idTarjeta = @p_idTarjeta
   END
   ```

4. Regresa el código `000000`.

---

## Códigos de salida

El SP siempre regresa un renglón con dos columnas: `ErrCodigo` y `ErrMensaje`.

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La tarjeta no existe | `idTarjeta` inválido |
| `000002` | La tarjeta está cancelada | `Tarjeta.Activo = 0` |
| `000003` | La tarjeta está vencida | `Tarjeta.FechaVencimiento` anterior a la fecha de hoy |
| `000004` | El tipo de movimiento no existe | `idTipoMovimiento` inválido |
| `000005` | El monto debe ser mayor a cero | `@p_Monto` es `0`, negativo o `NULL` |
| `000006` | El cargo excede el crédito disponible | Es cargo y `SaldoActual + Monto > LimiteCredito` |
| `000007` | El abono es mayor que el saldo de la tarjeta | Es abono y `Monto > SaldoActual` |
| `000000` | Movimiento registrado | Éxito: se insertó el movimiento y se actualizó el saldo |

---

## Ejemplos de uso

Un ejemplo por cada tipo de movimiento, todos sobre tarjetas vigentes de los datos iniciales:

```sql
-- Compra de 850.00 en un supermercado con la tarjeta 1
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 1, @p_Monto = 850.00, @p_Descripcion = 'Supermercado'

-- Retiro de 2,000.00 en cajero (disposición de efectivo) con la tarjeta 5
EXEC usp_registrarMovimiento @p_idTarjeta = 5, @p_idTipoMovimiento = 2, @p_Monto = 2000.00, @p_Descripcion = 'Retiro en cajero'

-- Cobro de la anualidad de una tarjeta Gold (1,200.00) a la tarjeta 2
EXEC usp_registrarMovimiento @p_idTarjeta = 2, @p_idTipoMovimiento = 3, @p_Monto = 1200.00, @p_Descripcion = 'Cobro de anualidad 2026'

-- Pago de 1,000.00 en línea a la tarjeta 1
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = 1000.00, @p_Descripcion = 'Pago en línea'

-- Devolución de 300.00 de una compra a la tarjeta 1
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 5, @p_Monto = 300.00, @p_Descripcion = 'Devolución de compra'
```

> El SP no valida que el monto de una **anualidad** sea igual a `TipoTarjetaCredito.Anualidad` ni que la descripción tenga un formato particular. Se registra lo que se envía en los parámetros.

---

## Ejemplo paso a paso: la tarjeta 1 durante un día

La tarjeta 1 es una Banquito Básica de Carlos García, con **límite de 15,000.00** y **saldo inicial de 3,250.00** (crédito disponible: 11,750.00). Esta es la secuencia de llamadas y cómo cambia el saldo después de cada una:

| # | Llamada | Resultado | `SaldoActual` después | Crédito disponible |
|---|---------|-----------|----------------------|--------------------|
| — | *(datos iniciales)* | — | 3,250.00 | 11,750.00 |
| 1 | Compra de 500.00 | `000000` | 3,750.00 | 11,250.00 |
| 2 | Pago de 750.00 | `000000` | 3,000.00 | 12,000.00 |
| 3 | Compra de 12,000.01 | `000006` (excede por 0.01) | 3,000.00 *(sin cambio)* | 12,000.00 |
| 4 | Retiro de 12,000.00 | `000000` (llega justo al límite) | 15,000.00 | 0.00 |
| 5 | Compra de 1.00 | `000006` (ya no hay crédito) | 15,000.00 *(sin cambio)* | 0.00 |
| 6 | Pago de 15,000.00 | `000000` (liquida la tarjeta) | 0.00 | 15,000.00 |
| 7 | Pago de 1.00 | `000007` (no hay nada que pagar) | 0.00 *(sin cambio)* | 15,000.00 |

```sql
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 1, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = 750.00, @p_Descripcion = 'Pago en línea'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 1, @p_Monto = 12000.01, @p_Descripcion = 'Tienda departamental'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 2, @p_Monto = 12000.00, @p_Descripcion = 'Retiro en cajero'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 1, @p_Monto = 1.00, @p_Descripcion = 'Farmacia'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = 15000.00, @p_Descripcion = 'Pago en sucursal'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = 1.00, @p_Descripcion = 'Pago en línea'
```

De las 7 llamadas, solo las 4 exitosas (1, 2, 4 y 6) aparecen como renglones nuevos en `Movimiento`. Las que regresaron error no dejaron rastro.

---

## Casos de prueba sugeridos

Cada caso usa una tarjeta de los datos iniciales que cumple justo la condición a probar.

### Errores (no deben modificar nada)

```sql
-- 000001 La tarjeta no existe
EXEC usp_registrarMovimiento @p_idTarjeta = 9999, @p_idTipoMovimiento = 1, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'

-- 000002 La tarjeta está cancelada (la tarjeta 6 tiene Activo = 0)
EXEC usp_registrarMovimiento @p_idTarjeta = 6, @p_idTipoMovimiento = 1, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'

-- 000003 La tarjeta está vencida (la tarjeta 3 venció el 2026-02-15)
EXEC usp_registrarMovimiento @p_idTarjeta = 3, @p_idTipoMovimiento = 1, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'

-- 000004 El tipo de movimiento no existe
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 99, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'

-- 000005 El monto debe ser mayor a cero (monto cero y monto negativo)
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 1, @p_Monto = 0, @p_Descripcion = 'Supermercado'
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = -100.00, @p_Descripcion = 'Pago en línea'

-- 000006 El cargo excede el crédito disponible (la tarjeta 13 está al tope: 30,000.00 de 30,000.00)
EXEC usp_registrarMovimiento @p_idTarjeta = 13, @p_idTipoMovimiento = 1, @p_Monto = 100.00, @p_Descripcion = 'Supermercado'

-- 000007 El abono es mayor que el saldo (la tarjeta 7 tiene saldo 0)
EXEC usp_registrarMovimiento @p_idTarjeta = 7, @p_idTipoMovimiento = 4, @p_Monto = 100.00, @p_Descripcion = 'Pago en línea'

-- Orden de las validaciones: tarjeta cancelada Y tipo inexistente => solo se reporta 000002
EXEC usp_registrarMovimiento @p_idTarjeta = 6, @p_idTipoMovimiento = 99, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'
```

Para confirmar que un error no modificó nada, revisar que la tarjeta conserve su saldo y que no haya movimientos nuevos:

```sql
SELECT idTarjeta, SaldoActual, FechaUltimaModificacion
FROM Tarjeta
WHERE idTarjeta = 13

SELECT idMovimiento, idTarjeta, idTipoMovimiento, Monto, FechaMovimiento
FROM Movimiento
WHERE idTarjeta = 13
ORDER BY FechaMovimiento DESC
```

### Éxito (deben insertar el movimiento y actualizar el saldo)

```sql
-- Cargo: compra de 500.00 con la tarjeta 1 (saldo 3,250.00 -> 3,750.00)
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 1, @p_Monto = 500.00, @p_Descripcion = 'Supermercado'

-- Abono: pago de 750.00 a la tarjeta 1 (saldo 3,750.00 -> 3,000.00)
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = 750.00, @p_Descripcion = 'Pago en línea'

-- Cargo que deja el saldo exactamente en el límite (tarjeta 1: 3,000.00 + 12,000.00 = 15,000.00)
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 2, @p_Monto = 12000.00, @p_Descripcion = 'Retiro en cajero'

-- Abono que liquida el saldo completo (tarjeta 1: 15,000.00 -> 0.00)
EXEC usp_registrarMovimiento @p_idTarjeta = 1, @p_idTipoMovimiento = 4, @p_Monto = 15000.00, @p_Descripcion = 'Pago en sucursal'
```

Después de cada caso exitoso:

```sql
-- El movimiento nuevo debe aparecer al principio
SELECT TOP 5 idMovimiento, idTipoMovimiento, Monto, FechaMovimiento, Descripcion
FROM Movimiento
WHERE idTarjeta = 1
ORDER BY idMovimiento DESC

-- El saldo debe haber cambiado por el monto del movimiento
SELECT idTarjeta, LimiteCredito, SaldoActual, FechaUltimaModificacion
FROM Tarjeta
WHERE idTarjeta = 1
```

---

## Cómo verificar que el saldo sigue cuadrando

Para una tarjeta, se suman por separado sus cargos y sus abonos. La resta de ambos debe ser igual a su `SaldoActual`:

```sql
-- Suma de cargos de la tarjeta 1
SELECT SUM(X.Monto) AS TotalCargos
FROM Movimiento X
INNER JOIN TipoMovimiento TT ON TT.idTipoMovimiento = X.idTipoMovimiento
WHERE X.idTarjeta = 1 AND TT.EsCargo = 1

-- Suma de abonos de la tarjeta 1
SELECT SUM(X.Monto) AS TotalAbonos
FROM Movimiento X
INNER JOIN TipoMovimiento TT ON TT.idTipoMovimiento = X.idTipoMovimiento
WHERE X.idTarjeta = 1 AND TT.EsCargo = 0

-- Saldo guardado en la tarjeta: debe ser TotalCargos - TotalAbonos
SELECT SaldoActual
FROM Tarjeta
WHERE idTarjeta = 1
```

Si en algún momento no cuadra, casi siempre es porque alguien insertó un movimiento directo en `Movimiento` sin usar este SP.

---

## Consideraciones

- **La fecha y hora son las del servidor.** `FechaMovimiento` toma el valor de `GETDATE()` en el servidor de base de datos. En la instancia del curso (AWS RDS) el servidor está en hora UTC, seis horas adelante de la hora de Monterrey: una compra hecha a las 9:00 pm de Monterrey queda registrada a las 3:00 am del día siguiente.
- **La validación de vencimiento también usa la fecha del servidor.** Por la misma razón, cerca de la medianoche puede haber una diferencia de un día respecto a la fecha local.
- **No se valida la descripción.** Se guarda tal cual se envía (máximo 100 caracteres).
- **No se valida el monto de la anualidad** contra `TipoTarjetaCredito.Anualidad`.

---

## Instalación

El SP se crea después de las tablas `Tarjeta`, `TipoMovimiento` y `Movimiento`, en la carpeta `06-Movimiento`. Ya está incluido en [`instalar-completo.sql`](../../instalar-completo.sql).

El script usa `GO` después de `USE SistemaBancarioBD;` porque `CREATE PROCEDURE` debe ser la primera sentencia de su lote.

Para modificarlo después de instalado, cambiar `CREATE PROCEDURE` por `ALTER PROCEDURE` y volver a ejecutar el script.

Los casos de prueba de éxito **modifican los datos** (agregan movimientos y cambian saldos). Para regresar a los datos iniciales, ejecutar la [reversa](../../reversa) y luego volver a instalar con `instalar-completo.sql`.
