# Examen de Medio Término — Ejercicio 2 de 3: `vw_ResumenSucursal`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Vista `vw_ResumenSucursal`
**Valor:** 30 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente regional, **quiero** un resumen por sucursal con el número de tarjetas de sus clientes, el crédito otorgado y el saldo que se debe, **para** comparar el tamaño de la cartera de cada sucursal.

## Contexto

Cada cliente pertenece a una sucursal, y cada tarjeta pertenece a un cliente. Para resumir las tarjetas por sucursal hay que ir de `Sucursal` a `Cliente` y de `Cliente` a `Tarjeta`, y agrupar por sucursal.

Ojo: la **Sucursal Guadalupe** no tiene clientes (y por lo tanto tampoco tarjetas), pero **sí** debe aparecer en el resumen, con ceros. Eso obliga a usar `LEFT JOIN`.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenSucursal` que regrese una fila por cada sucursal, con las columnas de la tabla de abajo.

## Columnas de la vista

**Columnas, en este orden:**

| Columna | Origen |
|---------|--------|
| `idSucursal` | `Sucursal.idSucursal` |
| `Sucursal` | `Sucursal.Nombre` |
| `TotalTarjetas` | Número de tarjetas de los clientes de la sucursal (`COUNT`) |
| `LimiteTotal` | Suma de `Tarjeta.LimiteCredito` de esas tarjetas; `0` si no hay |
| `SaldoTotal` | Suma de `Tarjeta.SaldoActual` de esas tarjetas; `0` si no hay |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenSucursal`.
- [ ] Tiene exactamente las 5 columnas de la tabla, con esos nombres y en ese orden.
- [ ] Parte de `Sucursal` y usa `LEFT JOIN` hacia `Cliente` y hacia `Tarjeta`, para que las sucursales sin clientes también aparezcan.
- [ ] Agrupa con `GROUP BY` por sucursal y calcula los totales con `COUNT` y `SUM`.
- [ ] `TotalTarjetas` cuenta tarjetas, no clientes ni filas: usa `COUNT(T.idTarjeta)` (no `COUNT(*)`), para que Guadalupe dé `0`.
- [ ] `LimiteTotal` y `SaldoTotal` regresan `0` (no `NULL`) para una sucursal sin tarjetas; usa `ISNULL`.
- [ ] Regresa exactamente 5 filas, una por sucursal. Cuenta todas las tarjetas, activas y canceladas.
- [ ] La vista no tiene `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_ResumenSucursal ORDER BY idSucursal`

| idSucursal | Sucursal | TotalTarjetas | LimiteTotal | SaldoTotal |
|---|---|---|---|---|
| 1 | Sucursal Centro | 11 | 452000.00 | 144310.50 |
| 2 | Sucursal San Pedro | 18 | 2689000.00 | 940671.00 |
| 3 | Sucursal Cumbres | 9 | 1047000.00 | 134750.00 |
| 4 | Sucursal Apodaca | 2 | 13000.00 | 9200.00 |
| 5 | Sucursal Guadalupe | 0 | 0.00 | 0.00 |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT idSucursal, Sucursal, TotalTarjetas, LimiteTotal, SaldoTotal
FROM vw_ResumenSucursal
ORDER BY idSucursal                          -- esperado: las 5 filas del ejemplo

-- Comprobación: la suma de TotalTarjetas debe ser 40
SELECT SUM(TotalTarjetas) AS Total
FROM vw_ResumenSucursal
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 2**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
