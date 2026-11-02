# PIA EnigmaRoom — Objeto 04 de 11: `usp_actualizarPrecioSalaEscape`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioSalaEscape`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** cambiar el precio por partida de una sala de escape, **para** que las partidas nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada partida guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioSalaEscape` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreSalaEscape` | `varchar(50)` | Nombre de sala |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por partida nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La sala de escape existe | `000001` | La sala de escape no existe |
| 2 | El precio por partida nuevo es mayor a cero | `000002` | El precio por partida debe ser mayor a cero |
| 3 | El precio por partida nuevo es distinto al actual | `000003` | El precio por partida nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por partida actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioSalaEscape` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la sala de escape existe → `000001` *La sala de escape no existe*.
- [ ] Valida: el precio por partida nuevo es mayor a cero → `000002` *El precio por partida debe ser mayor a cero*.
- [ ] Valida: el precio por partida nuevo es distinto al actual → `000003` *El precio por partida nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna partida ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por partida actualizado'`.

**Sugerencia** (no se califica): Obtén el id de la sala de escape y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe una sala de escape 'Otro'
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'Otro', @p_PrecioNuevo = 1000.00

-- 000002: precio 0
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Gran Robo', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Gran Robo', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $1,000.00
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Gran Robo', @p_PrecioNuevo = 1000.00

-- 000000: sube a $1,300.00
EXEC usp_actualizarPrecioSalaEscape @p_NombreSalaEscape = 'El Gran Robo', @p_PrecioNuevo = 1300.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe una sala de escape 'Otro' | `000001` | La sala de escape no existe |
| Precio 0 | `000002` | El precio por partida debe ser mayor a cero |
| Precio negativo | `000002` | El precio por partida debe ser mayor a cero |
| Ya cuesta $1,000.00 | `000003` | El precio por partida nuevo es igual al actual |
| Sube a $1,300.00 | `000000` | Precio por partida actualizado |

Al final, el precio por partida de 'El Gran Robo' es **$1,300.00**.
