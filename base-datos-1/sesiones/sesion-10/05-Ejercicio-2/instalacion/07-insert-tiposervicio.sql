-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar catálogo de tipos de servicio
-- Autor:       Daniel Hilario

USE AutoFixDB;

INSERT INTO TipoServicio (Descripcion, Costo, Activo)
VALUES ('Afinación', 850.00, 1),
       ('Cambio de aceite', 450.00, 1),
       ('Revisión de frenos', 1200.00, 1),
       ('Suspensión', 2500.00, 1),
       ('Diagnóstico computarizado', 350.00, 1),
       ('Cambio de llantas', 3200.00, 1);
