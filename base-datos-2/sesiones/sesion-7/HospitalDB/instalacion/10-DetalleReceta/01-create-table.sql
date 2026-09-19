-- Tema:        HospitalDB - Sesión 7
-- Descripción: Crear tabla DetalleReceta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE DetalleReceta (
    idDetalleReceta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idReceta INT NOT NULL,
    idMedicamento INT NOT NULL,
    Cantidad INT NOT NULL,
    Indicaciones VARCHAR(200) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaUltimaModificacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_DetalleReceta_Receta FOREIGN KEY (idReceta) REFERENCES Receta(idReceta),
    CONSTRAINT fk_DetalleReceta_Medicamento FOREIGN KEY (idMedicamento) REFERENCES Medicamento(idMedicamento),
    CONSTRAINT chk_DetalleReceta_Cantidad CHECK (Cantidad > 0)
);
