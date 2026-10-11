-- Consulta 7: Muestra cada pedido con el tipo de servicio, el precio por kilo cobrado y el precio por kilo actual del servicio.
SELECT P.idPedido, P.FechaPedido, T.Nombre AS TipoServicio, P.PrecioPorKilo AS PrecioCobrado, T.PrecioPorKilo AS PrecioActual
FROM Pedido P
INNER JOIN TipoServicio T ON T.idTipoServicio = P.idTipoServicio
ORDER BY P.FechaPedido
