-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 18 salas físicas del cine
-- Autor:       Daniel Hilario

USE CineDB;

-- idTipoSala: 1=2D  2=3D  3=IMAX  4=VIP
INSERT INTO Sala (idTipoSala, Nombre, Capacidad, Activo)
VALUES (1, 'Sala 1', 120, 1),
       (1, 'Sala 2', 120, 1),
       (1, 'Sala 3', 100, 1),
       (2, 'Sala 4', 110, 1),
       (2, 'Sala 5', 110, 1),
       (3, 'IMAX Norte', 200, 1),
       (3, 'IMAX Sur', 200, 1),
       (4, 'VIP Lounge', 40, 1),
       (4, 'VIP Premium', 30, 1),
       (1, 'Sala 10', 120, 1),
       (1, 'Sala 11', 100, 1),
       (1, 'Sala 12', 100, 1),
       (2, 'Sala 13', 110, 1),
       (2, 'Sala 14', 110, 1),
       (3, 'IMAX Este', 200, 1),
       (3, 'IMAX Oeste', 200, 1),
       (4, 'VIP Presidencial', 35, 1),
       (4, 'VIP Suite', 25, 1);
