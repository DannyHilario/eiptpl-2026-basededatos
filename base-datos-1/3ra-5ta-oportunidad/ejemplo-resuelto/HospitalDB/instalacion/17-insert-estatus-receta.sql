-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Insertar los 5 estatus que puede tener una receta
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO EstatusReceta (Nombre, Activo)
VALUES ('Creada', 1),
       ('En atención', 1),
       ('Surtida', 1),
       ('Surtida parcialmente', 1),
       ('Cancelada', 1);
