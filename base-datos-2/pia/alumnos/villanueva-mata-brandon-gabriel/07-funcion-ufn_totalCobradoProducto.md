# PIA ImprimeYa — Objeto 07 de 11: `ufn_totalCobradoProducto`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Función escalar `ufn_totalCobradoProducto`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** saber cuánto se ha cobrado en total por cada producto, **para** saber qué tanto deja cada uno.

## Contexto

Lo cobrado con un producto es la **suma de lo cobrado** en todas sus pedidos: en cada uno, el precio cobrado × paquetes, **no** el precio actual.

| Situación | Regresa |
|---|---|
| El producto tiene pedidos | La suma de lo cobrado |
| El producto existe pero no tiene pedidos | `0.00` |
| El producto no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoProducto` que reciba el nombre de un producto y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreProducto` | `varchar(50)` | Nombre del producto |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoProducto` y recibe `@p_NombreProducto varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un producto con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada pedido, no el precio actual), multiplicado por paquetes.
- [ ] Si el producto existe pero no tiene pedidos, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarProducto`](03-procedimiento-usp_insertarProducto.md), [`usp_actualizarPrecioProducto`](04-procedimiento-usp_actualizarPrecioProducto.md), [`usp_registrarPedido`](05-procedimiento-usp_registrarPedido.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: un producto nuevo, 'Producto de Prueba' ($250.00)
EXEC usp_insertarProducto @p_Nombre = 'Producto de Prueba', @p_PiezasPorPaquete = 50, @p_PrecioPorPaquete = 250.00

-- Sin pedidos: 0.00
SELECT dbo.ufn_totalCobradoProducto('Producto de Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoProducto('NoExiste') AS TotalCobrado
EXEC usp_registrarPedido @p_NombreProducto = 'Producto de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2
EXEC usp_registrarPedido @p_NombreProducto = 'Producto de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 3

-- Dos pedidos: 1250.00
SELECT dbo.ufn_totalCobradoProducto('Producto de Prueba') AS TotalCobrado

-- Sube el precio a $300.00 y se registra otro; los anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Producto de Prueba', @p_PrecioNuevo = 300.00
EXEC usp_registrarPedido @p_NombreProducto = 'Producto de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-03', @p_Paquetes = 1

-- Tres pedidos: 1550.00
SELECT dbo.ufn_totalCobradoProducto('Producto de Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Producto de Prueba' sin pedidos | 0.00 |
| No existe | NULL |
| Con 2 pedidos | 1250.00 |
| Con 3 pedidos, uno con el precio nuevo | 1550.00 |
