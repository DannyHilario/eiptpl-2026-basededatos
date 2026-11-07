# PIA ImprimeYa — Objeto 05 de 11: `usp_registrarPedido`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_registrarPedido`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** registrar un pedido, **para** que quede guardado quién, qué, cuándo y cuánto se cobró.

## Contexto

Quien registra conoce el **nombre de producto** y el **correo electrónico**; el procedimiento busca al producto y al cliente. Solo se registran pedidos con productos y clientes **activos**.

El pedido se cobra con el **precio por paquete vigente** del producto, en el momento de registrarlo. Ese precio se **copia** al pedido: si mañana cambia, el pedido conserva el que se cobró.

Hay reglas que el procedimiento **no** valida con un `IF`, porque ya las cuida una restricción de la tabla: por ejemplo, paquetes fuera de rango (`CHECK`). Si algo así falla, el procedimiento no debe terminar con un error en rojo: lo atrapa con `TRY … CATCH` y responde con el código `999999` ([Excepciones en procedimientos almacenados](../../../temas/Etapa-4/05-ExcepcionesProcedimientos.md)).

> **Aquí no se valida con `IF` a propósito.** En el tema se recomienda convertir en validación un error que se repite; en esta ficha esa regla se deja **sin** `IF` para comprobar que tu `CATCH` funciona. Si le agregas una validación, la prueba del `999999` ya no da el resultado esperado.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_registrarPedido` que valide las reglas de abajo y, si todo es correcto, registre el pedido con el precio vigente, dentro de un `TRY … CATCH`.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreProducto` | `varchar(50)` | Nombre de producto |
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico |
| `@p_FechaPedido` | `date` | Fecha del pedido |
| `@p_Paquetes` | `int` | Paquetes |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El producto existe | `000001` | El producto no existe |
| 2 | El producto está activo | `000002` | El producto está dado de baja |
| 3 | El cliente existe | `000003` | El cliente no existe |
| 4 | El cliente está activo | `000004` | El cliente está dado de baja |
| 5 | Todo correcto | `000000` | Pedido registrado |
| — | Cualquier error al insertar (lo atrapa el `CATCH`) | `999999` | `Error <número>: <mensaje de SQL Server>` |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_registrarPedido` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el producto existe → `000001` *El producto no existe*.
- [ ] Valida: el producto está activo → `000002` *El producto está dado de baja*.
- [ ] Valida: el cliente existe → `000003` *El cliente no existe*.
- [ ] Valida: el cliente está activo → `000004` *El cliente está dado de baja*.
- [ ] El `INSERT` del pedido va dentro de `BEGIN TRY … END TRY`, con el precio vigente que obtuvo en la validación 1.
- [ ] En el `BEGIN CATCH … END CATCH` responde `ErrCodigo = '999999'` y un `ErrMensaje` armado con `ERROR_NUMBER()` y `ERROR_MESSAGE()`: `'Error ' + número + ': ' + mensaje`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Pedido registrado'`.
- [ ] En **todos** los casos responde con las mismas dos columnas, `ErrCodigo` y `ErrMensaje`, sin mensajes en rojo.

**Sugerencia** (no se califica): Obtén en variables, con un solo `SELECT ... FROM ... WHERE`, el id del producto, si está activo y el **precio por paquete vigente**.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_darDeBajaCliente`](02-procedimiento-usp_darDeBajaCliente.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 000000: 'Tarjetas de presentación', $250.00
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2

-- 000001: no existe un producto 'NoExiste'
EXEC usp_registrarPedido @p_NombreProducto = 'NoExiste', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2

-- 000002: el producto dado de baja. Como ningún procedimiento da de baja los productos,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo) y regrésalo a activo al terminar
UPDATE <TuTablaDeProductos> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Volantes media carta'
EXEC usp_registrarPedido @p_NombreProducto = 'Volantes media carta', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2
UPDATE <TuTablaDeProductos> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Volantes media carta'

-- 000003: no existe un cliente con ese correo electrónico
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'noexiste@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2

-- 999999: paquetes = 51; no hay validación con IF, la detiene el CHECK y la atrapa el CATCH
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 51

-- 000004: el cliente dado de baja
EXEC usp_darDeBajaCliente @p_CorreoCliente = 'prueba1@correo.com'
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-03', @p_Paquetes = 2
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| El cliente de prueba | `000000` | Cliente registrado |
| 'Tarjetas de presentación', $250.00 | `000000` | Pedido registrado |
| No existe un producto 'NoExiste' | `000001` | El producto no existe |
| El producto dado de baja. Como ningún procedimiento da de baja los productos | `000002` | El producto está dado de baja |
| No existe un cliente con ese correo electrónico | `000003` | El cliente no existe |
| Paquetes = 51 | `999999` | Error 547: … |
| El cliente dado de baja | `000000` | Cliente dado de baja |
| El cliente dado de baja | `000004` | El cliente está dado de baja |

En el `999999`, el nombre de la restricción, de la tabla o de la columna que aparecen en el mensaje son **los de tu modelo**; lo que debe coincidir es el código `999999` y el número de error, **547**.
