# PIA EnigmaRoom — Objeto 09 de 11: `vw_DetallePartida`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Vista `vw_DetallePartida`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** ver cada partida completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada partida guarda el **precio cobrado**, y la sala de escape tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetallePartida` que muestre **todas** las partidas con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaPartida` | Fecha de la partida |
| `Cliente` | Nombre del cliente |
| `SalaEscape` | Sala de escape |
| `Jugadores` | Jugadores |
| `PrecioCobrado` | Precio que guarda la partida |
| `PrecioActual` | Precio actual de la sala de escape |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetallePartida`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de partidas con salas de escape y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por partida**: el número de filas de la vista es igual al de tu tabla de partidas.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetallePartida WHERE FechaPartida >= '2026-12-01' ORDER BY FechaPartida`, después de la preparación de los casos de prueba:

| FechaPartida | Cliente | SalaEscape | Jugadores | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Cliente de Prueba | El Gran Robo | 4 | 1000.00 | 1100.00 | Subió |
| 2026-12-02 | Cliente de Prueba | El Gran Robo | 5 | 1200.00 | 1100.00 | Bajó |
| 2026-12-03 | Cliente de Prueba | El Gran Robo | 3 | 1100.00 | 1100.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarPrecioSalaEscape`](04-procedimiento-usp_actualizarPrecioSalaEscape.md), [`usp_registrarPartida`](05-procedimiento-usp_registrarPartida.md).

```sql
-- Preparación: tres partidas de 'El Gran Robo', cada una con un precio distinto
EXEC usp_insertarCliente @p_NombreMedio = 'Redes sociales', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Gran Robo', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Gran Robo', @p_PrecioNuevo = 1200.00
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Gran Robo', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 5
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Gran Robo', @p_PrecioNuevo = 1100.00
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Gran Robo', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-03', @p_Jugadores = 3

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetallePartida WHERE FechaPartida >= '2026-12-01' ORDER BY FechaPartida

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetallePartida
SELECT COUNT(*) AS Total FROM <TuTablaDePartidas>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus partidas más las 3 de prueba |
| Tus partidas inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
