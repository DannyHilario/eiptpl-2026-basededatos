SELECT M.Nombre, M.PrimerApellido, M.Cedula, E.Nombre AS Especialidad
FROM Medico M
INNER JOIN MedicoEspecialidad ME ON ME.idMedico = M.idMedico
INNER JOIN Especialidad E ON E.idEspecialidad = ME.idEspecialidad
ORDER BY M.PrimerApellido
