-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar habitaciones
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Habitacion (idTipoHabitacion, NumeroHabitacion, DescripcionHabitacion)
VALUES (1, '101', 'Planta baja, vista al jardín'),
       (1, '102', 'Planta baja, vista al patio'),
       (2, '201', 'Segunda planta, vista a la calle'),
       (2, '202', 'Segunda planta, vista a la piscina'),
       (2, '203', 'Segunda planta, balcón privado'),
       (3, '301', 'Planta alta, terraza privada'),
       (3, '302', 'Planta alta, jacuzzi y vista panorámica')
