SELECT C.idConsulta, P.Nombre + ' ' + P.PrimerApellido AS Paciente, M.Nombre + ' ' + M.PrimerApellido AS Medico,
       CO.Nombre AS Consultorio, C.Fecha
FROM Consulta C
INNER JOIN Paciente P ON P.idPaciente = C.idPaciente
INNER JOIN Medico M ON M.idMedico = C.idMedico
INNER JOIN Consultorio CO ON CO.idConsultorio = C.idConsultorio
ORDER BY C.Fecha
