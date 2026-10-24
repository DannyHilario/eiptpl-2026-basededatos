-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Insertar las 8 clasificaciones de artículos
-- Autor:       Daniel Hilario

USE TiendaDB;

INSERT INTO Clasificacion (Nombre)
VALUES ('Bebidas'),
       ('Botanas'),
       ('Dulces y chocolates'),
       ('Lácteos'),
       ('Panadería'),
       ('Abarrotes'),
       ('Limpieza del hogar'),
       ('Higiene personal');
