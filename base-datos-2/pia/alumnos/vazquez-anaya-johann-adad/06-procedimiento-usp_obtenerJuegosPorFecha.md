# PIA StrikeMax — Objeto 06 de 11: `usp_obtenerJuegosPorFecha`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerJuegosPorFecha`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** ver los juegos de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa los juegos de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerJuegosPorFecha` que valide el rango y regrese los juegos.

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
| `FechaJuego` | Fecha del juego |
| `NumeroPista` | Pista |
| `Cliente` | Nombre del cliente |
| `Lineas` | Líneas |
| `PrecioCobrado` | Precio con el que se cobró el juego |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerJuegosPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaJuego` y, en un mismo día, por `NumeroPista`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerJuegosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaJuego | NumeroPista | Cliente | Lineas | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | 1 | Cliente de Prueba | 3 | 70.00 |
| 2026-12-02 | 3 | Cliente de Prueba | 1 | 90.00 |
| 2026-12-02 | 7 | Cliente de Prueba | 2 | 150.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarJuego`](05-procedimiento-usp_registrarJuego.md).

```sql
-- Preparación: el cliente de prueba y tres juegos de diciembre, registrados en desorden
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'
EXEC usp_registrarJuego @p_NumeroPista = 7, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-02', @p_Lineas = 2
EXEC usp_registrarJuego @p_NumeroPista = 1, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-01', @p_Lineas = 3
EXEC usp_registrarJuego @p_NumeroPista = 3, @p_TelefonoCliente = '8199990001', @p_FechaJuego = '2026-12-02', @p_Lineas = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerJuegosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerJuegosPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerJuegosPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerJuegosPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
