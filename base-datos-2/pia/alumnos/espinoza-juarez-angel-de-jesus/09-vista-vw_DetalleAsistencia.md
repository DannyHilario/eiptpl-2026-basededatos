# PIA FitZone — Objeto 09 de 11: `vw_DetalleAsistencia`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Vista `vw_DetalleAsistencia`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** ver cada asistencia completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada asistencia guarda el **precio cobrado**, y la clase tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleAsistencia` que muestre **todas** las asistencias con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaAsistencia` | Fecha de la asistencia |
| `Socio` | Nombre del socio |
| `Clase` | Clase |
| `PrecioCobrado` | Precio que guarda la asistencia |
| `PrecioActual` | Precio actual de la clase |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleAsistencia`.
- [ ] Regresa las 6 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de asistencias con clases y socios (`INNER JOIN`).
- [ ] Tiene **una fila por asistencia**: el número de filas de la vista es igual al de tu tabla de asistencias.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleAsistencia WHERE FechaAsistencia >= '2026-12-01' ORDER BY FechaAsistencia`, después de la preparación de los casos de prueba:

| FechaAsistencia | Socio | Clase | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|
| 2026-12-01 | Socio de Prueba | Box | 100.00 | 110.00 | Subió |
| 2026-12-02 | Socio de Prueba | Box | 120.00 | 110.00 | Bajó |
| 2026-12-03 | Socio de Prueba | Box | 110.00 | 110.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md), [`usp_actualizarPrecioClase`](04-procedimiento-usp_actualizarPrecioClase.md), [`usp_registrarAsistencia`](05-procedimiento-usp_registrarAsistencia.md).

```sql
-- Preparación: tres asistencias de 'Box', cada una con un precio distinto
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'
EXEC usp_registrarAsistencia @p_NombreClase = 'Box', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Box', @p_PrecioNuevo = 120.00
EXEC usp_registrarAsistencia @p_NombreClase = 'Box', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-02'
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Box', @p_PrecioNuevo = 110.00
EXEC usp_registrarAsistencia @p_NombreClase = 'Box', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-03'

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleAsistencia WHERE FechaAsistencia >= '2026-12-01' ORDER BY FechaAsistencia

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleAsistencia
SELECT COUNT(*) AS Total FROM <TuTablaDeAsistencias>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus asistencias más las 3 de prueba |
| Tus asistencias inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
