-- Tema:        BancoDB - Examen Final
-- Descripción: Instalación completa (base de datos, tablas y datos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando los scripts de instalacion/ en orden alfabético ('find instalacion -name "*.sql" | sort'),
-- que es el mismo orden de la tabla del README y respeta las llaves foráneas.
-- Requiere ejecutarse completo en SSMS (F5): se separa cada script con GO para que ninguno interfiera
-- con el batch del anterior.

-- ============================================================
-- instalacion/01-create-database.sql
-- ============================================================
-- Tema:        BancoDB - Examen Final
-- Descripción: Crear base de datos BancoDB
-- Autor:       Daniel Hilario

CREATE DATABASE BancoDB

GO

-- ============================================================
-- instalacion/02-create-table-cliente.sql
-- ============================================================
-- Tema:        BancoDB - Examen Final
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE BancoDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    CURP CHAR(18),
    RFC CHAR(13),
    Sexo CHAR(1) NOT NULL,
    Telefono VARCHAR(15),
    CorreoElectronico VARCHAR(100),
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT chk_Cliente_Sexo CHECK (Sexo IN ('M', 'F'))
);

GO

-- ============================================================
-- instalacion/03-create-table-cuenta.sql
-- ============================================================
-- Tema:        BancoDB - Examen Final
-- Descripción: Crear tabla Cuenta
-- Autor:       Daniel Hilario

USE BancoDB;

CREATE TABLE Cuenta (
    idCuenta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NumeroCuenta CHAR(10) NOT NULL,
    TipoCuenta VARCHAR(20) NOT NULL,
    FechaApertura DATE NOT NULL,
    FechaCancelacion DATE,
    SaldoActual DECIMAL(12,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT uq_Cuenta_NumeroCuenta UNIQUE (NumeroCuenta),
    CONSTRAINT chk_Cuenta_TipoCuenta CHECK (TipoCuenta IN ('Débito', 'Nómina', 'Ahorro')),
    CONSTRAINT chk_Cuenta_Saldo CHECK (SaldoActual >= 0)
);

GO

-- ============================================================
-- instalacion/04-create-table-transaccion.sql
-- ============================================================
-- Tema:        BancoDB - Examen Final
-- Descripción: Crear tabla Transaccion
-- Autor:       Daniel Hilario

USE BancoDB;

CREATE TABLE Transaccion (
    idTransaccion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCuenta INT NOT NULL,
    idCliente INT NOT NULL,
    TipoTransaccion VARCHAR(20) NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    FechaTransaccion DATE NOT NULL,
    HoraTransaccion TIME NOT NULL,
    CONSTRAINT fk_Transaccion_Cuenta FOREIGN KEY (idCuenta) REFERENCES Cuenta(idCuenta),
    CONSTRAINT fk_Transaccion_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT chk_Transaccion_Tipo CHECK (TipoTransaccion IN ('Depósito', 'Retiro', 'Transferencia')),
    CONSTRAINT chk_Transaccion_Monto CHECK (Monto > 0)
);

GO

-- ============================================================
-- instalacion/05-insert-cliente.sql
-- ============================================================
-- Tema:        BancoDB - Examen Final
-- Descripción: Insertar 30 clientes (datos tomados de EscuelaDB)
-- Autor:       Daniel Hilario

USE BancoDB;

-- Clientes 1-10
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, CURP,
    RFC, Sexo, Telefono, CorreoElectronico, Activo)
VALUES ('García', 'López', 'Carlos', '2008-03-15', 'GALC080315NLHRRL06',
    'GALC080315AA6', 'M', '8112340001', 'carlos.garcia@correo.mx', 1),
       ('Hernández', 'Ramírez', 'Ana', '2007-12-20', 'HERA071220NLMRNA09',
    'HERA071220AB3', 'F', '8112340002', 'ana.hernandez@correo.mx', 1),
       ('Rodríguez', 'Silva', 'Miguel', '2009-11-05', 'ROSM091105NLHDGS07',
    'ROSM091105AC7', 'M', '8112340003', 'miguel.rodriguez@correo.mx', 1),
       ('Torres', 'Gutiérrez', 'Valeria', '2008-07-22', 'TOGV080722NLMRRV02',
    'TOGV080722AD2', 'F', '8112340004', 'valeria.torres@correo.mx', 1),
       ('Pérez', 'Morales', 'Luis', '2007-10-14', 'PEML071014NLHRRM08',
    'PEML071014AE8', 'M', '8112340005', 'luis.perez@correo.mx', 1),
       ('Sánchez', 'Vega', 'Sofía', '2009-12-30', 'SAVS091230NLMNNS04',
    'SAVS091230AF4', 'F', '8112340006', 'sofia.sanchez@correo.mx', 1),
       ('Ramírez', 'Cruz', 'Alejandro', '2006-10-05', 'RACA061005NLHRCM01',
    'RACA061005AG1', 'M', '8112340007', 'alejandro.ramirez@correo.mx', 1),
       ('Jiménez', 'Flores', 'Daniela', '2008-08-18', 'JIFD080818NLMMNF03',
    'JIFD080818AH3', 'F', '8112340008', 'daniela.jimenez@correo.mx', 1),
       ('Gómez', 'Reyes', 'Ricardo', '2007-05-15', 'GORR070515NLHMMR07',
    'GORR070515AI7', 'M', '8112340009', 'ricardo.gomez@correo.mx', 1),
       ('Delgado', 'Ortiz', 'Mariana', '2009-10-20', 'DEOM091020NLMLLG05',
    'DEOM091020AJ5', 'F', '8112340010', 'mariana.delgado@correo.mx', 1)

