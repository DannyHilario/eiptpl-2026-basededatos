# Examen de Medio Término — Ejercicio 3 de 3: `usp_actualizarLimiteCredito`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarLimiteCredito`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** analista de crédito, **quiero** cambiar el límite de crédito de una tarjeta, **para** aumentarlo o reducirlo según el historial del cliente, sin romper las reglas del producto.

## Contexto

Cambiar el límite de una tarjeta es actualizar `Tarjeta.LimiteCredito`. Solo se permite si:

- La tarjeta existe, no está cancelada (`Activo = 0`) y no está vencida (`FechaVencimiento` anterior a hoy).
- El límite nuevo está **dentro del rango de su producto** (`LimiteCreditoMinimo` a `LimiteCreditoMaximo` de `TipoTarjetaCredito`, incluidos los extremos).
- El límite nuevo **no es menor que lo que ya debe** el cliente (`SaldoActual`). Si la tarjeta debe 30,000.00, no se le puede bajar el límite a 25,000.00.

Para la validación del rango necesitas el producto de la tarjeta: cruza `Tarjeta` con `TipoTarjetaCredito`.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarLimiteCredito` que valide las reglas de arriba y, si todo es correcto, actualice el límite.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |
| `@p_LimiteNuevo` | `decimal(12,2)` | Límite de crédito nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La tarjeta existe | `000001` | La tarjeta no existe |
| 2 | La tarjeta no está cancelada (`Activo = 1`) | `000002` | La tarjeta está cancelada |
| 3 | La tarjeta no está vencida (`FechaVencimiento` ≥ `CAST(GETDATE() AS date)`) | `000003` | La tarjeta está vencida |
| 4 | El límite nuevo está dentro del rango del producto de la tarjeta | `000004` | El límite nuevo está fuera del rango del producto |
| 5 | El límite nuevo es mayor o igual al `SaldoActual` | `000005` | El límite nuevo es menor que el saldo actual |
| 6 | Todo correcto | `000000` | Límite actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarLimiteCredito` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la tarjeta existe → `000001` *La tarjeta no existe*.
- [ ] Valida: la tarjeta no está cancelada (`Activo = 1`) → `000002` *La tarjeta está cancelada*.
- [ ] Valida: la tarjeta no está vencida (`FechaVencimiento` ≥ `CAST(GETDATE() AS date)`) → `000003` *La tarjeta está vencida*.
- [ ] Valida: el límite nuevo está dentro del rango del producto de la tarjeta → `000004` *El límite nuevo está fuera del rango del producto*.
- [ ] Valida: el límite nuevo es mayor o igual al `SaldoActual` → `000005` *El límite nuevo es menor que el saldo actual*.
- [ ] Si todo es correcto, actualiza `LimiteCredito` con el límite nuevo y `FechaUltimaModificacion` con `GETDATE()`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Límite actualizado'`.

## Ejemplo de salida esperada

`EXEC usp_actualizarLimiteCredito @p_idTarjeta = 1, @p_LimiteNuevo = 20000.00`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Límite actualizado |

La tarjeta 1 es Banquito Básica (rango 5,000 a 30,000) y debe 3,250.00. Después, `SELECT LimiteCredito, SaldoActual FROM Tarjeta WHERE idTarjeta = 1` muestra `20000.00` y `3250.00`.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: tarjeta 1 (Básica, rango 5,000 a 30,000, saldo 3,250) a 20,000
EXEC usp_actualizarLimiteCredito @p_idTarjeta = 1, @p_LimiteNuevo = 20000.00
SELECT idTarjeta, LimiteCredito, SaldoActual
FROM Tarjeta
WHERE idTarjeta = 1

-- 000001: la tarjeta no existe
EXEC usp_actualizarLimiteCredito @p_idTarjeta = 9999, @p_LimiteNuevo = 20000.00

-- 000002: la tarjeta 6 está cancelada
EXEC usp_actualizarLimiteCredito @p_idTarjeta = 6, @p_LimiteNuevo = 20000.00

-- 000003: la tarjeta 3 venció el 2026-02-15
EXEC usp_actualizarLimiteCredito @p_idTarjeta = 3, @p_LimiteNuevo = 200000.00

-- 000004: 35,000 está fuera del rango de Básica (5,000 a 30,000)
EXEC usp_actualizarLimiteCredito @p_idTarjeta = 1, @p_LimiteNuevo = 35000.00

-- 000005: la tarjeta 13 debe 30,000; no se le puede bajar el límite a 25,000
EXEC usp_actualizarLimiteCredito @p_idTarjeta = 13, @p_LimiteNuevo = 25000.00
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_RodriguezMorenoRicardo_2254147_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
