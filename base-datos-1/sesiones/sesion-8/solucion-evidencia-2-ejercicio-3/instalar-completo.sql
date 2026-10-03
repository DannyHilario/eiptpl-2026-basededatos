-- Tema:        Ejercicio 3 - ViajeYA
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
-- Tema:        Ejercicio 3 - ViajeYA
-- Descripción: Crear base de datos ViajeYA
-- Autor:       Daniel Hilario

CREATE DATABASE ViajeYA;

GO

-- ============================================================
-- instalacion/02-tablas.sql
-- ============================================================
-- Tema:        Ejercicio 3 - ViajeYA
-- Descripción: Crear las tablas del modelo ViajeYA
-- Autor:       Daniel Hilario

USE ViajeYA;

-- Tabla Cliente
CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL
);

-- Tabla Pais
CREATE TABLE Pais (
    idPais INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NombrePais VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla TipoPaquete
CREATE TABLE TipoPaquete (
    idTipoPaquete INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NombrePaquete VARCHAR(100) NOT NULL,
    PrecioActual DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_TipoPaquete_PrecioActual CHECK (PrecioActual > 0)
);

-- Tabla Destino
CREATE TABLE Destino (
    idDestino INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPais INT NOT NULL,
    idTipoPaquete INT NOT NULL,
    NombreDestino VARCHAR(100) NOT NULL,
    CONSTRAINT fk_Destino_Pais
        FOREIGN KEY (idPais)
        REFERENCES Pais(idPais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_Destino_TipoPaquete
        FOREIGN KEY (idTipoPaquete)
        REFERENCES TipoPaquete(idTipoPaquete)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla Reservacion
CREATE TABLE Reservacion (
    idReservacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idDestino INT NOT NULL,
    FechaSalida DATE NOT NULL,
    NumeroNoches INT NOT NULL,
    PrecioAlMomento DECIMAL(10,2) NOT NULL,
    TotalAPagar DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Reservacion_Cliente
        FOREIGN KEY (idCliente)
        REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_Reservacion_Destino
        FOREIGN KEY (idDestino)
        REFERENCES Destino(idDestino)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT chk_Reservacion_NumeroNoches CHECK (NumeroNoches > 0),
    CONSTRAINT chk_Reservacion_PrecioAlMomento CHECK (PrecioAlMomento > 0),
    CONSTRAINT chk_Reservacion_TotalAPagar CHECK (TotalAPagar > 0)
);

GO

-- ============================================================
-- instalacion/03-datos.sql
-- ============================================================
-- Tema:        Ejercicio 3 - ViajeYA
-- Descripción: Insertar 10 registros por tabla en la base de datos ViajeYA
-- Autor:       Daniel Hilario

USE ViajeYA;

-- Tabla Pais
INSERT INTO Pais (NombrePais)
VALUES ('México'),
       ('España'),
       ('Francia'),
       ('Italia'),
       ('Argentina'),
       ('Colombia'),
       ('Perú'),
       ('Brasil'),
       ('Japón'),
       ('Tailandia')

-- Tabla TipoPaquete
INSERT INTO TipoPaquete (NombrePaquete, PrecioActual)
VALUES ('Escapada de fin de semana', 1500.00),
       ('Luna de miel', 4500.00),
       ('Aventura extrema', 3200.00),
       ('Relax y bienestar', 2800.00),
       ('Cultural e histórico', 2000.00),
       ('Gastronómico', 2200.00),
       ('Ecoturismo', 1800.00),
       ('Crucero fluvial', 3500.00),
       ('Safari urbano', 1600.00),
       ('Turismo de playa', 2500.00)

-- Tabla Cliente
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre)
VALUES ('García', 'Martínez', 'Ana'),
       ('López', 'Hernández', 'Carlos'),
       ('Rodríguez', 'Pérez', 'María'),
       ('Martínez', 'González', 'José'),
       ('Hernández', 'López', 'Laura'),
       ('González', 'Rodríguez', 'Miguel'),
       ('Pérez', 'García', 'Sofía'),
       ('Sánchez', 'Martínez', 'Diego'),
       ('Ramírez', 'López', 'Valentina'),
       ('Torres', 'González', 'Andrés')

-- Tabla Destino
-- Cada destino combina un país y un tipo de paquete
INSERT INTO Destino (idPais, idTipoPaquete, NombreDestino)
VALUES (1, 10, 'Cancún'),
       (2, 5,  'Barcelona'),
       (3, 2,  'París'),
       (4, 6,  'Roma'),
       (5, 3,  'Patagonia'),
       (6, 1,  'Cartagena de Indias'),
       (7, 7,  'Machu Picchu'),
       (8, 4,  'Río de Janeiro'),
       (9, 9,  'Tokio'),
       (10, 8, 'Bangkok')

-- Tabla Reservacion
-- PrecioAlMomento: snapshot del precio del TipoPaquete al momento de reservar
-- TotalAPagar: PrecioAlMomento * NumeroNoches
INSERT INTO Reservacion (idCliente, idDestino, FechaSalida,
    NumeroNoches, PrecioAlMomento, TotalAPagar)
VALUES (1,  1,  '2026-01-15', 7,  2500.00, 17500.00),
       (2,  2,  '2026-02-10', 5,  2000.00, 10000.00),
       (3,  3,  '2026-03-20', 10, 4500.00, 45000.00),
       (4,  4,  '2026-04-05', 6,  2200.00, 13200.00),
       (5,  5,  '2026-05-12', 8,  3200.00, 25600.00),
       (6,  6,  '2026-06-18', 3,  1500.00,  4500.00),
       (7,  7,  '2026-07-22', 9,  1800.00, 16200.00),
       (8,  8,  '2026-08-08', 4,  2800.00, 11200.00),
       (9,  9,  '2026-09-14', 6,  1600.00,  9600.00),
       (10, 10, '2026-10-30', 12, 3500.00, 42000.00)

GO
