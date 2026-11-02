# PIA ImprimeYa — Objeto 04 de 11: `usp_actualizarPrecioProducto`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_actualizarPrecioProducto`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** cambiar el precio por paquete de un producto, **para** que los pedidos nuevos se cobren con el precio actualizado.

## Contexto

Los precios cambian de vez en cuando. Cambiar el precio **no** cambia lo que ya se cobró: cada pedido guarda su propio precio. El precio siempre es **mayor a cero**, y no tiene sentido "cambiarlo" por el mismo valor.

Este procedimiento **solo cambia el precio**. Quien registra el cambio en el [histórico de precios](README.md#lo-nuevo-el-histórico-de-precios) es el trigger [`trg_registrarHistoricoPrecio`](11-trigger-trg_registrarHistoricoPrecio.md): el procedimiento **no** escribe en el histórico.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_actualizarPrecioProducto` que valide las reglas de abajo y, si todo es correcto, actualice el precio.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreProducto` | `varchar(50)` | Nombre de producto |
| `@p_PrecioNuevo` | `decimal(10,2)` | Precio por paquete nuevo |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El producto existe | `000001` | El producto no existe |
| 2 | El precio por paquete nuevo es mayor a cero | `000002` | El precio por paquete debe ser mayor a cero |
| 3 | El precio por paquete nuevo es distinto al actual | `000003` | El precio por paquete nuevo es igual al actual |
| 4 | Todo correcto | `000000` | Precio por paquete actualizado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPrecioProducto` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el producto existe → `000001` *El producto no existe*.
- [ ] Valida: el precio por paquete nuevo es mayor a cero → `000002` *El precio por paquete debe ser mayor a cero*.
- [ ] Valida: el precio por paquete nuevo es distinto al actual → `000003` *El precio por paquete nuevo es igual al actual*.
- [ ] Si todo es correcto, actualiza el precio con un `UPDATE`. **No** modifica ningun pedido ni escribe en el histórico.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Precio por paquete actualizado'`.

**Sugerencia** (no se califica): Obtén el id del producto y su precio actual en variables con un solo `SELECT ... FROM ... WHERE`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000001: no existe un producto 'Otro'
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Otro', @p_PrecioNuevo = 380.00

-- 000002: precio 0
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Menús enmicados', @p_PrecioNuevo = 0

-- 000002: precio negativo
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Menús enmicados', @p_PrecioNuevo = -50.00

-- 000003: ya cuesta $380.00
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Menús enmicados', @p_PrecioNuevo = 380.00

-- 000000: sube a $500.00
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Menús enmicados', @p_PrecioNuevo = 500.00
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| No existe un producto 'Otro' | `000001` | El producto no existe |
| Precio 0 | `000002` | El precio por paquete debe ser mayor a cero |
| Precio negativo | `000002` | El precio por paquete debe ser mayor a cero |
| Ya cuesta $380.00 | `000003` | El precio por paquete nuevo es igual al actual |
| Sube a $500.00 | `000000` | Precio por paquete actualizado |

Al final, el precio por paquete de 'Menús enmicados' es **$500.00**.
