-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear tabla Servicio
-- Autor:       Daniel Hilario

USE ComedorDB;

CREATE TABLE Servicio (
    idServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idEmpleado INT NOT NULL,
    idPlatillo INT NOT NULL,
    FechaServicio DATE NOT NULL,
    Precio DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_Servicio_Empleado FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado),
    CONSTRAINT fk_Servicio_Platillo FOREIGN KEY (idPlatillo) REFERENCES Platillo(idPlatillo),
    CONSTRAINT chk_Servicio_Precio CHECK (Precio > 0)
);
