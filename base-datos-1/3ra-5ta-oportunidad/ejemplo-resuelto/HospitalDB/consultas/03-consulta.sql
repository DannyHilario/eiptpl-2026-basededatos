SELECT idPaciente, Nombre, PrimerApellido, Correo
FROM Paciente
WHERE Correo LIKE '%@gmail.com'
