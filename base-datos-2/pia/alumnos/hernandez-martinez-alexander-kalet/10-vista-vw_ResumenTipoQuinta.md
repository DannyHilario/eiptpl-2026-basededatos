# PIA QuintaSol — Objeto 10 de 11: `vw_ResumenTipoQuinta`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Vista `vw_ResumenTipoQuinta`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** un resumen por tipo de quinta, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de quinta tiene quintas, y cada quinta tiene eventos: el resumen junta **todos los eventos de todas las quintas** de cada tipo de quinta.

Un tipo de quinta puede no tener eventos todavía. También debe aparecer en el resumen, con 0 eventos y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoQuinta` que muestre **una fila por tipo de quinta** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoQuinta` | Nombre del tipo de quinta |
| `PrecioPorDia` | Precio por día actual |
| `TotalEventos` | Cuántos eventos se han registrado con quintas de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado) |
| `UltimoEvento` | Fecha del evento más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoQuinta`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de quinta**, incluidos los que no tienen eventos: usa `LEFT JOIN` desde los tipos de quinta.
- [ ] Un tipo de quinta sin eventos sale con `TotalEventos = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimoEvento = NULL`.
- [ ] `TotalEventos` cuenta eventos: para que un tipo de quinta sin eventos salga en 0, cuenta una columna de la tabla de eventos, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoQuinta` regresa algo así:

| TipoQuinta | PrecioPorDia | TotalEventos | TotalCobrado | UltimoEvento |
|---|---|---|---|---|
| Chica | 3500.00 | 7 | 24500.00 | 2026-05-16 |
| Mediana | 5500.00 | 7 | 38500.00 | 2026-05-09 |
| Grande | 8000.00 | 7 | 56000.00 | 2026-05-23 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarEvento`](05-procedimiento-usp_registrarEvento.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoQuinta

-- 2. Dos eventos más de 'Las Palmas' ($8,000.00)
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'
EXEC usp_registrarEvento @p_NombreQuinta = 'Las Palmas', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80
EXEC usp_registrarEvento @p_NombreQuinta = 'Las Palmas', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 120
SELECT * FROM vw_ResumenTipoQuinta

-- 3. Un tipo de quinta nuevo, sin quintas. Como ningún procedimiento crea tipos de quinta,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeQuinta> (<ColumnaNombre>, <ColumnaPrecioPorDia>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoQuinta
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de 'Grande': `TotalEventos` **+2**, `TotalCobrado` **+16000.00** y `UltimoEvento` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de quinta nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
