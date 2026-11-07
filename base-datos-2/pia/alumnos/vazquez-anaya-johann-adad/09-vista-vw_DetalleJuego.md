# PIA StrikeMax — Objeto 09 de 11: `vw_DetalleJuego`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Vista `vw_DetalleJuego`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** ver cada juego completo con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratos o más caros que el precio actual.

## Contexto

Cada juego guarda el **precio cobrado**, y el tipo de pista tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleJuego` que muestre **todos** los juegos con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaJuego` | Fecha del juego |
| `NumeroPista` | Número de pista |
| `TipoPista` | Nombre del tipo de pista |
| `Cliente` | Nombre del cliente |
| `Lineas` | Líneas |
| `PrecioCobrado` | Precio que guarda el juego |
| `PrecioActual` | Precio actual del tipo de pista |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleJuego`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de juegos con pistas, tipos de pista y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por juego**: el número de filas de la vista es igual al de tu tabla de juegos.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleJuego WHERE FechaJuego >= '2026-12-01' ORDER BY FechaJuego`, después de la preparación de los casos de prueba:

| FechaJuego | NumeroPista | TipoPista | Cliente | Lineas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | 7 | VIP | Cliente de Prueba | 2 | 150.00 | 165.00 | Subió |
| 2026-12-02 | 7 | VIP | Cliente de Prueba | 3 | 180.00 | 165.00 | Bajó |
| 2026-12-03 | 7 | VIP | Cliente de Prueba | 1 | 165.00 | 165.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarTarifaTipoPista`](04-procedimiento-usp_actualizarTarifaTipoPista.md), [`usp_registrarJuego`](05-procedimiento-usp_registrarJuego.md).

```sql
-- Preparación: tres juegos de 7, cada uno con un precio distinto
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'
EXEC usp_registrarJuego @p_NumeroPista = 7, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 2
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'VIP', @p_PrecioNuevo = 180.00
EXEC usp_registrarJuego @p_NumeroPista = 7, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-02', @p_Lineas = 3
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'VIP', @p_PrecioNuevo = 165.00
EXEC usp_registrarJuego @p_NumeroPista = 7, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-03', @p_Lineas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleJuego WHERE FechaJuego >= '2026-12-01' ORDER BY FechaJuego

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleJuego
SELECT COUNT(*) AS Total FROM <TuTablaDeJuegos>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus juegos más las 3 de prueba |
| Tus juegos inventados | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
