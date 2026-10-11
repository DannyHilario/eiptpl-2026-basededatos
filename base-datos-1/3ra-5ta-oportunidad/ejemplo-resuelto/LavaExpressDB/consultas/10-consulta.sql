-- Consulta 10: Lista los tipos de servicio que nunca se han solicitado.
SELECT T.idTipoServicio, T.Nombre, T.PrecioPorKilo
FROM TipoServicio T
LEFT JOIN Pedido P ON P.idTipoServicio = T.idTipoServicio
WHERE P.idPedido IS NULL
