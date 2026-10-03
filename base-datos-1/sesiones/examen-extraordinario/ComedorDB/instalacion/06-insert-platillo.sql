-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Insertar 10 platillos del comedor subsidiado
-- Autor:       Daniel Hilario

USE ComedorDB;

INSERT INTO Platillo (Nombre, Descripcion, Precio)
VALUES ('Pozole rojo', 'Caldo de maíz cacahuazintle con carne de cerdo y chile guajillo', 45.00),
       ('Enchiladas verdes', 'Tortillas bañadas en salsa verde con pollo y crema', 40.00),
       ('Tacos de bistec', 'Tres tacos de carne de res asada con cebolla y cilantro', 38.00),
       ('Arroz con pollo', 'Pechuga de pollo guisada con arroz rojo y verduras', 42.00),
       ('Milanesa de res', 'Empanizada de res frita acompañada de ensalada de col', 48.00),
       ('Sopa de lima', 'Caldo de pollo con tortilla frita y lima yucateca', 35.00),
       ('Tamales de rajas', 'Masa de maíz rellena de rajas de chile poblano y queso', 30.00),
       ('Quesadillas de queso', 'Dos piezas de harina rellenas de queso Oaxaca', 32.00),
       ('Chile relleno', 'Chile poblano relleno de queso en caldillo de jitomate', 44.00),
       ('Frijoles charros', 'Caldo de frijol con chorizo, tocino y epazote', 28.00)
