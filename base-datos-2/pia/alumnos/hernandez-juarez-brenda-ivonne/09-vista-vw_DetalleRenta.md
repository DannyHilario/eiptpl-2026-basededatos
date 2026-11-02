# PIA CampoVerde — Objeto 09 de 11: `vw_DetalleRenta`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Vista `vw_DetalleRenta`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** ver cada renta completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada renta guarda el **precio cobrado**, y el tipo de casa de campaña tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

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
| `FechaLlegada` | Fecha de la renta |
| `CodigoTienda` | Código |
| `TipoTienda` | Nombre del tipo de casa de campaña |
| `Campista` | Nombre del campista |
| `Noches` | Noches |
| `PrecioCobrado` | Precio que guarda la renta |
| `PrecioActual` | Precio actual del tipo de casa de campaña |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleRenta`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de rentas con casas de campaña, tipos de casa de campaña y campistas (`INNER JOIN`).
- [ ] Tiene **una fila por renta**: el número de filas de la vista es igual al de tu tabla de rentas.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleRenta WHERE FechaLlegada >= '2026-12-01' ORDER BY FechaLlegada`, después de la preparación de los casos de prueba:

| FechaLlegada | CodigoTienda | TipoTienda | Campista | Noches | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | T-05 | 6 personas | Campista de Prueba | 2 | 520.00 | 570.00 | Subió |
| 2026-12-02 | T-05 | 6 personas | Campista de Prueba | 3 | 620.00 | 570.00 | Bajó |
| 2026-12-03 | T-05 | 6 personas | Campista de Prueba | 1 | 570.00 | 570.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCampista`](01-procedimiento-usp_insertarCampista.md), [`usp_actualizarPrecioTipoTienda`](04-procedimiento-usp_actualizarPrecioTipoTienda.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: tres rentas de 'T-05', cada una con un precio distinto
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'
EXEC usp_registrarRenta @p_CodigoTienda = 'T-05', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '6 personas', @p_PrecioNuevo = 620.00
EXEC usp_registrarRenta @p_CodigoTienda = 'T-05', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-02', @p_Noches = 3
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '6 personas', @p_PrecioNuevo = 570.00
EXEC usp_registrarRenta @p_CodigoTienda = 'T-05', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-03', @p_Noches = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleRenta WHERE FechaLlegada >= '2026-12-01' ORDER BY FechaLlegada

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleRenta
SELECT COUNT(*) AS Total FROM <TuTablaDeRentas>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus rentas más las 3 de prueba |
| Tus rentas inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
