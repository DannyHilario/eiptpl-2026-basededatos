-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 3 tipos de tarjeta de crédito
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO TipoTarjetaCredito (Nombre, LimiteCreditoMinimo, LimiteCreditoMaximo, Anualidad, TasaInteresAnual)
VALUES ('Banquito Básica', 5000.00, 30000.00, 0.00, 55.00),
       ('Banquito Gold', 30000.00, 100000.00, 1200.00, 45.00),
       ('Banquito Platinum', 100000.00, 500000.00, 3500.00, 35.00);
