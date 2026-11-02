# PIA ImprimeYa — Objeto 03 de 11: `usp_insertarProducto`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_insertarProducto`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** dar de alta un producto nuevo, **para** que empiece a acumular pedidos.

## Contexto

Cada producto tiene un nombre de producto que **no se repite** y un **precio por paquete** mayor a cero. Además: las piezas por paquete deben ser mayores a cero. Un producto nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarProducto` que valide las reglas de arriba y, si todo es correcto, registre el producto.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(50)` | Nombre del producto |
| `@p_PiezasPorPaquete` | `int` | Piezas que trae cada paquete |
| `@p_PrecioPorPaquete` | `decimal(10,2)` | Precio por paquete |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de producto no existe | `000001` | El nombre de producto ya existe |
| 2 | Las piezas por paquete son mayores a cero | `000002` | Las piezas por paquete deben ser mayores a cero |
| 3 | El precio por paquete es mayor a cero | `000003` | El precio por paquete debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Producto registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarProducto` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de producto no existe → `000001` *El nombre de producto ya existe*.
- [ ] Valida: las piezas por paquete son mayores a cero → `000002` *Las piezas por paquete deben ser mayores a cero*.
- [ ] Valida: el precio por paquete es mayor a cero → `000003` *El precio por paquete debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta el producto **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Producto registrado'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un producto nuevo
EXEC usp_insertarProducto @p_Nombre = 'Producto de Prueba', @p_PiezasPorPaquete = 50, @p_PrecioPorPaquete = 250.00

-- 000001: 'Tarjetas de presentación' ya existe
EXEC usp_insertarProducto @p_Nombre = 'Tarjetas de presentación', @p_PiezasPorPaquete = 50, @p_PrecioPorPaquete = 250.00

-- 000002: PiezasPorPaquete = 0
EXEC usp_insertarProducto @p_Nombre = 'Producto de Prueba 2', @p_PiezasPorPaquete = 0, @p_PrecioPorPaquete = 250.00

-- 000003: precio 0
EXEC usp_insertarProducto @p_Nombre = 'Producto de Prueba 2', @p_PiezasPorPaquete = 50, @p_PrecioPorPaquete = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un producto nuevo | `000000` | Producto registrado |
| 'Tarjetas de presentación' ya existe | `000001` | El nombre de producto ya existe |
| PiezasPorPaquete = 0 | `000002` | Las piezas por paquete deben ser mayores a cero |
| Precio 0 | `000003` | El precio por paquete debe ser mayor a cero |
