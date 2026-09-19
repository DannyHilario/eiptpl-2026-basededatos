-- Tema:        Reversa HospitalDB - Sesión 7
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Paso 1: BitacoraEstatusReceta — depende de Receta y de EstatusReceta
DROP TABLE IF EXISTS BitacoraEstatusReceta;

-- Paso 2: DetalleReceta — depende de Receta y de Medicamento
DROP TABLE IF EXISTS DetalleReceta;

-- Paso 3: Medicamento — ya no tiene dependientes tras eliminar DetalleReceta
DROP TABLE IF EXISTS Medicamento;

-- Paso 4: Receta — depende de Consulta y de EstatusReceta
DROP TABLE IF EXISTS Receta;

-- Paso 5: EstatusReceta — ya no tiene dependientes tras eliminar Receta y BitacoraEstatusReceta
DROP TABLE IF EXISTS EstatusReceta;

-- Paso 6: Consulta — depende de Paciente, Medico y Consultorio
DROP TABLE IF EXISTS Consulta;

-- Paso 7: Consultorio — ya no tiene dependientes tras eliminar Consulta
DROP TABLE IF EXISTS Consultorio;

-- Paso 8: Paciente — ya no tiene dependientes tras eliminar Consulta
DROP TABLE IF EXISTS Paciente;

-- Paso 9: MedicoEspecialidad — depende de Medico y de Especialidad
DROP TABLE IF EXISTS MedicoEspecialidad;

-- Paso 10: Medico — ya no tiene dependientes tras eliminar Consulta y MedicoEspecialidad
DROP TABLE IF EXISTS Medico;

-- Paso 11: Especialidad — ya no tiene dependientes tras eliminar MedicoEspecialidad
DROP TABLE IF EXISTS Especialidad;
