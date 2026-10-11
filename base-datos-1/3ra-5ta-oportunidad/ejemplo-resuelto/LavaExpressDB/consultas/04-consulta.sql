-- Consulta 4: Lista los pedidos realizados en marzo de 2026, ordenados por fecha.
SELECT idPedido, idCliente, FechaPedido, Kilos
FROM Pedido
WHERE MONTH(FechaPedido) = 3 AND YEAR(FechaPedido) = 2026
ORDER BY FechaPedido
