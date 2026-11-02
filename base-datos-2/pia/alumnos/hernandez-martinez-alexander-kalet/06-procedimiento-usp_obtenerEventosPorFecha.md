# PIA QuintaSol — Objeto 06 de 11: `usp_obtenerEventosPorFecha`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerEventosPorFecha`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** ver los eventos de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa los eventos de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerEventosPorFecha` que valide el rango y regrese los eventos.

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
| `FechaEvento` | Fecha del evento |
| `Quinta` | Quinta |
| `Cliente` | Nombre del cliente |
| `Invitados` | Invitados |
| `PrecioCobrado` | Precio con el que se cobró el evento |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerEventosPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaEvento` y, en un mismo día, por `Quinta`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerEventosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaEvento | Quinta | Cliente | Invitados | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | Los Nogales | Cliente de Prueba | 120 | 5500.00 |
| 2026-12-02 | El Encino | Cliente de Prueba | 50 | 3500.00 |
| 2026-12-02 | Las Palmas | Cliente de Prueba | 80 | 8000.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarEvento`](05-procedimiento-usp_registrarEvento.md).

```sql
-- Preparación: el cliente de prueba y tres eventos de diciembre, registrados en desorden
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'
EXEC usp_registrarEvento @p_NombreQuinta = 'Las Palmas', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 80
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 120
EXEC usp_registrarEvento @p_NombreQuinta = 'El Encino', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 50

-- Todo diciembre: 3 filas
EXEC usp_obtenerEventosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerEventosPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerEventosPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerEventosPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
