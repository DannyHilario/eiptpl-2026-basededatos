-- Tema:        BancoDB - Examen Final
-- Descripción: Insertar 50 transacciones (clientes 1-22 tienen movimientos;
--              clientes 23-30 no tienen ninguna transacción registrada)
-- Autor:       Daniel Hilario

USE BancoDB;

-- Transacciones 1-10
INSERT INTO Transaccion (idCuenta, idCliente, TipoTransaccion, Monto, FechaTransaccion,
    HoraTransaccion)
VALUES (1, 1, 'Depósito', 5000.00, '2025-03-15',
    '10:30:00'),
       (2, 2, 'Retiro', 2000.00, '2025-03-16',
    '14:15:00'),
       (3, 3, 'Depósito', 8000.00, '2025-03-18',
    '09:45:00'),
       (4, 4, 'Transferencia', 3500.00, '2025-03-20',
    '16:00:00'),
       (5, 5, 'Retiro', 1500.00, '2025-03-22',
    '11:30:00'),
       (6, 6, 'Depósito', 6000.00, '2025-04-01',
    '08:20:00'),
       (7, 7, 'Transferencia', 4000.00, '2025-04-03',
    '13:45:00'),
       (8, 8, 'Retiro', 2500.00, '2025-04-05',
    '15:10:00'),
       (9, 9, 'Depósito', 10000.00, '2025-04-08',
    '10:00:00'),
       (10, 10, 'Retiro', 3000.00, '2025-04-10',
    '12:30:00')

-- Transacciones 11-20
INSERT INTO Transaccion (idCuenta, idCliente, TipoTransaccion, Monto, FechaTransaccion,
    HoraTransaccion)
VALUES (11, 11, 'Depósito', 7500.00, '2025-04-12',
    '09:15:00'),
       (12, 12, 'Transferencia', 5000.00, '2025-04-15',
    '14:00:00'),
       (13, 13, 'Retiro', 1000.00, '2025-04-17',
    '16:30:00'),
       (14, 14, 'Depósito', 12000.00, '2025-04-20',
    '10:45:00'),
       (15, 15, 'Retiro', 800.00, '2025-04-22',
    '11:20:00'),
       (16, 16, 'Depósito', 9000.00, '2025-04-25',
    '08:00:00'),
       (19, 17, 'Transferencia', 3200.00, '2025-04-28',
    '13:10:00'),
       (20, 18, 'Retiro', 4500.00, '2025-05-02',
    '15:45:00'),
       (1, 19, 'Depósito', 6500.00, '2025-05-05',
    '09:30:00'),
       (2, 20, 'Transferencia', 2800.00, '2025-05-08',
    '14:20:00')

-- Transacciones 21-30
INSERT INTO Transaccion (idCuenta, idCliente, TipoTransaccion, Monto, FechaTransaccion,
    HoraTransaccion)
VALUES (3, 21, 'Retiro', 1800.00, '2025-05-10',
    '10:15:00'),
       (4, 22, 'Depósito', 5500.00, '2025-05-12',
    '16:00:00'),
       (5, 1, 'Retiro', 2200.00, '2025-05-15',
    '11:00:00'),
       (6, 3, 'Transferencia', 7000.00, '2025-05-18',
    '08:30:00'),
       (7, 5, 'Depósito', 3800.00, '2025-05-20',
    '13:00:00'),
       (8, 7, 'Retiro', 900.00, '2025-05-22',
    '15:30:00'),
       (9, 9, 'Depósito', 4200.00, '2025-05-25',
    '09:00:00'),
       (10, 11, 'Transferencia', 6000.00, '2025-05-28',
    '12:45:00'),
       (11, 13, 'Retiro', 1600.00, '2025-06-01',
    '10:30:00'),
       (12, 15, 'Depósito', 8500.00, '2025-06-03',
    '14:15:00')

-- Transacciones 31-40
INSERT INTO Transaccion (idCuenta, idCliente, TipoTransaccion, Monto, FechaTransaccion,
    HoraTransaccion)
VALUES (13, 2, 'Retiro', 3500.00, '2025-06-05',
    '16:00:00'),
       (14, 4, 'Transferencia', 9500.00, '2025-06-08',
    '09:45:00'),
       (15, 6, 'Depósito', 11000.00, '2025-06-10',
    '11:15:00'),
       (16, 8, 'Retiro', 2700.00, '2025-06-12',
    '13:30:00'),
       (19, 10, 'Depósito', 4800.00, '2025-06-15',
    '08:00:00'),
       (20, 12, 'Transferencia', 3100.00, '2025-06-18',
    '14:45:00'),
       (1, 14, 'Retiro', 1900.00, '2025-06-20',
    '10:00:00'),
       (2, 16, 'Depósito', 7200.00, '2025-06-22',
    '15:20:00'),
       (3, 18, 'Transferencia', 5600.00, '2025-06-25',
    '12:00:00'),
       (4, 20, 'Retiro', 2400.00, '2025-06-28',
    '09:15:00')

-- Transacciones 41-50
INSERT INTO Transaccion (idCuenta, idCliente, TipoTransaccion, Monto, FechaTransaccion,
    HoraTransaccion)
VALUES (5, 22, 'Depósito', 6800.00, '2025-07-01',
    '10:45:00'),
       (6, 1, 'Transferencia', 4300.00, '2025-07-03',
    '14:00:00'),
       (7, 3, 'Retiro', 1100.00, '2025-07-05',
    '16:30:00'),
       (8, 5, 'Depósito', 9200.00, '2025-07-08',
    '08:15:00'),
       (9, 7, 'Transferencia', 3700.00, '2025-07-10',
    '11:30:00'),
       (10, 9, 'Retiro', 2100.00, '2025-07-12',
    '13:45:00'),
       (11, 11, 'Depósito', 5300.00, '2025-07-15',
    '09:30:00'),
       (12, 19, 'Transferencia', 8100.00, '2025-07-18',
    '14:30:00'),
       (13, 21, 'Retiro', 1700.00, '2025-07-20',
    '10:15:00'),
       (14, 17, 'Depósito', 6100.00, '2025-07-22',
    '15:00:00')
