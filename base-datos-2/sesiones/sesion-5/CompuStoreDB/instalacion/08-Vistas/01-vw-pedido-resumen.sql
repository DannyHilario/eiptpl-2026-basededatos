-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Vista de resumen de pedidos (cliente, estado de entrega y total)
-- Autor:       Daniel Hilario

USE CompuStoreDB;
GO

CREATE VIEW vw_PedidoResumen
AS
SELECT
	p.idPedido,
	p.idCliente,
	c.Nombre + ' ' + c.PrimerApellido + ISNULL(' ' + c.SegundoApellido, '') AS NombreCliente,
	p.Fecha,
	p.Cerrado,
	p.FechaEntrega,
	dbo.ufn_calcularTotalPedido(p.idPedido) AS Total
FROM Pedido p
INNER JOIN Cliente c ON c.idCliente = p.idCliente
