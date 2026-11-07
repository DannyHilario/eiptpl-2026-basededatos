# PIA ImprimeYa — Objeto 09 de 11: `vw_DetallePedido`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Vista `vw_DetallePedido`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** ver cada pedido completo con lo que se cobró y lo que costaría hoy, **para** saber cuáles se cobraron más baratos o más caros que el precio actual.

## Contexto

Cada pedido guarda el **precio cobrado**, y el producto tiene su **precio actual**. Si el precio cambió después, los dos son distintos. La vista los muestra lado a lado y dice, en palabras, cómo cambió:

| Situación | `CambioPrecio` |
|---|---|
| El precio actual es mayor que el cobrado | **Subió** |
| El precio actual es menor que el cobrado | **Bajó** |
| Son iguales | **Sin cambio** |

## Tu tarea

Crea una vista llamada exactamente `vw_DetallePedido` que muestre **todos** los pedidos con las columnas de abajo. Decide el `CambioPrecio` con `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaPedido` | Fecha del pedido |
| `Cliente` | Nombre del cliente |
| `Producto` | Producto |
| `Paquetes` | Paquetes |
| `PrecioCobrado` | Precio que guarda el pedido |
| `PrecioActual` | Precio actual del producto |
| `CambioPrecio` | `'Subió'`, `'Bajó'` o `'Sin cambio'` |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetallePedido`.
- [ ] Regresa las 7 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Une la tabla de pedidos con productos y clientes (`INNER JOIN`).
- [ ] Tiene **una fila por pedido**: el número de filas de la vista es igual al de tu tabla de pedidos.
- [ ] `CambioPrecio` se calcula con `CASE`: `'Subió'`, `'Bajó'` o `'Sin cambio'`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

`SELECT * FROM vw_DetallePedido WHERE FechaPedido >= '2026-12-01' ORDER BY FechaPedido`, después de la preparación de los casos de prueba:

| FechaPedido | Cliente | Producto | Paquetes | PrecioCobrado | PrecioActual | CambioPrecio |
|---|---|---|---|---|---|---|
| 2026-12-01 | Negocio de Prueba | Menús enmicados | 2 | 380.00 | 420.00 | Subió |
| 2026-12-02 | Negocio de Prueba | Menús enmicados | 3 | 460.00 | 420.00 | Bajó |
| 2026-12-03 | Negocio de Prueba | Menús enmicados | 1 | 420.00 | 420.00 | Sin cambio |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_actualizarPrecioProducto`](04-procedimiento-usp_actualizarPrecioProducto.md), [`usp_registrarPedido`](05-procedimiento-usp_registrarPedido.md).

```sql
-- Preparación: tres pedidos de 'Menús enmicados', cada uno con un precio distinto
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarPedido @p_NombreProducto = 'Menús enmicados', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Menús enmicados', @p_PrecioNuevo = 460.00
EXEC usp_registrarPedido @p_NombreProducto = 'Menús enmicados', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 3
EXEC usp_actualizarPrecioProducto @p_NombreProducto = 'Menús enmicados', @p_PrecioNuevo = 420.00
EXEC usp_registrarPedido @p_NombreProducto = 'Menús enmicados', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-03', @p_Paquetes = 1

-- Las tres de prueba: Subió, Bajó y Sin cambio
SELECT * FROM vw_DetallePedido WHERE FechaPedido >= '2026-12-01' ORDER BY FechaPedido

-- Una fila por hecho: los dos conteos deben ser iguales
SELECT COUNT(*) AS Total FROM vw_DetallePedido
SELECT COUNT(*) AS Total FROM <TuTablaDePedidos>
```

| Caso | Resultado esperado |
|---|---|
| Las tres de prueba | Las 3 filas del ejemplo de arriba |
| Conteos | El mismo número en los dos: tus pedidos más las 3 de prueba |
| Tus pedidos inventados | Todas en *Sin cambio*: en tus datos cada una se cobró con el precio que viene en el caso |
