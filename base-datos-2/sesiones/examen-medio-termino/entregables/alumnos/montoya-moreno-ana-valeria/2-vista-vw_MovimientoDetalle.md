# Examen de Medio Término — Ejercicio 2 de 3: `vw_MovimientoDetalle`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Vista `vw_MovimientoDetalle`
**Valor:** 30 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** analista de crédito, **quiero** ver cada movimiento con el número de tarjeta, el nombre del cliente y el nombre del tipo de movimiento, **para** revisar los movimientos sin tener que buscar a qué corresponde cada id.

## Contexto

La tabla `Movimiento` guarda `idTarjeta` e `idTipoMovimiento`, pero no dice de quién es la tarjeta ni qué tipo de movimiento es. Para eso hay que unir `Movimiento`, `Tarjeta`, `Cliente` y `TipoMovimiento`. Recuerda que el cliente se llega a través de la tarjeta: `Movimiento` no tiene `idCliente`.

## Tu tarea

Crea una vista llamada exactamente `vw_MovimientoDetalle` que regrese una fila por cada movimiento, con las columnas de la tabla de abajo.

## Columnas de la vista

**Columnas, en este orden:**

| Columna | Origen |
|---------|--------|
| `idMovimiento` | `Movimiento.idMovimiento` |
| `FechaMovimiento` | `Movimiento.FechaMovimiento` |
| `NumeroTarjeta` | `Tarjeta.NumeroTarjeta` |
| `NombreCliente` | `Cliente.Nombre + ' ' + Cliente.PrimerApellido + ' ' + Cliente.SegundoApellido` (nombre completo separado por espacios) |
| `TipoMovimiento` | `TipoMovimiento.Nombre` |
| `EsCargo` | `TipoMovimiento.EsCargo` |
| `Monto` | `Movimiento.Monto` |
| `Descripcion` | `Movimiento.Descripcion` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_MovimientoDetalle`.
- [ ] Tiene exactamente las 8 columnas de la tabla, con esos nombres y en ese orden.
- [ ] Une `Movimiento`, `Tarjeta`, `Cliente` y `TipoMovimiento` con `INNER JOIN`.
- [ ] `NombreCliente` concatena nombre, primer apellido y segundo apellido con un espacio entre cada uno.
- [ ] Incluye todos los movimientos: `SELECT COUNT(*) FROM vw_MovimientoDetalle` regresa **164**.
- [ ] La vista no tiene `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_MovimientoDetalle WHERE NumeroTarjeta = '3333000000000031' ORDER BY FechaMovimiento`

| idMovimiento | FechaMovimiento | NumeroTarjeta | NombreCliente | TipoMovimiento | EsCargo | Monto | Descripcion |
|---|---|---|---|---|---|---|---|
| 43 | 2025-11-12 16:50 | 3333000000000031 | Gabriel Ortiz Peña | Compra | 1 | 1312.88 | Gasolinera |
| 52 | 2025-12-12 09:30 | 3333000000000031 | Gabriel Ortiz Peña | Anualidad | 1 | 3500.00 | Cobro de anualidad 2025 |
| 54 | 2025-12-18 11:20 | 3333000000000031 | Gabriel Ortiz Peña | Compra | 1 | 563.14 | Cine |
| 58 | 2025-12-20 13:25 | 3333000000000031 | Gabriel Ortiz Peña | Pago | 0 | 3199.68 | Pago en línea |
| 79 | 2026-02-28 21:50 | 3333000000000031 | Gabriel Ortiz Peña | Compra | 1 | 15652.11 | Aerolínea |
| 109 | 2026-05-10 20:20 | 3333000000000031 | Gabriel Ortiz Peña | Compra | 1 | 144749.24 | Agencia de viajes |
| 143 | 2026-07-20 15:50 | 3333000000000031 | Gabriel Ortiz Peña | Compra | 1 | 87422.31 | Agencia de viajes |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT COUNT(*) AS Total
FROM vw_MovimientoDetalle                    -- esperado: 164

SELECT idMovimiento, FechaMovimiento, NumeroTarjeta, NombreCliente, TipoMovimiento,
    EsCargo, Monto, Descripcion
FROM vw_MovimientoDetalle
WHERE NumeroTarjeta = '3333000000000031'
ORDER BY FechaMovimiento                     -- esperado: las 7 filas del ejemplo
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 2**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