-- Clientes 11-20
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, CURP,
    RFC, Sexo, Telefono, CorreoElectronico, Activo)
VALUES ('Castro', 'Ibarra', 'Sergio', '2008-08-07', 'CAIS080807NLHSTR09',
    'CAIS080807AK9', 'M', '8112340011', 'sergio.castro@correo.mx', 1),
       ('Morales', 'Sandoval', 'Fernanda', '2007-06-25', 'MOSF070625NLMRLL02',
    'MOSF070625AL2', 'F', '8112340012', 'fernanda.morales@correo.mx', 1),
       ('Vargas', 'Lozano', 'Eduardo', '2006-03-14', 'VALE060314NLHRRG06',
    'VALE060314AM6', 'M', '8112340013', 'eduardo.vargas@correo.mx', 1),
       ('Fuentes', 'Cervantes', 'Adriana', '2008-09-12', 'FUCA080912NLMNNN01',
    'FUCA080912AN1', 'F', '8112340014', 'adriana.fuentes@correo.mx', 1),
       ('Aguilar', 'Mendoza', 'Daniel', '2009-11-28', 'AGMD091128NLHLLR04',
    'AGMD091128AO4', 'M', '8112340015', 'daniel.aguilar@correo.mx', 1),
       ('Salinas', 'Herrera', 'Carolina', '2007-10-03', 'SAHC071003NLMLLN07',
    'SAHC071003AP7', 'F', '8112340016', 'carolina.salinas@correo.mx', 1),
       ('Medina', 'Castillo', 'Pablo', '2008-05-20', 'MECP080520NLHDNN08',
    'MECP080520AQ8', 'M', '8112340017', 'pablo.medina@correo.mx', 1),
       ('Lozano', 'Guerrero', 'Elena', '2009-12-15', 'LOGE091215NLMZNN03',
    'LOGE091215AR3', 'F', '8112340018', 'elena.lozano@correo.mx', 1),
       ('Núñez', 'Ramos', 'Francisco', '2006-11-02', 'NURF061102NLHNNM06',
    'NURF061102AS6', 'M', '8112340019', 'francisco.nunez@correo.mx', 1),
       ('Reyes', 'Díaz', 'Victoria', '2008-04-06', 'REDV080406NLMYYY01',
    'REDV080406AT1', 'F', '8112340020', 'victoria.reyes@correo.mx', 1)

-- Clientes 21-30
-- NOTA: Los clientes 23-30 no tienen transacciones registradas.
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, CURP,
    RFC, Sexo, Telefono, CorreoElectronico, Activo)
VALUES ('Ortiz', 'Peña', 'Gabriel', '2007-08-25', 'ORPG070825NLHRRZ05',
    'ORPG070825AU8', 'M', '8112340021', 'gabriel.ortiz@correo.mx', 1),
       ('Cruz', 'Navarro', 'Monserrat', '2009-10-08', 'CUNM091008NLMRRR09',
    'CUNM091008AV3', 'F', '8112340022', 'monserrat.cruz@correo.mx', 1),
       ('Flores', 'Ibáñez', 'Héctor', '2008-02-14', 'FLIH080214NLHLLR02',
    'FLIH080214AW6', 'M', '8112340023', 'hector.flores@correo.mx', 1),
       ('Rivera', 'Moreno', 'Patricia', '2007-09-29', 'RIMP070929NLMVRR07',
    'RIMP070929AX1', 'F', '8112340024', 'patricia.rivera@correo.mx', 1),
       ('Silva', 'Espinoza', 'Roberto', '2008-06-17', 'SIER080617NLHLLV04',
    'SIER080617AY4', 'M', '8112340025', 'roberto.silva@correo.mx', 1),
       ('Gutiérrez', 'Peña', 'Andrea', '2009-11-24', 'GUPA091124NLMTTM08',
    'GUPA091124AZ7', 'F', '8112340026', 'andrea.gutierrez@correo.mx', 1),
       ('Mendoza', 'Torres', 'Iván', '2008-03-13', 'METI080313NLHNDZ03',
    'METI080313BA2', 'M', '8112340027', 'ivan.mendoza@correo.mx', 1),
       ('Herrera', 'Soto', 'Camila', '2007-10-19', 'HESC071019NLMRRR06',
    'HESC071019BB5', 'F', '8112340028', 'camila.herrera@correo.mx', 1),
       ('Vega', 'Ramírez', 'Carlos', '2009-12-07', 'VERC091207NLHGGS01',
    'VERC091207BC8', 'M', '8112340029', 'carlos.vega@correo.mx', 1),
       ('Navarro', 'Flores', 'Lucía', '2008-05-25', 'NAFL080525NLMVRR09',
    'NAFL080525BD1', 'F', '8112340030', 'lucia.navarro@correo.mx', 1)

GO

-- ============================================================
-- instalacion/06-insert-cuenta.sql
-- ============================================================
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

GO

-- ============================================================
-- instalacion/07-insert-transaccion.sql
-- ============================================================
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

GO
