-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar catálogo de tipos de sala
-- Autor:       Daniel Hilario

USE CineDB;

INSERT INTO TipoSala (Descripcion, Precio, Activo)
VALUES ('2D', 90.00, 1),
       ('3D', 130.00, 1),
       ('IMAX', 180.00, 1),
       ('VIP', 220.00, 1);
