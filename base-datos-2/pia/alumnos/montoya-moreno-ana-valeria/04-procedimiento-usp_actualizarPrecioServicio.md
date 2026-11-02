# PIA SpaZen — Objeto 04 de 11: `usp_actualizarPrecioServicio`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioServicio`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** cambiar el precio de un servicio, **para** que las citas nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada cita guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioServicio` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreServicio` | `varchar(50)` | Nombre de servicio |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El servicio existe | `000001` | El servicio no existe |
| 2 | El precio nuevo es mayor a cero | `000002` | El precio debe ser mayor a cero |
| 3 | El precio nuevo es distinto al actual | `000003` | El precio nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioServicio` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el servicio existe → `000001` *El servicio no existe*.
- [ ] Valida: el precio nuevo es mayor a cero → `000002` *El precio debe ser mayor a cero*.
- [ ] Valida: el precio nuevo es distinto al actual → `000003` *El precio nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna cita ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio actualizado'`.

**Sugerencia** (no se califica): Obtén el id del servicio y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un servicio 'Otro'
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Otro', @p_PrecioNuevo = 600.00

-- 000002: precio 0
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Facial hidratante', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Facial hidratante', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $600.00
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Facial hidratante', @p_PrecioNuevo = 600.00

-- 000000: sube a $780.00
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Facial hidratante', @p_PrecioNuevo = 780.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un servicio 'Otro' | `000001` | El servicio no existe |
| Precio 0 | `000002` | El precio debe ser mayor a cero |
| Precio negativo | `000002` | El precio debe ser mayor a cero |
| Ya cuesta $600.00 | `000003` | El precio nuevo es igual al actual |
| Sube a $780.00 | `000000` | Precio actualizado |

Al final, el precio de 'Facial hidratante' es **$780.00**.
