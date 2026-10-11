-- Consulta 6: Muestra cada cliente con el nombre de la sucursal donde se registró.
SELECT C.Nombre AS Cliente, C.Telefono, S.Nombre AS Sucursal
FROM Cliente C
INNER JOIN Sucursal S ON S.idSucursal = C.idSucursal
