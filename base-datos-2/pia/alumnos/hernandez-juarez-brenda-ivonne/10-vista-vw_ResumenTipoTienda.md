# PIA CampoVerde — Objeto 10 de 11: `vw_ResumenTipoTienda`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Vista `vw_ResumenTipoTienda`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** un resumen por tipo de casa de campaña, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de casa de campaña tiene casas de campaña, y cada casa de campaña tiene rentas: el resumen junta **todas las rentas de todas las casas de campaña** de cada tipo de casa de campaña.

Un tipo de casa de campaña puede no tener rentas todavía. También debe aparecer en el resumen, con 0 rentas y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoTienda` que muestre **una fila por tipo de casa de campaña** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoTienda` | Nombre del tipo de casa de campaña |
| `PrecioPorNoche` | Precio por noche actual |
| `TotalRentas` | Cuántas rentas se han registrado con casas de campaña de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × noches) |
| `UltimaRenta` | Fecha de la renta más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoTienda`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de casa de campaña**, incluidos los que no tienen rentas: usa `LEFT JOIN` desde los tipos de casa de campaña.
- [ ] Un tipo de casa de campaña sin rentas sale con `TotalRentas = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaRenta = NULL`.
- [ ] `TotalRentas` cuenta rentas: para que un tipo de casa de campaña sin rentas salga en 0, cuenta una columna de la tabla de rentas, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoTienda` regresa algo así:

| TipoTienda | PrecioPorNoche | TotalRentas | TotalCobrado | UltimaRenta |
|---|---|---|---|---|
| 2 personas | 250.00 | 7 | 5000.00 | 2026-05-08 |
| 4 personas | 380.00 | 7 | 6460.00 | 2026-05-15 |
| 6 personas | 520.00 | 7 | 11960.00 | 2026-05-22 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCampista`](01-procedimiento-usp_insertarCampista.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoTienda

-- 2. Dos rentas más de 'T-05' ($520.00)
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'
EXEC usp_registrarRenta @p_CodigoTienda = 'T-05', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2
EXEC usp_registrarRenta @p_CodigoTienda = 'T-05', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-02', @p_Noches = 3
SELECT * FROM vw_ResumenTipoTienda

-- 3. Un tipo de casa de campaña nuevo, sin casas de campaña. Como ningún procedimiento crea tipos de casa de campaña,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeCasaDeCampaña> (<ColumnaNombre>, <ColumnaPrecioPorNoche>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoTienda
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de '6 personas': `TotalRentas` **+2**, `TotalCobrado` **+2600.00** y `UltimaRenta` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de casa de campaña nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
