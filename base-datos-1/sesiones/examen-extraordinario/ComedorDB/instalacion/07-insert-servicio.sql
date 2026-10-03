-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Insertar 54 registros de servicio (empleados 1-22 tienen consumos;
--              empleados 23-25 no tienen ningún servicio registrado)
--              Nota: el Precio refleja el cobro del día; algunos platillos
--              tuvieron precio distinto en abril vs mayo de 2026.
-- Autor:       Daniel Hilario

USE ComedorDB;

-- Servicios del 7 al 9 de abril de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (1, 3, '2026-04-07', 38.00),
       (5, 6, '2026-04-07', 35.00),
       (10, 7, '2026-04-07', 30.00),
       (2, 1, '2026-04-08', 42.00),
       (6, 5, '2026-04-08', 45.00),
       (11, 2, '2026-04-08', 38.00),
       (3, 8, '2026-04-09', 30.00),
       (7, 4, '2026-04-09', 40.00),
       (12, 9, '2026-04-09', 42.00)

-- Servicios del 10 al 15 de abril de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (4, 2, '2026-04-10', 38.00),
       (8, 3, '2026-04-10', 38.00),
       (13, 1, '2026-04-10', 42.00),
       (1, 5, '2026-04-14', 45.00),
       (9, 7, '2026-04-14', 30.00),
       (14, 6, '2026-04-14', 35.00),
       (5, 9, '2026-04-15', 42.00),
       (10, 8, '2026-04-15', 30.00),
       (15, 4, '2026-04-15', 40.00)

-- Servicios del 16 al 21 de abril de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (2, 3, '2026-04-16', 38.00),
       (6, 1, '2026-04-16', 42.00),
       (16, 2, '2026-04-16', 38.00),
       (3, 6, '2026-04-17', 35.00),
       (7, 5, '2026-04-17', 45.00),
       (17, 3, '2026-04-17', 38.00),
       (4, 7, '2026-04-21', 30.00),
       (8, 2, '2026-04-21', 38.00),
       (18, 9, '2026-04-21', 42.00)

-- Servicios del 22 de abril al 6 de mayo de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (11, 4, '2026-04-22', 40.00),
       (19, 1, '2026-04-22', 42.00),
       (20, 3, '2026-04-22', 38.00),
       (1, 1, '2026-05-05', 45.00),
       (5, 2, '2026-05-05', 40.00),
       (21, 5, '2026-05-05', 48.00),
       (2, 4, '2026-05-06', 42.00),
       (9, 8, '2026-05-06', 32.00),
       (22, 7, '2026-05-06', 30.00)

-- Servicios del 7 al 13 de mayo de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (3, 5, '2026-05-07', 48.00),
       (10, 3, '2026-05-07', 38.00),
       (12, 9, '2026-05-07', 44.00),
       (4, 9, '2026-05-12', 44.00),
       (6, 7, '2026-05-12', 30.00),
       (13, 4, '2026-05-12', 42.00),
       (7, 2, '2026-05-13', 40.00),
       (11, 8, '2026-05-13', 32.00),
       (14, 1, '2026-05-13', 45.00)

-- Servicios del 19 al 26 de mayo de 2026
INSERT INTO Servicio (idEmpleado, idPlatillo, FechaServicio, Precio)
VALUES (8, 6, '2026-05-19', 35.00),
       (15, 5, '2026-05-19', 48.00),
       (16, 3, '2026-05-19', 38.00),
       (17, 2, '2026-05-20', 40.00),
       (18, 9, '2026-05-20', 44.00),
       (19, 6, '2026-05-20', 35.00),
       (20, 1, '2026-05-26', 45.00),
       (21, 8, '2026-05-26', 32.00),
       (22, 4, '2026-05-26', 42.00)
