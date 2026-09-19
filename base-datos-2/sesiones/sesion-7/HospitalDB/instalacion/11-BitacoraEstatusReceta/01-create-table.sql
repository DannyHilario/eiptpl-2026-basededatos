-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla BitacoraEstatusReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE BitacoraEstatusReceta (
    idBitacoraEstatusReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idReceta INT NOT NULL,
    idEstatusReceta INT NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_BitacoraEstatusReceta_Receta FOREIGN KEY (idReceta) REFERENCES Receta(idReceta),
    CONSTRAINT fk_BitacoraEstatusReceta_EstatusReceta FOREIGN KEY (idEstatusReceta) REFERENCES EstatusReceta(idEstatusReceta)
);
