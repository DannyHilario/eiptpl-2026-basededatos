-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 10 médicos (origen: primeros 10 clientes de CompuStoreDB - Sesión 5, adaptados)
-- Autor:       Daniel Hilario

USE HospitalDB;

INSERT INTO Medico (Nombre, PrimerApellido, SegundoApellido, Cedula, Telefono,
                    Correo, Activo)
VALUES ('Carlos', 'García', 'López', '10234501', '8112000001',
        'carlos.garcia@hospitaldb.com', 1),
       ('Ana', 'Hernández', 'Ramírez', '10234502', '8112000002',
        'ana.hernandez@hospitaldb.com', 1),
       ('Miguel', 'Rodríguez', 'Silva', '10234503', '8112000003',
        'miguel.rodriguez@hospitaldb.com', 1),
       ('Valeria', 'Torres', 'Gutiérrez', '10234504', '8112000004',
        'valeria.torres@hospitaldb.com', 1),
       ('Luis', 'Pérez', 'Morales', '10234505', '8112000005',
        'luis.perez@hospitaldb.com', 1),
       ('Sofía', 'Sánchez', 'Vega', '10234506', '8112000006',
        'sofia.sanchez@hospitaldb.com', 1),
       ('Alejandro', 'Ramírez', 'Cruz', '10234507', '8112000007',
        'alejandro.ramirez@hospitaldb.com', 1),
       ('Daniela', 'Jiménez', 'Flores', '10234508', '8112000008',
        'daniela.jimenez@hospitaldb.com', 1),
       ('Ricardo', 'Gómez', 'Reyes', '10234509', '8112000009',
        'ricardo.gomez@hospitaldb.com', 1),
       ('Mariana', 'Delgado', 'Ortiz', '10234510', '8112000010',
        'mariana.delgado@hospitaldb.com', 1);
