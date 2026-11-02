# PIA EspacioUno — Objeto 06 de 11: `usp_obtenerReservasPorFecha`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerReservasPorFecha`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** ver las reservas de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las reservas de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerReservasPorFecha` que valide el rango y regrese las reservas.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_FechaInicio` | `date` | Primer día del rango |
| `@p_FechaFin` | `date` | Último día del rango |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La fecha inicial no es posterior a la final | `000001` | La fecha inicial es posterior a la fecha final |

**Columnas del resultado**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaReserva` | Fecha de la reserva |
| `Espacio` | Espacio |
| `Miembro` | Nombre del miembro |
| `Horas` | Horas |
| `PrecioCobrado` | Precio con el que se cobró la reserva |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerReservasPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaReserva` y, en un mismo día, por `Espacio`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerReservasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaReserva | Espacio | Miembro | Horas | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | Oficina Cerro de la Silla | Miembro de Prueba | 3 | 200.00 |
| 2026-12-02 | Escritorio Ventana | Miembro de Prueba | 1 | 80.00 |
| 2026-12-02 | Sala Fundidora | Miembro de Prueba | 2 | 350.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md), [`usp_registrarReserva`](05-procedimiento-usp_registrarReserva.md).

```sql
-- Preparación: el miembro de prueba y tres reservas de diciembre, registradas en desorden
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'
EXEC usp_registrarReserva @p_NombreEspacio = 'Sala Fundidora', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 2
EXEC usp_registrarReserva @p_NombreEspacio = 'Oficina Cerro de la Silla', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 3
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerReservasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerReservasPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerReservasPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerReservasPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
