-- Tema:        Ejercicio 2 - Etapa 4 (AutoFixDB)
-- Descripción: Instalación completa (base de datos, tablas y datos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando los scripts de instalacion/ en orden alfabético ('find instalacion -name "*.sql" | sort'),
-- que es el mismo orden de la tabla del README y respeta las llaves foráneas.
-- Requiere ejecutarse completo en SSMS (F5): se separa cada script con GO para que ninguno interfiera
-- con el batch del anterior.

-- ============================================================
-- instalacion/01-create-database.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear base de datos AutoFixDB
-- Autor:       Daniel Hilario

CREATE DATABASE AutoFixDB;

GO

-- ============================================================
-- instalacion/02-create-table-cliente.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Correo VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

GO

-- ============================================================
-- instalacion/03-create-table-tiposervicio.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla TipoServicio
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE TipoServicio (
    idTipoServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    Costo DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

GO

-- ============================================================
-- instalacion/04-create-table-vehiculo.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla Vehiculo
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE Vehiculo (
    idVehiculo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Anio INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Vehiculo_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

GO

-- ============================================================
-- instalacion/05-create-table-servicio.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Crear tabla Servicio
-- Autor:       Daniel Hilario

USE AutoFixDB;

CREATE TABLE Servicio (
    idServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idVehiculo INT NOT NULL,
    idTipoServicio INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    CostoServicio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Servicio_Vehiculo FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo),
    CONSTRAINT fk_Servicio_TipoServicio FOREIGN KEY (idTipoServicio) REFERENCES TipoServicio(idTipoServicio)
);

GO

-- ============================================================
-- instalacion/06-insert-cliente.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar 200 clientes (exportados de Alumno - Sesión 9)
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Clientes 1-25 (origen: Técnica 1 - Sistemas Computacionales)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('García', 'López', 'Carlos', '8100000001', 'carlos.garcia@gmail.com',
        1),
       ('Hernández', 'Ramírez', 'Ana', '8100000002', 'ana.hernandez@hotmail.com',
        1),
       ('Rodríguez', 'Silva', 'Miguel', '8100000003', 'miguel.rodriguez@outlook.com',
        1),
       ('Torres', 'Gutiérrez', 'Valeria', '8100000004', 'valeria.torres@yahoo.com.mx',
        1),
       ('Pérez', 'Morales', 'Luis', '8100000005', 'luis.perez@gmail.com',
        1),
       ('Sánchez', 'Vega', 'Sofía', '8100000006', 'sofia.sanchez@hotmail.com',
        1),
       ('Ramírez', 'Cruz', 'Alejandro', '8100000007', 'alejandro.ramirez@outlook.com',
        1),
       ('Jiménez', 'Flores', 'Daniela', '8100000008', 'daniela.jimenez@yahoo.com.mx',
        1),
       ('Gómez', 'Reyes', 'Ricardo', '8100000009', 'ricardo.gomez@gmail.com',
        1),
       ('Delgado', 'Ortiz', 'Mariana', '8100000010', 'mariana.delgado@hotmail.com',
        1),
       ('Castro', 'Ibarra', 'Sergio', '8100000011', 'sergio.castro@outlook.com',
        1),
       ('Morales', 'Sandoval', 'Fernanda', '8100000012', 'fernanda.morales@yahoo.com.mx',
        1),
       ('Vargas', 'Lozano', 'Eduardo', '8100000013', 'eduardo.vargas@gmail.com',
        1),
       ('Fuentes', 'Cervantes', 'Adriana', '8100000014', 'adriana.fuentes@hotmail.com',
        1),
       ('Aguilar', 'Mendoza', 'Daniel', '8100000015', 'daniel.aguilar@outlook.com',
        1),
       ('Salinas', 'Herrera', 'Carolina', '8100000016', 'carolina.salinas@yahoo.com.mx',
        1),
       ('Medina', 'Castillo', 'Pablo', '8100000017', 'pablo.medina@gmail.com',
        1),
       ('Lozano', 'Guerrero', 'Elena', '8100000018', 'elena.lozano@hotmail.com',
        1),
       ('Núñez', 'Ramos', 'Francisco', '8100000019', 'francisco.nunez@outlook.com',
        1),
       ('Reyes', 'Díaz', 'Victoria', '8100000020', 'victoria.reyes@yahoo.com.mx',
        1),
       ('Ortiz', 'Peña', 'Gabriel', '8100000021', 'gabriel.ortiz@gmail.com',
        1),
       ('Cruz', 'Navarro', 'Monserrat', '8100000022', 'monserrat.cruz@hotmail.com',
        1),
       ('Flores', 'Ibáñez', 'Héctor', '8100000023', 'hector.flores@outlook.com',
        1),
       ('Rivera', 'Moreno', 'Patricia', '8100000024', 'patricia.rivera@yahoo.com.mx',
        1),
       ('Silva', 'Espinoza', 'Roberto', '8100000025', 'roberto.silva@gmail.com',
        1);

-- Clientes 26-50 (origen: Técnica 2 - Diseño de Imagen)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('Gutiérrez', 'Peña', 'Andrea', '8100000026', 'andrea.gutierrez@hotmail.com',
        1),
       ('Mendoza', 'Torres', 'Iván', '8100000027', 'ivan.mendoza@outlook.com',
        1),
       ('Herrera', 'Soto', 'Camila', '8100000028', 'camila.herrera@yahoo.com.mx',
        1),
       ('Vega', 'Ramírez', 'Carlos', '8100000029', 'carlos.vega@gmail.com',
        1),
       ('Navarro', 'Flores', 'Lucía', '8100000030', 'lucia.navarro@hotmail.com',
        1),
       ('Castillo', 'García', 'Tomás', '8100000031', 'tomas.castillo@outlook.com',
        1),
       ('Espinoza', 'Jiménez', 'Renata', '8100000032', 'renata.espinoza@yahoo.com.mx',
        1),
       ('Moreno', 'Cruz', 'Rodrigo', '8100000033', 'rodrigo.moreno@gmail.com',
        1),
       ('Ibarra', 'Martínez', 'Paulina', '8100000034', 'paulina.ibarra@hotmail.com',
        1),
       ('Peña', 'González', 'Oscar', '8100000035', 'oscar.pena@outlook.com',
        1),
       ('Soto', 'Rodríguez', 'Alicia', '8100000036', 'alicia.soto@yahoo.com.mx',
        1),
       ('Cervantes', 'Hernández', 'Marco', '8100000037', 'marco.cervantes@gmail.com',
        1),
       ('Sandoval', 'Delgado', 'Isabella', '8100000038', 'isabella.sandoval@hotmail.com',
        1),
       ('Guerrero', 'Castro', 'Emilio', '8100000039', 'emilio.guerrero@outlook.com',
        1),
       ('Lozano', 'Vargas', 'Sandra', '8100000040', 'sandra.lozano@yahoo.com.mx',
        1),
       ('Ramos', 'Aguilar', 'Javier', '8100000041', 'javier.ramos@gmail.com',
        1),
       ('Díaz', 'Salinas', 'Verónica', '8100000042', 'veronica.diaz@hotmail.com',
        1),
       ('Ibáñez', 'Medina', 'Ángel', '8100000043', 'angel.ibanez@outlook.com',
        1),
       ('Peña', 'Reyes', 'Karla', '8100000044', 'karla.pena@yahoo.com.mx',
        1),
       ('Gómez', 'Lozano', 'Arturo', '8100000045', 'arturo.gomez@gmail.com',
        1),
       ('Fuentes', 'Núñez', 'Stephanie', '8100000046', 'stephanie.fuentes@hotmail.com',
        1),
       ('Torres', 'Ortiz', 'Jonathan', '8100000047', 'jonathan.torres@outlook.com',
        1),
       ('Aguilar', 'Cervantes', 'Natalia', '8100000048', 'natalia.aguilar@yahoo.com.mx',
        1),
       ('García', 'Guerrero', 'Jesús', '8100000049', 'jesus.garcia@gmail.com',
        1),
       ('Hernández', 'Espinoza', 'Mónica', '8100000050', 'monica.hernandez@hotmail.com',
        1);

-- Clientes 51-75 (origen: Técnica 3 - Actividad Física y Deporte)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('López', 'García', 'Andrés', '8100000051', 'andres.lopez@outlook.com',
        1),
       ('Martínez', 'Flores', 'Diana', '8100000052', 'diana.martinez@yahoo.com.mx',
        1),
       ('González', 'Torres', 'Kevin', '8100000053', 'kevin.gonzalez@gmail.com',
        1),
       ('Ramírez', 'Pérez', 'Fernanda', '8100000054', 'fernanda.ramirez@hotmail.com',
        1),
       ('Rodríguez', 'Sánchez', 'Eduardo', '8100000055', 'eduardo.rodriguez@outlook.com',
        1),
       ('Cruz', 'Jiménez', 'Alejandra', '8100000056', 'alejandra.cruz@yahoo.com.mx',
        1),
       ('Flores', 'Gómez', 'Bryan', '8100000057', 'bryan.flores@gmail.com',
        1),
       ('Reyes', 'Vargas', 'Estefanía', '8100000058', 'estefania.reyes@hotmail.com',
        1),
       ('Sánchez', 'Delgado', 'Cristian', '8100000059', 'cristian.sanchez@outlook.com',
        1),
       ('Jiménez', 'Castro', 'Ximena', '8100000060', 'ximena.jimenez@yahoo.com.mx',
        1),
       ('Vega', 'Morales', 'Sebastián', '8100000061', 'sebastian.vega@gmail.com',
        1),
       ('Morales', 'Ramos', 'Lizeth', '8100000062', 'lizeth.morales@hotmail.com',
        1),
       ('Delgado', 'Fuentes', 'Gerardo', '8100000063', 'gerardo.delgado@outlook.com',
        1),
       ('Castro', 'Aguilar', 'Pamela', '8100000064', 'pamela.castro@yahoo.com.mx',
        1),
       ('Gutiérrez', 'Salinas', 'Alan', '8100000065', 'alan.gutierrez@gmail.com',
        1),
       ('Torres', 'Medina', 'Brenda', '8100000066', 'brenda.torres@hotmail.com',
        1),
       ('Silva', 'Lozano', 'Óscar', '8100000067', 'oscar.silva@outlook.com',
        1),
       ('Peña', 'Guerrero', 'Yesenia', '8100000068', 'yesenia.pena@yahoo.com.mx',
        1),
       ('Navarro', 'Ibarra', 'Ricardo', '8100000069', 'ricardo.navarro@gmail.com',
        1),
       ('Herrera', 'Espinoza', 'Samantha', '8100000070', 'samantha.herrera@hotmail.com',
        1),
       ('Ibarra', 'Soto', 'Emmanuel', '8100000071', 'emmanuel.ibarra@outlook.com',
        1),
       ('Castillo', 'Cervantes', 'Paola', '8100000072', 'paola.castillo@yahoo.com.mx',
        1),
       ('Espinoza', 'Sandoval', 'Hugo', '8100000073', 'hugo.espinoza@gmail.com',
        1),
       ('Moreno', 'Mendoza', 'Itzel', '8100000074', 'itzel.moreno@hotmail.com',
        1),
       ('Sandoval', 'Herrera', 'Alexis', '8100000075', 'alexis.sandoval@outlook.com',
        1);

-- Clientes 76-100 (origen: Técnica 4 - Artes)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('Aguilar', 'Reyes', 'Vanessa', '8100000076', 'vanessa.aguilar@yahoo.com.mx',
        1),
       ('Salinas', 'Díaz', 'Arturo', '8100000077', 'arturo.salinas@gmail.com',
        1),
       ('Medina', 'García', 'Guadalupe', '8100000078', 'guadalupe.medina@hotmail.com',
        1),
       ('Lozano', 'Martínez', 'Rubén', '8100000079', 'ruben.lozano@outlook.com',
        1),
       ('Fuentes', 'González', 'Sofía', '8100000080', 'sofia.fuentes@yahoo.com.mx',
        1),
       ('Núñez', 'Rodríguez', 'Miguel', '8100000081', 'miguel.nunez@gmail.com',
        1),
       ('Reyes', 'Ramírez', 'Fernanda', '8100000082', 'fernanda.reyes@hotmail.com',
        1),
       ('Ortiz', 'Cruz', 'Jonathan', '8100000083', 'jonathan.ortiz@outlook.com',
        1),
       ('Cruz', 'Flores', 'Priscila', '8100000084', 'priscila.cruz@yahoo.com.mx',
        1),
       ('Flores', 'Reyes', 'Daniel', '8100000085', 'daniel.flores@gmail.com',
        1),
       ('Rivera', 'Sánchez', 'Karina', '8100000086', 'karina.rivera@hotmail.com',
        1),
       ('Gómez', 'Torres', 'Alejandro', '8100000087', 'alejandro.gomez@outlook.com',
        1),
       ('Vargas', 'Jiménez', 'Valeria', '8100000088', 'valeria.vargas@yahoo.com.mx',
        1),
       ('Fuentes', 'Gómez', 'Héctor', '8100000089', 'hector.fuentes@gmail.com',
        1),
       ('Delgado', 'Vargas', 'Nadia', '8100000090', 'nadia.delgado@hotmail.com',
        1),
       ('Castro', 'Delgado', 'Iván', '8100000091', 'ivan.castro@outlook.com',
        1),
       ('Morales', 'Castro', 'Cristina', '8100000092', 'cristina.morales@yahoo.com.mx',
        1),
       ('Ramos', 'Morales', 'Kevin', '8100000093', 'kevin.ramos@gmail.com',
        1),
       ('Díaz', 'Ramos', 'Brenda', '8100000094', 'brenda.diaz@hotmail.com',
        1),
       ('Ibáñez', 'Fuentes', 'Pablo', '8100000095', 'pablo.ibanez@outlook.com',
        1),
       ('Gutiérrez', 'Medina', 'Liliana', '8100000096', 'liliana.gutierrez@yahoo.com.mx',
        1),
       ('Torres', 'Aguilar', 'Emilio', '8100000097', 'emilio.torres@gmail.com',
        1),
       ('García', 'Salinas', 'Maricruz', '8100000098', 'maricruz.garcia@hotmail.com',
        1),
       ('Hernández', 'Lozano', 'Axel', '8100000099', 'axel.hernandez@outlook.com',
        1),
       ('Rodríguez', 'Núñez', 'Esmeralda', '8100000100', 'esmeralda.rodriguez@yahoo.com.mx',
        1);

-- Clientes 101-125 (origen: Técnica 5 - Gastronomía Integral)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('Sánchez', 'Fuentes', 'Erick', '8100000101', 'erick.sanchez@gmail.com',
        1),
       ('Jiménez', 'Reyes', 'Angélica', '8100000102', 'angelica.jimenez@hotmail.com',
        1),
       ('Gómez', 'Herrera', 'Miguel', '8100000103', 'miguel.gomez@outlook.com',
        1),
       ('Delgado', 'Cruz', 'Jimena', '8100000104', 'jimena.delgado@yahoo.com.mx',
        1),
       ('Castro', 'Flores', 'Roberto', '8100000105', 'roberto.castro@gmail.com',
        1),
       ('Morales', 'Torres', 'Gabriela', '8100000106', 'gabriela.morales@hotmail.com',
        1),
       ('Vargas', 'Sánchez', 'Luis', '8100000107', 'luis.vargas@outlook.com',
        1),
       ('Fuentes', 'Jiménez', 'Karla', '8100000108', 'karla.fuentes@yahoo.com.mx',
        1),
       ('Aguilar', 'Vega', 'Diego', '8100000109', 'diego.aguilar@gmail.com',
        1),
       ('Salinas', 'Morales', 'Stephanie', '8100000110', 'stephanie.salinas@hotmail.com',
        1),
       ('Medina', 'Delgado', 'Jorge', '8100000111', 'jorge.medina@outlook.com',
        1),
       ('Lozano', 'Castro', 'Estefanía', '8100000112', 'estefania.lozano@yahoo.com.mx',
        1),
       ('Núñez', 'Moreno', 'Sergio', '8100000113', 'sergio.nunez@gmail.com',
        1),
       ('Reyes', 'Navarro', 'Daniela', '8100000114', 'daniela.reyes@hotmail.com',
        1),
       ('Ortiz', 'Espinoza', 'Marco', '8100000115', 'marco.ortiz@outlook.com',
        1),
       ('Cruz', 'Sandoval', 'Adriana', '8100000116', 'adriana.cruz@yahoo.com.mx',
        1),
       ('Flores', 'Ibarra', 'Tomás', '8100000117', 'tomas.flores@gmail.com',
        1),
       ('Rivera', 'Guerrero', 'Paulina', '8100000118', 'paulina.rivera@hotmail.com',
        1),
       ('Gómez', 'Peña', 'Alejandro', '8100000119', 'alejandro.gomez2@outlook.com',
        1),
       ('Hernández', 'Mendoza', 'Lorena', '8100000120', 'lorena.hernandez@yahoo.com.mx',
        1),
       ('Rodríguez', 'Cervantes', 'Hugo', '8100000121', 'hugo.rodriguez@gmail.com',
        1),
       ('Torres', 'Galván', 'Sandra', '8100000122', 'sandra.torres@hotmail.com',
        1),
       ('García', 'Romero', 'Arturo', '8100000123', 'arturo.garcia@outlook.com',
        1),
       ('López', 'Castillo', 'Vanessa', '8100000124', 'vanessa.lopez@yahoo.com.mx',
        1),
       ('Martínez', 'Ibáñez', 'Eduardo', '8100000125', 'eduardo.martinez@gmail.com',
        1);

-- Clientes 126-150 (origen: Técnica 6 - Diseño y Comunicación Visual)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('González', 'Ramírez', 'Paola', '8100000126', 'paola.gonzalez@hotmail.com',
        1),
       ('Ramírez', 'López', 'Alan', '8100000127', 'alan.ramirez@outlook.com',
        1),
       ('Rodríguez', 'García', 'Valeria', '8100000128', 'valeria.rodriguez@yahoo.com.mx',
        1),
       ('Hernández', 'Martínez', 'Carlos', '8100000129', 'carlos.hernandez@gmail.com',
        1),
       ('García', 'González', 'Camila', '8100000130', 'camila.garcia@hotmail.com',
        1),
       ('Torres', 'Rodríguez', 'Sergio', '8100000131', 'sergio.torres@outlook.com',
        1),
       ('Pérez', 'Hernández', 'Andrea', '8100000132', 'andrea.perez@yahoo.com.mx',
        1),
       ('Sánchez', 'Torres', 'Emilio', '8100000133', 'emilio.sanchez@gmail.com',
        1),
       ('Jiménez', 'Pérez', 'Natalia', '8100000134', 'natalia.jimenez@hotmail.com',
        1),
       ('Vega', 'Sánchez', 'Rodrigo', '8100000135', 'rodrigo.vega@outlook.com',
        1),
       ('Morales', 'Vega', 'Isabella', '8100000136', 'isabella.morales@yahoo.com.mx',
        1),
       ('Delgado', 'Morales', 'Daniel', '8100000137', 'daniel.delgado@gmail.com',
        1),
       ('Castro', 'Jiménez', 'Mariana', '8100000138', 'mariana.castro@hotmail.com',
        1),
       ('Gutiérrez', 'Reyes', 'Pablo', '8100000139', 'pablo.gutierrez@outlook.com',
        1),
       ('Torres', 'Cruz', 'Estefanía', '8100000140', 'estefania.torres@yahoo.com.mx',
        1),
       ('Flores', 'Delgado', 'Miguel', '8100000141', 'miguel.flores@gmail.com',
        1),
       ('Rivera', 'Castro', 'Alejandra', '8100000142', 'alejandra.rivera@hotmail.com',
        1),
       ('Gómez', 'Gutiérrez', 'Oscar', '8100000143', 'oscar.gomez@outlook.com',
        1),
       ('Vargas', 'Aguilar', 'Camila', '8100000144', 'camila.vargas@yahoo.com.mx',
        1),
       ('Fuentes', 'Salinas', 'Ricardo', '8100000145', 'ricardo.fuentes@gmail.com',
        1),
       ('Aguilar', 'Medina', 'Lucía', '8100000146', 'lucia.aguilar@hotmail.com',
        1),
       ('Salinas', 'Lozano', 'Fernando', '8100000147', 'fernando.salinas@outlook.com',
        1),
       ('Medina', 'Fuentes', 'Brenda', '8100000148', 'brenda.medina@yahoo.com.mx',
        1),
       ('Lozano', 'Núñez', 'Luis', '8100000149', 'luis.lozano@gmail.com',
        1),
       ('Núñez', 'Ortiz', 'Vanessa', '8100000150', 'vanessa.nunez@hotmail.com',
        1);

-- Clientes 151-175 (origen: Técnica 7 - Diseño de Modas)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('Reyes', 'Silva', 'Gabriela', '8100000151', 'gabriela.reyes@outlook.com',
        1),
       ('Ortiz', 'Rivera', 'Jonathan', '8100000152', 'jonathan.ortiz2@yahoo.com.mx',
        1),
       ('Cruz', 'Gómez', 'Pamela', '8100000153', 'pamela.cruz@gmail.com',
        1),
       ('Flores', 'Vargas', 'Sergio', '8100000154', 'sergio.flores@hotmail.com',
        1),
       ('Rivera', 'Fuentes', 'Daniela', '8100000155', 'daniela.rivera@outlook.com',
        1),
       ('Gómez', 'Aguilar', 'Tomás', '8100000156', 'tomas.gomez@yahoo.com.mx',
        1),
       ('Vargas', 'Salinas', 'Karla', '8100000157', 'karla.vargas@gmail.com',
        1),
       ('Delgado', 'Medina', 'Bryan', '8100000158', 'bryan.delgado@hotmail.com',
        1),
       ('Castro', 'Lozano', 'Monserrat', '8100000159', 'monserrat.castro@outlook.com',
        1),
       ('Morales', 'Núñez', 'Gerardo', '8100000160', 'gerardo.morales@yahoo.com.mx',
        1),
       ('Ramos', 'Reyes', 'Alicia', '8100000161', 'alicia.ramos@gmail.com',
        1),
       ('Díaz', 'Ortiz', 'Eduardo', '8100000162', 'eduardo.diaz@hotmail.com',
        1),
       ('Ibáñez', 'Cruz', 'Natalia', '8100000163', 'natalia.ibanez@outlook.com',
        1),
       ('Gutiérrez', 'Flores', 'Axel', '8100000164', 'axel.gutierrez@yahoo.com.mx',
        1),
       ('Torres', 'Hernández', 'Sofía', '8100000165', 'sofia.torres@gmail.com',
        1),
       ('Pérez', 'Rodríguez', 'Emilio', '8100000166', 'emilio.perez@hotmail.com',
        1),
       ('Sánchez', 'González', 'Victoria', '8100000167', 'victoria.sanchez@outlook.com',
        1),
       ('Jiménez', 'Martínez', 'Luis', '8100000168', 'luis.jimenez@yahoo.com.mx',
        1),
       ('Vega', 'Castillo', 'Patricia', '8100000169', 'patricia.vega@gmail.com',
        1),
       ('Morales', 'Espinoza', 'Hugo', '8100000170', 'hugo.morales@hotmail.com',
        1),
       ('Delgado', 'Sandoval', 'Cristina', '8100000171', 'cristina.delgado@outlook.com',
        1),
       ('Castro', 'Guerrero', 'Javier', '8100000172', 'javier.castro@yahoo.com.mx',
        1),
       ('Herrera', 'Mendoza', 'Renata', '8100000173', 'renata.herrera@gmail.com',
        1),
       ('Ibarra', 'Peña', 'Diego', '8100000174', 'diego.ibarra@hotmail.com',
        1),
       ('Espinoza', 'Ibarra', 'Adriana', '8100000175', 'adriana.espinoza@outlook.com',
        1);

-- Clientes 176-200 (origen: Técnica 8 - Fisioterapia y Readaptación)
-- Estos clientes NO tienen vehículo registrado (útil para LEFT/RIGHT JOIN)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo,
                     Activo)
VALUES ('Cervantes', 'García', 'Laura', '8100000176', 'laura.cervantes@yahoo.com.mx',
        1),
       ('Sandoval', 'Martínez', 'Javier', '8100000177', 'javier.sandoval@gmail.com',
        1),
       ('Guerrero', 'González', 'Vanessa', '8100000178', 'vanessa.guerrero@hotmail.com',
        1),
       ('Ibáñez', 'Rodríguez', 'Carlos', '8100000179', 'carlos.ibanez@outlook.com',
        1),
       ('Espinoza', 'Hernández', 'Paola', '8100000180', 'paola.espinoza@yahoo.com.mx',
        1),
       ('Moreno', 'Torres', 'Alexis', '8100000181', 'alexis.moreno@gmail.com',
        1),
       ('Navarro', 'Pérez', 'Estefanía', '8100000182', 'estefania.navarro@hotmail.com',
        1),
       ('Soto', 'Sánchez', 'Miguel', '8100000183', 'miguel.soto@outlook.com',
        1),
       ('Castillo', 'Jiménez', 'Yesenia', '8100000184', 'yesenia.castillo@yahoo.com.mx',
        1),
       ('Peña', 'Vega', 'Daniel', '8100000185', 'daniel.pena@gmail.com',
        1),
       ('Valdez', 'Cruz', 'Lorena', '8100000186', 'lorena.valdez@hotmail.com',
        1),
       ('Galván', 'Flores', 'Roberto', '8100000187', 'roberto.galvan@outlook.com',
        1),
       ('Téllez', 'Reyes', 'Adriana', '8100000188', 'adriana.tellez@yahoo.com.mx',
        1),
       ('Romero', 'Delgado', 'Kevin', '8100000189', 'kevin.romero@gmail.com',
        1),
       ('Reséndez', 'Castro', 'Itzel', '8100000190', 'itzel.resendez@hotmail.com',
        1),
       ('García', 'Lozano', 'Sebastián', '8100000191', 'sebastian.garcia@outlook.com',
        1),
       ('López', 'Morales', 'Brenda', '8100000192', 'brenda.lopez@yahoo.com.mx',
        1),
       ('Martínez', 'Ramos', 'Eduardo', '8100000193', 'eduardo.martinez2@gmail.com',
        1),
       ('González', 'Vargas', 'Pamela', '8100000194', 'pamela.gonzalez@hotmail.com',
        1),
       ('Ramírez', 'Fuentes', 'Alan', '8100000195', 'alan.ramirez2@outlook.com',
        1),
       ('Rodríguez', 'Aguilar', 'Cristina', '8100000196', 'cristina.rodriguez@yahoo.com.mx',
        1),
       ('Hernández', 'Salinas', 'Tomás', '8100000197', 'tomas.hernandez@gmail.com',
        1),
       ('García', 'Medina', 'Valeria', '8100000198', 'valeria.garcia@hotmail.com',
        1),
       ('Torres', 'Cervantes', 'Diego', '8100000199', 'diego.torres@outlook.com',
        1),
       ('Pérez', 'Sandoval', 'Monserrat', '8100000200', 'monserrat.perez@yahoo.com.mx',
        1);

GO

-- ============================================================
-- instalacion/07-insert-tiposervicio.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar catálogo de tipos de servicio
-- Autor:       Daniel Hilario

USE AutoFixDB;

INSERT INTO TipoServicio (Descripcion, Costo, Activo)
VALUES ('Afinación', 850.00, 1),
       ('Cambio de aceite', 450.00, 1),
       ('Revisión de frenos', 1200.00, 1),
       ('Suspensión', 2500.00, 1),
       ('Diagnóstico computarizado', 350.00, 1),
       ('Cambio de llantas', 3200.00, 1);

GO

-- ============================================================
-- instalacion/08-insert-vehiculo.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar 170 vehículos para clientes 1-155
--              Clientes 1-15 tienen 2 vehículos; clientes 16-155 tienen 1 vehículo
--              Clientes 156-200 NO tienen vehículo (útil para LEFT/RIGHT JOIN)
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Vehículos 1-30: clientes 1-15 con dos vehículos cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (1, 'Nissan', 'Versa', 2020, 1),
       (1, 'Chevrolet', 'Spark', 2018, 1),
       (2, 'Volkswagen', 'Vento', 2019, 1),
       (2, 'Toyota', 'Yaris', 2021, 1),
       (3, 'Ford', 'Figo', 2017, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (3, 'Kia', 'Rio', 2022, 1),
       (4, 'Hyundai', 'Accent', 2020, 1),
       (4, 'Nissan', 'March', 2016, 1),
       (5, 'Mazda', 'Mazda3', 2021, 1),
       (5, 'Honda', 'City', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (6, 'Seat', 'Ibiza', 2022, 1),
       (6, 'Chevrolet', 'Aveo', 2015, 1),
       (7, 'Volkswagen', 'Jetta', 2021, 1),
       (7, 'Toyota', 'Corolla', 2018, 1),
       (8, 'Nissan', 'Sentra', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (8, 'Ford', 'Escape', 2022, 1),
       (9, 'Kia', 'Sportage', 2019, 1),
       (9, 'Hyundai', 'Tucson', 2021, 1),
       (10, 'Mazda', 'CX-30', 2022, 1),
       (10, 'Honda', 'HR-V', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (11, 'Nissan', 'NP300', 2018, 1),
       (11, 'Chevrolet', 'S10', 2019, 1),
       (12, 'Toyota', 'Hilux', 2020, 1),
       (12, 'Volkswagen', 'Tiguan', 2021, 1),
       (13, 'Ford', 'F-150', 2017, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (13, 'Kia', 'Soul', 2022, 1),
       (14, 'Seat', 'Ateca', 2021, 1),
       (14, 'Honda', 'Civic', 2019, 1),
       (15, 'Hyundai', 'Creta', 2022, 1),
       (15, 'Mazda', 'CX-5', 2020, 1);

-- Vehículos 31-80: clientes 16-65 con un vehículo cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (16, 'Nissan', 'Versa', 2018, 1),
       (17, 'Volkswagen', 'Gol', 2017, 1),
       (18, 'Chevrolet', 'Spark', 2021, 1),
       (19, 'Toyota', 'Yaris', 2019, 1),
       (20, 'Ford', 'Figo', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (21, 'Kia', 'Picanto', 2018, 1),
       (22, 'Hyundai', 'Grand i10', 2021, 1),
       (23, 'Honda', 'City', 2020, 1),
       (24, 'Seat', 'Arona', 2022, 1),
       (25, 'Mazda', 'Mazda2', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (26, 'Nissan', 'March', 2020, 1),
       (27, 'Volkswagen', 'Vento', 2021, 1),
       (28, 'Chevrolet', 'Aveo', 2018, 1),
       (29, 'Toyota', 'Corolla', 2022, 1),
       (30, 'Ford', 'EcoSport', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (31, 'Kia', 'Rio', 2020, 1),
       (32, 'Hyundai', 'Accent', 2017, 1),
       (33, 'Honda', 'HR-V', 2021, 1),
       (34, 'Seat', 'Ibiza', 2020, 1),
       (35, 'Mazda', 'Mazda3', 2022, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (36, 'Nissan', 'Sentra', 2019, 1),
       (37, 'Volkswagen', 'Jetta', 2020, 1),
       (38, 'Chevrolet', 'Trax', 2021, 1),
       (39, 'Toyota', 'RAV4', 2022, 1),
       (40, 'Ford', 'Escape', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (41, 'Kia', 'Sportage', 2020, 1),
       (42, 'Hyundai', 'Tucson', 2018, 1),
       (43, 'Honda', 'CR-V', 2021, 1),
       (44, 'Seat', 'Ateca', 2019, 1),
       (45, 'Mazda', 'CX-30', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (46, 'Nissan', 'Versa', 2021, 1),
       (47, 'Volkswagen', 'Gol', 2018, 1),
       (48, 'Chevrolet', 'Spark', 2020, 1),
       (49, 'Toyota', 'Yaris', 2021, 1),
       (50, 'Ford', 'Figo', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (51, 'Kia', 'Picanto', 2022, 1),
       (52, 'Hyundai', 'Grand i10', 2020, 1),
       (53, 'Honda', 'City', 2018, 1),
       (54, 'Seat', 'Arona', 2021, 1),
       (55, 'Mazda', 'Mazda2', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (56, 'Nissan', 'March', 2019, 1),
       (57, 'Volkswagen', 'Vento', 2022, 1),
       (58, 'Chevrolet', 'Aveo', 2020, 1),
       (59, 'Toyota', 'Corolla', 2019, 1),
       (60, 'Ford', 'EcoSport', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (61, 'Kia', 'Rio', 2019, 1),
       (62, 'Hyundai', 'Accent', 2022, 1),
       (63, 'Honda', 'HR-V', 2019, 1),
       (64, 'Seat', 'Ibiza', 2021, 1),
       (65, 'Mazda', 'Mazda3', 2020, 1);

-- Vehículos 81-130: clientes 66-115 con un vehículo cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (66, 'Nissan', 'Sentra', 2021, 1),
       (67, 'Volkswagen', 'Jetta', 2019, 1),
       (68, 'Chevrolet', 'Trax', 2020, 1),
       (69, 'Toyota', 'RAV4', 2021, 1),
       (70, 'Ford', 'Escape', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (71, 'Kia', 'Sportage', 2021, 1),
       (72, 'Hyundai', 'Tucson', 2019, 1),
       (73, 'Honda', 'CR-V', 2020, 1),
       (74, 'Seat', 'Ateca', 2022, 1),
       (75, 'Mazda', 'CX-30', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (76, 'Nissan', 'Versa', 2022, 1),
       (77, 'Volkswagen', 'Gol', 2020, 1),
       (78, 'Chevrolet', 'Spark', 2019, 1),
       (79, 'Toyota', 'Yaris', 2022, 1),
       (80, 'Ford', 'Figo', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (81, 'Kia', 'Picanto', 2021, 1),
       (82, 'Hyundai', 'Grand i10', 2019, 1),
       (83, 'Honda', 'City', 2022, 1),
       (84, 'Seat', 'Arona', 2020, 1),
       (85, 'Mazda', 'Mazda2', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (86, 'Nissan', 'March', 2021, 1),
       (87, 'Volkswagen', 'Vento', 2020, 1),
       (88, 'Chevrolet', 'Aveo', 2022, 1),
       (89, 'Toyota', 'Corolla', 2020, 1),
       (90, 'Ford', 'EcoSport', 2022, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (91, 'Kia', 'Rio', 2021, 1),
       (92, 'Hyundai', 'Accent', 2020, 1),
       (93, 'Honda', 'HR-V', 2022, 1),
       (94, 'Seat', 'Ibiza', 2019, 1),
       (95, 'Mazda', 'Mazda3', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (96, 'Nissan', 'Sentra', 2022, 1),
       (97, 'Volkswagen', 'Jetta', 2022, 1),
       (98, 'Chevrolet', 'Trax', 2019, 1),
       (99, 'Toyota', 'RAV4', 2019, 1),
       (100, 'Ford', 'Escape', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (101, 'Kia', 'Sportage', 2022, 1),
       (102, 'Hyundai', 'Tucson', 2022, 1),
       (103, 'Honda', 'CR-V', 2019, 1),
       (104, 'Seat', 'Ateca', 2020, 1),
       (105, 'Mazda', 'CX-30', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (106, 'Nissan', 'Versa', 2019, 1),
       (107, 'Volkswagen', 'Gol', 2021, 1),
       (108, 'Chevrolet', 'Spark', 2022, 1),
       (109, 'Toyota', 'Yaris', 2020, 1),
       (110, 'Ford', 'Figo', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (111, 'Kia', 'Picanto', 2020, 1),
       (112, 'Hyundai', 'Grand i10', 2022, 1),
       (113, 'Honda', 'City', 2021, 1),
       (114, 'Seat', 'Arona', 2019, 1),
       (115, 'Mazda', 'Mazda2', 2022, 1);

-- Vehículos 131-170: clientes 116-155 con un vehículo cada uno
INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (116, 'Nissan', 'March', 2022, 1),
       (117, 'Volkswagen', 'Vento', 2019, 1),
       (118, 'Chevrolet', 'Aveo', 2021, 1),
       (119, 'Toyota', 'Corolla', 2021, 1),
       (120, 'Ford', 'EcoSport', 2020, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (121, 'Kia', 'Rio', 2022, 1),
       (122, 'Hyundai', 'Accent', 2019, 1),
       (123, 'Honda', 'HR-V', 2020, 1),
       (124, 'Seat', 'Ibiza', 2018, 1),
       (125, 'Mazda', 'Mazda3', 2019, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (126, 'Nissan', 'Sentra', 2018, 1),
       (127, 'Volkswagen', 'Jetta', 2018, 1),
       (128, 'Chevrolet', 'Trax', 2022, 1),
       (129, 'Toyota', 'RAV4', 2020, 1),
       (130, 'Ford', 'Escape', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (131, 'Kia', 'Sportage', 2018, 1),
       (132, 'Hyundai', 'Tucson', 2020, 1),
       (133, 'Honda', 'CR-V', 2022, 1),
       (134, 'Seat', 'Ateca', 2018, 1),
       (135, 'Mazda', 'CX-5', 2021, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (136, 'Nissan', 'Versa', 2017, 1),
       (137, 'Volkswagen', 'Gol', 2019, 1),
       (138, 'Chevrolet', 'Spark', 2018, 1),
       (139, 'Toyota', 'Yaris', 2018, 1),
       (140, 'Ford', 'Figo', 2022, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (141, 'Kia', 'Picanto', 2019, 1),
       (142, 'Hyundai', 'Grand i10', 2021, 1),
       (143, 'Honda', 'City', 2019, 1),
       (144, 'Seat', 'Arona', 2018, 1),
       (145, 'Mazda', 'Mazda2', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (146, 'Nissan', 'March', 2018, 1),
       (147, 'Volkswagen', 'Vento', 2018, 1),
       (148, 'Chevrolet', 'Aveo', 2019, 1),
       (149, 'Toyota', 'Corolla', 2017, 1),
       (150, 'Ford', 'EcoSport', 2018, 1);

INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio, Activo)
VALUES (151, 'Kia', 'Rio', 2018, 1),
       (152, 'Hyundai', 'Accent', 2021, 1),
       (153, 'Honda', 'HR-V', 2018, 1),
       (154, 'Seat', 'Ibiza', 2022, 1),
       (155, 'Mazda', 'Mazda3', 2017, 1);

GO

-- ============================================================
-- instalacion/09-insert-servicio.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Etapa 4
-- Descripción: Insertar 200 servicios distribuidos en vehículos 1-140
--              Vehículos 141-170 (y 61, 70, 94, 103, 127, 136) NO tienen órdenes (útil para LEFT/RIGHT JOIN)
--              Servicios: 1=Afinación, 2=Cambio de aceite, 3=Frenos,
--                         4=Suspensión, 5=Diagnóstico, 6=Cambio de llantas
-- Autor:       Daniel Hilario

USE AutoFixDB;

-- Órdenes 1-25
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (3, 2, '2026-01-05', 450.00),
       (15, 1, '2026-01-05', 850.00),
       (27, 5, '2026-01-06', 350.00),
       (8, 3, '2026-01-07', 1200.00),
       (42, 2, '2026-01-08', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (71, 6, '2026-01-09', 3200.00),
       (19, 4, '2026-01-10', 2500.00),
       (55, 1, '2026-01-12', 850.00),
       (88, 2, '2026-01-13', 450.00),
       (1, 5, '2026-01-14', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (33, 3, '2026-01-15', 1200.00),
       (64, 1, '2026-01-16', 850.00),
       (97, 2, '2026-01-17', 450.00),
       (120, 4, '2026-01-19', 2500.00),
       (7, 5, '2026-01-20', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (44, 6, '2026-01-21', 3200.00),
       (78, 1, '2026-01-22', 850.00),
       (110, 3, '2026-01-23', 1200.00),
       (22, 2, '2026-01-26', 450.00),
       (56, 5, '2026-01-27', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (89, 4, '2026-01-28', 2500.00),
       (130, 1, '2026-01-29', 850.00),
       (13, 2, '2026-01-30', 450.00),
       (47, 6, '2026-02-02', 3200.00),
       (81, 3, '2026-02-03', 1200.00);

-- Órdenes 26-50
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (114, 5, '2026-02-04', 350.00),
       (2, 1, '2026-02-05', 850.00),
       (36, 2, '2026-02-06', 450.00),
       (69, 4, '2026-02-09', 2500.00),
       (102, 3, '2026-02-10', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (18, 6, '2026-02-11', 3200.00),
       (52, 1, '2026-02-12', 850.00),
       (85, 2, '2026-02-13', 450.00),
       (118, 5, '2026-02-16', 350.00),
       (11, 3, '2026-02-17', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (45, 4, '2026-02-18', 2500.00),
       (79, 1, '2026-02-19', 850.00),
       (112, 2, '2026-02-20', 450.00),
       (25, 6, '2026-02-23', 3200.00),
       (59, 5, '2026-02-24', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (92, 1, '2026-02-25', 850.00),
       (125, 3, '2026-02-26', 1200.00),
       (4, 2, '2026-02-27', 450.00),
       (38, 4, '2026-03-02', 2500.00),
       (72, 6, '2026-03-03', 3200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (105, 1, '2026-03-04', 850.00),
       (16, 5, '2026-03-05', 350.00),
       (50, 2, '2026-03-06', 450.00),
       (83, 3, '2026-03-09', 1200.00),
       (116, 4, '2026-03-10', 2500.00);

-- Órdenes 51-75
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (29, 1, '2026-03-11', 850.00),
       (63, 2, '2026-03-12', 450.00),
       (96, 6, '2026-03-13', 3200.00),
       (129, 5, '2026-03-16', 350.00),
       (10, 3, '2026-03-17', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (43, 1, '2026-03-18', 850.00),
       (76, 2, '2026-03-19', 450.00),
       (109, 4, '2026-03-20', 2500.00),
       (21, 6, '2026-03-23', 3200.00),
       (54, 5, '2026-03-24', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (87, 1, '2026-03-25', 850.00),
       (120, 3, '2026-03-26', 1200.00),
       (6, 2, '2026-03-27', 450.00),
       (39, 4, '2026-03-30', 2500.00),
       (73, 1, '2026-03-31', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (106, 6, '2026-04-01', 3200.00),
       (14, 5, '2026-04-02', 350.00),
       (48, 2, '2026-04-03', 450.00),
       (81, 3, '2026-04-06', 1200.00),
       (114, 1, '2026-04-07', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (27, 4, '2026-04-08', 2500.00),
       (60, 2, '2026-04-09', 450.00),
       (93, 6, '2026-04-10', 3200.00),
       (126, 5, '2026-04-13', 350.00),
       (9, 1, '2026-04-14', 850.00);

-- Órdenes 76-100
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (42, 3, '2026-04-15', 1200.00),
       (75, 2, '2026-04-16', 450.00),
       (108, 4, '2026-04-17', 2500.00),
       (23, 6, '2026-04-20', 3200.00),
       (57, 1, '2026-01-08', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (90, 5, '2026-01-09', 350.00),
       (123, 2, '2026-01-10', 450.00),
       (5, 3, '2026-01-13', 1200.00),
       (40, 4, '2026-01-14', 2500.00),
       (74, 1, '2026-01-15', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (107, 6, '2026-01-16', 3200.00),
       (20, 2, '2026-01-19', 450.00),
       (53, 5, '2026-01-20', 350.00),
       (86, 3, '2026-01-21', 1200.00),
       (119, 1, '2026-01-22', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (31, 4, '2026-01-23', 2500.00),
       (65, 2, '2026-01-26', 450.00),
       (98, 6, '2026-01-27', 3200.00),
       (131, 5, '2026-01-28', 350.00),
       (12, 1, '2026-01-29', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (46, 2, '2026-02-02', 450.00),
       (80, 3, '2026-02-03', 1200.00),
       (113, 4, '2026-02-04', 2500.00),
       (26, 1, '2026-02-05', 850.00),
       (60, 6, '2026-02-06', 3200.00);

-- Órdenes 101-125
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (93, 2, '2026-02-09', 450.00),
       (126, 3, '2026-02-10', 1200.00),
       (17, 5, '2026-02-11', 350.00),
       (51, 1, '2026-02-12', 850.00),
       (84, 2, '2026-02-13', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (117, 4, '2026-02-16', 2500.00),
       (30, 6, '2026-02-17', 3200.00),
       (64, 3, '2026-02-18', 1200.00),
       (97, 5, '2026-02-19', 350.00),
       (130, 1, '2026-02-20', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (24, 2, '2026-02-23', 450.00),
       (58, 4, '2026-02-24', 2500.00),
       (91, 6, '2026-02-25', 3200.00),
       (124, 5, '2026-02-26', 350.00),
       (8, 1, '2026-02-27', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (41, 2, '2026-03-02', 450.00),
       (75, 3, '2026-03-03', 1200.00),
       (108, 5, '2026-03-04', 350.00),
       (19, 1, '2026-03-05', 850.00),
       (52, 6, '2026-03-06', 3200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (85, 2, '2026-03-09', 450.00),
       (118, 4, '2026-03-10', 2500.00),
       (32, 1, '2026-03-11', 850.00),
       (66, 3, '2026-03-12', 1200.00),
       (99, 5, '2026-03-13', 350.00);

-- Órdenes 126-150
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (132, 2, '2026-03-16', 450.00),
       (7, 4, '2026-03-17', 2500.00),
       (43, 6, '2026-03-18', 3200.00),
       (77, 1, '2026-03-19', 850.00),
       (110, 2, '2026-03-20', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (22, 3, '2026-03-23', 1200.00),
       (56, 5, '2026-03-24', 350.00),
       (89, 1, '2026-03-25', 850.00),
       (122, 4, '2026-03-26', 2500.00),
       (35, 6, '2026-03-27', 3200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (69, 2, '2026-03-30', 450.00),
       (102, 3, '2026-03-31', 1200.00),
       (135, 5, '2026-04-01', 350.00),
       (15, 1, '2026-04-02', 850.00),
       (49, 2, '2026-04-03', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (82, 4, '2026-04-06', 2500.00),
       (115, 6, '2026-04-07', 3200.00),
       (28, 5, '2026-04-08', 350.00),
       (62, 1, '2026-04-09', 850.00),
       (95, 2, '2026-04-10', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (128, 3, '2026-04-13', 1200.00),
       (11, 4, '2026-04-14', 2500.00),
       (44, 6, '2026-04-15', 3200.00),
       (78, 5, '2026-04-16', 350.00),
       (111, 1, '2026-04-17', 850.00);

-- Órdenes 151-175
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (33, 2, '2026-01-07', 450.00),
       (67, 4, '2026-01-08', 2500.00),
       (100, 6, '2026-01-09', 3200.00),
       (133, 3, '2026-01-12', 1200.00),
       (16, 5, '2026-01-13', 350.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (50, 1, '2026-01-14', 850.00),
       (83, 2, '2026-01-15', 450.00),
       (116, 4, '2026-01-16', 2500.00),
       (29, 6, '2026-01-19', 3200.00),
       (63, 3, '2026-01-20', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (96, 5, '2026-01-21', 350.00),
       (129, 1, '2026-01-22', 850.00),
       (37, 2, '2026-01-23', 450.00),
       (71, 3, '2026-01-26', 1200.00),
       (104, 4, '2026-01-27', 2500.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (137, 5, '2026-01-28', 350.00),
       (23, 1, '2026-01-29', 850.00),
       (57, 6, '2026-01-30', 3200.00),
       (90, 2, '2026-02-02', 450.00),
       (123, 3, '2026-02-03', 1200.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (38, 5, '2026-02-04', 350.00),
       (72, 1, '2026-02-05', 850.00),
       (105, 4, '2026-02-06', 2500.00),
       (138, 2, '2026-02-09', 450.00),
       (13, 6, '2026-02-10', 3200.00);

-- Órdenes 176-200
INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (47, 3, '2026-02-11', 1200.00),
       (80, 5, '2026-02-12', 350.00),
       (113, 1, '2026-02-13', 850.00),
       (34, 2, '2026-02-16', 450.00),
       (68, 4, '2026-02-17', 2500.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (101, 6, '2026-02-18', 3200.00),
       (134, 3, '2026-02-19', 1200.00),
       (21, 5, '2026-02-20', 350.00),
       (55, 1, '2026-02-23', 850.00),
       (88, 2, '2026-02-24', 450.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (121, 4, '2026-02-25', 2500.00),
       (4, 6, '2026-02-26', 3200.00),
       (39, 3, '2026-02-27', 1200.00),
       (73, 5, '2026-03-02', 350.00),
       (106, 1, '2026-03-03', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (139, 2, '2026-03-04', 450.00),
       (14, 3, '2026-03-05', 1200.00),
       (48, 4, '2026-03-06', 2500.00),
       (82, 5, '2026-03-09', 350.00),
       (115, 1, '2026-03-10', 850.00);

INSERT INTO Servicio (idVehiculo, idTipoServicio, FechaIngreso, CostoServicio)
VALUES (28, 2, '2026-03-11', 450.00),
       (62, 6, '2026-03-12', 3200.00),
       (95, 3, '2026-03-13', 1200.00),
       (128, 4, '2026-03-16', 2500.00),
       (140, 1, '2026-03-17', 850.00);

GO
