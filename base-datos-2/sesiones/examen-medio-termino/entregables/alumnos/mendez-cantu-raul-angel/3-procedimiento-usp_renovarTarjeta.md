# Examen de Medio Término — Ejercicio 3 de 3: `usp_renovarTarjeta`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_renovarTarjeta`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** renovar una tarjeta que ya venció, **para** que el cliente pueda seguir usándola otros 5 años.

## Contexto

Cuando una tarjeta activa llega a su `FechaVencimiento`, queda **vencida** y ya no se puede usar. Renovarla es darle una fecha de vencimiento nueva: **5 años a partir de hoy**, con `DATEADD(YEAR, 5, GETDATE())`.

Solo se renuevan tarjetas que **ya vencieron** y que **no están canceladas**. Una tarjeta vigente todavía no necesita renovarse.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_renovarTarjeta` que valide las reglas de arriba y, si todo es correcto, renueve la tarjeta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La tarjeta existe | `000001` | La tarjeta no existe |
| 2 | La tarjeta no está cancelada (`Activo = 1`) | `000002` | La tarjeta está cancelada |
| 3 | La tarjeta ya venció (`FechaVencimiento` < `CAST(GETDATE() AS date)`) | `000003` | La tarjeta todavía no vence |
| 4 | Todo correcto | `000000` | Tarjeta renovada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_renovarTarjeta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la tarjeta existe → `000001` *La tarjeta no existe*.
- [ ] Valida: la tarjeta no está cancelada (`Activo = 1`) → `000002` *La tarjeta está cancelada*.
- [ ] Valida: la tarjeta ya venció (`FechaVencimiento` < `CAST(GETDATE() AS date)`) → `000003` *La tarjeta todavía no vence*.
- [ ] Si todo es correcto, actualiza `FechaVencimiento = DATEADD(YEAR, 5, GETDATE())` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tarjeta renovada'`.

## Ejemplo de salida esperada

`EXEC usp_renovarTarjeta @p_idTarjeta = 3`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Tarjeta renovada |

La tarjeta 3 venció el 2026-02-15. Después, `SELECT FechaVencimiento FROM Tarjeta WHERE idTarjeta = 3` muestra la fecha de hoy pero 5 años después (por ejemplo, `2031-10-03` si se ejecuta el 3 de octubre de 2026).

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: la tarjeta 3 venció el 2026-02-15
EXEC usp_renovarTarjeta @p_idTarjeta = 3
SELECT idTarjeta, FechaVencimiento, Activo
FROM Tarjeta
WHERE idTarjeta = 3

-- 000003: la tarjeta 3 ya se renovó en el caso anterior (también sirve la tarjeta 1, vigente hasta 2028)
EXEC usp_renovarTarjeta @p_idTarjeta = 3

-- 000001: la tarjeta no existe
EXEC usp_renovarTarjeta @p_idTarjeta = 9999

-- 000002: la tarjeta 6 está cancelada
EXEC usp_renovarTarjeta @p_idTarjeta = 6
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_MendezCantuRaulAngel_2212484_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
