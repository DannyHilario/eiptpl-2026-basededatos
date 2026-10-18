SELECT R.idReceta, R.idConsulta, R.idEstatusReceta
FROM Receta R
LEFT JOIN DetalleReceta D ON D.idReceta = R.idReceta
WHERE D.idDetalleReceta IS NULL
