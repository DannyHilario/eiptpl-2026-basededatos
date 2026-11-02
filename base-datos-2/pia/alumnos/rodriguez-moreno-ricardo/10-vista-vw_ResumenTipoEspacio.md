# PIA EspacioUno — Objeto 10 de 11: `vw_ResumenTipoEspacio`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Vista `vw_ResumenTipoEspacio`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** un resumen por tipo de espacio, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto

Cada tipo de espacio tiene espacios, y cada espacio tiene reservas: el resumen junta **todas las reservas de todos los espacios** de cada tipo de espacio.

Un tipo de espacio puede no tener reservas todavía. También debe aparecer en el resumen, con 0 reservas y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenTipoEspacio` que muestre **una fila por tipo de espacio** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `TipoEspacio` | Nombre del tipo de espacio |
| `TarifaPorHora` | Tarifa por hora actual |
| `TotalReservas` | Cuántas reservas se han registrado con espacios de ese tipo |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × horas) |
| `UltimaReserva` | Fecha de la reserva más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenTipoEspacio`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada tipo de espacio**, incluidos los que no tienen reservas: usa `LEFT JOIN` desde los tipos de espacio.
- [ ] Un tipo de espacio sin reservas sale con `TotalReservas = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaReserva = NULL`.
- [ ] `TotalReservas` cuenta reservas: para que un tipo de espacio sin reservas salga en 0, cuenta una columna de la tabla de reservas, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenTipoEspacio` regresa algo así:

| TipoEspacio | TarifaPorHora | TotalReservas | TotalCobrado | UltimaReserva |
|---|---|---|---|---|
| Escritorio | 80.00 | 9 | 2960.00 | 2026-05-20 |
| Oficina privada | 200.00 | 6 | 6600.00 | 2026-05-13 |
| Sala de juntas | 350.00 | 6 | 5250.00 | 2026-05-06 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md), [`usp_registrarReserva`](05-procedimiento-usp_registrarReserva.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenTipoEspacio

-- 2. Dos reservas más de 'Sala Fundidora' ($350.00)
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'
EXEC usp_registrarReserva @p_NombreEspacio = 'Sala Fundidora', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2
EXEC usp_registrarReserva @p_NombreEspacio = 'Sala Fundidora', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 3
SELECT * FROM vw_ResumenTipoEspacio

-- 3. Un tipo de espacio nuevo, sin espacios. Como ningún procedimiento crea tipos de espacio,
-- insértalo directamente en tu tabla (cambia los nombres por los de tu modelo;
-- si tu tabla pide otra columna sin DEFAULT, como la de activo, agrégala)
INSERT INTO <TuTablaDeTiposDeEspacio> (<ColumnaNombre>, <ColumnaTarifaPorHora>) VALUES ('Nuevo tipo', 100.00)
SELECT * FROM vw_ResumenTipoEspacio
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 3 filas |
| 2. Después de las dos nuevas | La fila de 'Sala de juntas': `TotalReservas` **+2**, `TotalCobrado` **+1750.00** y `UltimaReserva` **2026-12-02**. Las demás no cambian |
| 3. Con el tipo de espacio nuevo | 4 filas. 'Nuevo tipo': 100.00, 0, 0.00, NULL |
