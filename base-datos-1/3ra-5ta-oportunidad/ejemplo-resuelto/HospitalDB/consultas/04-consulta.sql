SELECT idConsulta, idPaciente, idMedico, idConsultorio, Fecha
FROM Consulta
WHERE MONTH(Fecha) = 9 AND YEAR(Fecha) = 2026 AND Efectuada = 1
ORDER BY Fecha
