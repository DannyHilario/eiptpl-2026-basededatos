-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar 200 servicios distribuidos en vehículos 1-140
--              Vehículos 141-170 (y 61, 70, 94, 103, 127, 136) NO tienen órdenes (útil para LEFT/RIGHT JOIN)
--              Servicios: 1=Afinación, 2=Cambio de aceite, 3=Frenos,
--                         4=Suspensión, 5=Diagnóstico, 6=Cambio de llantas
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Órdenes 1-25
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (3, 2, '2026-01-05', 450.00),
       (15, 1, '2026-01-05', 850.00),
       (27, 5, '2026-01-06', 350.00),
       (8, 3, '2026-01-07', 1200.00),
       (42, 2, '2026-01-08', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (71, 6, '2026-01-09', 3200.00),
       (19, 4, '2026-01-10', 2500.00),
       (55, 1, '2026-01-12', 850.00),
       (88, 2, '2026-01-13', 450.00),
       (1, 5, '2026-01-14', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (33, 3, '2026-01-15', 1200.00),
       (64, 1, '2026-01-16', 850.00),
       (97, 2, '2026-01-17', 450.00),
       (120, 4, '2026-01-19', 2500.00),
       (7, 5, '2026-01-20', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (44, 6, '2026-01-21', 3200.00),
       (78, 1, '2026-01-22', 850.00),
       (110, 3, '2026-01-23', 1200.00),
       (22, 2, '2026-01-26', 450.00),
       (56, 5, '2026-01-27', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (89, 4, '2026-01-28', 2500.00),
       (130, 1, '2026-01-29', 850.00),
       (13, 2, '2026-01-30', 450.00),
       (47, 6, '2026-02-02', 3200.00),
       (81, 3, '2026-02-03', 1200.00);

-- Órdenes 26-50
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (114, 5, '2026-02-04', 350.00),
       (2, 1, '2026-02-05', 850.00),
       (36, 2, '2026-02-06', 450.00),
       (69, 4, '2026-02-09', 2500.00),
       (102, 3, '2026-02-10', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (18, 6, '2026-02-11', 3200.00),
       (52, 1, '2026-02-12', 850.00),
       (85, 2, '2026-02-13', 450.00),
       (118, 5, '2026-02-16', 350.00),
       (11, 3, '2026-02-17', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (45, 4, '2026-02-18', 2500.00),
       (79, 1, '2026-02-19', 850.00),
       (112, 2, '2026-02-20', 450.00),
       (25, 6, '2026-02-23', 3200.00),
       (59, 5, '2026-02-24', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (92, 1, '2026-02-25', 850.00),
       (125, 3, '2026-02-26', 1200.00),
       (4, 2, '2026-02-27', 450.00),
       (38, 4, '2026-03-02', 2500.00),
       (72, 6, '2026-03-03', 3200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (105, 1, '2026-03-04', 850.00),
       (16, 5, '2026-03-05', 350.00),
       (50, 2, '2026-03-06', 450.00),
       (83, 3, '2026-03-09', 1200.00),
       (116, 4, '2026-03-10', 2500.00);

-- Órdenes 51-75
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (29, 1, '2026-03-11', 850.00),
       (63, 2, '2026-03-12', 450.00),
       (96, 6, '2026-03-13', 3200.00),
       (129, 5, '2026-03-16', 350.00),
       (10, 3, '2026-03-17', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (43, 1, '2026-03-18', 850.00),
       (76, 2, '2026-03-19', 450.00),
       (109, 4, '2026-03-20', 2500.00),
       (21, 6, '2026-03-23', 3200.00),
       (54, 5, '2026-03-24', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (87, 1, '2026-03-25', 850.00),
       (120, 3, '2026-03-26', 1200.00),
       (6, 2, '2026-03-27', 450.00),
       (39, 4, '2026-03-30', 2500.00),
       (73, 1, '2026-03-31', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (106, 6, '2026-04-01', 3200.00),
       (14, 5, '2026-04-02', 350.00),
       (48, 2, '2026-04-03', 450.00),
       (81, 3, '2026-04-06', 1200.00),
       (114, 1, '2026-04-07', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (27, 4, '2026-04-08', 2500.00),
       (60, 2, '2026-04-09', 450.00),
       (93, 6, '2026-04-10', 3200.00),
       (126, 5, '2026-04-13', 350.00),
       (9, 1, '2026-04-14', 850.00);

-- Órdenes 76-100
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (42, 3, '2026-04-15', 1200.00),
       (75, 2, '2026-04-16', 450.00),
       (108, 4, '2026-04-17', 2500.00),
       (23, 6, '2026-04-20', 3200.00),
       (57, 1, '2026-01-08', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (90, 5, '2026-01-09', 350.00),
       (123, 2, '2026-01-10', 450.00),
       (5, 3, '2026-01-13', 1200.00),
       (40, 4, '2026-01-14', 2500.00),
       (74, 1, '2026-01-15', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (107, 6, '2026-01-16', 3200.00),
       (20, 2, '2026-01-19', 450.00),
       (53, 5, '2026-01-20', 350.00),
       (86, 3, '2026-01-21', 1200.00),
       (119, 1, '2026-01-22', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (31, 4, '2026-01-23', 2500.00),
       (65, 2, '2026-01-26', 450.00),
       (98, 6, '2026-01-27', 3200.00),
       (131, 5, '2026-01-28', 350.00),
       (12, 1, '2026-01-29', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (46, 2, '2026-02-02', 450.00),
       (80, 3, '2026-02-03', 1200.00),
       (113, 4, '2026-02-04', 2500.00),
       (26, 1, '2026-02-05', 850.00),
       (60, 6, '2026-02-06', 3200.00);

-- Órdenes 101-125
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (93, 2, '2026-02-09', 450.00),
       (126, 3, '2026-02-10', 1200.00),
       (17, 5, '2026-02-11', 350.00),
       (51, 1, '2026-02-12', 850.00),
       (84, 2, '2026-02-13', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (117, 4, '2026-02-16', 2500.00),
       (30, 6, '2026-02-17', 3200.00),
       (64, 3, '2026-02-18', 1200.00),
       (97, 5, '2026-02-19', 350.00),
       (130, 1, '2026-02-20', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (24, 2, '2026-02-23', 450.00),
       (58, 4, '2026-02-24', 2500.00),
       (91, 6, '2026-02-25', 3200.00),
       (124, 5, '2026-02-26', 350.00),
       (8, 1, '2026-02-27', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (41, 2, '2026-03-02', 450.00),
       (75, 3, '2026-03-03', 1200.00),
       (108, 5, '2026-03-04', 350.00),
       (19, 1, '2026-03-05', 850.00),
       (52, 6, '2026-03-06', 3200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (85, 2, '2026-03-09', 450.00),
       (118, 4, '2026-03-10', 2500.00),
       (32, 1, '2026-03-11', 850.00),
       (66, 3, '2026-03-12', 1200.00),
       (99, 5, '2026-03-13', 350.00);

-- Órdenes 126-150
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (132, 2, '2026-03-16', 450.00),
       (7, 4, '2026-03-17', 2500.00),
       (43, 6, '2026-03-18', 3200.00),
       (77, 1, '2026-03-19', 850.00),
       (110, 2, '2026-03-20', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (22, 3, '2026-03-23', 1200.00),
       (56, 5, '2026-03-24', 350.00),
       (89, 1, '2026-03-25', 850.00),
       (122, 4, '2026-03-26', 2500.00),
       (35, 6, '2026-03-27', 3200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (69, 2, '2026-03-30', 450.00),
       (102, 3, '2026-03-31', 1200.00),
       (135, 5, '2026-04-01', 350.00),
       (15, 1, '2026-04-02', 850.00),
       (49, 2, '2026-04-03', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (82, 4, '2026-04-06', 2500.00),
       (115, 6, '2026-04-07', 3200.00),
       (28, 5, '2026-04-08', 350.00),
       (62, 1, '2026-04-09', 850.00),
       (95, 2, '2026-04-10', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (128, 3, '2026-04-13', 1200.00),
       (11, 4, '2026-04-14', 2500.00),
       (44, 6, '2026-04-15', 3200.00),
       (78, 5, '2026-04-16', 350.00),
       (111, 1, '2026-04-17', 850.00);

-- Órdenes 151-175
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (33, 2, '2026-01-07', 450.00),
       (67, 4, '2026-01-08', 2500.00),
       (100, 6, '2026-01-09', 3200.00),
       (133, 3, '2026-01-12', 1200.00),
       (16, 5, '2026-01-13', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (50, 1, '2026-01-14', 850.00),
       (83, 2, '2026-01-15', 450.00),
       (116, 4, '2026-01-16', 2500.00),
       (29, 6, '2026-01-19', 3200.00),
       (63, 3, '2026-01-20', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (96, 5, '2026-01-21', 350.00),
       (129, 1, '2026-01-22', 850.00),
       (37, 2, '2026-01-23', 450.00),
       (71, 3, '2026-01-26', 1200.00),
       (104, 4, '2026-01-27', 2500.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (137, 5, '2026-01-28', 350.00),
       (23, 1, '2026-01-29', 850.00),
       (57, 6, '2026-01-30', 3200.00),
       (90, 2, '2026-02-02', 450.00),
       (123, 3, '2026-02-03', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (38, 5, '2026-02-04', 350.00),
       (72, 1, '2026-02-05', 850.00),
       (105, 4, '2026-02-06', 2500.00),
       (138, 2, '2026-02-09', 450.00),
       (13, 6, '2026-02-10', 3200.00);

-- Órdenes 176-200
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (47, 3, '2026-02-11', 1200.00),
       (80, 5, '2026-02-12', 350.00),
       (113, 1, '2026-02-13', 850.00),
       (34, 2, '2026-02-16', 450.00),
       (68, 4, '2026-02-17', 2500.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (101, 6, '2026-02-18', 3200.00),
       (134, 3, '2026-02-19', 1200.00),
       (21, 5, '2026-02-20', 350.00),
       (55, 1, '2026-02-23', 850.00),
       (88, 2, '2026-02-24', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (121, 4, '2026-02-25', 2500.00),
       (4, 6, '2026-02-26', 3200.00),
       (39, 3, '2026-02-27', 1200.00),
       (73, 5, '2026-03-02', 350.00),
       (106, 1, '2026-03-03', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (139, 2, '2026-03-04', 450.00),
       (14, 3, '2026-03-05', 1200.00),
       (48, 4, '2026-03-06', 2500.00),
       (82, 5, '2026-03-09', 350.00),
       (115, 1, '2026-03-10', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (28, 2, '2026-03-11', 450.00),
       (62, 6, '2026-03-12', 3200.00),
       (95, 3, '2026-03-13', 1200.00),
       (128, 4, '2026-03-16', 2500.00),
       (140, 1, '2026-03-17', 850.00);
