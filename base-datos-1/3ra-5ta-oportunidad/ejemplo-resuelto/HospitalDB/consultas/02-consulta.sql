SELECT idPaciente, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento
FROM Paciente
WHERE Activo = 1
ORDER BY FechaNacimiento
