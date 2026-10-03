-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Consultas de validación para verificar la estructura y datos
-- Autor:       Daniel Hilario

USE CursoDB;

-- 1. Ver todos los tipos de habitación
SELECT *
FROM TipoHabitacion

-- 2. Ver todas las habitaciones
SELECT *
FROM Habitacion

-- 3. Ver todos los huéspedes
SELECT *
FROM Huesped

-- 4. Ver todas las reservaciones
SELECT *
FROM Reservacion

-- 5. Conteo de registros por tabla
SELECT COUNT(*) AS TotalTiposHabitacion
FROM TipoHabitacion

SELECT COUNT(*) AS TotalHabitaciones
FROM Habitacion

SELECT COUNT(*) AS TotalHuespedes
FROM Huesped

SELECT COUNT(*) AS TotalReservaciones
FROM Reservacion

-- 6. Habitaciones del tipo 1 (Sencilla)
SELECT *
FROM Habitacion
WHERE idTipoHabitacion = 1

-- 7. Reservaciones de un huésped específico
SELECT *
FROM Reservacion
WHERE idHuesped = 1

-- 8. Reservaciones ordenadas por fecha de ingreso
SELECT *
FROM Reservacion
ORDER BY FechaIngreso
