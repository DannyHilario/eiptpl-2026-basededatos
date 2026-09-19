-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla Receta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Receta (
    idReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idConsulta INT NOT NULL UNIQUE,
    idEstatusReceta INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_Receta_Consulta FOREIGN KEY (idConsulta) REFERENCES Consulta(idConsulta),
    CONSTRAINT fk_Receta_EstatusReceta FOREIGN KEY (idEstatusReceta) REFERENCES EstatusReceta(idEstatusReceta)
);
