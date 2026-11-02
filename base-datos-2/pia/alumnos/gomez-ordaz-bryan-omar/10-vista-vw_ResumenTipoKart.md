# PIA VeloKart — Objeto 10 de 11: `vw_ResumenTipoKart`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Vista `vw_ResumenTipoKart`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** un resumen por tipo de kart, **para** saber qué tipo se usa más, cuánto deja cada uno y cuál es el récord de vuelta de cada tipo.

## Contexto

Un tipo de kart tiene karts, y cada kart tiene carreras. El resumen junta **todas las carreras de todos los karts** de cada tipo.

Un tipo puede no tener carreras todavía (por ejemplo, un tipo nuevo del que aún no se compran karts). Ese tipo **también debe aparecer** en el resumen, con 0 carreras y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoKart` que muestre **una fila por tipo de kart** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoKart` | Nombre del tipo de kart |
| `PrecioPorCarrera` | Precio por carrera actual del tipo |
| `TotalCarreras` | Cuántas carreras se han corrido con karts de ese tipo |
| `TotalCobrado` | Suma del precio cobrado de esas carreras |
| `MejorVuelta` | La vuelta más rápida (la menor) de esas carreras |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoKart`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MIN`.
- [ ] Tiene **una fila por cada tipo de kart**, incluidos los que no tienen carreras: usa `LEFT JOIN` desde los tipos de kart.
- [ ] Un tipo sin carreras sale con `TotalCarreras = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `MejorVuelta = NULL`.
- [ ] `TotalCarreras` cuenta carreras, no karts: para que un tipo sin carreras salga en 0, cuenta una columna de la tabla de carreras, no `COUNT(*)`.
- [ ] `TotalCobrado` suma el **precio cobrado** de cada carrera, no el precio actual.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoKart` regresa algo así:

| TipoKart | PrecioPorCarrera | TotalCarreras | TotalCobrado | MejorVuelta |
|---|---|---|---|---|
| Estándar | 250.00 | 8 | 2000.00 | 40.90 |
| Infantil | 180.00 | 6 | 1080.00 | 50.95 |
| Profesional | 350.00 | 7 | 2450.00 | 37.55 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPiloto`](01-procedimiento-usp_insertarPiloto.md) y [`usp_registrarCarrera`](05-procedimiento-usp_registrarCarrera.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos: 3 filas. Anota los valores de Profesional
SELECT * FROM vw_ResumenTipoKart

-- 2. Dos carreras más en el K-13 (Profesional, $350.00), con una vuelta récord de 35.10
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175
EXEC usp_registrarCarrera @p_NumeroKart = 'K-13', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 35.10
EXEC usp_registrarCarrera @p_NumeroKart = 'K-13', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 36.20
SELECT * FROM vw_ResumenTipoKart

-- 3. Un tipo nuevo, sin karts. Como ningún procedimiento crea tipos,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeKart> (<ColumnaNombre>, <ColumnaPrecio>) VALUES ('Doble', 400.00)
SELECT * FROM vw_ResumenTipoKart
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas: Estándar, Infantil y Profesional |
| 2. Después de las dos carreras | Profesional: `TotalCarreras` **+2**, `TotalCobrado` **+700.00** y `MejorVuelta` **35.10** (si ninguna de tus carreras de Profesional es más rápida). Estándar e Infantil no cambian |
| 3. Con el tipo Doble | 4 filas. Doble: `PrecioPorCarrera` 400.00, `TotalCarreras` 0, `TotalCobrado` 0.00, `MejorVuelta` NULL |
