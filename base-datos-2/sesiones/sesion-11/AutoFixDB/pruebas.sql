-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Pruebas de los triggers y del procedimiento usp_insertarCliente.
--              Ejecutar una sección a la vez (seleccionarla y F5), sobre una instalación limpia,
--              y revisar la pestaña "Mensajes" y la auditoría después de cada una
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Prueba 1: la auditoría empieza vacía.
-- Los 215 clientes de la instalación se insertaron ANTES de crear los triggers
SELECT idAuditoriaOperacionCliente, idCliente, TipoOperacion, FechaOperacion
FROM AuditoriaOperacionCliente;
-- Esperado: 0 filas

-- Prueba 2: INSERT de un cliente.
-- Mensajes: "Registros correctamente insertados: 1"
-- Auditoría: 1 renglón I con idCliente = 216
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
VALUES ('Medina', 'Rocha', 'Arturo', '8100000216', 'arturo.medina@gmail.com');

SELECT idAuditoriaOperacionCliente, idCliente, TipoOperacion, FechaOperacion
FROM AuditoriaOperacionCliente;

-- Prueba 3: INSERT de 3 clientes en UNA sola sentencia.
-- El trigger se dispara UNA vez: Mensajes muestra "Registros correctamente insertados: 3"
-- Auditoría: 3 renglones I (217, 218 y 219), uno por cliente
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
VALUES ('Salazar', 'Cruz', 'Brenda', '8100000217', 'brenda.salazar@hotmail.com'),
       ('Rangel', 'Mata', 'Óscar', '8100000218', 'oscar.rangel@outlook.com'),
       ('Peña', 'Lara', 'Itzel', '8100000219', 'itzel.pena@yahoo.com.mx');

SELECT idAuditoriaOperacionCliente, idCliente, TipoOperacion, FechaOperacion
FROM AuditoriaOperacionCliente;

-- Prueba 4: alta con el procedimiento almacenado.
-- El INSERT dentro del SP dispara los mismos triggers: Mensajes "Registros correctamente insertados: 1",
-- resultado ErrCodigo 000000 y un renglón I con idCliente = 220
EXEC usp_insertarCliente 'Martínez', 'Garza', 'Valeria', '8100000220', 'valeria.martinez@gmail.com';

-- Prueba 5: el SP rechaza un correo repetido (000001) y un teléfono repetido (000002).
-- No hay INSERT, así que los triggers no se disparan y la auditoría no cambia
EXEC usp_insertarCliente 'Martínez', 'Garza', 'Valeria', '8100000221', 'valeria.martinez@gmail.com';
EXEC usp_insertarCliente 'Martínez', 'Garza', 'Valeria', '8100000220', 'otro.correo@gmail.com';

-- Prueba 6: UPDATE. inserted trae los valores nuevos y deleted los anteriores.
-- Auditoría: 1 renglón U con idCliente = 211
UPDATE Cliente
SET PrimerApellido = 'Ochoa', SegundoApellido = 'Galván'
WHERE idCliente = 211;

SELECT idAuditoriaOperacionCliente, idCliente, TipoOperacion, FechaOperacion
FROM AuditoriaOperacionCliente;

-- Prueba 7: DELETE. Solo deleted trae filas.
-- Auditoría: 2 renglones D (219 y 220). El historial de esos clientes se conserva
DELETE FROM Cliente
WHERE idCliente >= 219;

SELECT idAuditoriaOperacionCliente, idCliente, TipoOperacion, FechaOperacion
FROM AuditoriaOperacionCliente;

-- Prueba 8: una sentencia que no afecta ninguna fila TAMBIÉN dispara el trigger,
-- pero inserted y deleted llegan vacíos y el trigger sale con RETURN: la auditoría no cambia
DELETE FROM Cliente
WHERE idCliente = 9999;

SELECT idAuditoriaOperacionCliente, idCliente, TipoOperacion, FechaOperacion
FROM AuditoriaOperacionCliente;

-- Prueba 9: desactivar un trigger. Con el trigger de mensaje desactivado,
-- el INSERT ya no imprime nada, pero el de auditoría sigue activo y registra la I de 221
DISABLE TRIGGER trg_mensajeInsertarCliente ON Cliente;

INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
VALUES ('Quintero', 'Solís', 'Mauro', '8100000222', 'mauro.quintero@gmail.com');

SELECT name, is_disabled
FROM sys.triggers;
-- Esperado: trg_mensajeInsertarCliente con is_disabled = 1

-- Prueba 10: volver a activarlo
ENABLE TRIGGER trg_mensajeInsertarCliente ON Cliente;

SELECT name, is_disabled
FROM sys.triggers;
-- Esperado: los dos triggers con is_disabled = 0

-- Prueba 11: desactivar y activar TODOS los triggers de la tabla
ALTER TABLE Cliente DISABLE TRIGGER ALL;
ALTER TABLE Cliente ENABLE TRIGGER ALL;
