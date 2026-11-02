# PIA GameZone — Objeto 02 de 11: `usp_darDeBajaJugador`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaJugador`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** dar de baja al jugador que ya no regresa, **para** que ya no se le registren sesiones sin perder su historial.

## Contexto

En GameZone un jugador **no se borra**: se da de baja, para conservar su historial. Se lo busca por su **gamertag**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaJugador` que valide las reglas de abajo y, si todo es correcto, marque al jugador como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Gamertag` | `varchar(30)` | Gamertag del jugador |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El jugador existe | `000001` | El jugador no existe |
| 2 | El jugador está activo | `000002` | El jugador ya está dado de baja |
| 3 | Todo correcto | `000000` | Jugador dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaJugador` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el jugador existe → `000001` *El jugador no existe*.
- [ ] Valida: el jugador está activo → `000002` *El jugador ya está dado de baja*.
- [ ] Si todo es correcto, marca al jugador como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Jugador dado de baja'`.

**Sugerencia** (no se califica): Obtén el id del jugador y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el gamertag.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarJugador`](01-procedimiento-usp_insertarJugador.md).

```sql
-- Preparación: el jugador de prueba
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15

-- 000001: no existe un jugador con ese gamertag
EXEC usp_darDeBajaJugador @p_Gamertag = 'NoExiste99'

-- 000000: se da de baja
EXEC usp_darDeBajaJugador @p_Gamertag = 'Prueba01'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaJugador @p_Gamertag = 'Prueba01'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El jugador de prueba | `000000` | Jugador registrado |
| No existe un jugador con ese gamertag | `000001` | El jugador no existe |
| Se da de baja | `000000` | Jugador dado de baja |
| Ya estaba dado de baja | `000002` | El jugador ya está dado de baja |
