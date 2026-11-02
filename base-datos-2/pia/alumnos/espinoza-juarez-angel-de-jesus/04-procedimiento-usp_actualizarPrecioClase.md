# PIA FitZone — Objeto 04 de 11: `usp_actualizarPrecioClase`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioClase`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** cambiar el precio por clase de una clase, **para** que las asistencias nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada asistencia guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioClase` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreClase` | `varchar(50)` | Nombre de clase |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por clase nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La clase existe | `000001` | La clase no existe |
| 2 | El precio por clase nuevo es mayor a cero | `000002` | El precio por clase debe ser mayor a cero |
| 3 | El precio por clase nuevo es distinto al actual | `000003` | El precio por clase nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por clase actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioClase` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la clase existe → `000001` *La clase no existe*.
- [ ] Valida: el precio por clase nuevo es mayor a cero → `000002` *El precio por clase debe ser mayor a cero*.
- [ ] Valida: el precio por clase nuevo es distinto al actual → `000003` *El precio por clase nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna asistencia ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por clase actualizado'`.

**Sugerencia** (no se califica): Obtén el id de la clase y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe una clase 'Otro'
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Otro', @p_PrecioNuevo = 100.00

-- 000002: precio 0
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Box', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Box', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $100.00
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Box', @p_PrecioNuevo = 100.00

-- 000000: sube a $130.00
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Box', @p_PrecioNuevo = 130.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe una clase 'Otro' | `000001` | La clase no existe |
| Precio 0 | `000002` | El precio por clase debe ser mayor a cero |
| Precio negativo | `000002` | El precio por clase debe ser mayor a cero |
| Ya cuesta $100.00 | `000003` | El precio por clase nuevo es igual al actual |
| Sube a $130.00 | `000000` | Precio por clase actualizado |

Al final, el precio por clase de 'Box' es **$130.00**.
