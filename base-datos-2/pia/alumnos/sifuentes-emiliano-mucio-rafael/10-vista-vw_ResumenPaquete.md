# PIA MudaFacil — Objeto 10 de 11: `vw_ResumenPaquete`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Vista `vw_ResumenPaquete`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** un resumen por paquete, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Un paquete puede no tener mudanzas todavía. También debe aparecer en el resumen, con 0 mudanzas y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenPaquete` que muestre **una fila por paquete** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `Paquete` | Nombre del paquete |
| `Precio` | Precio por mudanza actual |
| `TotalMudanzas` | Cuántas mudanzas se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado) |
| `UltimaMudanza` | Fecha de la mudanza más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenPaquete`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada paquete**, incluidos los que no tienen mudanzas: usa `LEFT JOIN` desde los paquetes.
- [ ] Un paquete sin mudanzas sale con `TotalMudanzas = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaMudanza = NULL`.
- [ ] `TotalMudanzas` cuenta mudanzas: para que un paquete sin mudanzas salga en 0, cuenta una columna de la tabla de mudanzas, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenPaquete` regresa algo así:

| Paquete | Precio | TotalMudanzas | TotalCobrado | UltimaMudanza |
|---|---|---|---|---|
| Express | 1800.00 | 5 | 9000.00 | 2026-05-09 |
| Chico | 3500.00 | 6 | 21000.00 | 2026-05-23 |
| Mediano | 6000.00 | 5 | 30000.00 | 2026-05-02 |
| Grande | 8500.00 | 5 | 42500.00 | 2026-05-16 |
| Familiar | 11000.00 | 0 | 0.00 | NULL |
| Corporativo | 15000.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarMudanza`](05-procedimiento-usp_registrarMudanza.md), [`usp_insertarPaquete`](03-procedimiento-usp_insertarPaquete.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenPaquete

-- 2. Dos mudanzas más de 'Corporativo' ($15,000.00)
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarMudanza @p_NombrePaquete = 'Corporativo', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-01', @p_Cargadores = 3
EXEC usp_registrarMudanza @p_NombrePaquete = 'Corporativo', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-02', @p_Cargadores = 2
SELECT * FROM vw_ResumenPaquete

-- 3. Un paquete nuevo, sin mudanzas
EXEC usp_insertarPaquete @p_Nombre = 'Paquete de Prueba', @p_CapacidadToneladas = 2.0, @p_Precio = 100.00
SELECT * FROM vw_ResumenPaquete
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 6 filas |
| 2. Después de las dos nuevas | La fila de 'Corporativo': `TotalMudanzas` **+2**, `TotalCobrado` **+30000.00** y `UltimaMudanza` **2026-12-02**. Las demás no cambian |
| 3. Con el paquete nuevo | 7 filas. 'Paquete de Prueba': 100.00, 0, 0.00, NULL |
