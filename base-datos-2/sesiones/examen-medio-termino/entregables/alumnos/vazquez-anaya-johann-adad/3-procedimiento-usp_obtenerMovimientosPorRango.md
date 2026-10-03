# Examen de Medio Término — Ejercicio 3 de 3: `usp_obtenerMovimientosPorRango`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerMovimientosPorRango`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** consultar los movimientos de una tarjeta entre dos fechas, **para** revisar con el cliente solo el periodo que le interesa.

## Contexto

Los movimientos de una tarjeta están en `Movimiento` y el nombre de cada tipo en `TipoMovimiento`. Tu procedimiento regresa solo los movimientos cuya fecha cae **dentro del rango** indicado, incluidos el primer y el último día.

`FechaMovimiento` es `DATETIME` (tiene hora), pero los parámetros son `DATE` (sin hora). Para que un movimiento del último día a las 9:00 pm sí entre en el rango, compara la fecha del movimiento **sin hora**: `CAST(M.FechaMovimiento AS date) BETWEEN @p_FechaInicio AND @p_FechaFin`.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerMovimientosPorRango` que valide la tarjeta y el rango de fechas y regrese los movimientos de ese periodo.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idTarjeta` | `int` | Id de la tarjeta |
| `@p_FechaInicio` | `date` | Primer día del periodo |
| `@p_FechaFin` | `date` | Último día del periodo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La tarjeta existe | `000001` | La tarjeta no existe |
| 2 | La fecha inicial no es mayor que la fecha final | `000002` | La fecha inicial es mayor que la fecha final |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerMovimientosPorRango` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Si una validación falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`.
- [ ] Valida: la tarjeta existe → `000001` *La tarjeta no existe*.
- [ ] Valida: la fecha inicial no es mayor que la fecha final → `000002` *La fecha inicial es mayor que la fecha final*.
- [ ] Filtra con `CAST(M.FechaMovimiento AS date) BETWEEN @p_FechaInicio AND @p_FechaFin`, para incluir los movimientos del primer y del último día a cualquier hora.
- [ ] Si todo es correcto, regresa con un `SELECT` (no con las variables de error) las columnas `idMovimiento`, `FechaMovimiento`, `TipoMovimiento` (de `TipoMovimiento.Nombre`), `Monto` y `Descripcion`, de los movimientos de esa tarjeta dentro del rango, ordenadas por `FechaMovimiento` de la más antigua a la más reciente.
- [ ] Si no hay filas que mostrar, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerMovimientosPorRango @p_idTarjeta = 31, @p_FechaInicio = '2026-01-01', @p_FechaFin = '2026-06-30'`

| idMovimiento | FechaMovimiento | TipoMovimiento | Monto | Descripcion |
|---|---|---|---|---|
| 79 | 2026-02-28 21:50 | Compra | 15652.11 | Aerolínea |
| 109 | 2026-05-10 20:20 | Compra | 144749.24 | Agencia de viajes |

La tarjeta 31 tiene 7 movimientos, pero solo 2 caen en el primer semestre de 2026.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- 2 movimientos en el primer semestre de 2026
EXEC usp_obtenerMovimientosPorRango @p_idTarjeta = 31, @p_FechaInicio = '2026-01-01', @p_FechaFin = '2026-06-30'

-- Periodo sin movimientos: 0 filas, no es error
EXEC usp_obtenerMovimientosPorRango @p_idTarjeta = 31, @p_FechaInicio = '2024-01-01', @p_FechaFin = '2024-12-31'

-- 000001: la tarjeta no existe
EXEC usp_obtenerMovimientosPorRango @p_idTarjeta = 9999, @p_FechaInicio = '2026-01-01', @p_FechaFin = '2026-06-30'

-- 000002: las fechas están al revés
EXEC usp_obtenerMovimientosPorRango @p_idTarjeta = 31, @p_FechaInicio = '2026-06-30', @p_FechaFin = '2026-01-01'
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
