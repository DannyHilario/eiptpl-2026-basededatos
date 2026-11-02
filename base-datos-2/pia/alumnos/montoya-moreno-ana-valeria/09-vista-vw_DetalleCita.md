# PIA SpaZen — Objeto 09 de 11: `vw_DetalleCita`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Vista `vw_DetalleCita`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** ver cada cita completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada cita guarda el **precio cobrado**, y el servicio tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleCita` que muestre **todas** las citas con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaCita` | Fecha de la cita |
| `Cliente` | Nombre del cliente |
| `Servicio` | Servicio |
| `Calificacion` | Calificación |
| `PrecioCobrado` | Precio que guarda la cita |
| `PrecioActual` | Precio actual del servicio |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleCita`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de citas con servicios y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por cita**: el número de filas de la vista es igual al de tu tabla de citas.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleCita WHERE FechaCita >= '2026-12-01' ORDER BY FechaCita`, después de la preparación de los casos de prueba:

| FechaCita | Cliente | Servicio | Calificacion | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Cliente de Prueba | Facial hidratante | 5 | 600.00 | 660.00 | Subió |
| 2026-12-02 | Cliente de Prueba | Facial hidratante | 4 | 720.00 | 660.00 | Bajó |
| 2026-12-03 | Cliente de Prueba | Facial hidratante | 3 | 660.00 | 660.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarPrecioServicio`](04-procedimiento-usp_actualizarPrecioServicio.md), [`usp_registrarCita`](05-procedimiento-usp_registrarCita.md).

```sql
-- Preparación: tres citas de 'Facial hidratante', cada una con un precio distinto
EXEC usp_insertarCliente @p_NombreZona = 'Norte', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarCita @p_NombreServicio = 'Facial hidratante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Facial hidratante', @p_PrecioNuevo = 720.00
EXEC usp_registrarCita @p_NombreServicio = 'Facial hidratante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 4
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Facial hidratante', @p_PrecioNuevo = 660.00
EXEC usp_registrarCita @p_NombreServicio = 'Facial hidratante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-03', @p_Calificacion = 3

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleCita WHERE FechaCita >= '2026-12-01' ORDER BY FechaCita

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleCita
SELECT COUNT(*) AS Total FROM <TuTablaDeCitas>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus citas más las 3 de prueba |
| Tus citas inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
