# PIA AsesorPro — Objeto 10 de 11: `vw_ResumenAsesor`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Vista `vw_ResumenAsesor`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** un resumen por asesor, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Un asesor puede no tener asesorías todavía. También debe aparecer en el resumen, con 0 asesorías y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenAsesor` que muestre **una fila por asesor** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `Asesor` | Nombre del asesor |
| `TarifaPorHora` | Tarifa por hora actual |
| `TotalAsesorias` | Cuántas asesorías se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × horas) |
| `UltimaAsesoria` | Fecha de la asesoría más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenAsesor`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada asesor**, incluidos los que no tienen asesorías: usa `LEFT JOIN` desde los asesores.
- [ ] Un asesor sin asesorías sale con `TotalAsesorias = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaAsesoria = NULL`.
- [ ] `TotalAsesorias` cuenta asesorías: para que un asesor sin asesorías salga en 0, cuenta una columna de la tabla de asesorías, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenAsesor` regresa algo así:

| Asesor | TarifaPorHora | TotalAsesorias | TotalCobrado | UltimaAsesoria |
|---|---|---|---|---|
| Laura Garza Ríos | 250.00 | 6 | 2250.00 | 2026-04-29 |
| Jorge Treviño Salas | 280.00 | 5 | 3080.00 | 2026-05-27 |
| Mónica Leal Cantú | 260.00 | 4 | 1560.00 | 2026-05-13 |
| Ricardo Peña Ortiz | 200.00 | 0 | 0.00 | NULL |
| Sofía Villarreal Mata | 300.00 | 5 | 3900.00 | 2026-05-20 |
| Andrés Cavazos Lara | 180.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarAlumno`](01-procedimiento-usp_insertarAlumno.md), [`usp_registrarAsesoria`](05-procedimiento-usp_registrarAsesoria.md), [`usp_insertarAsesor`](03-procedimiento-usp_insertarAsesor.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenAsesor

-- 2. Dos asesorías más de 'andres.cavazos@asesorpro.mx' ($180.00)
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'andres.cavazos@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'andres.cavazos@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-02', @p_Horas = 3
SELECT * FROM vw_ResumenAsesor

-- 3. Un asesor nuevo, sin asesorías
EXEC usp_insertarAsesor @p_Nombre = 'Asesor de Prueba', @p_CorreoElectronico = 'asesor.prueba@asesorpro.mx', @p_Materia = 'Historia', @p_AniosExperiencia = 2, @p_TarifaPorHora = 100.00
SELECT * FROM vw_ResumenAsesor
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 6 filas |
| 2. Después de las dos nuevas | La fila de 'Andrés Cavazos Lara': `TotalAsesorias` **+2**, `TotalCobrado` **+900.00** y `UltimaAsesoria` **2026-12-02**. Las demás no cambian |
| 3. Con el asesor nuevo | 7 filas. 'Asesor de Prueba': 100.00, 0, 0.00, NULL |
