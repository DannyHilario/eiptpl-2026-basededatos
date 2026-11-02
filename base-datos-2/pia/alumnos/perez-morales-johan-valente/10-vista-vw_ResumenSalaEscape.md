# PIA EnigmaRoom — Objeto 10 de 11: `vw_ResumenSalaEscape`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Vista `vw_ResumenSalaEscape`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** un resumen por sala de escape, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Una sala de escape puede no tener partidas todavía. También debe aparecer en el resumen, con 0 partidas y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenSalaEscape` que muestre **una fila por sala de escape** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `SalaEscape` | Nombre de la sala de escape |
| `Precio` | Precio por partida actual |
| `TotalPartidas` | Cuántas partidas se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado) |
| `UltimaPartida` | Fecha de la partida más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenSalaEscape`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada sala de escape**, incluidas las que no tienen partidas: usa `LEFT JOIN` desde las salas de escape.
- [ ] Una sala de escape sin partidas sale con `TotalPartidas = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimaPartida = NULL`.
- [ ] `TotalPartidas` cuenta partidas: para que una sala de escape sin partidas salga en 0, cuenta una columna de la tabla de partidas, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenSalaEscape` regresa algo así:

| SalaEscape | Precio | TotalPartidas | TotalCobrado | UltimaPartida |
|---|---|---|---|---|
| El Laboratorio | 900.00 | 6 | 5400.00 | 2026-05-09 |
| La Cripta | 1100.00 | 5 | 5500.00 | 2026-04-18 |
| El Gran Robo | 1000.00 | 4 | 4000.00 | 2026-05-23 |
| La Cabaña | 800.00 | 6 | 4800.00 | 2026-05-16 |
| El Submarino | 950.00 | 0 | 0.00 | NULL |
| La Escuela de Magia | 750.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarPartida`](05-procedimiento-usp_registrarPartida.md), [`usp_insertarSalaEscape`](03-procedimiento-usp_insertarSalaEscape.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenSalaEscape

-- 2. Dos partidas más de 'La Escuela de Magia' ($750.00)
EXEC usp_insertarCliente @p_NombreMedio = 'Redes sociales', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarPartida @p_NombreSalaEscape = 'La Escuela de Magia', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4
EXEC usp_registrarPartida @p_NombreSalaEscape = 'La Escuela de Magia', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 5
SELECT * FROM vw_ResumenSalaEscape

-- 3. Una sala de escape nueva, sin partidas
EXEC usp_insertarSalaEscape @p_Nombre = 'Sala de Prueba', @p_Tema = 'Piratas', @p_Dificultad = 2, @p_Precio = 100.00
SELECT * FROM vw_ResumenSalaEscape
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 6 filas |
| 2. Después de las dos nuevas | La fila de 'La Escuela de Magia': `TotalPartidas` **+2**, `TotalCobrado` **+1500.00** y `UltimaPartida` **2026-12-02**. Las demás no cambian |
| 3. Con la sala de escape nueva | 7 filas. 'Sala de Prueba': 100.00, 0, 0.00, NULL |
