# PIA GameZone — Objeto 01 de 11: `usp_insertarJugador`

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)
**Objeto a crear:** Procedimiento almacenado `usp_insertarJugador`

← [Regresar al caso GameZone](README.md)

---

## Historia de usuario

**Como** dueño de GameZone, **quiero** registrar a un jugador que llega por primera vez, **para** empezar a registrar sus sesiones sin que se repita su registro.

## Contexto

Un jugador se registra una sola vez. El gamertag identifica al jugador: no puede haber dos jugadores con el mismo gamertag. Además, un jugador tiene **al menos 8 años**. Un jugador nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarJugador` que valide las reglas de arriba y, si todo es correcto, registre al jugador.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Gamertag` | `varchar(30)` | Gamertag del jugador |
| `@p_Nombre` | `varchar(100)` | Nombre del jugador |
| `@p_Edad` | `int` | Edad en años |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El gamertag no está registrado | `000001` | El gamertag ya está registrado |
| 2 | Un jugador tiene al menos 8 años | `000002` | La edad mínima es de 8 años |
| 3 | Todo correcto | `000000` | Jugador registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarJugador` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el gamertag no está registrado → `000001` *El gamertag ya está registrado*.
- [ ] Valida: un jugador tiene al menos 8 años → `000002` *La edad mínima es de 8 años*.
- [ ] Cuenta también a los jugadores dados de baja: su gamertag sigue siendo suyo.
- [ ] Si todo es correcto, inserta al jugador **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Jugador registrado'`.

**Sugerencia** (no se califica): Para validar, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` / `IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un jugador nuevo
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador de Prueba', @p_Edad = 15

-- 000001: el gamertag 'Prueba01' ya está registrado
EXEC usp_insertarJugador @p_Gamertag = 'Prueba01', @p_Nombre = 'Jugador Dos', @p_Edad = 12

-- 000002: Edad = 7
EXEC usp_insertarJugador @p_Gamertag = 'Prueba02', @p_Nombre = 'Jugador Dos', @p_Edad = 7

-- 000000: el límite, Edad = 8, sí se acepta
EXEC usp_insertarJugador @p_Gamertag = 'Prueba02', @p_Nombre = 'Jugador Dos', @p_Edad = 8
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un jugador nuevo | `000000` | Jugador registrado |
| El gamertag 'Prueba01' ya está registrado | `000001` | El gamertag ya está registrado |
| Edad = 7 | `000002` | La edad mínima es de 8 años |
| El límite, Edad = 8, sí se acepta | `000000` | Jugador registrado |
