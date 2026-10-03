-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar 170 vehículos para clientes 1-155
--              Clientes 1-15 tienen 2 vehículos; clientes 16-155 tienen 1 vehículo
--              Clientes 156-200 NO tienen vehículo (útil para LEFT/RIGHT JOIN)
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Vehículos 1-30: clientes 1-15 con dos vehículos cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (1, 'Nissan', 'Versa', 2020, 1),
       (1, 'Chevrolet', 'Spark', 2018, 1),
       (2, 'Volkswagen', 'Vento', 2019, 1),
       (2, 'Toyota', 'Yaris', 2021, 1),
       (3, 'Ford', 'Figo', 2017, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (3, 'Kia', 'Rio', 2022, 1),
       (4, 'Hyundai', 'Accent', 2020, 1),
       (4, 'Nissan', 'March', 2016, 1),
       (5, 'Mazda', 'Mazda3', 2021, 1),
       (5, 'Honda', 'City', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (6, 'Seat', 'Ibiza', 2022, 1),
       (6, 'Chevrolet', 'Aveo', 2015, 1),
       (7, 'Volkswagen', 'Jetta', 2021, 1),
       (7, 'Toyota', 'Corolla', 2018, 1),
       (8, 'Nissan', 'Sentra', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (8, 'Ford', 'Escape', 2022, 1),
       (9, 'Kia', 'Sportage', 2019, 1),
       (9, 'Hyundai', 'Tucson', 2021, 1),
       (10, 'Mazda', 'CX-30', 2022, 1),
       (10, 'Honda', 'HR-V', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (11, 'Nissan', 'NP300', 2018, 1),
       (11, 'Chevrolet', 'S10', 2019, 1),
       (12, 'Toyota', 'Hilux', 2020, 1),
       (12, 'Volkswagen', 'Tiguan', 2021, 1),
       (13, 'Ford', 'F-150', 2017, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (13, 'Kia', 'Soul', 2022, 1),
       (14, 'Seat', 'Ateca', 2021, 1),
       (14, 'Honda', 'Civic', 2019, 1),
       (15, 'Hyundai', 'Creta', 2022, 1),
       (15, 'Mazda', 'CX-5', 2020, 1);

-- Vehículos 31-80: clientes 16-65 con un vehículo cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (16, 'Nissan', 'Versa', 2018, 1),
       (17, 'Volkswagen', 'Gol', 2017, 1),
       (18, 'Chevrolet', 'Spark', 2021, 1),
       (19, 'Toyota', 'Yaris', 2019, 1),
       (20, 'Ford', 'Figo', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (21, 'Kia', 'Picanto', 2018, 1),
       (22, 'Hyundai', 'Grand i10', 2021, 1),
       (23, 'Honda', 'City', 2020, 1),
       (24, 'Seat', 'Arona', 2022, 1),
       (25, 'Mazda', 'Mazda2', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (26, 'Nissan', 'March', 2020, 1),
       (27, 'Volkswagen', 'Vento', 2021, 1),
       (28, 'Chevrolet', 'Aveo', 2018, 1),
       (29, 'Toyota', 'Corolla', 2022, 1),
       (30, 'Ford', 'EcoSport', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (31, 'Kia', 'Rio', 2020, 1),
       (32, 'Hyundai', 'Accent', 2017, 1),
       (33, 'Honda', 'HR-V', 2021, 1),
       (34, 'Seat', 'Ibiza', 2020, 1),
       (35, 'Mazda', 'Mazda3', 2022, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (36, 'Nissan', 'Sentra', 2019, 1),
       (37, 'Volkswagen', 'Jetta', 2020, 1),
       (38, 'Chevrolet', 'Trax', 2021, 1),
       (39, 'Toyota', 'RAV4', 2022, 1),
       (40, 'Ford', 'Escape', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (41, 'Kia', 'Sportage', 2020, 1),
       (42, 'Hyundai', 'Tucson', 2018, 1),
       (43, 'Honda', 'CR-V', 2021, 1),
       (44, 'Seat', 'Ateca', 2019, 1),
       (45, 'Mazda', 'CX-30', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (46, 'Nissan', 'Versa', 2021, 1),
       (47, 'Volkswagen', 'Gol', 2018, 1),
       (48, 'Chevrolet', 'Spark', 2020, 1),
       (49, 'Toyota', 'Yaris', 2021, 1),
       (50, 'Ford', 'Figo', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (51, 'Kia', 'Picanto', 2022, 1),
       (52, 'Hyundai', 'Grand i10', 2020, 1),
       (53, 'Honda', 'City', 2018, 1),
       (54, 'Seat', 'Arona', 2021, 1),
       (55, 'Mazda', 'Mazda2', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (56, 'Nissan', 'March', 2019, 1),
       (57, 'Volkswagen', 'Vento', 2022, 1),
       (58, 'Chevrolet', 'Aveo', 2020, 1),
       (59, 'Toyota', 'Corolla', 2019, 1),
       (60, 'Ford', 'EcoSport', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (61, 'Kia', 'Rio', 2019, 1),
       (62, 'Hyundai', 'Accent', 2022, 1),
       (63, 'Honda', 'HR-V', 2019, 1),
       (64, 'Seat', 'Ibiza', 2021, 1),
       (65, 'Mazda', 'Mazda3', 2020, 1);

-- Vehículos 81-130: clientes 66-115 con un vehículo cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (66, 'Nissan', 'Sentra', 2021, 1),
       (67, 'Volkswagen', 'Jetta', 2019, 1),
       (68, 'Chevrolet', 'Trax', 2020, 1),
       (69, 'Toyota', 'RAV4', 2021, 1),
       (70, 'Ford', 'Escape', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (71, 'Kia', 'Sportage', 2021, 1),
       (72, 'Hyundai', 'Tucson', 2019, 1),
       (73, 'Honda', 'CR-V', 2020, 1),
       (74, 'Seat', 'Ateca', 2022, 1),
       (75, 'Mazda', 'CX-30', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (76, 'Nissan', 'Versa', 2022, 1),
       (77, 'Volkswagen', 'Gol', 2020, 1),
       (78, 'Chevrolet', 'Spark', 2019, 1),
       (79, 'Toyota', 'Yaris', 2022, 1),
       (80, 'Ford', 'Figo', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (81, 'Kia', 'Picanto', 2021, 1),
       (82, 'Hyundai', 'Grand i10', 2019, 1),
       (83, 'Honda', 'City', 2022, 1),
       (84, 'Seat', 'Arona', 2020, 1),
       (85, 'Mazda', 'Mazda2', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (86, 'Nissan', 'March', 2021, 1),
       (87, 'Volkswagen', 'Vento', 2020, 1),
       (88, 'Chevrolet', 'Aveo', 2022, 1),
       (89, 'Toyota', 'Corolla', 2020, 1),
       (90, 'Ford', 'EcoSport', 2022, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (91, 'Kia', 'Rio', 2021, 1),
       (92, 'Hyundai', 'Accent', 2020, 1),
       (93, 'Honda', 'HR-V', 2022, 1),
       (94, 'Seat', 'Ibiza', 2019, 1),
       (95, 'Mazda', 'Mazda3', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (96, 'Nissan', 'Sentra', 2022, 1),
       (97, 'Volkswagen', 'Jetta', 2022, 1),
       (98, 'Chevrolet', 'Trax', 2019, 1),
       (99, 'Toyota', 'RAV4', 2019, 1),
       (100, 'Ford', 'Escape', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (101, 'Kia', 'Sportage', 2022, 1),
       (102, 'Hyundai', 'Tucson', 2022, 1),
       (103, 'Honda', 'CR-V', 2019, 1),
       (104, 'Seat', 'Ateca', 2020, 1),
       (105, 'Mazda', 'CX-30', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (106, 'Nissan', 'Versa', 2019, 1),
       (107, 'Volkswagen', 'Gol', 2021, 1),
       (108, 'Chevrolet', 'Spark', 2022, 1),
       (109, 'Toyota', 'Yaris', 2020, 1),
       (110, 'Ford', 'Figo', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (111, 'Kia', 'Picanto', 2020, 1),
       (112, 'Hyundai', 'Grand i10', 2022, 1),
       (113, 'Honda', 'City', 2021, 1),
       (114, 'Seat', 'Arona', 2019, 1),
       (115, 'Mazda', 'Mazda2', 2022, 1);

-- Vehículos 131-170: clientes 116-155 con un vehículo cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (116, 'Nissan', 'March', 2022, 1),
       (117, 'Volkswagen', 'Vento', 2019, 1),
       (118, 'Chevrolet', 'Aveo', 2021, 1),
       (119, 'Toyota', 'Corolla', 2021, 1),
       (120, 'Ford', 'EcoSport', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (121, 'Kia', 'Rio', 2022, 1),
       (122, 'Hyundai', 'Accent', 2019, 1),
       (123, 'Honda', 'HR-V', 2020, 1),
       (124, 'Seat', 'Ibiza', 2018, 1),
       (125, 'Mazda', 'Mazda3', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (126, 'Nissan', 'Sentra', 2018, 1),
       (127, 'Volkswagen', 'Jetta', 2018, 1),
       (128, 'Chevrolet', 'Trax', 2022, 1),
       (129, 'Toyota', 'RAV4', 2020, 1),
       (130, 'Ford', 'Escape', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (131, 'Kia', 'Sportage', 2018, 1),
       (132, 'Hyundai', 'Tucson', 2020, 1),
       (133, 'Honda', 'CR-V', 2022, 1),
       (134, 'Seat', 'Ateca', 2018, 1),
       (135, 'Mazda', 'CX-5', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (136, 'Nissan', 'Versa', 2017, 1),
       (137, 'Volkswagen', 'Gol', 2019, 1),
       (138, 'Chevrolet', 'Spark', 2018, 1),
       (139, 'Toyota', 'Yaris', 2018, 1),
       (140, 'Ford', 'Figo', 2022, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (141, 'Kia', 'Picanto', 2019, 1),
       (142, 'Hyundai', 'Grand i10', 2021, 1),
       (143, 'Honda', 'City', 2019, 1),
       (144, 'Seat', 'Arona', 2018, 1),
       (145, 'Mazda', 'Mazda2', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (146, 'Nissan', 'March', 2018, 1),
       (147, 'Volkswagen', 'Vento', 2018, 1),
       (148, 'Chevrolet', 'Aveo', 2019, 1),
       (149, 'Toyota', 'Corolla', 2017, 1),
       (150, 'Ford', 'EcoSport', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (151, 'Kia', 'Rio', 2018, 1),
       (152, 'Hyundai', 'Accent', 2021, 1),
       (153, 'Honda', 'HR-V', 2018, 1),
       (154, 'Seat', 'Ibiza', 2022, 1),
       (155, 'Mazda', 'Mazda3', 2017, 1);
