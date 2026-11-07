# PIA QuintaSol — Objeto 09 de 11: `vw_DetalleEvento`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Vista `vw_DetalleEvento`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** ver cada evento completo con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratos o más caros que el precio actual.

## Contexto

Cada evento guarda el **precio cobrado**, y el tipo de quinta tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleEvento` que muestre **todos** los eventos con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaEvento` | Fecha del evento |
| `Quinta` | Nombre de quinta |
| `TipoQuinta` | Nombre del tipo de quinta |
| `Cliente` | Nombre del cliente |
| `Invitados` | Invitados |
| `PrecioCobrado` | Precio que guarda el evento |
| `PrecioActual` | Precio actual del tipo de quinta |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleEvento`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de eventos con quintas, tipos de quinta y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por evento**: el número de filas de la vista es igual al de tu tabla de eventos.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleEvento WHERE FechaEvento >= '2026-12-01' ORDER BY FechaEvento`, después de la preparación de los casos de prueba:

| FechaEvento | Quinta | TipoQuinta | Cliente | Invitados | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | Las Palmas | Grande | Cliente de Prueba | 80 | 8000.00 | 8800.00 | Subió |
| 2026-12-02 | Las Palmas | Grande | Cliente de Prueba | 120 | 9600.00 | 8800.00 | Bajó |
| 2026-12-03 | Las Palmas | Grande | Cliente de Prueba | 50 | 8800.00 | 8800.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarPrecioTipoQuinta`](04-procedimiento-usp_actualizarPrecioTipoQuinta.md), [`usp_registrarEvento`](05-procedimiento-usp_registrarEvento.md).

```sql
-- Preparación: tres eventos de 'Las Palmas', cada uno con un precio distinto
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'
EXEC usp_registrarEvento @p_NombreQuinta = 'Las Palmas', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Grande', @p_PrecioNuevo = 9600.00
EXEC usp_registrarEvento @p_NombreQuinta = 'Las Palmas', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 120
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Grande', @p_PrecioNuevo = 8800.00
EXEC usp_registrarEvento @p_NombreQuinta = 'Las Palmas', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-03', @p_Invitados = 50

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleEvento WHERE FechaEvento >= '2026-12-01' ORDER BY FechaEvento

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleEvento
SELECT COUNT(*) AS Total FROM <TuTablaDeEventos>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus eventos más las 3 de prueba |
| Tus eventos inventados | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
