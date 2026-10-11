-- Consulta 1: Lista los pedidos de más de 5 kilos, ordenados del más pesado al más ligero.
SELECT idPedido, idCliente, FechaPedido, Kilos
FROM Pedido
WHERE Kilos > 5
ORDER BY Kilos DESC
