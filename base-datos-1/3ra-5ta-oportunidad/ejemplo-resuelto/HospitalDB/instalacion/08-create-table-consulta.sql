-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Crear tabla Consulta
-- Autor:       Daniel Hilario

USE HospitalDB;

CREATE TABLE Consulta (
    idConsulta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idPaciente INT NOT NULL,
    idMedico INT NOT NULL,
    idConsultorio INT NOT NULL,
    Fecha DATETIME NOT NULL,
    Efectuada BIT NOT NULL DEFAULT 0,
    CONSTRAINT fk_Consulta_Paciente FOREIGN KEY (idPaciente) REFERENCES Paciente(idPaciente),
    CONSTRAINT fk_Consulta_Medico FOREIGN KEY (idMedico) REFERENCES Medico(idMedico),
    CONSTRAINT fk_Consulta_Consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(idConsultorio)
);
