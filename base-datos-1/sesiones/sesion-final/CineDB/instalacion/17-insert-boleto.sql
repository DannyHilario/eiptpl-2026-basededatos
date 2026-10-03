-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 100 boletos vendidos en mayo y junio 2026
-- Autor:       Daniel Hilario

USE CineDB;

-- Clientes que compraron (mayo):   1,2,3,5,7,9,11,13,15,17,19  (11 de 20)
-- Clientes sin compras (mayo):     4,6,8,10,12,14,16,18,20
-- Clientes que compraron (junio):  21,22,24,25,27,30,31,33,35,37,39  (11 de 20 nuevos)
-- Clientes sin compras (junio):    23,26,28,29,32,34,36,38,40
--
-- Referencia funciones mayo (1-45):
--  1=Intensamente 2 (03-may)    2=Intensamente 2 (10-may)   3=Intensamente 2 (24-may)
--  4=Moana 2 (02-may)           5=Moana 2 (12-may)          6=Moana 2 (23-may)
--  7=El Robot Salvaje (04-may)  8=El Robot Salvaje (16-may)  9=El Robot Salvaje (25-may)
-- 10=Wicked (01-may)           11=Wicked (14-may)           12=Wicked (22-may)
-- 13=Cónclave (05-may)         14=Cónclave (13-may)         15=Cónclave (28-may)
-- 16=Dune (02-may)             17=Dune (15-may)             18=Dune (29-may)
-- 19=Oppenheimer (06-may)      20=Oppenheimer (17-may)      21=Oppenheimer (30-may)
-- 22=Un lugar (03-may)         23=Un lugar (11-may)         24=Un lugar (24-may)
-- 25=Deadpool (01-may)         26=Deadpool (09-may)         27=Deadpool (21-may)
-- 28=Alien (07-may)            29=Alien (16-may)            30=Alien (26-may)
-- 31=La Sustancia (08-may)     32=La Sustancia (19-may)     33=La Sustancia (27-may)
-- 34=Gladiator II (02-may)     35=Gladiator II (15-may)     36=Gladiator II (23-may)
-- 37=Furiosa (04-may)          38=Furiosa (18-may)          39=Furiosa (31-may)
-- 40=Anora (06-may)            41=Anora (20-may)            42=Anora (28-may)
-- 43=El Brutalista (09-may)    44=El Brutalista (17-may)    45=El Brutalista (30-may)
--
-- Referencia funciones junio (46-90):
-- 46=Barbie(06-01)        47=Barbie(06-13)        48=Barbie(06-25)
-- 49=Spider-Man(06-02)    50=Spider-Man(06-14)     51=Spider-Man(06-26)
-- 52=Minecraft(06-03)     53=Minecraft(06-15)      54=Minecraft(06-27)
-- 55=Past Lives(06-04)    56=Past Lives(06-16)     57=Past Lives(06-28)
-- 58=Guardianes(06-01)    59=Guardianes(06-14)     60=Guardianes(06-28)
-- 61=Napoleón(06-02)      62=Napoleón(06-17)       63=Napoleón(06-30)
-- 64=Asesinos(06-03)      65=Asesinos(06-18)       66=Asesinos(06-29)
-- 67=Mickey 17(06-05)     68=Mickey 17(06-19)      69=Mickey 17(06-30)
-- 70=Thunderbolts(06-06)  71=Thunderbolts(06-20)   72=Thunderbolts(06-28)
-- 73=Cap América(06-07)   74=Cap América(06-21)    75=Cap América(06-27)
-- 76=John Wick(06-01)     77=John Wick(06-15)      78=John Wick(06-28)
-- 79=Pobres criat.(06-04) 80=Pobres criat.(06-20)  81=Pobres criat.(06-28)
-- 82=Saltburn(06-05)      83=Saltburn(06-20)       84=Saltburn(06-27)
-- 85=El asesino(06-06)    86=El asesino(06-21)     87=El asesino(06-28)
-- 88=Sinners(06-07)       89=Sinners(06-21)        90=Sinners(06-29)

-- ── MAYO 2026 (boletos 1-50) ──────────────────────────────────────────────────

-- Cliente 1 — Carlos García (acción y ciencia ficción) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (25, 1, '2026-04-30', '20:00'),
       (34, 1, '2026-05-01', '18:30'),
       (16, 1, '2026-05-01', '18:00'),
       (37, 1, '2026-05-03', '15:00'),
       (26, 1, '2026-05-08', '20:00')

-- Cliente 2 — Ana Hernández (musicales y drama) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (19, 2, '2026-05-05', '21:00'),
       (40, 2, '2026-05-06', '09:00'),
       (11, 2, '2026-05-12', '11:00')

-- Cliente 3 — Miguel Rodríguez (ciencia ficción y acción) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (28, 3, '2026-05-07', '16:00'),
       (17, 3, '2026-05-13', '20:00'),
       (35, 3, '2026-05-13', '20:15'),
       (38, 3, '2026-05-17', '14:00')

-- Cliente 5 — Iván Mendoza (terror) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (22, 5, '2026-05-03', '13:00'),
       (28, 5, '2026-05-06', '17:00'),
       (31, 5, '2026-05-08', '12:00'),
       (33, 5, '2026-05-25', '19:00')

-- Cliente 7 — Andrés López (va con familia, compra boletos extra) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (4,  7, '2026-05-01', '09:30'),
       (4,  7, '2026-05-01', '09:30'),
       (1,  7, '2026-05-02', '10:00'),
       (1,  7, '2026-05-02', '10:00'),
       (7,  7, '2026-05-03', '11:00')

-- Cliente 9 — Kevin González (acción) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (25, 9, '2026-05-01', '10:00'),
       (36, 9, '2026-05-22', '18:00'),
       (39, 9, '2026-05-30', '15:00')

