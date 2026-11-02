# PIA GuardaTodo — Objeto 04 de 11: `usp_actualizarPrecioTipoBodega`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioTipoBodega`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** cambiar el precio por mes de un tipo de bodega, **para** que los contratos nuevos se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada contrato guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioTipoBodega` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoBodega` | `varchar(30)` | Nombre del tipo de bodega |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por mes nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de bodega existe | `000001` | El tipo de bodega no existe |
| 2 | El precio por mes nuevo es mayor a cero | `000002` | El precio por mes debe ser mayor a cero |
| 3 | El precio por mes nuevo es distinto al actual | `000003` | El precio por mes nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por mes actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioTipoBodega` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de bodega existe → `000001` *El tipo de bodega no existe*.
- [ ] Valida: el precio por mes nuevo es mayor a cero → `000002` *El precio por mes debe ser mayor a cero*.
- [ ] Valida: el precio por mes nuevo es distinto al actual → `000003` *El precio por mes nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ningun contrato ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por mes actualizado'`.

**Sugerencia** (no se califica): Obtén el id del tipo de bodega y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un tipo de bodega 'Otro'
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Otro', @p_PrecioNuevo = 2400.00

-- 000002: precio 0
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Grande', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Grande', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $2,400.00
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Grande', @p_PrecioNuevo = 2400.00

-- 000000: sube a $3,120.00
EXEC usp_actualizarPrecioTipoBodega @p_NombreTipoBodega = 'Grande', @p_PrecioNuevo = 3120.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un tipo de bodega 'Otro' | `000001` | El tipo de bodega no existe |
| Precio 0 | `000002` | El precio por mes debe ser mayor a cero |
| Precio negativo | `000002` | El precio por mes debe ser mayor a cero |
| Ya cuesta $2,400.00 | `000003` | El precio por mes nuevo es igual al actual |
| Sube a $3,120.00 | `000000` | Precio por mes actualizado |

Al final, el precio por mes de 'Grande' es **$3,120.00**.
