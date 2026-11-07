# PIA EnigmaRoom — Objeto 07 de 11: `ufn_totalCobradoSalaEscape`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Función escalar `ufn_totalCobradoSalaEscape`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** saber cuánto se ha cobrado en total por cada sala de escape, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una sala de escape es la **suma del precio cobrado** de todas sus partidas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La sala de escape tiene partidas | La suma de lo cobrado |
| La sala de escape existe pero no tiene partidas | `0.00` |
| La sala de escape no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoSalaEscape` que reciba el nombre de una sala de escape y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreSalaEscape` | `varchar(50)` | Nombre de la sala de escape |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoSalaEscape` y recibe `@p_NombreSalaEscape varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una sala de escape con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada partida, no el precio actual).
- [ ] Si la sala de escape existe pero no tiene partidas, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarSalaEscape`](03-procedimiento-usp_insertarSalaEscape.md), [`usp_actualizarPrecioSalaEscape`](04-procedimiento-usp_actualizarPrecioSalaEscape.md), [`usp_registrarPartida`](05-procedimiento-usp_registrarPartida.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreMedio = 'Redes sociales', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: una sala de escape nueva, 'Sala de Prueba' ($900.00)
EXEC usp_insertarSalaEscape @p_Nombre = 'Sala de Prueba', @p_Tema = 'Piratas', @p_Dificultad = 2, @p_Precio = 900.00

-- Sin partidas: 0.00
SELECT dbo.ufn_totalCobradoSalaEscape('Sala de Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoSalaEscape('NoExiste') AS TotalCobrado
EXEC usp_registrarPartida @p_NombreSalaEscape = 'Sala de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4
EXEC usp_registrarPartida @p_NombreSalaEscape = 'Sala de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 5

-- Dos partidas: 1800.00
SELECT dbo.ufn_totalCobradoSalaEscape('Sala de Prueba') AS TotalCobrado

-- Sube el precio a $1,080.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'Sala de Prueba', @p_PrecioNuevo = 1080.00
EXEC usp_registrarPartida @p_NombreSalaEscape = 'Sala de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-03', @p_Jugadores = 3

-- Tres partidas: 2880.00
SELECT dbo.ufn_totalCobradoSalaEscape('Sala de Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Sala de Prueba' sin partidas | 0.00 |
| No existe | NULL |
| Con 2 partidas | 1800.00 |
| Con 3 partidas, una con el precio nuevo | 2880.00 |