-- Cliente 11 — Arturo Salinas (sala VIP, cine de autor) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (13, 11, '2026-05-04', '16:00'),
       (43, 11, '2026-05-08', '20:00'),
       (20, 11, '2026-05-16', '12:00'),
       (44, 11, '2026-05-16', '19:00')

-- Cliente 13 — Erick Sánchez (terror y suspenso) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (22, 13, '2026-05-02', '14:00'),
       (23, 13, '2026-05-10', '19:00'),
       (29, 13, '2026-05-15', '20:00'),
       (32, 13, '2026-05-19', '11:00')

-- Cliente 15 — Paola González (animación y musicales, va con amiga) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (10, 15, '2026-04-29', '20:00'),
       (2,  15, '2026-05-09', '18:00'),
       (2,  15, '2026-05-09', '18:00'),
       (5,  15, '2026-05-11', '17:00'),
       (12, 15, '2026-05-21', '16:00')

-- Cliente 17 — Gabriela Reyes (variedad) — 6 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (10, 17, '2026-04-28', '11:00'),
       (14, 17, '2026-05-12', '14:00'),
       (8,  17, '2026-05-15', '10:00'),
       (41, 17, '2026-05-19', '10:00'),
       (42, 17, '2026-05-27', '18:00'),
       (18, 17, '2026-05-28', '12:00')

-- Cliente 19 — Laura Cervantes (cinéfila, última semana intensa) — 7 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (6,  19, '2026-05-22', '19:00'),
       (3,  19, '2026-05-23', '18:00'),
       (9,  19, '2026-05-24', '15:00'),
       (30, 19, '2026-05-25', '11:00'),
       (15, 19, '2026-05-27', '13:00'),
       (21, 19, '2026-05-29', '16:00'),
       (45, 19, '2026-05-29', '16:15')

-- ── JUNIO 2026 (boletos 51-100) ───────────────────────────────────────────────

-- Cliente 21 — Valeria Torres (animación, va con acompañante) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (46, 21, '2026-05-30', '19:00'),
       (46, 21, '2026-05-30', '19:00'),
       (49, 21, '2026-06-01', '14:00'),
       (52, 21, '2026-06-02', '10:00')

-- Cliente 22 — Luis Pérez (acción) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (58, 22, '2026-05-31', '20:00'),
       (70, 22, '2026-06-05', '17:00'),
       (73, 22, '2026-06-06', '16:00')

-- Cliente 24 — Carlos Vega (drama histórico) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (61, 24, '2026-06-01', '15:00'),
       (64, 24, '2026-06-02', '12:00'),
       (65, 24, '2026-06-17', '13:00')

-- Cliente 25 — Lucía Navarro (romance y animación) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (55, 25, '2026-06-03', '20:00'),
       (50, 25, '2026-06-13', '11:00'),
       (56, 25, '2026-06-15', '18:00'),
       (57, 25, '2026-06-27', '19:00')

-- Cliente 27 — Fernanda Ramírez (terror y suspenso) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (76, 27, '2026-05-31', '21:00'),
       (79, 27, '2026-06-03', '15:00'),
       (82, 27, '2026-06-04', '21:00'),
       (85, 27, '2026-06-05', '21:00'),
       (88, 27, '2026-06-06', '17:00')

-- Cliente 30 — Rubén Lozano (drama, cine de autor) — 6 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (61, 30, '2026-05-30', '10:00'),
       (64, 30, '2026-06-01', '14:00'),
       (67, 30, '2026-06-04', '19:00'),
       (62, 30, '2026-06-16', '11:00'),
       (66, 30, '2026-06-28', '15:00'),
       (63, 30, '2026-06-29', '14:00')

-- Cliente 31 — Sofía Fuentes (ciencia ficción y aventura) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (58, 31, '2026-05-30', '15:00'),
       (67, 31, '2026-06-04', '12:00'),
       (59, 31, '2026-06-13', '16:00'),
       (68, 31, '2026-06-18', '10:00'),
       (60, 31, '2026-06-27', '14:00')

-- Cliente 33 — Miguel Gómez (familia, va con hijo) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (46, 33, '2026-05-31', '10:00'),
       (46, 33, '2026-05-31', '10:00'),
       (52, 33, '2026-06-02', '09:00'),
       (52, 33, '2026-06-02', '09:00'),
       (53, 33, '2026-06-14', '11:00')

-- Cliente 35 — Valeria Rodríguez (terror y suspenso) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (80, 35, '2026-06-19', '21:00'),
       (83, 35, '2026-06-19', '20:00'),
       (84, 35, '2026-06-26', '18:00'),
       (89, 35, '2026-06-20', '15:00')

-- Cliente 37 — Pamela Cruz (acción y suspenso) — 6 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (71, 37, '2026-06-19', '14:00'),
       (74, 37, '2026-06-20', '13:00'),
       (86, 37, '2026-06-20', '21:00'),
       (72, 37, '2026-06-27', '16:00'),
       (78, 37, '2026-06-27', '20:00'),
       (87, 37, '2026-06-27', '22:00')

-- Cliente 39 — Vanessa Guerrero (animación, última semana) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (48, 39, '2026-06-24', '18:00'),
       (51, 39, '2026-06-25', '15:00'),
       (54, 39, '2026-06-26', '12:00'),
       (75, 39, '2026-06-26', '19:00'),
       (90, 39, '2026-06-28', '17:00')

-- Sincroniza Funcion.CantidadVendida con los boletos vendidos de cada función
UPDATE Funcion
SET CantidadVendida = (SELECT COUNT(*) FROM Boleto B WHERE B.idFuncion = Funcion.idFuncion);
