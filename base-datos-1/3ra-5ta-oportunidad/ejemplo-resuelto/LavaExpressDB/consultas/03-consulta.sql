-- Consulta 3: Lista los clientes cuyo nombre comienza con la letra M.
SELECT idCliente, Nombre, Telefono
FROM Cliente
WHERE Nombre LIKE 'M%'
