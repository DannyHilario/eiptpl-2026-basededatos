-- Tema:        AutoFixDB - Sesión 11 (Triggers)
-- Descripción: Crear tabla AuditoriaOperacionCliente: un renglón por cada cliente insertado, modificado o eliminado.
--              idCliente no lleva FOREIGN KEY a propósito: el historial de un cliente eliminado debe conservarse
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE AuditoriaOperacionCliente (
    idAuditoriaOperacionCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    TipoOperacion CHAR(1) NOT NULL,
    FechaOperacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_AuditoriaOperacionCliente_TipoOperacion CHECK (TipoOperacion IN ('I', 'U', 'D'))
);
