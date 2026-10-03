-- Tema:        Reversa Sesión 7
-- Descripción: Eliminar la base de datos CursoDB por completo
-- Autor:       Daniel Hilario

-- IMPORTANTE: Antes de ejecutar este script, selecciona otra base de datos
--             en el dropdown de SSMS (por ejemplo: master).
--             No puedes eliminar una base de datos a la que estás conectado.

DROP DATABASE IF EXISTS CursoDB;
