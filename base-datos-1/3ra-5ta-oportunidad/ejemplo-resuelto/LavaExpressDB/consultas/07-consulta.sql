-- Consulta 7: Muestra los pedidos que se cobraron con un precio por kilo distinto al precio actual del servicio.
SELECT P.idPedido, P.FechaPedido, T.Nombre AS TipoServicio, P.PrecioPorKilo AS PrecioCobrado, T.PrecioPorKilo AS PrecioActual
FROM Pedido P
INNER JOIN TipoServicio T ON T.idTipoServicio = P.idTipoServicio
WHERE P.PrecioPorKilo <> T.PrecioPorKilo
ORDER BY P.FechaPedido
