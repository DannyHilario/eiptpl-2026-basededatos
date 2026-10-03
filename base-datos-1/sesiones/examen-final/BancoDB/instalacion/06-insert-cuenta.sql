-- Tema:        BancoDB - Examen Final
-- Descripción: Insertar 20 cuentas bancarias
-- Autor:       Daniel Hilario

USE BancoDB;

-- Cuentas 1-7: activas sin cancelación
INSERT INTO Cuenta (NumeroCuenta, TipoCuenta, FechaApertura, FechaCancelacion, SaldoActual,
    Activo)
VALUES ('0032345693', 'Débito', '2023-01-15', NULL, 15420.50,
    1),
       ('0045678901', 'Nómina', '2022-06-01', NULL, 28300.00,
    1),
       ('0056789012', 'Ahorro', '2023-03-20', NULL, 5800.75,
    1),
       ('0067890123', 'Débito', '2021-11-10', NULL, 3200.00,
    1),
       ('0078901234', 'Nómina', '2024-01-05', NULL, 42100.00,
    1),
       ('0089012345', 'Ahorro', '2022-08-15', NULL, 9500.25,
    1),
       ('0090123456', 'Débito', '2023-07-22', NULL, 7650.00,
    1)

-- Cuentas 8-14: activas sin cancelación
INSERT INTO Cuenta (NumeroCuenta, TipoCuenta, FechaApertura, FechaCancelacion, SaldoActual,
    Activo)
VALUES ('0012345678', 'Nómina', '2021-05-30', NULL, 33800.00,
    1),
       ('0023456789', 'Ahorro', '2024-03-12', NULL, 12400.50,
    1),
       ('0034567890', 'Débito', '2022-12-01', NULL, 4100.00,
    1),
       ('0011234567', 'Nómina', '2023-09-18', NULL, 25600.00,
    1),
       ('0033456789', 'Débito', '2022-04-10', NULL, 8900.00,
    1),
       ('0044567890', 'Nómina', '2023-11-05', NULL, 31500.00,
    1),
       ('0055678901', 'Ahorro', '2021-08-20', NULL, 18200.75,
    1)

-- Cuentas 15-20: mezcla de activas y canceladas
INSERT INTO Cuenta (NumeroCuenta, TipoCuenta, FechaApertura, FechaCancelacion, SaldoActual,
    Activo)
VALUES ('0066789012', 'Débito', '2024-02-14', NULL, 6300.00,
    1),
       ('0077890123', 'Nómina', '2022-10-30', NULL, 44700.00,
    1),
       ('0022345678', 'Ahorro', '2024-06-25', '2025-01-15', 0.00,
    0),
       ('0088901234', 'Ahorro', '2023-05-08', '2024-12-01', 0.00,
    0),
       ('0099012345', 'Débito', '2024-07-16', NULL, 2100.00,
    1),
       ('0010123456', 'Nómina', '2021-03-25', NULL, 37900.00,
    1)
