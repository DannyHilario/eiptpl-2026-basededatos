-- Tema:        Evidencia Integral - Ejemplo resuelto HospitalDB
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Paso 1: DetalleReceta — depende de Receta y de Medicamento
DROP TABLE IF EXISTS DetalleReceta;

-- Paso 2: Medicamento — ya no tiene dependientes tras eliminar DetalleReceta
DROP TABLE IF EXISTS Medicamento;

-- Paso 3: Receta — depende de Consulta y de EstatusReceta; ya no tiene dependientes tras eliminar DetalleReceta
DROP TABLE IF EXISTS Receta;

-- Paso 4: EstatusReceta — ya no tiene dependientes tras eliminar Receta
DROP TABLE IF EXISTS EstatusReceta;

-- Paso 5: Consulta — depende de Paciente, Medico y Consultorio; ya no tiene dependientes tras eliminar Receta
DROP TABLE IF EXISTS Consulta;

-- Paso 6: Consultorio — ya no tiene dependientes tras eliminar Consulta
DROP TABLE IF EXISTS Consultorio;

-- Paso 7: Paciente — ya no tiene dependientes tras eliminar Consulta
DROP TABLE IF EXISTS Paciente;

-- Paso 8: MedicoEspecialidad — depende de Medico y de Especialidad
DROP TABLE IF EXISTS MedicoEspecialidad;

-- Paso 9: Medico — ya no tiene dependientes tras eliminar Consulta y MedicoEspecialidad
DROP TABLE IF EXISTS Medico;

-- Paso 10: Especialidad — ya no tiene dependientes tras eliminar MedicoEspecialidad
DROP TABLE IF EXISTS Especialidad;
