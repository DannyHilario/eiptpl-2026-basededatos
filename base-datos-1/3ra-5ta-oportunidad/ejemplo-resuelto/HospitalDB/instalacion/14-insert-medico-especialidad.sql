-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Insertar las 13 especialidades que ejerce cada médico (un médico puede tener más de una)
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO MedicoEspecialidad (idMedico, idEspecialidad)
VALUES (1, 1),
       (1, 3),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (5, 10),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10),
       (10, 1);
