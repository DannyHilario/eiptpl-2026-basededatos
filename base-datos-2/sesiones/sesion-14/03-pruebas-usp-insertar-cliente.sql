-- Tema:        Sesión 14 - Manejo de excepciones en procedimientos almacenados
-- Descripción: Casos de prueba de usp_insertarCliente. Se ejecuta completo DOS veces:
--              antes y después del ALTER (04-alter-usp-insertar-cliente.sql)
-- Autor:       Daniel Hilario

-- Limpieza: quita lo que dejó una ejecución anterior, para poder repetir las pruebas

DELETE FROM Cliente
WHERE Correo IN ('jorge.salas@gmail.com', 'pedro.luna@gmail.com', 'laura.mata@gmail.com',
				 'rosa.vega@gmail.com', 'ivan.mora@gmail.com')

-- Caso 1: camino feliz
-- Esperado: 000000

EXEC usp_insertarCliente 'Jorge', 'Salas', 'Ibarra', 'M', '8199990001',
						 'jorge.salas@gmail.com'

-- Caso 2: validación (sexo inválido)
-- Esperado: 000001

EXEC usp_insertarCliente 'Rosa', 'Vega', 'Leal', 'X', '8199990002',
						 'rosa.vega@gmail.com'

-- Caso 3: validación (el correo ya es de Carlos García)
-- Esperado: 000002

EXEC usp_insertarCliente 'Iván', 'Mora', 'Cruz', 'M', '8199990003',
						 'carlos.garcia@gmail.com'

-- Caso 4: EXCEPCIÓN. Sí hay una validación del sexo, pero NULL NOT IN ('M', 'F')
-- no es verdadero: el IF no entra y el NULL llega al INSERT (Sexo es NOT NULL)
-- Antes del ALTER: Msg 515 en rojo... y aun así responde 000000
-- Después del ALTER: 999999

EXEC usp_insertarCliente 'Rosa', 'Vega', 'Leal', NULL, '8199990002',
						 'rosa.vega@gmail.com'

-- Caso 5: EXCEPCIÓN. Nadie valida el primer apellido (PrimerApellido es NOT NULL)
-- Antes del ALTER: Msg 515 en rojo... y aun así responde 000000
-- Después del ALTER: 999999

EXEC usp_insertarCliente 'Iván', NULL, 'Cruz', 'M', '8199990003',
						 'ivan.mora@gmail.com'

-- Caso 6: cliente sin teléfono. Es el primero: entra bien
-- Esperado: 000000

EXEC usp_insertarCliente 'Pedro', 'Luna', 'Ríos', 'M', NULL,
						 'pedro.luna@gmail.com'

-- Caso 7: EXCEPCIÓN. Otro cliente sin teléfono. Telefono es UNIQUE y un UNIQUE
-- solo admite UN NULL. La validación del teléfono se salta los NULL a propósito
-- Antes del ALTER: Msg 2627 en rojo... y aun así responde 000000
-- Después del ALTER: 999999

EXEC usp_insertarCliente 'Laura', 'Mata', 'Solís', 'F', NULL,
						 'laura.mata@gmail.com'

-- Verificación: de los 7 casos solo entraron Jorge y Pedro

SELECT idCliente, Nombre, PrimerApellido, Telefono, Correo
FROM Cliente
WHERE Correo IN ('jorge.salas@gmail.com', 'pedro.luna@gmail.com', 'laura.mata@gmail.com',
				 'rosa.vega@gmail.com', 'ivan.mora@gmail.com')
