SELECT idDetalleReceta, idReceta, idMedicamento, Cantidad
FROM DetalleReceta
WHERE Cantidad > 10
ORDER BY Cantidad DESC
