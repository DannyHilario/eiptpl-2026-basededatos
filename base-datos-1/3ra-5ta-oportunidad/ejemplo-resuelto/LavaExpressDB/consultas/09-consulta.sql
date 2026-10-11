-- Consulta 9: Lista los clientes que nunca han hecho un pedido.
SELECT C.idCliente, C.Nombre, C.Telefono
FROM Cliente C
LEFT JOIN Pedido P ON P.idCliente = C.idCliente
WHERE P.idPedido IS NULL
