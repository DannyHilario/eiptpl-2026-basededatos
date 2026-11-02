# PIA CampoVerde — Objeto 04 de 11: `usp_actualizarPrecioTipoTienda`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioTipoTienda`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** cambiar el precio por noche de un tipo de casa de campaña, **para** que las rentas nuevas se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada renta guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioTipoTienda` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreTipoTienda` | `varchar(30)` | Nombre del tipo de casa de campaña |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por noche nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de casa de campaña existe | `000001` | El tipo de casa de campaña no existe |
| 2 | El precio por noche nuevo es mayor a cero | `000002` | El precio por noche debe ser mayor a cero |
| 3 | El precio por noche nuevo es distinto al actual | `000003` | El precio por noche nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por noche actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioTipoTienda` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de casa de campaña existe → `000001` *El tipo de casa de campaña no existe*.
- [ ] Valida: el precio por noche nuevo es mayor a cero → `000002` *El precio por noche debe ser mayor a cero*.
- [ ] Valida: el precio por noche nuevo es distinto al actual → `000003` *El precio por noche nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ninguna renta ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por noche actualizado'`.

**Sugerencia** (no se califica): Obtén el id del tipo de casa de campaña y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un tipo de casa de campaña 'Otro'
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = 'Otro', @p_PrecioNuevo = 520.00

-- 000002: precio 0
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '6 personas', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '6 personas', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $520.00
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '6 personas', @p_PrecioNuevo = 520.00

-- 000000: sube a $670.00
EXEC usp_actualizarPrecioTipoTienda @p_NombreTipoTienda = '6 personas', @p_PrecioNuevo = 670.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un tipo de casa de campaña 'Otro' | `000001` | El tipo de casa de campaña no existe |
| Precio 0 | `000002` | El precio por noche debe ser mayor a cero |
| Precio negativo | `000002` | El precio por noche debe ser mayor a cero |
| Ya cuesta $520.00 | `000003` | El precio por noche nuevo es igual al actual |
| Sube a $670.00 | `000000` | Precio por noche actualizado |

Al final, el precio por noche de '6 personas' es **$670.00**.
