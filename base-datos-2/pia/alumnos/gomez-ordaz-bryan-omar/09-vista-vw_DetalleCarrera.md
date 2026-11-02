# PIA VeloKart — Objeto 09 de 11: `vw_DetalleCarrera`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Vista `vw_DetalleCarrera`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** ver cada carrera completa, con lo que se cobró y lo que costaría hoy, **para** saber qué carreras se cobraron más baratas o más caras que el precio actual.

## Contexto

Una carrera, por sí sola, guarda ids. Para leerla hacen falta el número del kart, su tipo y el nombre del piloto, que están en otras tablas.

Además, cada carrera guarda el **precio cobrado** y el tipo de kart tiene su **precio actual**. Si el precio cambió después de la carrera, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleCarrera` que muestre **todas** las carreras con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaCarrera` | Día de la carrera |
| `NumeroKart` | Número del kart |
| `TipoKart` | Nombre del tipo de kart |
| `Piloto` | Nombre del piloto |
| `MejorVuelta` | Mejor vuelta, en segundos |
| `PrecioCobrado` | Precio que guarda la carrera |
| `PrecioActual` | Precio por carrera actual del tipo de kart |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleCarrera`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de carreras con karts, tipos de kart y pilotos (`INNER JOIN`).
- [ ] Tiene **una fila por carrera**: el número de filas de la vista es igual al de tu tabla de carreras.
- [ ] `PrecioCobrado` sale de la carrera y `PrecioActual` del tipo de kart.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`, según la tabla del contexto.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleCarrera WHERE FechaCarrera >= '2026-12-01'`, después de la preparación de los casos de prueba:

| FechaCarrera | NumeroKart | TipoKart | Piloto | MejorVuelta | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | K-12 | Profesional | Piloto de Prueba | 38.40 | 350.00 | 380.00 | Subió |
| 2026-12-02 | K-12 | Profesional | Piloto de Prueba | 38.10 | 400.00 | 380.00 | Bajó |
| 2026-12-03 | K-12 | Profesional | Piloto de Prueba | 37.95 | 380.00 | 380.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan los procedimientos [01](01-procedimiento-usp_insertarPiloto.md), [04](04-procedimiento-usp_actualizarPrecioTipoKart.md) y [05](05-procedimiento-usp_registrarCarrera.md).

```sql
-- Preparación: tres carreras del K-12 (Profesional), cada una con un precio distinto
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175
EXEC usp_registrarCarrera @p_NumeroKart = 'K-12', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-01', @p_MejorVuelta = 38.40
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = 400.00
EXEC usp_registrarCarrera @p_NumeroKart = 'K-12', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-02', @p_MejorVuelta = 38.10
EXEC usp_actualizarPrecioTipoKart @p_NombreTipoKart = 'Profesional', @p_PrecioNuevo = 380.00
EXEC usp_registrarCarrera @p_NumeroKart = 'K-12', @p_TelefonoPiloto = '8199990001', @p_FechaCarrera = '2026-12-03', @p_MejorVuelta = 37.95

-- Las tres carreras de prueba: Subió, Bajó y Sin cambio (ver el ejemplo de arriba)
SELECT * FROM vw_DetalleCarrera WHERE FechaCarrera >= '2026-12-01'

-- Una fila por carrera: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleCarrera
SELECT COUNT(*) AS Total FROM <TuTablaDeCarreras>
```

| Caso | Resultado esperado |
|---|---|
| Carreras de diciembre de 2026 | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus carreras más las 3 de prueba |
| Tus carreras inventadas | Todas en *Sin cambio*, porque en tus datos cada carrera se cobró con el precio de su tipo |
