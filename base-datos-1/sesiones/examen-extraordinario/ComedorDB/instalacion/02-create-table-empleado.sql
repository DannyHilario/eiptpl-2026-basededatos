-- Tema:        ComedorDB - 2da Oportunidad de Base de Datos I
-- Descripción: Crear tabla Empleado
-- Autor:       Daniel Hilario

USE ComedorDB;

CREATE TABLE Empleado (
    idEmpleado INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Departamento VARCHAR(50) NOT NULL,
    CURP CHAR(18),
    Sexo CHAR(1) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    CONSTRAINT chk_Empleado_Sexo CHECK (Sexo IN ('M', 'F'))
);
