-- Tema:        Sesión 14 - Manejo de excepciones en procedimientos almacenados
-- Descripción: Casos de prueba de usp_insertarCategoria. Se ejecuta completo DOS veces:
--              antes y después del ALTER (02-alter-usp-insertar-categoria.sql)
-- Autor:       Daniel Hilario

-- Limpieza: quita lo que dejó una ejecución anterior, para poder repetir las pruebas

DELETE FROM Categoria
WHERE Nombre = 'Gaming'

-- Caso 1: camino feliz
-- Esperado: 000000

EXEC usp_insertarCategoria 'Gaming'

-- Caso 2: validación (la categoría ya existe)
-- Esperado: 000001

EXEC usp_insertarCategoria 'Laptops'

-- Caso 3: EXCEPCIÓN. Nadie valida que el nombre venga vacío (NULL),
-- pero la columna Nombre es NOT NULL
-- Antes del ALTER: Msg 515 en rojo... y aun así responde 000000
-- Después del ALTER: 999999 con el mensaje del error, sin rojo

EXEC usp_insertarCategoria NULL

-- Verificación: solo 'Gaming' se agregó a las 11 categorías originales

SELECT idCategoria, Nombre, Activo
FROM Categoria
ORDER BY idCategoria
