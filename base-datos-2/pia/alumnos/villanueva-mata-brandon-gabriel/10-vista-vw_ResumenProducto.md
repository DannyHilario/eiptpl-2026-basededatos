# PIA ImprimeYa — Objeto 10 de 11: `vw_ResumenProducto`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Vista `vw_ResumenProducto`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** un resumen por producto, **para** saber qué se usa más, cuánto deja y cuándo fue la última vez.

## Contexto



Un producto puede no tener pedidos todavía. También debe aparecer en el resumen, con 0 pedidos y $0.00 cobrados.

## Tu tarea

Crea una vista llamada exactamente `vw_ResumenProducto` que muestre **una fila por producto** con las columnas de abajo.

**Columnas**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `Producto` | Nombre del producto |
| `PrecioPorPaquete` | Precio por paquete actual |
| `TotalPedidos` | Cuántos pedidos se han registrado |
| `TotalCobrado` | Suma de lo cobrado (precio cobrado × paquetes) |
| `UltimoPedido` | Fecha del pedido más reciente |

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_ResumenProducto`.
- [ ] Regresa las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Agrupa con `GROUP BY` y calcula con funciones de agregado: `COUNT`, `SUM` y `MAX`.
- [ ] Tiene **una fila por cada producto**, incluidos los que no tienen pedidos: usa `LEFT JOIN` desde los productos.
- [ ] Un producto sin pedidos sale con `TotalPedidos = 0`, `TotalCobrado = 0.00` (con `ISNULL`) y `UltimoPedido = NULL`.
- [ ] `TotalPedidos` cuenta pedidos: para que un producto sin pedidos salga en 0, cuenta una columna de la tabla de pedidos, no `COUNT(*)`.
- [ ] La vista no lleva `ORDER BY`.

## Ejemplo de salida esperada

Los totales dependen de tus datos inventados. Con los datos de la solución de referencia, `SELECT * FROM vw_ResumenProducto` regresa algo así:

| Producto | PrecioPorPaquete | TotalPedidos | TotalCobrado | UltimoPedido |
|---|---|---|---|---|
| Tarjetas de presentación | 250.00 | 6 | 9000.00 | 2026-05-20 |
| Volantes media carta | 450.00 | 5 | 21600.00 | 2026-05-06 |
| Menús enmicados | 380.00 | 2 | 1140.00 | 2026-02-05 |
| Etiquetas adhesivas | 300.00 | 5 | 5700.00 | 2026-05-27 |
| Lona de 1 x 2 metros | 420.00 | 3 | 2520.00 | 2026-04-21 |
| Folders impresos | 600.00 | 0 | 0.00 | NULL |
| Calendarios de pared | 520.00 | 0 | 0.00 | NULL |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarPedido`](05-procedimiento-usp_registrarPedido.md), [`usp_insertarProducto`](03-procedimiento-usp_insertarProducto.md). Como los totales dependen de tus datos, las pruebas revisan **cuánto cambian**.

```sql
-- 1. El resumen con tus datos
SELECT * FROM vw_ResumenProducto

-- 2. Dos pedidos más de 'Calendarios de pared' ($520.00)
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'
EXEC usp_registrarPedido @p_NombreProducto = 'Calendarios de pared', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2
EXEC usp_registrarPedido @p_NombreProducto = 'Calendarios de pared', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 3
SELECT * FROM vw_ResumenProducto

-- 3. Un producto nuevo, sin pedidos
EXEC usp_insertarProducto @p_Nombre = 'Producto de Prueba', @p_PiezasPorPaquete = 50, @p_PrecioPorPaquete = 100.00
SELECT * FROM vw_ResumenProducto
```

| Caso | Resultado esperado |
|---|---|
| 1. Con tus datos | 7 filas |
| 2. Después de las dos nuevas | La fila de 'Calendarios de pared': `TotalPedidos` **+2**, `TotalCobrado` **+2600.00** y `UltimoPedido` **2026-12-02**. Las demás no cambian |
| 3. Con el producto nuevo | 8 filas. 'Producto de Prueba': 100.00, 0, 0.00, NULL |
