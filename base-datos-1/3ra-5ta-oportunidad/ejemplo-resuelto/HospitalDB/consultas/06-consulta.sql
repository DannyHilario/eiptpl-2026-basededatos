SELECT R.idReceta, R.idConsulta, E.Nombre AS Estatus
FROM Receta R
INNER JOIN EstatusReceta E ON E.idEstatusReceta = R.idEstatusReceta
