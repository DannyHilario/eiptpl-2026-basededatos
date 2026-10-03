# Examen de Medio Término — Ejercicio 2 de 3: `vw_ClienteSinTarjeta`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Vista `vw_ClienteSinTarjeta`
**Valor:** 30 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de ventas, **quiero** la lista de clientes que todavía no tienen ninguna tarjeta, con sus datos de contacto y su sucursal, **para** llamarles y ofrecerles un producto.

## Contexto

No todos los clientes del banco tienen tarjeta. Para encontrar a los que no tienen ninguna hay que buscar los clientes que **no aparecen** en la tabla `Tarjeta`: eso se resuelve con un `LEFT JOIN` hacia `Tarjeta` y filtrando las filas donde la tarjeta quedó en `NULL`.

## Tu tarea

Crea una vista llamada exactamente `vw_ClienteSinTarjeta` que regrese una fila por cada cliente que no tenga ninguna tarjeta, con las columnas de la tabla de abajo.

## Columnas de la vista

**Columnas, en este orden:**

| Columna | Origen |
|---------|--------|
| `idCliente` | `Cliente.idCliente` |
| `NombreCliente` | `Cliente.Nombre + ' ' + Cliente.PrimerApellido + ' ' + Cliente.SegundoApellido` (nombre completo separado por espacios) |
| `Telefono` | `Cliente.Telefono` |
| `CorreoElectronico` | `Cliente.CorreoElectronico` |
| `Sucursal` | `Sucursal.Nombre` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ClienteSinTarjeta`.
- [ ] Tiene exactamente las 5 columnas de la tabla, con esos nombres y en ese orden.
- [ ] Une `Cliente` con `Sucursal` (`INNER JOIN`) y con `Tarjeta` (`LEFT JOIN`).
- [ ] Filtra con `WHERE ... IS NULL` sobre una columna de `Tarjeta` para quedarse solo con los clientes sin tarjeta.
- [ ] Regresa exactamente 6 filas: los clientes 25 a 30.
- [ ] La vista no tiene `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_ClienteSinTarjeta ORDER BY idCliente`

| idCliente | NombreCliente | Telefono | CorreoElectronico | Sucursal |
|---|---|---|---|---|
| 25 | Roberto Silva Espinoza | 8112340025 | roberto.silva@correo.mx | Sucursal Apodaca |
| 26 | Andrea Gutiérrez Peña | 8112340026 | andrea.gutierrez@correo.mx | Sucursal Apodaca |
| 27 | Iván Mendoza Torres | 8112340027 | ivan.mendoza@correo.mx | Sucursal Cumbres |
| 28 | Camila Herrera Soto | 8112340028 | camila.herrera@correo.mx | Sucursal Centro |
| 29 | Carlos Vega Ramírez | 8112340029 | carlos.vega@correo.mx | Sucursal Cumbres |
| 30 | Lucía Navarro Flores | 8112340030 | lucia.navarro@correo.mx | Sucursal Apodaca |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT idCliente, NombreCliente, Telefono, CorreoElectronico, Sucursal
FROM vw_ClienteSinTarjeta
ORDER BY idCliente                           -- esperado: las 6 filas del ejemplo
```

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_PerezMoralesJohanValente_2254047_Ejercicio2.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 2 | Vistas*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
