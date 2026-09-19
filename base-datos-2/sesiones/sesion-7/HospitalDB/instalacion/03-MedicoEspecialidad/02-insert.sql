-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar relaciones Medico-Especialidad (algunos médicos con más de una especialidad, para ilustrar la relación N:M)
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Especialidades: 1 Medicina General, 2 Pediatría, 3 Cardiología, 4 Dermatología, 5 Ginecología,
--                 6 Traumatología, 7 Oftalmología, 8 Otorrinolaringología, 9 Psiquiatría, 10 Endocrinología

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
