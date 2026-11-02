# PIA GuardaTodo — Objeto 10 de 11: `vw_ResumenTipoBodega`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Vista `vw_ResumenTipoBodega`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** un resumen por tipo de bodega, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de bodega tiene bodegas, y cada bodega tiene contratos: el resumen junta **todos los contratos de todas las bodegas** de cada tipo de bodega.

Un tipo de bodega puede no tener contratos todavía. También debe aparecer en el resumen, con 0 contratos y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoBodega` que muestre **una fila por tipo de bodega** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoBodega` | Nombre del tipo de bodega |
| `PrecioPorMes` | Precio por mes actual |
| `TotalContratos` | Cuántos contratos se han registrado con bodegas de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × meses) |
| `UltimoContrato` | Fecha del contrato más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoBodega`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de bodega**, incluidos los que no tienen contratos: usa `LEFT JOIN` desde los tipos de bodega.
- [ ] Un tipo de bodega sin contratos sale con `TotalContratos = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimoContrato = NULL`.
- [ ] `TotalContratos` cuenta contratos: para que un tipo de bodega sin contratos salga en 0, cuenta una columna de la tabla de contratos, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoBodega` regresa algo así:

| TipoBodega | PrecioPorMes | TotalContratos | TotalCobrado | UltimoContrato |
|---|---|---|---|---|
| Chica | 900.00 | 9 | 30600.00 | 2026-04-13 |
| Mediana | 1500.00 | 6 | 42000.00 | 2026-01-19 |
| Grande | 2400.00 | 6 | 60000.00 | 2026-04-06 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarContrato`](05-procedimiento-usp_registrarContrato.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoBodega

-- 2. Dos contratos más de 'B-104' ($2,400.00)
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'
EXEC usp_registrarContrato @p_NumeroBodega = 'B-104', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-01', @p_Meses = 2
EXEC usp_registrarContrato @p_NumeroBodega = 'B-104', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-02', @p_Meses = 3
SELECT * FROM vw_ResumenTipoBodega

-- 3. Un tipo de bodega nuevo, sin bodegas. Como ningún procedimiento crea tipos de bodega,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeBodega> (<ColumnaNombre>, <ColumnaPrecioPorMes>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoBodega
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de 'Grande': `TotalContratos` **+2**, `TotalCobrado` **+12000.00** y `UltimoContrato` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de bodega nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
