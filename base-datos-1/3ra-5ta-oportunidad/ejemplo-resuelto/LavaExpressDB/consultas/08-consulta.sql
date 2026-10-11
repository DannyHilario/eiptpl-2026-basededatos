-- Consulta 8: Muestra cada pedido con el nombre del cliente, el tipo de servicio, los kilos y el precio por kilo cobrado.
SELECT P.FechaPedido, C.Nombre AS Cliente, T.Nombre AS TipoServicio, P.Kilos, P.PrecioPorKilo
FROM Pedido P
INNER JOIN Cliente C ON C.idCliente = P.idCliente
INNER JOIN TipoServicio T ON T.idTipoServicio = P.idTipoServicio
ORDER BY P.FechaPedido
