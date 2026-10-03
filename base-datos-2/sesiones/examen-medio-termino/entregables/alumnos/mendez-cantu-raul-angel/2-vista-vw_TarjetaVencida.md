# Examen de Medio Término — Ejercicio 2 de 3: `vw_TarjetaVencida`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Vista `vw_TarjetaVencida`
**Valor:** 30 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** la lista de tarjetas que ya vencieron pero no se han cancelado, **para** contactar a sus titulares y ofrecerles la renovación.

## Contexto

Según la regla del README (sección *Estado de una tarjeta*), una tarjeta está **vencida** cuando sigue activa (`Activo = 1`) pero su `FechaVencimiento` ya es anterior a la fecha de hoy. Las tarjetas canceladas (`Activo = 0`) **no** se consideran vencidas, aunque su fecha ya haya pasado.

## Tu tarea

Crea una vista llamada exactamente `vw_TarjetaVencida` que regrese una fila por cada tarjeta vencida, con las columnas de la tabla de abajo.

## Columnas de la vista

**Columnas, en este orden:**

| Columna | Origen |
|---------|--------|
| `idTarjeta` | `Tarjeta.idTarjeta` |
| `NumeroTarjeta` | `Tarjeta.NumeroTarjeta` |
| `NombreCliente` | `Cliente.Nombre + ' ' + Cliente.PrimerApellido + ' ' + Cliente.SegundoApellido` (nombre completo separado por espacios) |
| `FechaVencimiento` | `Tarjeta.FechaVencimiento` |
| `SaldoActual` | `Tarjeta.SaldoActual` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_TarjetaVencida`.
- [ ] Tiene exactamente las 5 columnas de la tabla, con esos nombres y en ese orden.
- [ ] Une `Tarjeta` con `Cliente` con `INNER JOIN`.
- [ ] Filtra las tarjetas con `Activo = 1` **y** `FechaVencimiento` menor a la fecha de hoy, usando `CAST(GETDATE() AS date)`.
- [ ] Regresa exactamente 4 filas: las tarjetas 3, 9, 15 y 29.
- [ ] La vista no tiene `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_TarjetaVencida ORDER BY idTarjeta`

| idTarjeta | NumeroTarjeta | NombreCliente | FechaVencimiento | SaldoActual |
|---|---|---|---|---|
| 3 | 3333000000000003 | Miguel Rodríguez Silva | 2026-02-15 | 48900.00 |
| 9 | 1111000000000009 | Ricardo Gómez Reyes | 2025-06-25 | 1200.00 |
| 15 | 2222000000000015 | Adriana Fuentes Cervantes | 2026-05-10 | 9800.00 |
| 29 | 1111000000000029 | Gabriel Ortiz Peña | 2025-09-14 | 0.00 |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT idTarjeta, NumeroTarjeta, NombreCliente, FechaVencimiento, SaldoActual
FROM vw_TarjetaVencida
ORDER BY idTarjeta                           -- esperado: las 4 filas del ejemplo
```

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_MendezCantuRaulAngel_2212484_Ejercicio2.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 2 | Vistas*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
