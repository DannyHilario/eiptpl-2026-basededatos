-- Consulta 2: Lista los clientes activos, del más antiguo al más reciente según su fecha de registro.
SELECT idCliente, Nombre, Telefono, FechaRegistro
FROM Cliente
WHERE Activo = 1
ORDER BY FechaRegistro
