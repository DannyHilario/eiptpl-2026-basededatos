# PIA AsesorPro — Objeto 09 de 11: `vw_DetalleAsesoria`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Vista `vw_DetalleAsesoria`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** ver cada asesoría completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada asesoría guarda el **precio cobrado**, y el asesor tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleAsesoria` que muestre **todas** las asesorías con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaAsesoria` | Fecha de la asesoría |
| `Alumno` | Nombre del alumno |
| `Asesor` | Asesor |
| `Horas` | Horas |
| `PrecioCobrado` | Precio que guarda la asesoría |
| `PrecioActual` | Precio actual del asesor |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleAsesoria`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de asesorías con asesores y alumnos (`INNER JOIN`).
- [ ] Tiene **una fila por asesoría**: el número de filas de la vista es igual al de tu tabla de asesorías.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleAsesoria WHERE FechaAsesoria >= '2026-12-01' ORDER BY FechaAsesoria`, después de la preparación de los casos de prueba:

| FechaAsesoria | Alumno | Asesor | Horas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Alumno de Prueba | Mónica Leal Cantú | 2 | 260.00 | 285.00 | Subió |
| 2026-12-02 | Alumno de Prueba | Mónica Leal Cantú | 3 | 310.00 | 285.00 | Bajó |
| 2026-12-03 | Alumno de Prueba | Mónica Leal Cantú | 1 | 285.00 | 285.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarAlumno`](01-procedimiento-usp_insertarAlumno.md), [`usp_actualizarTarifaAsesor`](04-procedimiento-usp_actualizarTarifaAsesor.md), [`usp_registrarAsesoria`](05-procedimiento-usp_registrarAsesoria.md).

```sql
-- Preparación: tres asesorías de 'monica.leal@asesorpro.mx', cada una con un precio distinto
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_PrecioNuevo = 310.00
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-02', @p_Horas = 3
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_PrecioNuevo = 285.00
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'monica.leal@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-03', @p_Horas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleAsesoria WHERE FechaAsesoria >= '2026-12-01' ORDER BY FechaAsesoria

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleAsesoria
SELECT COUNT(*) AS Total FROM <TuTablaDeAsesorías>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus asesorías más las 3 de prueba |
| Tus asesorías inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
