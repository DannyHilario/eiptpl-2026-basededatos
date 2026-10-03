# Examen de Medio Término — Ejercicio 3 de 3: `usp_cancelarTarjeta`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_cancelarTarjeta`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** cancelar la tarjeta de un cliente que ya no la quiere, **para** que no se pueda usar más, siempre que esté liquidada.

## Contexto

Cancelar una tarjeta es una **baja lógica**: se pone `Activo = 0` y el registro se conserva con todo su historial de movimientos.

El banco solo permite cancelar una tarjeta **liquidada**, es decir, con `SaldoActual = 0`. Si el cliente todavía debe algo, primero tiene que pagarlo. Una tarjeta vencida con saldo 0 **sí** se puede cancelar.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_cancelarTarjeta` que valide las reglas de arriba y, si todo es correcto, cancele la tarjeta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La tarjeta existe | `000001` | La tarjeta no existe |
| 2 | La tarjeta no está ya cancelada (`Activo = 1`) | `000002` | La tarjeta ya está cancelada |
| 3 | La tarjeta no tiene saldo (`SaldoActual = 0`) | `000003` | La tarjeta tiene saldo pendiente |
| 4 | Todo correcto | `000000` | Tarjeta cancelada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_cancelarTarjeta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la tarjeta existe → `000001` *La tarjeta no existe*.
- [ ] Valida: la tarjeta no está ya cancelada (`Activo = 1`) → `000002` *La tarjeta ya está cancelada*.
- [ ] Valida: la tarjeta no tiene saldo (`SaldoActual = 0`) → `000003` *La tarjeta tiene saldo pendiente*.
- [ ] Si todo es correcto, actualiza la tarjeta con `Activo = 0` y `FechaUltimaModificacion = GETDATE()`. No usa `DELETE`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tarjeta cancelada'`.

## Ejemplo de salida esperada

`EXEC usp_cancelarTarjeta @p_idTarjeta = 7`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Tarjeta cancelada |

La tarjeta 7 está vigente y tiene saldo 0. Después, `SELECT SaldoActual, Activo FROM Tarjeta WHERE idTarjeta = 7` muestra `0.00` y `0`.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: la tarjeta 7 tiene saldo 0
EXEC usp_cancelarTarjeta @p_idTarjeta = 7
SELECT idTarjeta, SaldoActual, Activo
FROM Tarjeta
WHERE idTarjeta = 7

-- Éxito: la tarjeta 29 está vencida, pero con saldo 0
EXEC usp_cancelarTarjeta @p_idTarjeta = 29

-- 000002: la tarjeta 7 ya se canceló en el primer caso
EXEC usp_cancelarTarjeta @p_idTarjeta = 7

-- 000001: la tarjeta no existe
EXEC usp_cancelarTarjeta @p_idTarjeta = 9999

-- 000003: la tarjeta 1 debe 3,250.00
EXEC usp_cancelarTarjeta @p_idTarjeta = 1
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
