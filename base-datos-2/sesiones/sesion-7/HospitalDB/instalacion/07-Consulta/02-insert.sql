-- Tema:        HospitalDB - Sesión 7
-- Descripción: Insertar 17 consultas (15 efectuadas, una por paciente, más 2 sin efectuar)
-- Autor:       Daniel Hilario

USE HospitalDB;

-- Las primeras 15 ya se efectuaron y cada una generó su receta (ver 08-Receta/02-insert.sql).
-- Las 2 últimas ilustran el flujo de "consulta agendada, pendiente de efectuarse":
-- la 16 ya pasó su fecha y nunca se efectuó (no se presentó el paciente); la 17 todavía no llega su fecha.
-- Ninguna de las dos tiene receta — se generaría con usp_generarReceta una vez efectuada con usp_efectuarConsulta.

INSERT INTO Consulta (idPaciente, idMedico, idConsultorio, Fecha, Efectuada)
VALUES (1, 1, 1, '2026-09-01T09:00:00', 1),
       (2, 2, 2, '2026-09-01T10:00:00', 1),
       (3, 3, 3, '2026-09-02T09:00:00', 1),
       (4, 4, 4, '2026-09-02T11:00:00', 1),
       (5, 5, 5, '2026-09-03T09:00:00', 1),
       (6, 6, 6, '2026-09-03T12:00:00', 1),
       (7, 7, 7, '2026-09-04T09:00:00', 1),
       (8, 8, 8, '2026-09-04T13:00:00', 1),
       (9, 9, 9, '2026-09-05T09:00:00', 1),
       (10, 10, 10, '2026-09-05T10:30:00', 1),
       (11, 1, 1, '2026-09-08T09:00:00', 1),
       (12, 2, 2, '2026-09-08T11:00:00', 1),
       (13, 3, 3, '2026-09-09T09:00:00', 1),
       (14, 4, 4, '2026-09-09T12:00:00', 1),
       (15, 5, 5, '2026-09-10T09:00:00', 1),
       (1, 6, 6, '2026-09-11T09:00:00', 0),
       (2, 7, 7, '2026-10-01T09:00:00', 0);
