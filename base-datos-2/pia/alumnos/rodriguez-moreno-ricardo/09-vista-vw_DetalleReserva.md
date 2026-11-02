# PIA EspacioUno — Objeto 09 de 11: `vw_DetalleReserva`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Vista `vw_DetalleReserva`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** ver cada reserva completa con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratas o más caras que el precio actual.

## Contexto

Cada reserva guarda el **precio cobrado**, y el tipo de espacio tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleReserva` que muestre **todas** las reservas con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaReserva` | Fecha de la reserva |
| `Espacio` | Nombre de espacio |
| `TipoEspacio` | Nombre del tipo de espacio |
| `Miembro` | Nombre del miembro |
| `Horas` | Horas |
| `PrecioCobrado` | Precio que guarda la reserva |
| `PrecioActual` | Precio actual del tipo de espacio |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleReserva`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de reservas con espacios, tipos de espacio y miembros (`INNER JOIN`).
- [ ] Tiene **una fila por reserva**: el número de filas de la vista es igual al de tu tabla de reservas.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleReserva WHERE FechaReserva >= '2026-12-01' ORDER BY FechaReserva`, después de la preparación de los casos de prueba:

| FechaReserva | Espacio | TipoEspacio | Miembro | Horas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | Sala Fundidora | Sala de juntas | Miembro de Prueba | 2 | 350.00 | 385.00 | Subió |
| 2026-12-02 | Sala Fundidora | Sala de juntas | Miembro de Prueba | 3 | 420.00 | 385.00 | Bajó |
| 2026-12-03 | Sala Fundidora | Sala de juntas | Miembro de Prueba | 1 | 385.00 | 385.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md), [`usp_actualizarTarifaTipoEspacio`](04-procedimiento-usp_actualizarTarifaTipoEspacio.md), [`usp_registrarReserva`](05-procedimiento-usp_registrarReserva.md).

```sql
-- Preparación: tres reservas de 'Sala Fundidora', cada una con un precio distinto
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'
EXEC usp_registrarReserva @p_NombreEspacio = 'Sala Fundidora', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2
EXEC usp_actualizarTarifaTipoEspacio @p_NombreTipoEspacio = 'Sala de juntas', @p_PrecioNuevo = 420.00
EXEC usp_registrarReserva @p_NombreEspacio = 'Sala Fundidora', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 3
EXEC usp_actualizarTarifaTipoEspacio @p_NombreTipoEspacio = 'Sala de juntas', @p_PrecioNuevo = 385.00
EXEC usp_registrarReserva @p_NombreEspacio = 'Sala Fundidora', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-03', @p_Horas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleReserva WHERE FechaReserva >= '2026-12-01' ORDER BY FechaReserva

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleReserva
SELECT COUNT(*) AS Total FROM <TuTablaDeReservas>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus reservas más las 3 de prueba |
| Tus reservas inventadas | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
