-- Tema:        Ejercicio 1
-- Descripción: Consultas de ejemplo sobre Alumno
-- Autor:       Daniel Hilario

USE CursoDB;

SELECT *
FROM Alumno;

SELECT Nombre, Edad
FROM Alumno
WHERE Edad >= 30;

SELECT	idAlumno as ClaveAlumno,
		PrimerApellido + ' ' + SegundoApellido + ' ' + Nombre as NombreCompleto,
		Edad,
		Sexo
FROM Alumno
WHERE Edad = 21 AND Sexo = 'H';