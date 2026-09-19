-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 15 recetas (una por consulta), repartidas entre los 5 estatus
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Estatus: 1 Creada, 2 En atención, 3 Surtida, 4 Surtida parcialmente, 5 Cancelada

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
