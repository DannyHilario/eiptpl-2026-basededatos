# PIA RutaNorte — Objeto 09 de 11: `vw_DetalleBoleto`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Vista `vw_DetalleBoleto`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** ver cada boleto completo con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratos o más caros que el precio actual.

## Contexto

Cada boleto guarda el **precio cobrado**, y la ruta tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleBoleto` que muestre **todos** los boletos con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaViaje` | Fecha del boleto |
| `Pasajero` | Nombre del pasajero |
| `ClaveRuta` | Ruta |
| `Asiento` | Asiento |
| `PrecioCobrado` | Precio que guarda el boleto |
| `PrecioActual` | Precio actual de la ruta |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleBoleto`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de boletos con rutas y pasajeros (`INNER JOIN`).
- [ ] Tiene **una fila por boleto**: el número de filas de la vista es igual al de tu tabla de boletos.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleBoleto WHERE FechaViaje >= '2026-12-01' ORDER BY FechaViaje`, después de la preparación de los casos de prueba:

| FechaViaje | Pasajero | ClaveRuta | Asiento | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Pasajero de Prueba | MTY-NLD | 12 | 450.00 | 495.00 | Subió |
| 2026-12-02 | Pasajero de Prueba | MTY-NLD | 20 | 540.00 | 495.00 | Bajó |
| 2026-12-03 | Pasajero de Prueba | MTY-NLD | 5 | 495.00 | 495.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md), [`usp_actualizarPrecioRuta`](04-procedimiento-usp_actualizarPrecioRuta.md), [`usp_registrarBoleto`](05-procedimiento-usp_registrarBoleto.md).

```sql
-- Preparación: tres boletos de 'MTY-NLD', cada uno con un precio distinto
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-NLD', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-NLD', @p_PrecioNuevo = 540.00
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-NLD', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 20
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-NLD', @p_PrecioNuevo = 495.00
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-NLD', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-03', @p_Asiento = 5

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleBoleto WHERE FechaViaje >= '2026-12-01' ORDER BY FechaViaje

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleBoleto
SELECT COUNT(*) AS Total FROM <TuTablaDeBoletos>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus boletos más las 3 de prueba |
| Tus boletos inventados | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
