# PIA RecorreMTY — Objeto 07 de 11: `ufn_totalCobradoRecorrido`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Función escalar `ufn_totalCobradoRecorrido`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** saber cuánto se ha cobrado en total por cada recorrido, **para** saber qué tanto deja cada uno.

## Contexto

Lo cobrado con un recorrido es la **suma de lo cobrado** en todas sus reservaciones: en cada una, el precio cobrado × personas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| El recorrido tiene reservaciones | La suma de lo cobrado |
| El recorrido existe pero no tiene reservaciones | `0.00` |
| El recorrido no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoRecorrido` que reciba el nombre de un recorrido y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreRecorrido` | `varchar(50)` | Nombre del recorrido |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoRecorrido` y recibe `@p_NombreRecorrido varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un recorrido con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada reservación, no el precio actual), multiplicado por personas.
- [ ] Si el recorrido existe pero no tiene reservaciones, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarTurista`](01-procedimiento-usp_insertarTurista.md), [`usp_insertarRecorrido`](03-procedimiento-usp_insertarRecorrido.md), [`usp_actualizarPrecioRecorrido`](04-procedimiento-usp_actualizarPrecioRecorrido.md), [`usp_registrarReservacion`](05-procedimiento-usp_registrarReservacion.md).

```sql
-- Preparación: el turista de prueba
EXEC usp_insertarTurista @p_NombrePais = 'México', @p_Nombre = 'Turista de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: un recorrido nuevo, 'Recorrido de Prueba' ($250.00)
EXEC usp_insertarRecorrido @p_Nombre = 'Recorrido de Prueba', @p_DuracionHoras = 2.5, @p_PrecioPorPersona = 250.00

-- Sin reservaciones: 0.00
SELECT dbo.ufn_totalCobradoRecorrido('Recorrido de Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoRecorrido('NoExiste') AS TotalCobrado
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Recorrido de Prueba', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-01', @p_Personas = 2
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Recorrido de Prueba', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-02', @p_Personas = 3

-- Dos reservaciones: 1250.00
SELECT dbo.ufn_totalCobradoRecorrido('Recorrido de Prueba') AS TotalCobrado

-- Sube el precio a $300.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Recorrido de Prueba', @p_PrecioNuevo = 300.00
EXEC usp_registrarReservacion @p_NombreRecorrido = 'Recorrido de Prueba', @p_CorreoTurista = 'prueba1@correo.com', @p_FechaRecorrido = '2026-12-03', @p_Personas = 1

-- Tres reservaciones: 1550.00
SELECT dbo.ufn_totalCobradoRecorrido('Recorrido de Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Recorrido de Prueba' sin reservaciones | 0.00 |
| No existe | NULL |
| Con 2 reservaciones | 1250.00 |
| Con 3 reservaciones, una con el precio nuevo | 1550.00 |
