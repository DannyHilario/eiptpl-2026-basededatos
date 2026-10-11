-- Tema:        Evidencia Integral - Ejemplo resuelto LavaExpressDB
-- Descripción: Insertar 12 clientes (los clientes 11 y 12 no tienen pedidos)
-- Autor:       Daniel Hilario

USE LavaExpressDB;

INSERT INTO Cliente (idSucursal, Nombre, Telefono, FechaRegistro, Activo)
VALUES (1, 'Marcela Rivas Ochoa', '8115550101', '2025-11-03', 1),
       (1, 'Tomás Garza Leal', '8115550102', '2025-11-18', 1),
       (2, 'Mónica Salas Tijerina', '8115550103', '2025-12-02', 1),
       (2, 'Raúl Cantú Barrera', '8115550104', '2025-12-15', 1),
       (3, 'Patricia Ibarra Solís', '8115550105', '2026-01-07', 1),
       (1, 'Miguel Ángel Treviño', '8115550106', '2026-01-20', 1),
       (3, 'Lorena Fuentes Garza', '8115550107', '2026-02-04', 0),
       (2, 'Javier Ortiz Peña', '8115550108', '2026-02-11', 1),
       (1, 'Mariela Torres Cruz', '8115550109', '2026-02-26', 1),
       (3, 'Sergio Lozano Ríos', '8115550110', '2026-03-05', 1),
       (2, 'Natalia Vega Saldaña', '8115550111', '2026-03-19', 1),
       (1, 'Gerardo Elizondo Mata', '8115550112', '2026-04-02', 1);
