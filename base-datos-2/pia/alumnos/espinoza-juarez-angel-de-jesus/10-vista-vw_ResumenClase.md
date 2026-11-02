# PIA FitZone — Objeto 10 de 11: `vw_ResumenClase`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Vista `vw_ResumenClase`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** un resumen por clase, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Una clase puede no tener asistencias todavía. También debe aparecer en el resumen, con 0 asistencias y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenClase` que muestre **una fila por clase** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `Clase` | Nombre de la clase |
| `PrecioPorClase` | Precio por clase actual |
| `TotalAsistencias` | Cuántas asistencias se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado) |
| `UltimaAsistencia` | Fecha de la asistencia más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenClase`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada clase**, incluidas las que no tienen asistencias: usa `LEFT JOIN` desde las clases.
- [ ] Una clase sin asistencias sale con `TotalAsistencias = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaAsistencia = NULL`.
- [ ] `TotalAsistencias` cuenta asistencias: para que una clase sin asistencias salga en 0, cuenta una columna de la tabla de asistencias, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenClase` regresa algo así:

| Clase | PrecioPorClase | TotalAsistencias | TotalCobrado | UltimaAsistencia |
|---|---|---|---|---|
| Spinning | 90.00 | 2 | 180.00 | 2026-04-11 |
| Yoga | 80.00 | 8 | 640.00 | 2026-05-22 |
| Box | 100.00 | 4 | 400.00 | 2026-04-11 |
| Pilates | 110.00 | 0 | 0.00 | NULL |
| Zumba | 70.00 | 7 | 490.00 | 2026-04-27 |
| CrossFit | 120.00 | 6 | 720.00 | 2026-05-21 |
| Body Pump | 90.00 | 3 | 270.00 | 2026-05-02 |
| Stretching | 60.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md), [`usp_registrarAsistencia`](05-procedimiento-usp_registrarAsistencia.md), [`usp_insertarClase`](03-procedimiento-usp_insertarClase.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenClase

-- 2. Dos asistencias más de 'Stretching' ($60.00)
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'
EXEC usp_registrarAsistencia @p_NombreClase = 'Stretching', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'
EXEC usp_registrarAsistencia @p_NombreClase = 'Stretching', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-02'
SELECT * FROM vw_ResumenClase

-- 3. Una clase nueva, sin asistencias
EXEC usp_insertarClase @p_Nombre = 'Clase de Prueba', @p_Instructor = 'Instructor de Prueba', @p_CupoMaximo = 10, @p_PrecioPorClase = 100.00
SELECT * FROM vw_ResumenClase
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 8 filas |
| 2. Después de las dos nuevas | La fila de 'Stretching': `TotalAsistencias` **+2**, `TotalCobrado` **+120.00** y `UltimaAsistencia` **2026-12-02**. Las demás no cambian |
| 3. Con la clase nueva | 9 filas. 'Clase de Prueba': 100.00, 0, 0.00, NULL |
