# PIA SpaZen — Objeto 10 de 11: `vw_ResumenServicio`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Vista `vw_ResumenServicio`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** un resumen por servicio, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Un servicio puede no tener citas todavía. También debe aparecer en el resumen, con 0 citas y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenServicio` que muestre **una fila por servicio** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `Servicio` | Nombre del servicio |
| `Precio` | Precio actual |
| `TotalCitas` | Cuántas citas se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado) |
| `UltimaCita` | Fecha de la cita más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenServicio`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada servicio**, incluidos los que no tienen citas: usa `LEFT JOIN` desde los servicios.
- [ ] Un servicio sin citas sale con `TotalCitas = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaCita = NULL`.
- [ ] `TotalCitas` cuenta citas: para que un servicio sin citas salga en 0, cuenta una columna de la tabla de citas, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenServicio` regresa algo así:

| Servicio | Precio | TotalCitas | TotalCobrado | UltimaCita |
|---|---|---|---|---|
| Masaje relajante | 750.00 | 6 | 4500.00 | 2026-05-15 |
| Masaje con piedras calientes | 1100.00 | 5 | 5500.00 | 2026-05-08 |
| Facial hidratante | 600.00 | 5 | 3000.00 | 2026-05-01 |
| Reflexología | 500.00 | 5 | 2500.00 | 2026-05-22 |
| Aromaterapia | 650.00 | 0 | 0.00 | NULL |
| Exfoliación corporal | 800.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarCita`](05-procedimiento-usp_registrarCita.md), [`usp_insertarServicio`](03-procedimiento-usp_insertarServicio.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenServicio

-- 2. Dos citas más de 'Exfoliación corporal' ($800.00)
EXEC usp_insertarCliente @p_NombreZona = 'Norte', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarCita @p_NombreServicio = 'Exfoliación corporal', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5
EXEC usp_registrarCita @p_NombreServicio = 'Exfoliación corporal', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 4
SELECT * FROM vw_ResumenServicio

-- 3. Un servicio nuevo, sin citas
EXEC usp_insertarServicio @p_Nombre = 'Servicio de Prueba', @p_DuracionMinutos = 30, @p_Precio = 100.00
SELECT * FROM vw_ResumenServicio
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 6 filas |
| 2. Después de las dos nuevas | La fila de 'Exfoliación corporal': `TotalCitas` **+2**, `TotalCobrado` **+1600.00** y `UltimaCita` **2026-12-02**. Las demás no cambian |
| 3. Con el servicio nuevo | 7 filas. 'Servicio de Prueba': 100.00, 0, 0.00, NULL |
