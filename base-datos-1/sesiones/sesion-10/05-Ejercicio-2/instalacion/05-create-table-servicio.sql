-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla Servicio
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE Servicio (
    idServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idVehiculo INT NOT NULL,
    idTipoServicio INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    CostoServicio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Servicio_Vehiculo FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo),
    CONSTRAINT fk_Servicio_TipoServicio FOREIGN KEY (idTipoServicio) REFERENCES TipoServicio(idTipoServicio)
);
