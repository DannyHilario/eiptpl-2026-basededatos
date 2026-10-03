-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Instalación completa (tablas y datos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando los scripts de instalacion/ en orden alfabético de carpeta/archivo
-- (mismo orden que la tabla del README de esta sesión — un simple 'find instalacion -name "*.sql" | sort'
-- ya respeta las llaves foráneas porque el prefijo numérico de cada carpeta sigue ese orden).
-- Requiere ejecutarse completo en SSMS (F5): se separa cada script con GO para que ninguno interfiera
-- con el batch del anterior.

-- ============================================================
-- instalacion/00-create-database.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear base de datos SistemaBancarioBD
-- Autor:       Daniel Hilario

CREATE DATABASE SistemaBancarioBD;

GO

-- ============================================================
-- instalacion/01-Sucursal/01-create-table.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Sucursal
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Sucursal (
    idSucursal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- instalacion/01-Sucursal/02-insert.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 5 sucursales
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO Sucursal (Nombre, Direccion, Telefono)
VALUES ('Sucursal Centro', 'Av. Constitución 400, Col. Centro, Monterrey, N.L.', '8180000001'),
       ('Sucursal San Pedro', 'Av. Vasconcelos 1250, Col. Del Valle, San Pedro Garza García, N.L.', '8180000002'),
       ('Sucursal Cumbres', 'Av. Paseo de los Leones 3300, Col. Cumbres Elite, Monterrey, N.L.', '8180000003'),
       ('Sucursal Apodaca', 'Av. Miguel Alemán 1800, Col. Pueblo Nuevo, Apodaca, N.L.', '8180000004'),
       ('Sucursal Guadalupe', 'Av. Eloy Cavazos 2500, Col. Contry La Silla, Guadalupe, N.L.', '8180000005');

GO

-- ============================================================
-- instalacion/02-Cliente/01-create-table.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idSucursal INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Sexo CHAR(1) NOT NULL,
    CURP CHAR(18) NOT NULL UNIQUE,
    RFC CHAR(13) NOT NULL UNIQUE,
    Telefono VARCHAR(15) NOT NULL UNIQUE,
    CorreoElectronico VARCHAR(100) NOT NULL UNIQUE,
    Direccion VARCHAR(200) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Cliente_Sucursal FOREIGN KEY (idSucursal) REFERENCES Sucursal(idSucursal),
    CONSTRAINT chk_Cliente_Sexo CHECK (Sexo IN ('M', 'F'))
);

GO

-- ============================================================
-- instalacion/02-Cliente/02-insert.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 30 clientes
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO Cliente (idSucursal, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento,
                     Sexo, CURP, RFC, Telefono, CorreoElectronico,
                     Direccion, Activo)
VALUES (1, 'Carlos', 'García', 'López', '1988-03-15',
        'M', 'GALC880315HNLRPR01', 'GALC880315AA6', '8112340001', 'carlos.garcia@correo.mx',
        'Av. Matamoros 1691, Col. Centro, Monterrey, N.L.', 1),
       (1, 'Ana', 'Hernández', 'Ramírez', '1987-12-20',
        'F', 'HERA871220MNLRMN01', 'HERA871220AB3', '8112340002', 'ana.hernandez@correo.mx',
        'Av. Aramberri 1846, Col. María Luisa, Monterrey, N.L.', 1),
       (3, 'Miguel', 'Rodríguez', 'Silva', '1989-11-05',
        'M', 'ROSM891105HNLDLG00', 'ROSM891105AC7', '8112340003', 'miguel.rodriguez@correo.mx',
        'Calle Hidalgo 2005, Col. Valle del Topo Chico, General Escobedo, N.L.', 1),
       (4, 'Valeria', 'Torres', 'Gutiérrez', '1988-07-22',
        'F', 'TOGV880722MNLRTL02', 'TOGV880722AD2', '8112340004', 'valeria.torres@correo.mx',
        'Calle Los Ángeles 93, Col. Hacienda Las Margaritas, Apodaca, N.L.', 1),
       (1, 'Luis', 'Pérez', 'Morales', '1987-10-14',
        'M', 'PEML871014HNLRRS04', 'PEML871014AE8', '8112340005', 'luis.perez@correo.mx',
        'Av. Washington 1316, Col. Anáhuac, San Nicolás de los Garza, N.L.', 1),
       (1, 'Sofía', 'Sánchez', 'Vega', '1989-12-30',
        'F', 'SAVS891230MNLNGF01', 'SAVS891230AF4', '8112340006', 'sofia.sanchez@correo.mx',
        'Av. Matamoros 296, Col. Linda Vista, Guadalupe, N.L.', 1),
       (3, 'Alejandro', 'Ramírez', 'Cruz', '1986-10-05',
        'M', 'RACA861005HNLMRL09', 'RACA861005AG1', '8112340007', 'alejandro.ramirez@correo.mx',
        'Av. Calzada del Valle 1509, Col. Cumbres San Agustín, Monterrey, N.L.', 1),
       (1, 'Daniela', 'Jiménez', 'Flores', '1988-08-18',
        'F', 'JIFD880818MNLMLN05', 'JIFD880818AH3', '8112340008', 'daniela.jimenez@correo.mx',
        'Av. Hidalgo 1223, Col. Anáhuac, San Nicolás de los Garza, N.L.', 1),
       (4, 'Ricardo', 'Gómez', 'Reyes', '1987-05-15',
        'M', 'GORR870515HNLMYC07', 'GORR870515AI7', '8112340009', 'ricardo.gomez@correo.mx',
        'Calle Gonzalitos 1935, Col. Hacienda Las Margaritas, Apodaca, N.L.', 1),
       (1, 'Mariana', 'Delgado', 'Ortiz', '1989-10-20',
        'F', 'DEOM891020MNLLRR03', 'DEOM891020AJ5', '8112340010', 'mariana.delgado@correo.mx',
        'Av. Matamoros 1981, Col. María Luisa, Monterrey, N.L.', 1),
       (1, 'Sergio', 'Castro', 'Ibarra', '1988-08-07',
        'M', 'CAIS880807HNLSBR08', 'CAIS880807AK9', '8112340011', 'sergio.castro@correo.mx',
        'Av. Ruiz Cortines 1880, Col. Anáhuac, San Nicolás de los Garza, N.L.', 1),
       (2, 'Fernanda', 'Morales', 'Sandoval', '1987-06-25',
        'F', 'MOSF870625MNLRNR07', 'MOSF870625AL2', '8112340012', 'fernanda.morales@correo.mx',
        'Calle Morelos 1742, Col. Del Valle, San Pedro Garza García, N.L.', 1),
       (1, 'Eduardo', 'Vargas', 'Lozano', '1986-03-14',
        'M', 'VALE860314HNLRZD03', 'VALE860314AM6', '8112340013', 'eduardo.vargas@correo.mx',
        'Av. Abasolo 530, Col. Anáhuac, San Nicolás de los Garza, N.L.', 1),
       (2, 'Adriana', 'Fuentes', 'Cervantes', '1988-09-12',
        'F', 'FUCA880912MNLNRD09', 'FUCA880912AN1', '8112340014', 'adriana.fuentes@correo.mx',
        'Av. Abasolo 1766, Col. Chipinque, San Pedro Garza García, N.L.', 1),
       (3, 'Daniel', 'Aguilar', 'Mendoza', '1989-11-28',
        'M', 'AUMD891128HNLGNN08', 'AUMD891128AO4', '8112340015', 'daniel.aguilar@correo.mx',
        'Av. Gonzalitos 1412, Col. Valle del Topo Chico, General Escobedo, N.L.', 1),
       (3, 'Carolina', 'Salinas', 'Herrera', '1987-10-03',
        'F', 'SAHC871003MNLLRR00', 'SAHC871003AP7', '8112340016', 'carolina.salinas@correo.mx',
        'Calle Morelos 541, Col. Valle del Topo Chico, General Escobedo, N.L.', 1),
       (2, 'Pablo', 'Medina', 'Castillo', '1988-05-20',
        'M', 'MECP880520HNLDSB06', 'MECP880520AQ8', '8112340017', 'pablo.medina@correo.mx',
        'Av. Washington 894, Col. Chipinque, San Pedro Garza García, N.L.', 1),
       (1, 'Elena', 'Lozano', 'Guerrero', '1989-12-15',
        'F', 'LOGE891215MNLZRL05', 'LOGE891215AR3', '8112340018', 'elena.lozano@correo.mx',
        'Av. Ruiz Cortines 1842, Col. Linda Vista, Guadalupe, N.L.', 1),
       (2, 'Francisco', 'Núñez', 'Ramos', '1986-11-02',
        'M', 'NURF861102HNLXMR00', 'NURF861102AS6', '8112340019', 'francisco.nunez@correo.mx',
        'Av. Los Ángeles 378, Col. Fuentes del Valle, San Pedro Garza García, N.L.', 1),
       (2, 'Victoria', 'Reyes', 'Díaz', '1988-04-06',
        'F', 'REDV880406MNLYZC08', 'REDV880406AT1', '8112340020', 'victoria.reyes@correo.mx',
        'Calle Ruiz Cortines 1554, Col. Fuentes del Valle, San Pedro Garza García, N.L.', 1),
       (2, 'Gabriel', 'Ortiz', 'Peña', '1987-08-25',
        'M', 'OIPG870825HNLRXB00', 'OIPG870825AU8', '8112340021', 'gabriel.ortiz@correo.mx',
        'Av. Zaragoza 697, Col. Chipinque, San Pedro Garza García, N.L.', 1),
       (2, 'Monserrat', 'Cruz', 'Navarro', '1989-10-08',
        'F', 'CUNM891008MNLRVN06', 'CUNM891008AV3', '8112340022', 'monserrat.cruz@correo.mx',
        'Av. Hidalgo 300, Col. Chipinque, San Pedro Garza García, N.L.', 1),
       (3, 'Héctor', 'Flores', 'Ibáñez', '1988-02-14',
        'M', 'FOIH880214HNLLBC00', 'FOIH880214AW6', '8112340023', 'hector.flores@correo.mx',
        'Calle Río Nazas 439, Col. Cumbres Elite, Monterrey, N.L.', 1),
       (2, 'Patricia', 'Rivera', 'Moreno', '1987-09-29',
        'F', 'RIMP870929MNLVRT00', 'RIMP870929AX1', '8112340024', 'patricia.rivera@correo.mx',
        'Av. Padre Mier 70, Col. Chipinque, San Pedro Garza García, N.L.', 1),
       (4, 'Roberto', 'Silva', 'Espinoza', '1988-06-17',
        'M', 'SIER880617HNLLSB06', 'SIER880617AY4', '8112340025', 'roberto.silva@correo.mx',
        'Calle Abasolo 1908, Col. Prados de Santa Rosa, Apodaca, N.L.', 1),
       (4, 'Andrea', 'Gutiérrez', 'Peña', '1989-11-24',
        'F', 'GUPA891124MNLTXN03', 'GUPA891124AZ7', '8112340026', 'andrea.gutierrez@correo.mx',
        'Calle Ruiz Cortines 558, Col. Prados de Santa Rosa, Apodaca, N.L.', 1),
       (3, 'Iván', 'Mendoza', 'Torres', '1988-03-13',
        'M', 'METI880313HNLNRV04', 'METI880313BA2', '8112340027', 'ivan.mendoza@correo.mx',
        'Av. Gonzalitos 533, Col. Valle del Topo Chico, General Escobedo, N.L.', 1),
       (1, 'Camila', 'Herrera', 'Soto', '1987-10-19',
        'F', 'HESC871019MNLRTM07', 'HESC871019BB5', '8112340028', 'camila.herrera@correo.mx',
        'Calle Zaragoza 1254, Col. Linda Vista, Guadalupe, N.L.', 1),
       (3, 'Carlos', 'Vega', 'Ramírez', '1989-12-07',
        'M', 'VERC891207HNLGMR07', 'VERC891207BC8', '8112340029', 'carlos.vega@correo.mx',
        'Av. Hidalgo 132, Col. Valle del Topo Chico, General Escobedo, N.L.', 1),
       (4, 'Lucía', 'Navarro', 'Flores', '1988-05-25',
        'F', 'NAFL880525MNLVLC02', 'NAFL880525BD1', '8112340030', 'lucia.navarro@correo.mx',
        'Av. Los Ángeles 1057, Col. Hacienda Las Margaritas, Apodaca, N.L.', 1);

GO

-- ============================================================
-- instalacion/03-TipoTarjetaCredito/01-create-table.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla TipoTarjetaCredito
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE TipoTarjetaCredito (
    idTipoTarjetaCredito INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    LimiteCreditoMinimo DECIMAL(12,2) NOT NULL,
    LimiteCreditoMaximo DECIMAL(12,2) NOT NULL,
    Anualidad DECIMAL(10,2) NOT NULL,
    TasaInteresAnual DECIMAL(5,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_TipoTarjetaCredito_LimiteCreditoMinimo CHECK (LimiteCreditoMinimo > 0),
    CONSTRAINT chk_TipoTarjetaCredito_LimiteCreditoMaximo CHECK (LimiteCreditoMaximo > LimiteCreditoMinimo),
    CONSTRAINT chk_TipoTarjetaCredito_Anualidad CHECK (Anualidad >= 0),
    CONSTRAINT chk_TipoTarjetaCredito_TasaInteresAnual CHECK (TasaInteresAnual >= 0)
);

GO

-- ============================================================
-- instalacion/03-TipoTarjetaCredito/02-insert.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 3 tipos de tarjeta de crédito
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO TipoTarjetaCredito (Nombre, LimiteCreditoMinimo, LimiteCreditoMaximo, Anualidad, TasaInteresAnual)
VALUES ('Banquito Básica', 5000.00, 30000.00, 0.00, 55.00),
       ('Banquito Gold', 30000.00, 100000.00, 1200.00, 45.00),
       ('Banquito Platinum', 100000.00, 500000.00, 3500.00, 35.00);

GO

-- ============================================================
-- instalacion/04-Tarjeta/01-create-table.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Tarjeta
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Tarjeta (
    idTarjeta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idTipoTarjetaCredito INT NOT NULL,
    NumeroTarjeta CHAR(16) NOT NULL UNIQUE,
    FechaEmision DATE NOT NULL,
    FechaVencimiento DATE NOT NULL,
    LimiteCredito DECIMAL(12,2) NOT NULL,
    SaldoActual DECIMAL(12,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Tarjeta_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_Tarjeta_TipoTarjetaCredito FOREIGN KEY (idTipoTarjetaCredito) REFERENCES TipoTarjetaCredito(idTipoTarjetaCredito),
    CONSTRAINT uq_Tarjeta_Cliente_TipoTarjetaCredito UNIQUE (idCliente, idTipoTarjetaCredito),
    CONSTRAINT chk_Tarjeta_LimiteCredito CHECK (LimiteCredito > 0),
    CONSTRAINT chk_Tarjeta_SaldoActual CHECK (SaldoActual >= 0 AND SaldoActual <= LimiteCredito),
    CONSTRAINT chk_Tarjeta_FechaVencimiento CHECK (FechaVencimiento > FechaEmision)
);

GO

-- ============================================================
-- instalacion/04-Tarjeta/02-insert.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 40 tarjetas de crédito
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO Tarjeta (idCliente, idTipoTarjetaCredito, NumeroTarjeta, FechaEmision, FechaVencimiento,
                     LimiteCredito, SaldoActual, Activo)
VALUES (1, 1, '1111000000000001', '2023-04-10', '2028-04-10',
        15000.00, 3250.00, 1),
       (2, 2, '2222000000000002', '2022-11-01', '2027-11-01',
        60000.00, 0.00, 1),
       (3, 3, '3333000000000003', '2021-02-15', '2026-02-15',
        250000.00, 48900.00, 1),
       (4, 1, '1111000000000004', '2024-08-22', '2029-08-22',
        8000.00, 8000.00, 1),
       (5, 2, '2222000000000005', '2023-01-30', '2028-01-30',
        45000.00, 12780.50, 1),
       (6, 1, '1111000000000006', '2023-07-12', '2028-07-12',
        12000.00, 0.00, 0),
       (7, 3, '3333000000000007', '2025-03-03', '2030-03-03',
        150000.00, 0.00, 1),
       (8, 2, '2222000000000008', '2024-05-18', '2029-05-18',
        75000.00, 75000.00, 1),
       (9, 1, '1111000000000009', '2020-06-25', '2025-06-25',
        5000.00, 1200.00, 1),
       (10, 2, '2222000000000010', '2025-10-09', '2030-10-09',
        35000.00, 4100.00, 1),
       (11, 1, '1111000000000011', '2026-01-14', '2031-01-14',
        20000.00, 0.00, 1),
       (12, 3, '3333000000000012', '2022-12-05', '2027-12-05',
        320000.00, 87650.25, 1),
       (13, 1, '1111000000000013', '2024-01-20', '2029-01-20',
        30000.00, 30000.00, 1),
       (13, 2, '2222000000000014', '2025-06-05', '2030-06-05',
        80000.00, 12400.00, 1),
       (14, 2, '2222000000000015', '2021-05-10', '2026-05-10',
        50000.00, 9800.00, 1),
       (14, 3, '3333000000000016', '2024-09-17', '2029-09-17',
        200000.00, 15300.00, 1),
       (15, 1, '1111000000000017', '2023-03-28', '2028-03-28',
        10000.00, 2450.00, 1),
       (15, 3, '3333000000000018', '2025-11-11', '2030-11-11',
        120000.00, 0.00, 1),
       (16, 1, '1111000000000019', '2022-12-20', '2027-12-20',
        18000.00, 0.00, 1),
       (16, 2, '2222000000000020', '2024-02-29', '2029-02-28',
        40000.00, 40000.00, 1),
       (17, 2, '2222000000000021', '2023-08-08', '2028-08-08',
        90000.00, 33210.00, 1),
       (17, 3, '3333000000000022', '2026-02-02', '2031-02-02',
        450000.00, 102000.00, 1),
       (18, 1, '1111000000000023', '2024-10-30', '2029-10-30',
        25000.00, 6780.00, 1),
       (18, 2, '2222000000000024', '2023-05-15', '2028-05-15',
        55000.00, 0.00, 0),
       (19, 1, '1111000000000025', '2025-01-07', '2030-01-07',
        7000.00, 350.00, 1),
       (19, 3, '3333000000000026', '2023-11-23', '2028-11-23',
        180000.00, 180000.00, 1),
       (20, 2, '2222000000000027', '2024-07-01', '2029-07-01',
        65000.00, 21500.00, 1),
       (20, 3, '3333000000000028', '2025-04-19', '2030-04-19',
        100000.00, 5600.00, 1),
       (21, 1, '1111000000000029', '2020-09-14', '2025-09-14',
        6000.00, 0.00, 1),
       (21, 2, '2222000000000030', '2023-02-10', '2028-02-10',
        30000.00, 14250.00, 1),
       (21, 3, '3333000000000031', '2024-12-12', '2029-12-12',
        500000.00, 250000.00, 1),
       (22, 1, '1111000000000032', '2023-09-05', '2028-09-05',
        22000.00, 22000.00, 1),
       (22, 2, '2222000000000033', '2024-03-21', '2029-03-21',
        70000.00, 0.00, 1),
       (22, 3, '3333000000000034', '2025-08-30', '2030-08-30',
        280000.00, 64320.75, 1),
       (23, 1, '1111000000000035', '2022-11-15', '2027-11-15',
        9000.00, 4500.00, 1),
       (23, 2, '2222000000000036', '2024-06-27', '2029-06-27',
        100000.00, 38900.00, 1),
       (23, 3, '3333000000000037', '2026-05-20', '2031-05-20',
        350000.00, 0.00, 1),
       (24, 1, '1111000000000038', '2025-02-14', '2030-02-14',
        14000.00, 1890.00, 1),
       (24, 2, '2222000000000039', '2023-10-03', '2028-10-03',
        85000.00, 85000.00, 1),
       (24, 3, '3333000000000040', '2024-04-08', '2029-04-08',
        220000.00, 47800.00, 1);

GO

-- ============================================================
-- instalacion/05-TipoMovimiento/01-create-table.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla TipoMovimiento
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE TipoMovimiento (
    idTipoMovimiento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    EsCargo BIT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE()
);

GO

-- ============================================================
-- instalacion/05-TipoMovimiento/02-insert.sql
-- ============================================================
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

GO

-- ============================================================
-- instalacion/06-Movimiento/01-create-table.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Crear tabla Movimiento
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

CREATE TABLE Movimiento (
    idMovimiento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTarjeta INT NOT NULL,
    idTipoMovimiento INT NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    FechaMovimiento DATETIME NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Movimiento_Tarjeta FOREIGN KEY (idTarjeta) REFERENCES Tarjeta(idTarjeta),
    CONSTRAINT fk_Movimiento_TipoMovimiento FOREIGN KEY (idTipoMovimiento) REFERENCES TipoMovimiento(idTipoMovimiento),
    CONSTRAINT chk_Movimiento_Monto CHECK (Monto > 0)
);

GO

-- ============================================================
-- instalacion/06-Movimiento/02-insert.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Insertar 164 movimientos
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;

INSERT INTO Movimiento (idTarjeta, idTipoMovimiento, Monto, FechaMovimiento, Descripcion)
VALUES (9, 2, 500.00, '2024-07-05 13:45', 'Retiro en cajero'),
       (9, 1, 1452.85, '2024-08-11 15:10', 'Tienda departamental'),
       (9, 4, 1952.85, '2024-09-08 20:25', 'Pago en cajero'),
       (29, 2, 1000.00, '2024-11-07 20:30', 'Retiro en cajero'),
       (29, 1, 4124.24, '2024-11-29 10:00', 'Tienda en línea'),
       (29, 1, 301.66, '2025-01-06 09:35', 'Supermercado'),
       (9, 1, 1200.00, '2025-01-30 09:50', 'Ferretería'),
       (3, 3, 3500.00, '2025-02-15 15:30', 'Cobro de anualidad 2025'),
       (15, 1, 19574.20, '2025-04-18 13:50', 'Hotel'),
       (15, 3, 1200.00, '2025-05-10 20:10', 'Cobro de anualidad 2025'),
       (29, 4, 5425.90, '2025-05-11 19:30', 'Pago en sucursal'),
       (3, 1, 147069.44, '2025-05-24 19:00', 'Agencia de viajes'),
       (15, 4, 8034.91, '2025-07-19 15:20', 'Pago en cajero'),
       (3, 2, 3000.00, '2025-07-24 15:00', 'Retiro en cajero'),
       (8, 2, 5000.00, '2025-08-07 09:05', 'Retiro en cajero'),
       (30, 2, 3000.00, '2025-08-09 17:40', 'Retiro en cajero'),
       (39, 1, 31242.17, '2025-08-11 12:20', 'Aerolínea'),
       (33, 2, 5000.00, '2025-08-14 20:55', 'Retiro en cajero'),
       (15, 4, 7190.87, '2025-08-16 10:30', 'Pago en línea'),
       (28, 1, 52974.91, '2025-08-25 10:55', 'Mueblería'),
       (21, 2, 2000.00, '2025-09-02 20:20', 'Retiro en cajero'),
       (40, 1, 26110.77, '2025-09-03 14:20', 'Aerolínea'),
       (35, 2, 2000.00, '2025-09-04 11:05', 'Retiro en cajero'),
       (27, 1, 439.86, '2025-09-05 19:30', 'Cine'),
       (24, 2, 5000.00, '2025-09-06 17:25', 'Retiro en cajero'),
       (1, 1, 163.38, '2025-09-10 08:00', 'Cine'),
       (4, 1, 6662.08, '2025-09-16 13:15', 'Tienda de electrónica'),
       (39, 3, 1200.00, '2025-10-03 12:15', 'Cobro de anualidad 2025'),
       (25, 2, 1000.00, '2025-10-06 20:20', 'Retiro en cajero'),
       (28, 1, 17358.47, '2025-10-11 16:50', 'Tienda de electrónica'),
       (8, 1, 665.68, '2025-10-13 18:15', 'Supermercado'),
       (12, 2, 5000.00, '2025-10-14 21:25', 'Retiro en cajero'),
       (36, 2, 3000.00, '2025-10-16 17:55', 'Retiro en cajero'),
       (15, 4, 1912.13, '2025-10-21 17:15', 'Pago en línea'),
       (40, 1, 31232.56, '2025-10-22 14:25', 'Hotel'),
       (5, 1, 31004.74, '2025-10-22 20:45', 'Agencia de viajes'),
       (28, 5, 4339.62, '2025-10-24 17:45', 'Devolución de compra'),
       (4, 1, 830.40, '2025-10-31 13:55', 'Tienda departamental'),
       (36, 2, 5000.00, '2025-10-31 17:20', 'Retiro en cajero'),
       (2, 3, 1200.00, '2025-11-01 17:05', 'Cobro de anualidad 2025'),
       (3, 4, 104669.44, '2025-11-03 12:30', 'Pago en sucursal'),
       (12, 1, 1872.86, '2025-11-07 20:10', 'Tienda en línea'),
       (31, 1, 1312.88, '2025-11-12 16:50', 'Gasolinera'),
       (6, 2, 1000.00, '2025-11-13 21:30', 'Retiro en cajero'),
       (1, 2, 3000.00, '2025-11-14 13:05', 'Retiro en cajero'),
       (36, 1, 34383.79, '2025-11-15 16:45', 'Mueblería'),
       (20, 1, 12690.46, '2025-11-20 18:20', 'Hospital'),
       (26, 3, 3500.00, '2025-11-23 17:40', 'Cobro de anualidad 2025'),
       (36, 1, 3514.22, '2025-11-30 21:25', 'Supermercado'),
       (20, 1, 3444.13, '2025-12-03 08:10', 'Ferretería'),
       (12, 3, 3500.00, '2025-12-05 17:05', 'Cobro de anualidad 2025'),
       (31, 3, 3500.00, '2025-12-12 09:30', 'Cobro de anualidad 2025'),
       (34, 1, 65282.29, '2025-12-14 19:20', 'Hospital'),
       (31, 1, 563.14, '2025-12-18 11:20', 'Cine'),
       (26, 1, 32826.65, '2025-12-18 17:00', 'Aerolínea'),
       (33, 4, 3277.81, '2025-12-20 08:30', 'Pago en cajero'),
       (38, 1, 504.56, '2025-12-20 10:40', 'Restaurante'),
       (31, 4, 3199.68, '2025-12-20 13:25', 'Pago en línea'),
       (23, 2, 500.00, '2025-12-21 13:00', 'Retiro en cajero'),
       (28, 4, 29917.76, '2025-12-23 08:35', 'Pago en línea'),
       (39, 1, 942.14, '2026-01-07 15:00', 'Tienda en línea'),
       (27, 1, 14703.17, '2026-01-09 11:55', 'Tienda en línea'),
       (34, 1, 59315.11, '2026-01-14 15:25', 'Tienda de electrónica'),
       (14, 2, 2000.00, '2026-01-16 15:55', 'Retiro en cajero'),
       (19, 2, 3000.00, '2026-01-20 16:10', 'Retiro en cajero'),
       (21, 4, 2000.00, '2026-01-24 13:40', 'Pago en sucursal'),
       (5, 3, 1200.00, '2026-01-28 19:30', 'Cobro de anualidad 2026'),
       (15, 1, 6163.71, '2026-01-29 09:50', 'Tienda departamental'),
       (19, 4, 1066.56, '2026-01-31 10:10', 'Pago en sucursal'),
       (20, 1, 20755.30, '2026-02-09 08:30', 'Hotel'),
       (30, 3, 1200.00, '2026-02-10 21:20', 'Cobro de anualidad 2026'),
       (32, 2, 500.00, '2026-02-12 09:20', 'Retiro en cajero'),
       (24, 4, 5000.00, '2026-02-12 17:55', 'Pago en sucursal'),
       (16, 1, 477.49, '2026-02-12 18:30', 'Ferretería'),
       (24, 2, 1000.00, '2026-02-20 17:50', 'Retiro en cajero'),
       (1, 5, 81.69, '2026-02-21 09:55', 'Devolución de compra'),
       (26, 4, 34500.02, '2026-02-23 17:00', 'Pago en sucursal'),
       (20, 3, 1200.00, '2026-02-28 13:10', 'Cobro de anualidad 2026'),
       (31, 1, 15652.11, '2026-02-28 21:50', 'Aerolínea'),
       (23, 1, 616.81, '2026-03-01 16:50', 'Supermercado'),
       (13, 1, 18389.39, '2026-03-01 21:20', 'Agencia de viajes'),
       (6, 4, 331.96, '2026-03-02 08:00', 'Pago en cajero'),
       (21, 2, 500.00, '2026-03-03 16:25', 'Retiro en cajero'),
       (25, 1, 2255.07, '2026-03-06 13:15', 'Tienda departamental'),
       (22, 2, 2000.00, '2026-03-11 17:30', 'Retiro en cajero'),
       (19, 1, 14121.09, '2026-03-19 18:20', 'Hospital'),
       (33, 3, 1200.00, '2026-03-21 21:30', 'Cobro de anualidad 2026'),
       (19, 1, 419.62, '2026-03-26 15:45', 'Supermercado'),
       (27, 4, 9217.65, '2026-03-27 21:50', 'Pago en cajero'),
       (5, 4, 32204.74, '2026-04-01 20:50', 'Pago en sucursal'),
       (40, 4, 39666.37, '2026-04-04 10:30', 'Pago en línea'),
       (2, 1, 3257.79, '2026-04-07 15:20', 'Supermercado'),
       (40, 3, 3500.00, '2026-04-08 11:30', 'Cobro de anualidad 2026'),
       (17, 1, 10000.00, '2026-04-09 18:35', 'Hospital'),
       (17, 5, 5000.00, '2026-04-14 09:00', 'Devolución de compra'),
       (35, 1, 668.49, '2026-04-16 20:35', 'Farmacia'),
       (28, 3, 3500.00, '2026-04-19 09:45', 'Cobro de anualidad 2026'),
       (21, 1, 5384.51, '2026-04-19 20:45', 'Ferretería'),
       (38, 2, 2000.00, '2026-04-21 09:40', 'Retiro en cajero'),
       (8, 5, 332.84, '2026-04-23 20:10', 'Devolución de compra'),
       (2, 1, 173.74, '2026-04-24 19:15', 'Cine'),
       (25, 1, 3286.90, '2026-04-25 10:00', 'Tienda en línea'),
       (30, 2, 1000.00, '2026-04-28 20:15', 'Retiro en cajero'),
       (16, 4, 400.78, '2026-04-30 11:45', 'Pago en línea'),
       (12, 1, 77277.39, '2026-05-03 19:35', 'Hospital'),
       (4, 1, 506.49, '2026-05-08 11:45', 'Tienda departamental'),
       (36, 4, 45898.01, '2026-05-09 21:10', 'Pago en sucursal'),
       (32, 1, 5983.81, '2026-05-10 15:00', 'Ferretería'),
       (31, 1, 144749.24, '2026-05-10 20:20', 'Agencia de viajes'),
       (13, 1, 4916.09, '2026-05-12 13:10', 'Aerolínea'),
       (24, 3, 1200.00, '2026-05-15 16:50', 'Cobro de anualidad 2026'),
       (34, 2, 5000.00, '2026-05-17 18:45', 'Retiro en cajero'),
       (8, 3, 1200.00, '2026-05-18 08:00', 'Cobro de anualidad 2026'),
       (30, 1, 572.38, '2026-05-18 19:10', 'Cine'),
       (39, 1, 51615.69, '2026-05-20 09:25', 'Hospital'),
       (8, 2, 2000.00, '2026-05-21 17:40', 'Retiro en cajero'),
       (22, 1, 47131.38, '2026-05-24 08:05', 'Mueblería'),
       (20, 1, 969.26, '2026-06-05 11:25', 'Gasolinera'),
       (14, 3, 1200.00, '2026-06-05 21:25', 'Cobro de anualidad 2026'),
       (10, 1, 31360.69, '2026-06-09 17:15', 'Aerolínea'),
       (1, 1, 168.31, '2026-06-11 10:05', 'Ferretería'),
       (23, 1, 5663.19, '2026-06-15 08:15', 'Tienda de electrónica'),
       (6, 4, 668.04, '2026-06-16 21:30', 'Pago en sucursal'),
       (33, 4, 2922.19, '2026-06-25 11:30', 'Pago en línea'),
       (16, 1, 30061.04, '2026-06-25 11:35', 'Hotel'),
       (36, 3, 1200.00, '2026-06-27 17:45', 'Cobro de anualidad 2026'),
       (19, 4, 16474.15, '2026-06-28 10:00', 'Pago en sucursal'),
       (14, 4, 3200.00, '2026-06-29 09:15', 'Pago en sucursal'),
       (5, 1, 12780.50, '2026-07-01 09:50', 'Hotel'),
       (27, 3, 1200.00, '2026-07-01 13:10', 'Cobro de anualidad 2026'),
       (22, 1, 556.81, '2026-07-03 13:15', 'Cine'),
       (40, 1, 26623.04, '2026-07-04 20:55', 'Hotel'),
       (17, 4, 2550.00, '2026-07-07 09:15', 'Pago en cajero'),
       (35, 1, 1831.51, '2026-07-08 08:20', 'Supermercado'),
       (30, 1, 458.51, '2026-07-10 08:25', 'Supermercado'),
       (28, 4, 33976.00, '2026-07-10 21:45', 'Pago en línea'),
       (38, 4, 614.56, '2026-07-11 19:45', 'Pago en cajero'),
       (2, 4, 4631.53, '2026-07-12 16:55', 'Pago en cajero'),
       (10, 1, 161.76, '2026-07-13 15:35', 'Cine'),
       (25, 4, 6191.97, '2026-07-13 20:10', 'Pago en sucursal'),
       (4, 1, 1.03, '2026-07-19 15:45', 'Farmacia'),
       (32, 1, 15516.19, '2026-07-20 11:55', 'Aerolínea'),
       (31, 1, 87422.31, '2026-07-20 15:50', 'Agencia de viajes'),
       (24, 4, 2200.00, '2026-07-23 11:10', 'Pago en línea'),
       (8, 1, 66467.16, '2026-07-26 18:15', 'Hospital'),
       (20, 1, 940.85, '2026-08-02 16:15', 'Tienda en línea'),
       (26, 2, 500.00, '2026-08-04 17:00', 'Retiro en cajero'),
       (14, 1, 23229.60, '2026-08-07 08:40', 'Tienda departamental'),
       (21, 3, 1200.00, '2026-08-08 15:55', 'Cobro de anualidad 2026'),
       (13, 5, 2458.05, '2026-08-10 21:05', 'Devolución de compra'),
       (36, 1, 37700.00, '2026-08-13 14:15', 'Agencia de viajes'),
       (27, 1, 14374.62, '2026-08-15 21:10', 'Hotel'),
       (22, 1, 52311.81, '2026-08-16 16:55', 'Mueblería'),
       (30, 1, 8019.11, '2026-08-20 17:20', 'Mueblería'),
       (10, 4, 27422.45, '2026-08-21 17:15', 'Pago en sucursal'),
       (26, 1, 130932.25, '2026-08-23 20:00', 'Agencia de viajes'),
       (34, 3, 3500.00, '2026-08-28 16:40', 'Cobro de anualidad 2026'),
       (21, 1, 26125.49, '2026-09-03 12:35', 'Hospital'),
       (14, 4, 10829.60, '2026-09-03 18:50', 'Pago en cajero'),
       (13, 1, 9152.57, '2026-09-04 17:55', 'Tienda departamental'),
       (26, 1, 46741.12, '2026-09-11 16:30', 'Hospital'),
       (34, 4, 68776.65, '2026-09-13 12:50', 'Pago en sucursal'),
       (16, 3, 3500.00, '2026-09-17 09:20', 'Cobro de anualidad 2026'),
       (16, 4, 18337.75, '2026-09-23 15:35', 'Pago en cajero');

GO

-- ============================================================
-- instalacion/06-Movimiento/03-usp-registrar.sql
-- ============================================================
-- Tema:        SistemaBancarioBD - Examen de Medio Término
-- Descripción: Registrar un movimiento de tarjeta y actualizar su SaldoActual
--              (única vía permitida para insertar en Movimiento)
-- Autor:       Daniel Hilario

USE SistemaBancarioBD;
GO

CREATE PROCEDURE usp_registrarMovimiento
	@p_idTarjeta int,
	@p_idTipoMovimiento int,
	@p_Monto decimal(12,2),
	@p_Descripcion varchar(100)
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@ActivoTarjeta bit,
			@FechaVencimiento date,
			@LimiteCredito decimal(12,2),
			@SaldoActual decimal(12,2),
			@EsCargo bit

	-- Validación de la Tarjeta: revisamos primero si el idTarjeta existe en la tabla

	SELECT @ActivoTarjeta = Activo,
		@FechaVencimiento = FechaVencimiento,
		@LimiteCredito = LimiteCredito,
		@SaldoActual = SaldoActual
	FROM Tarjeta
	WHERE idTarjeta = @p_idTarjeta

	IF @ActivoTarjeta IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'La tarjeta no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de tarjeta cancelada (baja lógica)

	IF @ActivoTarjeta = 0 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'La tarjeta está cancelada'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de tarjeta vencida

	IF @FechaVencimiento < CAST(GETDATE() AS date) BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'La tarjeta está vencida'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del TipoMovimiento: revisamos si el idTipoMovimiento existe en la tabla

	SELECT @EsCargo = EsCargo
	FROM TipoMovimiento
	WHERE idTipoMovimiento = @p_idTipoMovimiento

	IF @EsCargo IS NULL BEGIN

		SELECT 	@ErrCodigo = '000004',
				@ErrMensaje = 'El tipo de movimiento no existe'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación del monto

	IF @p_Monto IS NULL OR @p_Monto <= 0 BEGIN

		SELECT 	@ErrCodigo = '000005',
				@ErrMensaje = 'El monto debe ser mayor a cero'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación de crédito disponible (cargos) y de saldo suficiente (abonos)

	IF @EsCargo = 1 AND @SaldoActual + @p_Monto > @LimiteCredito BEGIN

		SELECT 	@ErrCodigo = '000006',
				@ErrMensaje = 'El cargo excede el crédito disponible'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	IF @EsCargo = 0 AND @p_Monto > @SaldoActual BEGIN

		SELECT 	@ErrCodigo = '000007',
				@ErrMensaje = 'El abono es mayor que el saldo de la tarjeta'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Registro del movimiento y ajuste del saldo de la tarjeta

	INSERT INTO Movimiento (idTarjeta, idTipoMovimiento, Monto, FechaMovimiento, Descripcion)
	VALUES (@p_idTarjeta, @p_idTipoMovimiento, @p_Monto, GETDATE(), @p_Descripcion)

	IF @EsCargo = 1 BEGIN

		UPDATE Tarjeta
		SET
			SaldoActual = SaldoActual + @p_Monto,
			FechaUltimaModificacion = GETDATE()
		WHERE idTarjeta = @p_idTarjeta
	END
	ELSE BEGIN

		UPDATE Tarjeta
		SET
			SaldoActual = SaldoActual - @p_Monto,
			FechaUltimaModificacion = GETDATE()
		WHERE idTarjeta = @p_idTarjeta
	END

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Movimiento registrado'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END

GO
