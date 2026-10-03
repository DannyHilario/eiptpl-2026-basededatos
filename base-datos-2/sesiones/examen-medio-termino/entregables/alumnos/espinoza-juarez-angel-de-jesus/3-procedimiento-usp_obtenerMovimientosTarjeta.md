# Examen de Medio Término — Ejercicio 3 de 3: `usp_obtenerMovimientosTarjeta`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerMovimientosTarjeta`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** consultar todos los movimientos de una tarjeta en orden de fecha, **para** explicarle al cliente cómo llegó a su saldo actual.

## Contexto

Los movimientos de una tarjeta están en `Movimiento`, pero el nombre de cada tipo (Compra, Pago, etc.) está en `TipoMovimiento`. Tu procedimiento regresa los movimientos de una tarjeta ya con el nombre del tipo, ordenados del más antiguo al más reciente, como un estado de cuenta.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerMovimientosTarjeta` que valide que la tarjeta exista y regrese sus movimientos.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La tarjeta existe | `000001` | La tarjeta no existe |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerMovimientosTarjeta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Si una validación falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`.
- [ ] Valida: la tarjeta existe → `000001` *La tarjeta no existe*.
- [ ] Si todo es correcto, regresa con un `SELECT` (no con las variables de error) las columnas `idMovimiento`, `FechaMovimiento`, `TipoMovimiento` (de `TipoMovimiento.Nombre`), `Monto` y `Descripcion`, de los movimientos de esa tarjeta, ordenadas por `FechaMovimiento` de la más antigua a la más reciente.
- [ ] Si no hay filas que mostrar, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerMovimientosTarjeta @p_idTarjeta = 31`

| idMovimiento | FechaMovimiento | TipoMovimiento | Monto | Descripcion |
|---|---|---|---|---|
| 43 | 2025-11-12 16:50 | Compra | 1312.88 | Gasolinera |
| 52 | 2025-12-12 09:30 | Anualidad | 3500.00 | Cobro de anualidad 2025 |
| 54 | 2025-12-18 11:20 | Compra | 563.14 | Cine |
| 58 | 2025-12-20 13:25 | Pago | 3199.68 | Pago en línea |
| 79 | 2026-02-28 21:50 | Compra | 15652.11 | Aerolínea |
| 109 | 2026-05-10 20:20 | Compra | 144749.24 | Agencia de viajes |
| 143 | 2026-07-20 15:50 | Compra | 87422.31 | Agencia de viajes |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Tarjeta con 7 movimientos
EXEC usp_obtenerMovimientosTarjeta @p_idTarjeta = 31

-- Tarjeta sin movimientos: 0 filas, no es error
EXEC usp_obtenerMovimientosTarjeta @p_idTarjeta = 7

-- 000001: la tarjeta no existe
EXEC usp_obtenerMovimientosTarjeta @p_idTarjeta = 9999
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
