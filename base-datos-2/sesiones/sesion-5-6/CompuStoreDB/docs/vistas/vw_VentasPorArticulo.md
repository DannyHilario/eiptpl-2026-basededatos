# `vw_VentasPorArticulo`

Script: [`instalacion/08-Vistas/03-vw-ventas-por-articulo.sql`](../../instalacion/08-Vistas/03-vw-ventas-por-articulo.sql)

Un renglón por artículo con las unidades vendidas y el total facturado, contando **solo líneas de pedidos ya entregados** (`Pedido.Cerrado = 1`) — un pedido todavía abierto no cuenta como venta concretada. Todos los artículos aparecen, incluso los que nunca se han vendido (`LEFT JOIN`), con `0` en vez de `NULL`.

## Columnas

| Columna | Origen | Descripción |
|---------|--------|-------------|
| `idArticulo` | `Articulo` | Id del artículo |
| `Articulo` | `Articulo.Nombre` | Nombre del artículo |
| `Marca` | `Articulo` | Marca del artículo |
| `UnidadesVendidas` | calculado | `SUM(Cantidad)` de `DetallePedido`, solo de pedidos con `Cerrado = 1` |
| `TotalFacturado` | calculado | `SUM(Cantidad * PrecioUnitario)` de esas mismas líneas |

## Ejemplo de uso

```sql
-- Los 5 artículos más vendidos
SELECT TOP 5 * FROM vw_VentasPorArticulo ORDER BY UnidadesVendidas DESC
```

## Casos de prueba sugeridos

```sql
-- Artículo nunca vendido: debe aparecer con 0, no ausente
SELECT * FROM vw_VentasPorArticulo WHERE idArticulo = 3

-- Preparar una venta entregada
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-15'
DECLARE @idPedidoPrueba int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoPrueba, @p_idArticulo = 1, @p_Cantidad = 3
EXEC usp_entregarPedido @p_idPedido = @idPedidoPrueba

-- Debe reflejar la venta
SELECT * FROM vw_VentasPorArticulo WHERE idArticulo = 1

-- Un pedido SIN entregar no debe contar (preparar otro pedido, no entregarlo)
EXEC usp_insertarPedido @p_idCliente = 1, @p_Fecha = '2026-09-16'
DECLARE @idPedidoAbierto int = (SELECT MAX(idPedido) FROM Pedido)
EXEC usp_insertarDetallePedido @p_idPedido = @idPedidoAbierto, @p_idArticulo = 1, @p_Cantidad = 100
-- UnidadesVendidas de idArticulo = 1 NO debe incluir estas 100 unidades todavía
SELECT * FROM vw_VentasPorArticulo WHERE idArticulo = 1
```
