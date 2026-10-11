-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Insertar 5 tipos de servicio (Edredones no tiene pedidos)
-- Autor:       Daniel Hilario

USE LavaExpressDB;

INSERT INTO TipoServicio (Nombre, PrecioPorKilo)
VALUES ('Lavado', 28.00),
       ('Lavado y planchado', 45.00),
       ('Planchado', 35.00),
       ('Tintorería', 80.00),
       ('Edredones', 60.00);
