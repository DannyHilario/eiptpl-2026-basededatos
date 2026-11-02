# PIA StrikeMax — Objeto 04 de 11: `usp_actualizarTarifaTipoPista`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarTarifaTipoPista`

← [Regresar al caso StrikeMax](README.md)

---

## Historia de usuario

**Como** dueño de StrikeMax, **quiero** cambiar la tarifa por línea de un tipo de pista, **para** que los juegos nuevos se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada juego guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarTarifaTipoPista` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoPista` | `varchar(30)` | Nombre del tipo de pista |
| `@p_PrecioNuevo` | `decimal(10,2)` | Tarifa por línea nueva |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de pista existe | `000001` | El tipo de pista no existe |
| 2 | La tarifa por línea nueva es mayor a cero | `000002` | La tarifa por línea debe ser mayor a cero |
| 3 | La tarifa por línea nueva es distinta a la actual | `000003` | La tarifa por línea nueva es igual a la actual |
| 4 | Todo correcto | `000000` | Tarifa por línea actualizada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarTarifaTipoPista` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de pista existe → `000001` *El tipo de pista no existe*.
- [ ] Valida: la tarifa por línea nueva es mayor a cero → `000002` *La tarifa por línea debe ser mayor a cero*.
- [ ] Valida: la tarifa por línea nueva es distinta a la actual → `000003` *La tarifa por línea nueva es igual a la actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ningun juego ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Tarifa por línea actualizada'`.

**Sugerencia** (no se califica): Obtén el id del tipo de pista y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un tipo de pista 'Otro'
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'Otro', @p_PrecioNuevo = 150.00

-- 000002: precio 0
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'VIP', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'VIP', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $150.00
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'VIP', @p_PrecioNuevo = 150.00

-- 000000: sube a $195.00
EXEC usp_actualizarTarifaTipoPista @p_NombreTipoPista = 'VIP', @p_PrecioNuevo = 195.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un tipo de pista 'Otro' | `000001` | El tipo de pista no existe |
| Precio 0 | `000002` | La tarifa por línea debe ser mayor a cero |
| Precio negativo | `000002` | La tarifa por línea debe ser mayor a cero |
| Ya cuesta $150.00 | `000003` | La tarifa por línea nueva es igual a la actual |
| Sube a $195.00 | `000000` | Tarifa por línea actualizada |

Al final, la tarifa por línea de 'VIP' es **$195.00**.
