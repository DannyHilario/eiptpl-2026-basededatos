# PIA QuintaSol — Objeto 04 de 11: `usp_actualizarPrecioTipoQuinta`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioTipoQuinta`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** cambiar el precio por día de un tipo de quinta, **para** que los eventos nuevos se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada evento guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioTipoQuinta` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoQuinta` | `varchar(30)` | Nombre del tipo de quinta |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por día nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de quinta existe | `000001` | El tipo de quinta no existe |
| 2 | El precio por día nuevo es mayor a cero | `000002` | El precio por día debe ser mayor a cero |
| 3 | El precio por día nuevo es distinto al actual | `000003` | El precio por día nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por día actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioTipoQuinta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de quinta existe → `000001` *El tipo de quinta no existe*.
- [ ] Valida: el precio por día nuevo es mayor a cero → `000002` *El precio por día debe ser mayor a cero*.
- [ ] Valida: el precio por día nuevo es distinto al actual → `000003` *El precio por día nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ningun evento ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por día actualizado'`.

**Sugerencia** (no se califica): Obtén el id del tipo de quinta y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un tipo de quinta 'Otro'
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Otro', @p_PrecioNuevo = 8000.00

-- 000002: precio 0
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Grande', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Grande', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $8,000.00
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Grande', @p_PrecioNuevo = 8000.00

-- 000000: sube a $10,400.00
EXEC usp_actualizarPrecioTipoQuinta @p_NombreTipoQuinta = 'Grande', @p_PrecioNuevo = 10400.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un tipo de quinta 'Otro' | `000001` | El tipo de quinta no existe |
| Precio 0 | `000002` | El precio por día debe ser mayor a cero |
| Precio negativo | `000002` | El precio por día debe ser mayor a cero |
| Ya cuesta $8,000.00 | `000003` | El precio por día nuevo es igual al actual |
| Sube a $10,400.00 | `000000` | Precio por día actualizado |

Al final, el precio por día de 'Grande' es **$10,400.00**.
