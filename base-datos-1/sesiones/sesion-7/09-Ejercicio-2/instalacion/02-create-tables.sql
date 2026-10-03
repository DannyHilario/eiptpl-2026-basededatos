-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Crear tablas del modelo relacional del hotel
-- Autor:       Daniel Hilario

USE CursoDB;

-- Tabla Huesped
CREATE TABLE Huesped (
    idHuesped INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Telefono VARCHAR(20),
    Correo VARCHAR(100) UNIQUE
);

-- Tabla TipoHabitacion
CREATE TABLE TipoHabitacion (
    idTipoHabitacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    TipoHabitacion VARCHAR(50) NOT NULL UNIQUE,
    PrecioPorNoche DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_TipoHabitacion_PrecioPorNoche CHECK (PrecioPorNoche > 0)
);

-- Tabla Habitacion
CREATE TABLE Habitacion (
    idHabitacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTipoHabitacion INT NOT NULL,
    NumeroHabitacion VARCHAR(10) NOT NULL,
    DescripcionHabitacion VARCHAR(200),
    CONSTRAINT uq_Habitacion_NumeroHabitacion UNIQUE (NumeroHabitacion),
    CONSTRAINT fk_Habitacion_TipoHabitacion
        FOREIGN KEY (idTipoHabitacion)
        REFERENCES TipoHabitacion(idTipoHabitacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla Reservacion
CREATE TABLE Reservacion (
    idReservacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idHuesped INT NOT NULL,
    idHabitacion INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    NumeroNoches INT NOT NULL,
    PrecioAlMomento DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Reservacion_Huesped
        FOREIGN KEY (idHuesped)
        REFERENCES Huesped(idHuesped)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_Reservacion_Habitacion
        FOREIGN KEY (idHabitacion)
        REFERENCES Habitacion(idHabitacion)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT chk_Reservacion_NumeroNoches CHECK (NumeroNoches > 0),
    CONSTRAINT chk_Reservacion_PrecioAlMomento CHECK (PrecioAlMomento > 0)
);