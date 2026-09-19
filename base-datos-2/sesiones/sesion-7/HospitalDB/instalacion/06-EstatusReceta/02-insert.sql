-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar catálogo de estatus de receta
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO EstatusReceta (Nombre, Activo)
VALUES ('Creada', 1),
       ('En atención', 1),
       ('Surtida', 1),
       ('Surtida parcialmente', 1),
       ('Cancelada', 1);
