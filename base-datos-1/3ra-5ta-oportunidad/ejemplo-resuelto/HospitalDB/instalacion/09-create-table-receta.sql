-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla Receta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Receta (
    idReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idConsulta INT NOT NULL UNIQUE,
    idEstatusReceta INT NOT NULL,
    CONSTRAINT fk_Receta_Consulta FOREIGN KEY (idConsulta) REFERENCES Consulta(idConsulta),
    CONSTRAINT fk_Receta_EstatusReceta FOREIGN KEY (idEstatusReceta) REFERENCES EstatusReceta(idEstatusReceta)
);
