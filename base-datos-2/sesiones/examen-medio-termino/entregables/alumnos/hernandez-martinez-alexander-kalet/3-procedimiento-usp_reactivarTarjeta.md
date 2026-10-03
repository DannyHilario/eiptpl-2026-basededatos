# Examen de Medio Término — Ejercicio 3 de 3: `usp_reactivarTarjeta`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Procedimiento almacenado `usp_reactivarTarjeta`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** reactivar una tarjeta que se canceló, **para** que el cliente pueda volver a usarla sin emitirle una nueva, siempre que no haya vencido.

## Contexto

A veces un cliente cancela su tarjeta y después se arrepiente. En lugar de emitirle una nueva, el banco puede **reactivarla**: regresarla a `Activo = 1`.

Solo tiene sentido reactivar una tarjeta que **sí está cancelada** (`Activo = 0`), y solo si **no ha vencido** (`FechaVencimiento` igual o posterior a hoy): una tarjeta vencida ya no sirve aunque se reactive.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_reactivarTarjeta` que valide las reglas de arriba y, si todo es correcto, reactive la tarjeta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La tarjeta existe | `000001` | La tarjeta no existe |
| 2 | La tarjeta sí está cancelada (`Activo = 0`) | `000002` | La tarjeta no está cancelada |
| 3 | La tarjeta no está vencida (`FechaVencimiento` ≥ `CAST(GETDATE() AS date)`) | `000003` | La tarjeta está vencida |
| 4 | Todo correcto | `000000` | Tarjeta reactivada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_reactivarTarjeta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la tarjeta existe → `000001` *La tarjeta no existe*.
- [ ] Valida: la tarjeta sí está cancelada (`Activo = 0`) → `000002` *La tarjeta no está cancelada*.
- [ ] Valida: la tarjeta no está vencida (`FechaVencimiento` ≥ `CAST(GETDATE() AS date)`) → `000003` *La tarjeta está vencida*.
- [ ] Si todo es correcto, actualiza la tarjeta con `Activo = 1` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tarjeta reactivada'`.

## Ejemplo de salida esperada

`EXEC usp_reactivarTarjeta @p_idTarjeta = 6`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Tarjeta reactivada |

La tarjeta 6 está cancelada y vence el 2028-07-12. Después, `SELECT Activo FROM Tarjeta WHERE idTarjeta = 6` muestra `1`.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: la tarjeta 6 está cancelada y vence hasta 2028
EXEC usp_reactivarTarjeta @p_idTarjeta = 6
SELECT idTarjeta, FechaVencimiento, Activo
FROM Tarjeta
WHERE idTarjeta = 6

-- Éxito: la tarjeta 24 también está cancelada y no ha vencido
EXEC usp_reactivarTarjeta @p_idTarjeta = 24

-- 000001: la tarjeta no existe
EXEC usp_reactivarTarjeta @p_idTarjeta = 9999

-- 000002: la tarjeta 1 está activa, no hay nada que reactivar
EXEC usp_reactivarTarjeta @p_idTarjeta = 1

-- 000003: cancelada y vencida (en los datos iniciales no hay una así; primero cancela la 29, que venció en 2025)
UPDATE Tarjeta SET Activo = 0 WHERE idTarjeta = 29
EXEC usp_reactivarTarjeta @p_idTarjeta = 29
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_HernandezMartinezAlexanderKalet_2212470_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
