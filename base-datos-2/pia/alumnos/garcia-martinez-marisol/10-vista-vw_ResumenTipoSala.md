# PIA SalaRock — Objeto 10 de 11: `vw_ResumenTipoSala`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Vista `vw_ResumenTipoSala`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** un resumen por tipo de sala, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de sala tiene salas, y cada sala tiene ensayos: el resumen junta **todos los ensayos de todas las salas** de cada tipo de sala.

Un tipo de sala puede no tener ensayos todavía. También debe aparecer en el resumen, con 0 ensayos y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoSala` que muestre **una fila por tipo de sala** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoSala` | Nombre del tipo de sala |
| `TarifaPorHora` | Tarifa por hora actual |
| `TotalEnsayos` | Cuántos ensayos se han registrado con salas de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × horas) |
| `UltimoEnsayo` | Fecha del ensayo más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoSala`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de sala**, incluidos los que no tienen ensayos: usa `LEFT JOIN` desde los tipos de sala.
- [ ] Un tipo de sala sin ensayos sale con `TotalEnsayos = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimoEnsayo = NULL`.
- [ ] `TotalEnsayos` cuenta ensayos: para que un tipo de sala sin ensayos salga en 0, cuenta una columna de la tabla de ensayos, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoSala` regresa algo así:

| TipoSala | TarifaPorHora | TotalEnsayos | TotalCobrado | UltimoEnsayo |
|---|---|---|---|---|
| Chica | 150.00 | 7 | 2550.00 | 2026-05-08 |
| Mediana | 220.00 | 7 | 3740.00 | 2026-05-22 |
| Grande | 300.00 | 8 | 6600.00 | 2026-05-29 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md), [`usp_registrarEnsayo`](05-procedimiento-usp_registrarEnsayo.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoSala

-- 2. Dos ensayos más de 'Sala Lennon' ($300.00)
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Lennon', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Lennon', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 3
SELECT * FROM vw_ResumenTipoSala

-- 3. Un tipo de sala nuevo, sin salas. Como ningún procedimiento crea tipos de sala,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeSala> (<ColumnaNombre>, <ColumnaTarifaPorHora>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoSala
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de 'Grande': `TotalEnsayos` **+2**, `TotalCobrado` **+1500.00** y `UltimoEnsayo` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de sala nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
