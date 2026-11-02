# PIA RecorreMTY — Objeto 04 de 11: `usp_actualizarPrecioRecorrido`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioRecorrido`

← [Regresar al caso RecorreMTY](README.md)

---

## Historia de usuario

**Como** dueña de RecorreMTY, **quiero** cambiar el precio por persona de un recorrido, **para** que las reservaciones nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada reservación guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioRecorrido` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreRecorrido` | `varchar(50)` | Nombre de recorrido |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por persona nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El recorrido existe | `000001` | El recorrido no existe |
| 2 | El precio por persona nuevo es mayor a cero | `000002` | El precio por persona debe ser mayor a cero |
| 3 | El precio por persona nuevo es distinto al actual | `000003` | El precio por persona nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por persona actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioRecorrido` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el recorrido existe → `000001` *El recorrido no existe*.
- [ ] Valida: el precio por persona nuevo es mayor a cero → `000002` *El precio por persona debe ser mayor a cero*.
- [ ] Valida: el precio por persona nuevo es distinto al actual → `000003` *El precio por persona nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna reservación ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por persona actualizado'`.

**Sugerencia** (no se califica): Obtén el id del recorrido y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un recorrido 'Otro'
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Otro', @p_PrecioNuevo = 300.00

-- 000002: precio 0
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Parque Fundidora', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Parque Fundidora', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $300.00
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Parque Fundidora', @p_PrecioNuevo = 300.00

-- 000000: sube a $390.00
EXEC usp_actualizarPrecioRecorrido @p_NombreRecorrido = 'Parque Fundidora', @p_PrecioNuevo = 390.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un recorrido 'Otro' | `000001` | El recorrido no existe |
| Precio 0 | `000002` | El precio por persona debe ser mayor a cero |
| Precio negativo | `000002` | El precio por persona debe ser mayor a cero |
| Ya cuesta $300.00 | `000003` | El precio por persona nuevo es igual al actual |
| Sube a $390.00 | `000000` | Precio por persona actualizado |

Al final, el precio por persona de 'Parque Fundidora' es **$390.00**.
