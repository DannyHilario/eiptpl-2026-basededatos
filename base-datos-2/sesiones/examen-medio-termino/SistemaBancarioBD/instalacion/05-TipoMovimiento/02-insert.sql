-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 5 tipos de movimiento (3 cargos y 2 abonos)
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO TipoMovimiento (Nombre, EsCargo)
VALUES ('Compra', 1),
       ('Disposición de efectivo', 1),
       ('Anualidad', 1),
       ('Pago', 0),
       ('Devolución', 0);
