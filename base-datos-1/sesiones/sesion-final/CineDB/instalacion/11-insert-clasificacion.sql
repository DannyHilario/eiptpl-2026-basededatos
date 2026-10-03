-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar catálogo de clasificaciones
-- Autor:       Daniel Hilario

USE CineDB;

INSERT INTO Clasificacion (Nombre, Descripcion, Activo)
VALUES ('AA', 'Apta para todo público', 1),
       ('A', 'Público en general', 1),
       ('B', 'Mayores de 15 años', 1),
       ('C', 'Mayores de 18 años', 1);
