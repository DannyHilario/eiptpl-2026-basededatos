-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla MedicoEspecialidad
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE MedicoEspecialidad (
    idMedicoEspecialidad INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idMedico INT NOT NULL,
    idEspecialidad INT NOT NULL,
    CONSTRAINT fk_MedicoEspecialidad_Medico FOREIGN KEY (idMedico) REFERENCES Medico(idMedico),
    CONSTRAINT fk_MedicoEspecialidad_Especialidad FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(idEspecialidad),
    CONSTRAINT uq_MedicoEspecialidad_Medico_Especialidad UNIQUE (idMedico, idEspecialidad)
);
