-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar líneas de detalle en las recetas que ya tienen medicamentos asignados
-- Autor:       Daniel Hilario
--
-- Nota: las recetas 1, 2 y 3 (estatus Creada/Cancelada) se dejan sin líneas a propósito —
-- una receta puede seguir sin líneas mientras no se le haya empezado a surtir nada.

USE HospitalDB;

INSERT INTO DetalleReceta (idReceta, idMedicamento, Cantidad, Indicaciones)
VALUES (4, 1, 20, 'Tomar 1 tableta cada 8 horas por 5 días'),
       (4, 2, 10, 'Tomar 1 tableta cada 12 horas por 5 días'),
       (5, 3, 21, 'Tomar 1 cápsula cada 8 horas por 7 días'),
       (6, 4, 14, 'Tomar 1 tableta cada 12 horas en ayunas'),
       (7, 5, 10, 'Tomar 1 tableta cada 24 horas'),
       (8, 6, 60, 'Tomar 1 tableta cada 12 horas con alimentos'),
       (8, 7, 30, 'Tomar 1 tableta cada 24 horas'),
       (9, 8, 10, 'Tomar 1 tableta cada 12 horas por 5 días'),
       (10, 9, 1, 'Tomar 10ml cada 8 horas por 7 días'),
       (11, 10, 15, 'Tomar 1 tableta cada 8 horas por 5 días'),
       (11, 11, 20, 'Tomar 1 tableta cada 12 horas por 10 días'),
       (12, 12, 30, 'Tomar 1 tableta cada 8 horas'),
       (12, 13, 1, 'Aplicar 2 disparos cada 8 horas'),
       (13, 14, 8, 'Tomar 1 tableta cada 12 horas por 4 días'),
       (14, 15, 1, 'Aplicar en la zona afectada cada 12 horas'),
       (15, 1, 10, 'Tomar 1 tableta cada 8 horas por 3 días');
