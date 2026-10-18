SELECT C.idConsulta, C.idPaciente, C.Fecha, C.Efectuada
FROM Consulta C
LEFT JOIN Receta R ON R.idConsulta = C.idConsulta
WHERE R.idReceta IS NULL
