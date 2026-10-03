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