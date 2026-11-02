# PIA RutaNorte — Objeto 04 de 11: `usp_actualizarPrecioRuta`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioRuta`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** cambiar el precio de una ruta, **para** que los boletos nuevos se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada boleto guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioRuta` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_ClaveRuta` | `varchar(10)` | Clave de ruta |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La ruta existe | `000001` | La ruta no existe |
| 2 | El precio nuevo es mayor a cero | `000002` | El precio debe ser mayor a cero |
| 3 | El precio nuevo es distinto al actual | `000003` | El precio nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioRuta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la ruta existe → `000001` *La ruta no existe*.
- [ ] Valida: el precio nuevo es mayor a cero → `000002` *El precio debe ser mayor a cero*.
- [ ] Valida: el precio nuevo es distinto al actual → `000003` *El precio nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ningun boleto ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio actualizado'`.

**Sugerencia** (no se califica): Obtén el id de la ruta y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe una ruta 'Otro'
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'Otro', @p_PrecioNuevo = 450.00

-- 000002: precio 0
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-NLD', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-NLD', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $450.00
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-NLD', @p_PrecioNuevo = 450.00

-- 000000: sube a $585.00
EXEC usp_actualizarPrecioRuta @p_ClaveRuta = 'MTY-NLD', @p_PrecioNuevo = 585.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe una ruta 'Otro' | `000001` | La ruta no existe |
| Precio 0 | `000002` | El precio debe ser mayor a cero |
| Precio negativo | `000002` | El precio debe ser mayor a cero |
| Ya cuesta $450.00 | `000003` | El precio nuevo es igual al actual |
| Sube a $585.00 | `000000` | Precio actualizado |

Al final, el precio de 'MTY-NLD' es **$585.00**.
