# PIA EnigmaRoom — Objeto 06 de 11: `usp_obtenerPartidasPorFecha`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerPartidasPorFecha`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** ver las partidas de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa las partidas de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerPartidasPorFecha` que valide el rango y regrese las partidas.

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
| `FechaPartida` | Fecha de la partida |
| `SalaEscape` | Sala de escape |
| `Cliente` | Nombre del cliente |
| `Jugadores` | Jugadores |
| `PrecioCobrado` | Precio con el que se cobró la partida |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerPartidasPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaPartida` y, en un mismo día, por `SalaEscape`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerPartidasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaPartida | SalaEscape | Cliente | Jugadores | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | El Laboratorio | Cliente de Prueba | 5 | 900.00 |
| 2026-12-02 | El Gran Robo | Cliente de Prueba | 4 | 1000.00 |
| 2026-12-02 | La Cripta | Cliente de Prueba | 3 | 1100.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarPartida`](05-procedimiento-usp_registrarPartida.md).

```sql
-- Preparación: el cliente de prueba y tres partidas de diciembre, registradas en desorden
EXEC usp_insertarCliente @p_NombreMedio = 'Redes sociales', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Gran Robo', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 4
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 5
EXEC usp_registrarPartida @p_NombreSalaEscape = 'La Cripta', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 3

-- Todo diciembre: 3 filas
EXEC usp_obtenerPartidasPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerPartidasPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerPartidasPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerPartidasPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
