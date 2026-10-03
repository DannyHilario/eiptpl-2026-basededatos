-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar reservaciones ficticias
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Reservacion (idHuesped, idHabitacion, FechaIngreso, NumeroNoches, PrecioAlMomento)
VALUES (1, 1, '2026-03-10', 3, 850.00),
       (2, 3, '2026-03-12', 2, 1200.00),
       (3, 6, '2026-03-15', 5, 2500.00),
       (4, 2, '2026-03-18', 1, 850.00),
       (5, 4, '2026-03-20', 4, 1200.00),
       (6, 7, '2026-03-22', 3, 2500.00),
       (7, 5, '2026-03-25', 2, 1200.00),
       (8, 1, '2026-04-05', 7, 850.00),
       (1, 4, '2026-04-10', 2, 1200.00),
       (3, 7, '2026-04-18', 4, 2500.00)
