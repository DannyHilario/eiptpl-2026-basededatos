# PIA RecorreMTY — Objeto 10 de 11: `vw_ResumenRecorrido`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Vista `vw_ResumenRecorrido`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** un resumen por recorrido, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Un recorrido puede no tener reservaciones todavía. También debe aparecer en el resumen, con 0 reservaciones y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenRecorrido` que muestre **una fila por recorrido** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `Recorrido` | Nombre del recorrido |
| `PrecioPorPersona` | Precio por persona actual |
| `TotalReservaciones` | Cuántas reservaciones se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × personas) |
| `UltimaReservacion` | Fecha de la reservación más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenRecorrido`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada recorrido**, incluidos los que no tienen reservaciones: usa `LEFT JOIN` desde los recorridos.
- [ ] Un recorrido sin reservaciones sale con `TotalReservaciones = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaReservacion = NULL`.
- [ ] `TotalReservaciones` cuenta reservaciones: para que un recorrido sin reservaciones salga en 0, cuenta una columna de la tabla de reservaciones, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenRecorrido` regresa algo así:

| Recorrido | PrecioPorPersona | TotalReservaciones | TotalCobrado | UltimaReservacion |
|---|---|---|---|---|
| Barrio Antiguo | 250.00 | 6 | 6250.00 | 2026-05-16 |
| Paseo Santa Lucía | 200.00 | 5 | 5400.00 | 2026-04-25 |
| Parque Fundidora | 300.00 | 5 | 8100.00 | 2026-05-09 |
| Chipinque | 450.00 | 4 | 4050.00 | 2026-04-18 |
| Cerro de la Silla | 550.00 | 0 | 0.00 | NULL |
| Grutas de García | 650.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md), [`usp_registrarReservacion`](05-procedimiento-usp_registrarReservacion.md), [`usp_insertarRecorrido`](03-procedimiento-usp_insertarRecorrido.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenRecorrido

-- 2. Dos reservaciones más de 'Grutas de García' ($650.00)
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Grutas de García', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Grutas de García', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 3
SELECT * FROM vw_ResumenRecorrido

-- 3. Un recorrido nuevo, sin reservaciones
EXEC usp_insertarRecorrido @p_Nombre = 'Recorrido de Prueba', @p_DuracionHoras = 2.5, @p_PrecioPorPersona = 100.00
SELECT * FROM vw_ResumenRecorrido
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 6 filas |
| 2. Después de las dos nuevas | La fila de 'Grutas de García': `TotalReservaciones` **+2**, `TotalCobrado` **+3250.00** y `UltimaReservacion` **2026-12-02**. Las demás no cambian |
| 3. Con el recorrido nuevo | 7 filas. 'Recorrido de Prueba': 100.00, 0, 0.00, NULL |
