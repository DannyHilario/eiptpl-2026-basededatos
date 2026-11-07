# PIA SalaRock — Objeto 09 de 11: `vw_DetalleEnsayo`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Vista `vw_DetalleEnsayo`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** ver cada ensayo completo con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratos o más caros que el precio actual.

## Contexto

Cada ensayo guarda el **precio cobrado**, y el tipo de sala tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleEnsayo` que muestre **todos** los ensayos con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaEnsayo` | Fecha del ensayo |
| `Sala` | Nombre de sala |
| `TipoSala` | Nombre del tipo de sala |
| `Banda` | Nombre de la banda |
| `Horas` | Horas |
| `PrecioCobrado` | Precio que guarda el ensayo |
| `PrecioActual` | Precio actual del tipo de sala |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleEnsayo`.
- [ ] Regresa las 8 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de ensayos con salas, tipos de sala y bandas (`INNER JOIN`).
- [ ] Tiene **una fila por ensayo**: el número de filas de la vista es igual al de tu tabla de ensayos.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetalleEnsayo WHERE FechaEnsayo >= '2026-12-01' ORDER BY FechaEnsayo`, después de la preparación de los casos de prueba:

| FechaEnsayo | Sala | TipoSala | Banda | Horas | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|---|
| 2026-12-01 | Sala Lennon | Grande | Banda de Prueba | 2 | 300.00 | 330.00 | Subió |
| 2026-12-02 | Sala Lennon | Grande | Banda de Prueba | 3 | 360.00 | 330.00 | Bajó |
| 2026-12-03 | Sala Lennon | Grande | Banda de Prueba | 1 | 330.00 | 330.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md), [`usp_actualizarTarifaTipoSala`](04-procedimiento-usp_actualizarTarifaTipoSala.md), [`usp_registrarEnsayo`](05-procedimiento-usp_registrarEnsayo.md).

```sql
-- Preparación: tres ensayos de 'Sala Lennon', cada uno con un precio distinto
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Lennon', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2
EXEC usp_actualizarTarifaTipoSala @p_NombreTipoSala = 'Grande', @p_PrecioNuevo = 360.00
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Lennon', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 3
EXEC usp_actualizarTarifaTipoSala @p_NombreTipoSala = 'Grande', @p_PrecioNuevo = 330.00
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Lennon', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-03', @p_Horas = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetalleEnsayo WHERE FechaEnsayo >= '2026-12-01' ORDER BY FechaEnsayo

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetalleEnsayo
SELECT COUNT(*) AS Total FROM <TuTablaDeEnsayos>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus ensayos más las 3 de prueba |
| Tus ensayos inventados | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
