# PIA StrikeMax — Objeto 10 de 11: `vw_ResumenTipoPista`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Vista `vw_ResumenTipoPista`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** un resumen por tipo de pista, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de pista tiene pistas, y cada pista tiene juegos: el resumen junta **todos los juegos de todas las pistas** de cada tipo de pista.

Un tipo de pista puede no tener juegos todavía. También debe aparecer en el resumen, con 0 juegos y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoPista` que muestre **una fila por tipo de pista** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoPista` | Nombre del tipo de pista |
| `TarifaPorLinea` | Tarifa por línea actual |
| `TotalJuegos` | Cuántos juegos se han registrado con pistas de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × líneas) |
| `UltimoJuego` | Fecha del juego más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoPista`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de pista**, incluidos los que no tienen juegos: usa `LEFT JOIN` desde los tipos de pista.
- [ ] Un tipo de pista sin juegos sale con `TotalJuegos = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimoJuego = NULL`.
- [ ] `TotalJuegos` cuenta juegos: para que un tipo de pista sin juegos salga en 0, cuenta una columna de la tabla de juegos, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoPista` regresa algo así:

| TipoPista | TarifaPorLinea | TotalJuegos | TotalCobrado | UltimoJuego |
|---|---|---|---|---|
| Normal | 90.00 | 10 | 2970.00 | 2026-05-23 |
| Infantil | 70.00 | 5 | 560.00 | 2026-05-16 |
| VIP | 150.00 | 6 | 2700.00 | 2026-05-09 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarJuego`](05-procedimiento-usp_registrarJuego.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoPista

-- 2. Dos juegos más de 7 ($150.00)
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'
EXEC usp_registrarJuego @p_NumeroPista = 7, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 2
EXEC usp_registrarJuego @p_NumeroPista = 7, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-02', @p_Lineas = 3
SELECT * FROM vw_ResumenTipoPista

-- 3. Un tipo de pista nuevo, sin pistas. Como ningún procedimiento crea tipos de pista,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDePista> (<ColumnaNombre>, <ColumnaTarifaPorLinea>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoPista
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de 'VIP': `TotalJuegos` **+2**, `TotalCobrado` **+750.00** y `UltimoJuego` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de pista nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
