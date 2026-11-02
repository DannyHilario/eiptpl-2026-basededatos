# PIA BiciRuta — Objeto 09 de 11: `vw_DetalleRenta`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Vista `vw_DetalleRenta`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** ver cada renta completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada renta guarda el **precio cobrado**, y el tipo de bicicleta tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleRenta` que muestre **todas** las rentas con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaRenta` | Fecha de la renta |
| `NumeroSerie` | Número de serie |
| `TipoBicicleta` | Nombre del tipo de bicicleta |
| `Cliente` | Nombre del cliente |
| `Horas` | Horas |
| `PrecioCobrado` | Precio que guarda la renta |
| `PrecioActual` | Precio actual del tipo de bicicleta |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleRenta`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de rentas con bicicletas, tipos de bicicleta y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por renta**: el número de filas de la vista es igual al de tu tabla de rentas.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleRenta WHERE FechaRenta >= '2026-12-01' ORDER BY FechaRenta`, después de la preparación de los casos de prueba:

| FechaRenta | NumeroSerie | TipoBicicleta | Cliente | Horas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | EL-0001 | Eléctrica | Cliente de Prueba | 2 | 95.00 | 105.00 | Subió |
| 2026-12-02 | EL-0001 | Eléctrica | Cliente de Prueba | 3 | 115.00 | 105.00 | Bajó |
| 2026-12-03 | EL-0001 | Eléctrica | Cliente de Prueba | 1 | 105.00 | 105.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarTarifaTipoBicicleta`](04-procedimiento-usp_actualizarTarifaTipoBicicleta.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: tres rentas de 'EL-0001', cada una con un precio distinto
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'
EXEC usp_registrarRenta @p_NumeroSerie = 'EL-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2
EXEC usp_actualizarTarifaTipoBicicleta @p_NombreTipoBicicleta = 'Eléctrica', @p_PrecioNuevo = 115.00
EXEC usp_registrarRenta @p_NumeroSerie = 'EL-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 3
EXEC usp_actualizarTarifaTipoBicicleta @p_NombreTipoBicicleta = 'Eléctrica', @p_PrecioNuevo = 105.00
EXEC usp_registrarRenta @p_NumeroSerie = 'EL-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-03', @p_Horas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleRenta WHERE FechaRenta >= '2026-12-01' ORDER BY FechaRenta

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleRenta
SELECT COUNT(*) AS Total FROM <TuTablaDeRentas>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus rentas más las 3 de prueba |
| Tus rentas inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
