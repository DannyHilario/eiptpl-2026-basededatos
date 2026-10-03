# Examen de Medio Término — Ejercicio 2 de 3: `vw_ResumenProducto`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Vista `vw_ResumenProducto`
**Valor:** 30 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente de producto, **quiero** un resumen por tipo de tarjeta con cuántas hay, cuánto crédito se ha otorgado y cuánto se debe, **para** comparar el desempeño de Banquito Básica, Gold y Platinum.

## Contexto

El banco ofrece tres productos de tarjeta (`TipoTarjetaCredito`). Cada tarjeta emitida pertenece a uno de ellos. Tu vista agrupa las tarjetas por producto y calcula varios totales a la vez con funciones de agregado.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenProducto` que regrese una fila por producto, con las columnas de la tabla de abajo.

## Columnas de la vista

**Columnas, en este orden:**

| Columna | Origen |
|---------|--------|
| `idTipoTarjetaCredito` | `TipoTarjetaCredito.idTipoTarjetaCredito` |
| `Producto` | `TipoTarjetaCredito.Nombre` |
| `TotalTarjetas` | Número de tarjetas del producto (`COUNT`) |
| `LimiteTotal` | Suma de `Tarjeta.LimiteCredito` (`SUM`) |
| `SaldoTotal` | Suma de `Tarjeta.SaldoActual` (`SUM`) |
| `SaldoPromedio` | Promedio de `Tarjeta.SaldoActual` (`AVG`) |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenProducto`.
- [ ] Tiene exactamente las 6 columnas de la tabla, con esos nombres y en ese orden.
- [ ] Une `TipoTarjetaCredito` con `Tarjeta` y agrupa con `GROUP BY` por producto.
- [ ] Usa `COUNT`, `SUM` (dos veces) y `AVG` para las columnas calculadas.
- [ ] Considera todas las tarjetas, activas y canceladas. Regresa exactamente 3 filas.
- [ ] La suma de `TotalTarjetas` de las 3 filas es 40.
- [ ] La vista no tiene `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_ResumenProducto ORDER BY idTipoTarjetaCredito`

| idTipoTarjetaCredito | Producto | TotalTarjetas | LimiteTotal | SaldoTotal | SaldoPromedio |
|---|---|---|---|---|---|
| 1 | Banquito Básica | 14 | 201000.00 | 80420.00 | 5744.285714 |
| 2 | Banquito Gold | 14 | 880000.00 | 346940.50 | 24781.464285 |
| 3 | Banquito Platinum | 12 | 3120000.00 | 801571.00 | 66797.583333 |

> El número de decimales de `SaldoPromedio` puede variar; lo importante es el valor.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT idTipoTarjetaCredito, Producto, TotalTarjetas, LimiteTotal, SaldoTotal,
    SaldoPromedio
FROM vw_ResumenProducto
ORDER BY idTipoTarjetaCredito                -- esperado: las 3 filas del ejemplo
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 2**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
