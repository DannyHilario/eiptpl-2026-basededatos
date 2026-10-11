-- Consulta 5: Muestra los 5 pedidos con más kilos.
SELECT TOP 5 idPedido, idCliente, FechaPedido, Kilos
FROM Pedido
ORDER BY Kilos DESC
