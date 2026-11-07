# PIA MudaFacil — Objeto 09 de 11: `vw_DetalleMudanza`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Vista `vw_DetalleMudanza`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** ver cada mudanza completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada mudanza guarda el **precio cobrado**, y el paquete tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleMudanza` que muestre **todas** las mudanzas con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaMudanza` | Fecha de la mudanza |
| `Cliente` | Nombre del cliente |
| `Paquete` | Paquete |
| `Cargadores` | Cargadores |
| `PrecioCobrado` | Precio que guarda la mudanza |
| `PrecioActual` | Precio actual del paquete |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleMudanza`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de mudanzas con paquetes y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por mudanza**: el número de filas de la vista es igual al de tu tabla de mudanzas.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleMudanza WHERE FechaMudanza >= '2026-12-01' ORDER BY FechaMudanza`, después de la preparación de los casos de prueba:

| FechaMudanza | Cliente | Paquete | Cargadores | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Cliente de Prueba | Mediano | 3 | 6000.00 | 6600.00 | Subió |
| 2026-12-02 | Cliente de Prueba | Mediano | 2 | 7200.00 | 6600.00 | Bajó |
| 2026-12-03 | Cliente de Prueba | Mediano | 4 | 6600.00 | 6600.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarPrecioPaquete`](04-procedimiento-usp_actualizarPrecioPaquete.md), [`usp_registrarMudanza`](05-procedimiento-usp_registrarMudanza.md).

```sql
-- Preparación: tres mudanzas de 'Mediano', cada una con un precio distinto
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarMudanza @p_NombrePaquete = 'Mediano', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-01', @p_Cargadores = 3
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Mediano', @p_PrecioNuevo = 7200.00
EXEC usp_registrarMudanza @p_NombrePaquete = 'Mediano', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-02', @p_Cargadores = 2
EXEC usp_actualizarPrecioPaquete @p_NombrePaquete = 'Mediano', @p_PrecioNuevo = 6600.00
EXEC usp_registrarMudanza @p_NombrePaquete = 'Mediano', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-03', @p_Cargadores = 4

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleMudanza WHERE FechaMudanza >= '2026-12-01' ORDER BY FechaMudanza

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleMudanza
SELECT COUNT(*) AS Total FROM <TuTablaDeMudanzas>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus mudanzas más las 3 de prueba |
| Tus mudanzas inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
