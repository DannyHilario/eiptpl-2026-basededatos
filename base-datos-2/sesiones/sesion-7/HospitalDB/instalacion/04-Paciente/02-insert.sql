-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 15 pacientes (origen: clientes 11-25 de CompuStoreDB - Sesión 5, adaptados)
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Paciente (Nombre, PrimerApellido, SegundoApellido, Sexo, Telefono,
                      Correo, FechaNacimiento, Activo)
VALUES ('Sergio', 'Castro', 'Ibarra', 'M', '8100000011',
        'sergio.castro@outlook.com', '1978-04-12', 1),
       ('Fernanda', 'Morales', 'Sandoval', 'F', '8100000012',
        'fernanda.morales@yahoo.com.mx', '1985-11-03', 1),
       ('Eduardo', 'Vargas', 'Lozano', 'M', '8100000013',
        'eduardo.vargas@gmail.com', '1990-07-22', 1),
       ('Adriana', 'Fuentes', 'Cervantes', 'F', '8100000014',
        'adriana.fuentes@hotmail.com', '1965-02-14', 1),
       ('Daniel', 'Aguilar', 'Mendoza', 'M', '8100000015',
        'daniel.aguilar@outlook.com', '2001-09-30', 1),
       ('Carolina', 'Salinas', 'Herrera', 'F', '8100000016',
        'carolina.salinas@yahoo.com.mx', '1972-05-18', 1),
       ('Pablo', 'Medina', 'Castillo', 'M', '8100000017',
        'pablo.medina@gmail.com', '1995-12-08', 1),
       ('Elena', 'Lozano', 'Guerrero', 'F', '8100000018',
        'elena.lozano@hotmail.com', '1958-08-25', 1),
       ('Francisco', 'Núñez', 'Ramos', 'M', '8100000019',
        'francisco.nunez@outlook.com', '1983-03-11', 1),
       ('Victoria', 'Reyes', 'Díaz', 'F', '8100000020',
        'victoria.reyes@yahoo.com.mx', '1999-06-27', 1),
       ('Gabriel', 'Ortiz', 'Peña', 'M', '8100000021',
        'gabriel.ortiz@gmail.com', '1968-10-05', 1),
       ('Monserrat', 'Cruz', 'Navarro', 'F', '8100000022',
        'monserrat.cruz@hotmail.com', '1992-01-19', 1),
       ('Héctor', 'Flores', 'Ibáñez', 'M', '8100000023',
        'hector.flores@outlook.com', '1975-04-30', 1),
       ('Patricia', 'Rivera', 'Moreno', 'F', '8100000024',
        'patricia.rivera@yahoo.com.mx', '1988-09-14', 1),
       ('Roberto', 'Silva', 'Espinoza', 'M', '8100000025',
        'roberto.silva@gmail.com', '2003-02-21', 1);
