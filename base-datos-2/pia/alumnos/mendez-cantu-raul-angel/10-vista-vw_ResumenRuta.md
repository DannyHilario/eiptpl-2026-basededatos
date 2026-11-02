# PIA RutaNorte — Objeto 10 de 11: `vw_ResumenRuta`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Vista `vw_ResumenRuta`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** un resumen por ruta, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Una ruta puede no tener boletos todavía. También debe aparecer en el resumen, con 0 boletos y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenRuta` que muestre **una fila por ruta** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `ClaveRuta` | Nombre de la ruta |
| `Precio` | Precio actual |
| `TotalBoletos` | Cuántos boletos se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado) |
| `UltimoBoleto` | Fecha del boleto más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenRuta`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada ruta**, incluidas las que no tienen boletos: usa `LEFT JOIN` desde las rutas.
- [ ] Una ruta sin boletos sale con `TotalBoletos = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimoBoleto = NULL`.
- [ ] `TotalBoletos` cuenta boletos: para que una ruta sin boletos salga en 0, cuenta una columna de la tabla de boletos, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenRuta` regresa algo así:

| ClaveRuta | Precio | TotalBoletos | TotalCobrado | UltimoBoleto |
|---|---|---|---|---|
| MTY-SAL | 180.00 | 5 | 900.00 | 2026-05-09 |
| MTY-REY | 420.00 | 5 | 2100.00 | 2026-05-23 |
| MTY-NLD | 450.00 | 3 | 1350.00 | 2026-05-02 |
| MTY-TRC | 520.00 | 4 | 2080.00 | 2026-05-30 |
| MTY-SLP | 780.00 | 5 | 3900.00 | 2026-05-30 |
| MTY-MAT | 500.00 | 0 | 0.00 | NULL |
| MTY-SMA | 1150.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md), [`usp_registrarBoleto`](05-procedimiento-usp_registrarBoleto.md), [`usp_insertarRuta`](03-procedimiento-usp_insertarRuta.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenRuta

-- 2. Dos boletos más de 'MTY-SMA' ($1,150.00)
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SMA', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SMA', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 20
SELECT * FROM vw_ResumenRuta

-- 3. Una ruta nueva, sin boletos
EXEC usp_insertarRuta @p_Clave = 'MTY-ZAC', @p_Origen = 'Monterrey', @p_Destino = 'Zacatecas', @p_DuracionHoras = 6, @p_Precio = 100.00
SELECT * FROM vw_ResumenRuta
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 7 filas |
| 2. Después de las dos nuevas | La fila de 'MTY-SMA': `TotalBoletos` **+2**, `TotalCobrado` **+2300.00** y `UltimoBoleto` **2026-12-02**. Las demás no cambian |
| 3. Con la ruta nueva | 8 filas. 'MTY-ZAC': 100.00, 0, 0.00, NULL |
