-- Tema:        Reversa Ejercicio 1 - Etapa 4
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE EscuelaDB;

-- Paso 1: Alumno primero — depende de Tecnica mediante FK
DROP TABLE IF EXISTS Alumno;

-- Paso 2: Tecnica — ya no tiene dependientes tras eliminar Alumno
DROP TABLE IF EXISTS Tecnica;
