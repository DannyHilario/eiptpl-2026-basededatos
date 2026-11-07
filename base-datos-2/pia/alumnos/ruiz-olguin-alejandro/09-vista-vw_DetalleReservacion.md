# PIA RecorreMTY — Objeto 09 de 11: `vw_DetalleReservacion`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Vista `vw_DetalleReservacion`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** ver cada reservación completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada reservación guarda el **precio cobrado**, y el recorrido tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleReservacion` que muestre **todas** las reservaciones con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaRecorrido` | Fecha de la reservación |
| `Turista` | Nombre del turista |
| `Recorrido` | Recorrido |
| `Personas` | Personas |
| `PrecioCobrado` | Precio que guarda la reservación |
| `PrecioActual` | Precio actual del recorrido |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleReservacion`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de reservaciones con recorridos y turistas (`INNER JOIN`).
- [ ] Tiene **una fila por reservación**: el número de filas de la vista es igual al de tu tabla de reservaciones.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleReservacion WHERE FechaRecorrido >= '2026-12-01' ORDER BY FechaRecorrido`, después de la preparación de los casos de prueba:

| FechaRecorrido | Turista | Recorrido | Personas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Turista de Prueba | Parque Fundidora | 2 | 300.00 | 330.00 | Subió |
| 2026-12-02 | Turista de Prueba | Parque Fundidora | 3 | 360.00 | 330.00 | Bajó |
| 2026-12-03 | Turista de Prueba | Parque Fundidora | 1 | 330.00 | 330.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md), [`usp_actualizarPrecioRecorrido`](04-procedimiento-usp_actualizarPrecioRecorrido.md), [`usp_registrarReservacion`](05-procedimiento-usp_registrarReservacion.md).

```sql
-- Preparación: tres reservaciones de 'Parque Fundidora', cada una con un precio distinto
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Parque Fundidora', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Parque Fundidora', @p_PrecioNuevo = 360.00
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Parque Fundidora', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 3
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Parque Fundidora', @p_PrecioNuevo = 330.00
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Parque Fundidora', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-03', @p_Personas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleReservacion WHERE FechaRecorrido >= '2026-12-01' ORDER BY FechaRecorrido

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleReservacion
SELECT COUNT(*) AS Total FROM <TuTablaDeReservaciones>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus reservaciones más las 3 de prueba |
| Tus reservaciones inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
