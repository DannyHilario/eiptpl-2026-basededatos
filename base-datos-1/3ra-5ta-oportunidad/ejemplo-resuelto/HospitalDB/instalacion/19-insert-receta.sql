-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Insertar 15 recetas, una por consulta efectuada (las recetas 1, 2 y 3 no tienen medicamentos)
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Receta (idConsulta, idEstatusReceta)
VALUES (1, 1),
       (2, 1),
       (3, 5),
       (4, 2),
       (5, 2),
       (6, 2),
       (7, 2),
       (8, 3),
       (9, 3),
       (10, 3),
       (11, 3),
       (12, 4),
       (13, 4),
       (14, 2),
       (15, 5);
