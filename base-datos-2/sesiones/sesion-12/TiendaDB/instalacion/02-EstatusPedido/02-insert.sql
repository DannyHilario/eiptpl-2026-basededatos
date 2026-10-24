-- Tema:        TiendaDB - Sesión 12 (Triggers)
-- Descripción: Insertar los 4 estatus de un pedido (id explícito: las reglas de negocio dependen de él)
-- Autor:       Daniel Hilario

USE TiendaDB;

INSERT INTO EstatusPedido (idEstatusPedido, Nombre)
VALUES (1, 'Creado'),
       (2, 'Enviado'),
       (3, 'Cancelado'),
       (4, 'Entregado');
