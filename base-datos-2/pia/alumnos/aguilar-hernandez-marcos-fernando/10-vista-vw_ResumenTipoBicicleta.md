# PIA BiciRuta — Objeto 10 de 11: `vw_ResumenTipoBicicleta`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Vista `vw_ResumenTipoBicicleta`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** un resumen por tipo de bicicleta, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de bicicleta tiene bicicletas, y cada bicicleta tiene rentas: el resumen junta **todas las rentas de todas las bicicletas** de cada tipo de bicicleta.

Un tipo de bicicleta puede no tener rentas todavía. También debe aparecer en el resumen, con 0 rentas y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoBicicleta` que muestre **una fila por tipo de bicicleta** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoBicicleta` | Nombre del tipo de bicicleta |
| `TarifaPorHora` | Tarifa por hora actual |
| `TotalRentas` | Cuántas rentas se han registrado con bicicletas de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × horas) |
| `UltimaRenta` | Fecha de la renta más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoBicicleta`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de bicicleta**, incluidos los que no tienen rentas: usa `LEFT JOIN` desde los tipos de bicicleta.
- [ ] Un tipo de bicicleta sin rentas sale con `TotalRentas = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaRenta = NULL`.
- [ ] `TotalRentas` cuenta rentas: para que un tipo de bicicleta sin rentas salga en 0, cuenta una columna de la tabla de rentas, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoBicicleta` regresa algo así:

| TipoBicicleta | TarifaPorHora | TotalRentas | TotalCobrado | UltimaRenta |
|---|---|---|---|---|
| Urbana | 45.00 | 7 | 1080.00 | 2026-05-09 |
| Montaña | 60.00 | 8 | 1860.00 | 2026-05-16 |
| Eléctrica | 95.00 | 5 | 1425.00 | 2026-05-02 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoBicicleta

-- 2. Dos rentas más de 'EL-0001' ($95.00)
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'
EXEC usp_registrarRenta @p_NumeroSerie = 'EL-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2
EXEC usp_registrarRenta @p_NumeroSerie = 'EL-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 3
SELECT * FROM vw_ResumenTipoBicicleta

-- 3. Un tipo de bicicleta nuevo, sin bicicletas. Como ningún procedimiento crea tipos de bicicleta,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeBicicleta> (<ColumnaNombre>, <ColumnaTarifaPorHora>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoBicicleta
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de 'Eléctrica': `TotalRentas` **+2**, `TotalCobrado` **+475.00** y `UltimaRenta` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de bicicleta nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
