-- Tema:        BancoDB - Examen Final
-- Descripción: Insertar 30 clientes (datos tomados de EscuelaDB)
-- Autor:       Daniel Hilario

USE BancoDB;

-- Clientes 1-10
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, CURP,
    RFC, Sexo, Telefono, CorreoElectronico, Activo)
VALUES ('García', 'López', 'Carlos', '2008-03-15', 'GALC080315NLHRRL06',
    'GALC080315AA6', 'M', '8112340001', 'carlos.garcia@correo.mx', 1),
       ('Hernández', 'Ramírez', 'Ana', '2007-12-20', 'HERA071220NLMRNA09',
    'HERA071220AB3', 'F', '8112340002', 'ana.hernandez@correo.mx', 1),
       ('Rodríguez', 'Silva', 'Miguel', '2009-11-05', 'ROSM091105NLHDGS07',
    'ROSM091105AC7', 'M', '8112340003', 'miguel.rodriguez@correo.mx', 1),
       ('Torres', 'Gutiérrez', 'Valeria', '2008-07-22', 'TOGV080722NLMRRV02',
    'TOGV080722AD2', 'F', '8112340004', 'valeria.torres@correo.mx', 1),
       ('Pérez', 'Morales', 'Luis', '2007-10-14', 'PEML071014NLHRRM08',
    'PEML071014AE8', 'M', '8112340005', 'luis.perez@correo.mx', 1),
       ('Sánchez', 'Vega', 'Sofía', '2009-12-30', 'SAVS091230NLMNNS04',
    'SAVS091230AF4', 'F', '8112340006', 'sofia.sanchez@correo.mx', 1),
       ('Ramírez', 'Cruz', 'Alejandro', '2006-10-05', 'RACA061005NLHRCM01',
    'RACA061005AG1', 'M', '8112340007', 'alejandro.ramirez@correo.mx', 1),
       ('Jiménez', 'Flores', 'Daniela', '2008-08-18', 'JIFD080818NLMMNF03',
    'JIFD080818AH3', 'F', '8112340008', 'daniela.jimenez@correo.mx', 1),
       ('Gómez', 'Reyes', 'Ricardo', '2007-05-15', 'GORR070515NLHMMR07',
    'GORR070515AI7', 'M', '8112340009', 'ricardo.gomez@correo.mx', 1),
       ('Delgado', 'Ortiz', 'Mariana', '2009-10-20', 'DEOM091020NLMLLG05',
    'DEOM091020AJ5', 'F', '8112340010', 'mariana.delgado@correo.mx', 1)

-- Clientes 11-20
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, CURP,
    RFC, Sexo, Telefono, CorreoElectronico, Activo)
VALUES ('Castro', 'Ibarra', 'Sergio', '2008-08-07', 'CAIS080807NLHSTR09',
    'CAIS080807AK9', 'M', '8112340011', 'sergio.castro@correo.mx', 1),
       ('Morales', 'Sandoval', 'Fernanda', '2007-06-25', 'MOSF070625NLMRLL02',
    'MOSF070625AL2', 'F', '8112340012', 'fernanda.morales@correo.mx', 1),
       ('Vargas', 'Lozano', 'Eduardo', '2006-03-14', 'VALE060314NLHRRG06',
    'VALE060314AM6', 'M', '8112340013', 'eduardo.vargas@correo.mx', 1),
       ('Fuentes', 'Cervantes', 'Adriana', '2008-09-12', 'FUCA080912NLMNNN01',
    'FUCA080912AN1', 'F', '8112340014', 'adriana.fuentes@correo.mx', 1),
       ('Aguilar', 'Mendoza', 'Daniel', '2009-11-28', 'AGMD091128NLHLLR04',
    'AGMD091128AO4', 'M', '8112340015', 'daniel.aguilar@correo.mx', 1),
       ('Salinas', 'Herrera', 'Carolina', '2007-10-03', 'SAHC071003NLMLLN07',
    'SAHC071003AP7', 'F', '8112340016', 'carolina.salinas@correo.mx', 1),
       ('Medina', 'Castillo', 'Pablo', '2008-05-20', 'MECP080520NLHDNN08',
    'MECP080520AQ8', 'M', '8112340017', 'pablo.medina@correo.mx', 1),
       ('Lozano', 'Guerrero', 'Elena', '2009-12-15', 'LOGE091215NLMZNN03',
    'LOGE091215AR3', 'F', '8112340018', 'elena.lozano@correo.mx', 1),
       ('Núñez', 'Ramos', 'Francisco', '2006-11-02', 'NURF061102NLHNNM06',
    'NURF061102AS6', 'M', '8112340019', 'francisco.nunez@correo.mx', 1),
       ('Reyes', 'Díaz', 'Victoria', '2008-04-06', 'REDV080406NLMYYY01',
    'REDV080406AT1', 'F', '8112340020', 'victoria.reyes@correo.mx', 1)

-- Clientes 21-30
-- NOTA: Los clientes 23-30 no tienen transacciones registradas.
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, CURP,
    RFC, Sexo, Telefono, CorreoElectronico, Activo)
VALUES ('Ortiz', 'Peña', 'Gabriel', '2007-08-25', 'ORPG070825NLHRRZ05',
    'ORPG070825AU8', 'M', '8112340021', 'gabriel.ortiz@correo.mx', 1),
       ('Cruz', 'Navarro', 'Monserrat', '2009-10-08', 'CUNM091008NLMRRR09',
    'CUNM091008AV3', 'F', '8112340022', 'monserrat.cruz@correo.mx', 1),
       ('Flores', 'Ibáñez', 'Héctor', '2008-02-14', 'FLIH080214NLHLLR02',
    'FLIH080214AW6', 'M', '8112340023', 'hector.flores@correo.mx', 1),
       ('Rivera', 'Moreno', 'Patricia', '2007-09-29', 'RIMP070929NLMVRR07',
    'RIMP070929AX1', 'F', '8112340024', 'patricia.rivera@correo.mx', 1),
       ('Silva', 'Espinoza', 'Roberto', '2008-06-17', 'SIER080617NLHLLV04',
    'SIER080617AY4', 'M', '8112340025', 'roberto.silva@correo.mx', 1),
       ('Gutiérrez', 'Peña', 'Andrea', '2009-11-24', 'GUPA091124NLMTTM08',
    'GUPA091124AZ7', 'F', '8112340026', 'andrea.gutierrez@correo.mx', 1),
       ('Mendoza', 'Torres', 'Iván', '2008-03-13', 'METI080313NLHNDZ03',
    'METI080313BA2', 'M', '8112340027', 'ivan.mendoza@correo.mx', 1),
       ('Herrera', 'Soto', 'Camila', '2007-10-19', 'HESC071019NLMRRR06',
    'HESC071019BB5', 'F', '8112340028', 'camila.herrera@correo.mx', 1),
       ('Vega', 'Ramírez', 'Carlos', '2009-12-07', 'VERC091207NLHGGS01',
    'VERC091207BC8', 'M', '8112340029', 'carlos.vega@correo.mx', 1),
       ('Navarro', 'Flores', 'Lucía', '2008-05-25', 'NAFL080525NLMVRR09',
    'NAFL080525BD1', 'F', '8112340030', 'lucia.navarro@correo.mx', 1)
