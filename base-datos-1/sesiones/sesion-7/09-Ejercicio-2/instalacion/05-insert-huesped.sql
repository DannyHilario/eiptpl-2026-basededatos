-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar huéspedes ficticios
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Huesped (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
VALUES ('Ramírez', 'Fuentes', 'Carlos', '81-5543-2210', 'carlos.ramirez@gmail.com'),
       ('Torres', 'Salinas', 'Ana', '33-6621-8845', 'ana.torres@hotmail.com'),
       ('Mendoza', 'Ríos', 'Patricia', '55-7734-1190', 'patricia.mendoza@outlook.com'),
       ('Guerrero', 'Ibáñez', 'Roberto', '81-9981-4422', 'roberto.guerrero@gmail.com'),
       ('Castillo', 'Vega', 'Sofía', '222-4456-9900', 'sofia.castillo@gmail.com'),
       ('Navarro', 'Cruz', 'Miguel', '33-5510-7723', 'miguel.navarro@yahoo.com'),
       ('Herrera', 'Mora', 'Daniela', '55-2231-6677', 'daniela.herrera@gmail.com'),
       ('Aguilar', 'Peña', 'Luis', '81-8890-3344', 'luis.aguilar@hotmail.com')
