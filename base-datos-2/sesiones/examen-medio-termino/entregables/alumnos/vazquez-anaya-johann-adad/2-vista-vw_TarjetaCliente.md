# Examen de Medio Término — Ejercicio 2 de 3: `vw_TarjetaCliente`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Vista `vw_TarjetaCliente`
**Valor:** 30 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** ver cada tarjeta junto con el nombre de su titular, su producto y su sucursal, **para** no tener que cruzar cuatro tablas cada vez que reviso una tarjeta.

## Contexto

La tabla `Tarjeta` solo guarda ids (`idCliente`, `idTipoTarjetaCredito`). Para saber de quién es una tarjeta, qué producto es y en qué sucursal se atiende al cliente, hay que unir `Tarjeta`, `Cliente`, `TipoTarjetaCredito` y `Sucursal`. Tu vista deja ese cruce resuelto.

## Tu tarea

Crea una vista llamada exactamente `vw_TarjetaCliente` que regrese una fila por cada tarjeta, con las columnas de la tabla de abajo.

## Columnas de la vista

**Columnas, en este orden:**

| Columna | Origen |
|---------|--------|
| `idTarjeta` | `Tarjeta.idTarjeta` |
| `NumeroTarjeta` | `Tarjeta.NumeroTarjeta` |
| `NombreCliente` | `Cliente.Nombre + ' ' + Cliente.PrimerApellido + ' ' + Cliente.SegundoApellido` (nombre completo separado por espacios) |
| `Producto` | `TipoTarjetaCredito.Nombre` |
| `Sucursal` | `Sucursal.Nombre` (la sucursal del cliente) |
| `LimiteCredito` | `Tarjeta.LimiteCredito` |
| `SaldoActual` | `Tarjeta.SaldoActual` |
| `FechaVencimiento` | `Tarjeta.FechaVencimiento` |
| `Activo` | `Tarjeta.Activo` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_TarjetaCliente`.
- [ ] Tiene exactamente las 9 columnas de la tabla, con esos nombres y en ese orden (usa alias con `AS` donde haga falta).
- [ ] Une `Tarjeta`, `Cliente`, `TipoTarjetaCredito` y `Sucursal` con `INNER JOIN`. La sucursal se obtiene a través del cliente (`Cliente.idSucursal`).
- [ ] `NombreCliente` concatena nombre, primer apellido y segundo apellido con un espacio entre cada uno.
- [ ] Incluye **todas** las tarjetas, activas y canceladas: `SELECT COUNT(*) FROM vw_TarjetaCliente` regresa **40**.
- [ ] La vista no tiene `ORDER BY` (SQL Server no lo permite dentro de una vista; el orden se pide al consultarla).

## Ejemplo de salida esperada

`SELECT * FROM vw_TarjetaCliente WHERE idTarjeta IN (1, 6, 31) ORDER BY idTarjeta`

| idTarjeta | NumeroTarjeta | NombreCliente | Producto | Sucursal | LimiteCredito | SaldoActual | FechaVencimiento | Activo |
|---|---|---|---|---|---|---|---|---|
| 1 | 1111000000000001 | Carlos García López | Banquito Básica | Sucursal Centro | 15000.00 | 3250.00 | 2028-04-10 | 1 |
| 6 | 1111000000000006 | Sofía Sánchez Vega | Banquito Básica | Sucursal Centro | 12000.00 | 0.00 | 2028-07-12 | 0 |
| 31 | 3333000000000031 | Gabriel Ortiz Peña | Banquito Platinum | Sucursal San Pedro | 500000.00 | 250000.00 | 2029-12-12 | 1 |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT COUNT(*) AS Total
FROM vw_TarjetaCliente                       -- esperado: 40

SELECT idTarjeta, NumeroTarjeta, NombreCliente, Producto, Sucursal,
    LimiteCredito, SaldoActual, FechaVencimiento, Activo
FROM vw_TarjetaCliente
WHERE idTarjeta IN (1, 6, 31)
ORDER BY idTarjeta                           -- esperado: las 3 filas del ejemplo
```

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_VazquezAnayaJohannAdad_2253497_Ejercicio2.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 2 | Vistas*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
