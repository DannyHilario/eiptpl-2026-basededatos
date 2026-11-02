# PIA GameZone — Objeto 10 de 11: `vw_ResumenTipoConsola`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Vista `vw_ResumenTipoConsola`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** un resumen por tipo de consola, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de consola tiene estaciones, y cada estación tiene sesiones: el resumen junta **todas las sesiones de todas las estaciones** de cada tipo de consola.

Un tipo de consola puede no tener sesiones todavía. También debe aparecer en el resumen, con 0 sesiones y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoConsola` que muestre **una fila por tipo de consola** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoConsola` | Nombre del tipo de consola |
| `TarifaPorHora` | Tarifa por hora actual |
| `TotalSesiones` | Cuántas sesiones se han registrado con estaciones de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × horas) |
| `UltimaSesion` | Fecha de la sesión más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoConsola`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de consola**, incluidos los que no tienen sesiones: usa `LEFT JOIN` desde los tipos de consola.
- [ ] Un tipo de consola sin sesiones sale con `TotalSesiones = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaSesion = NULL`.
- [ ] `TotalSesiones` cuenta sesiones: para que un tipo de consola sin sesiones salga en 0, cuenta una columna de la tabla de sesiones, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoConsola` regresa algo así:

| TipoConsola | TarifaPorHora | TotalSesiones | TotalCobrado | UltimaSesion |
|---|---|---|---|---|
| PlayStation 5 | 60.00 | 7 | 1200.00 | 2026-05-01 |
| Xbox Series X | 55.00 | 5 | 825.00 | 2026-05-15 |
| Nintendo Switch | 45.00 | 5 | 360.00 | 2026-05-08 |
| PC Gamer | 75.00 | 3 | 750.00 | 2026-04-24 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md), [`usp_registrarSesion`](05-procedimiento-usp_registrarSesion.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoConsola

-- 2. Dos sesiones más de 'E-09' ($75.00)
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-09', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-01', @p_Horas = 2
EXEC usp_registrarSesion @p_NumeroEstacion = 'E-09', @p_Gamertag = 'Prueba01', @p_FechaSesion = '2026-12-02', @p_Horas = 3
SELECT * FROM vw_ResumenTipoConsola

-- 3. Un tipo de consola nuevo, sin estaciones. Como ningún procedimiento crea tipos de consola,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeConsola> (<ColumnaNombre>, <ColumnaTarifaPorHora>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoConsola
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 4 filas |
| 2. Después de las dos nuevas | La fila de 'PC Gamer': `TotalSesiones` **+2**, `TotalCobrado` **+375.00** y `UltimaSesion` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de consola nuevo | 5 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
