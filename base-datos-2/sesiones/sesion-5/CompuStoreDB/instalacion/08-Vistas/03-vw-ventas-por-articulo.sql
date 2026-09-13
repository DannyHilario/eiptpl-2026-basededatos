-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Vista de unidades vendidas y total facturado por artículo (solo pedidos entregados)
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE VIEW vw_VentasPorArticulo
AS
SELECT
	a.idArticulo,
	a.Nombre AS Articulo,
	a.Marca,
	ISNULL(SUM(dp.Cantidad), 0) AS UnidadesVendidas,
	ISNULL(SUM(dp.Cantidad * dp.PrecioUnitario), 0) AS TotalFacturado
FROM Articulo a
LEFT JOIN (
	DetallePedido dp
	INNER JOIN Pedido p ON p.idPedido = dp.idPedido AND p.Cerrado = 1
) ON dp.idArticulo = a.idArticulo
GROUP BY a.idArticulo, a.Nombre, a.Marca
