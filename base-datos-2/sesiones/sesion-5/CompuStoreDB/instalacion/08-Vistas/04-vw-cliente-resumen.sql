-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Vista de resumen de clientes (número de pedidos, total gastado en pedidos entregados)
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE VIEW vw_ClienteResumen
AS
SELECT
	c.idCliente,
	c.Nombre + ' ' + c.PrimerApellido + ISNULL(' ' + c.SegundoApellido, '') AS NombreCliente,
	COUNT(p.idPedido) AS TotalPedidos,
	ISNULL(SUM(CASE WHEN p.Cerrado = 1 THEN dbo.ufn_calcularTotalPedido(p.idPedido) ELSE 0 END), 0) AS TotalGastado,
	MAX(p.Fecha) AS FechaUltimoPedido
FROM Cliente c
LEFT JOIN Pedido p ON p.idCliente = c.idCliente
GROUP BY c.idCliente, c.Nombre, c.PrimerApellido, c.SegundoApellido
