-- Tema:        CineDB - Sesión Final
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
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear base de datos CineDB
-- Autor:       Daniel Hilario

CREATE DATABASE CineDB;

GO

-- ============================================================
-- instalacion/02-create-table-tiposala.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla TipoSala
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE TipoSala (
    idTipoSala INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

GO

-- ============================================================
-- instalacion/03-create-table-clasificacion.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Clasificacion
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Clasificacion (
    idClasificacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(10) NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

GO

-- ============================================================
-- instalacion/04-create-table-genero.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Genero
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Genero (
    idGenero INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

GO

-- ============================================================
-- instalacion/05-create-table-cliente.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Cliente
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Cliente (
    idCliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

GO

-- ============================================================
-- instalacion/06-create-table-sala.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Sala
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Sala (
    idSala INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTipoSala INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Capacidad INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Sala_TipoSala FOREIGN KEY (idTipoSala) REFERENCES TipoSala(idTipoSala)
);

GO

-- ============================================================
-- instalacion/07-create-table-pelicula.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Pelicula
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Pelicula (
    idPelicula INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idClasificacion INT NOT NULL,
    idGenero INT NOT NULL,
    Nombre VARCHAR(200) NOT NULL,
    Duracion INT NOT NULL,
    Director VARCHAR(150) NOT NULL,
    AnioEstreno INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT fk_Pelicula_Clasificacion FOREIGN KEY (idClasificacion) REFERENCES Clasificacion(idClasificacion),
    CONSTRAINT fk_Pelicula_Genero FOREIGN KEY (idGenero) REFERENCES Genero(idGenero)
);

GO

-- ============================================================
-- instalacion/08-create-table-funcion.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Funcion
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Funcion (
    idFuncion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idSala INT NOT NULL,
    idPelicula INT NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    CantidadVendida INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_Funcion_Sala FOREIGN KEY (idSala) REFERENCES Sala(idSala),
    CONSTRAINT fk_Funcion_Pelicula FOREIGN KEY (idPelicula) REFERENCES Pelicula(idPelicula),
    CONSTRAINT uq_Funcion_SalaFechaHora UNIQUE (idSala, Fecha, Hora)
);

GO

-- ============================================================
-- instalacion/09-create-table-boleto.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Crear tabla Boleto
-- Autor:       Daniel Hilario

USE CineDB;

CREATE TABLE Boleto (
    idBoleto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idFuncion INT NOT NULL,
    idCliente INT NOT NULL,
    FechaPago DATE NOT NULL,
    HoraPago TIME NOT NULL,
    CONSTRAINT fk_Boleto_Funcion FOREIGN KEY (idFuncion) REFERENCES Funcion(idFuncion),
    CONSTRAINT fk_Boleto_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

GO

-- ============================================================
-- instalacion/10-insert-tiposala.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar catálogo de tipos de sala
-- Autor:       Daniel Hilario

USE CineDB;

INSERT INTO TipoSala (Descripcion, Precio, Activo)
VALUES ('2D', 90.00, 1),
       ('3D', 130.00, 1),
       ('IMAX', 180.00, 1),
       ('VIP', 220.00, 1);

GO

-- ============================================================
-- instalacion/11-insert-clasificacion.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar catálogo de clasificaciones
-- Autor:       Daniel Hilario

USE CineDB;

INSERT INTO Clasificacion (Nombre, Descripcion, Activo)
VALUES ('AA', 'Apta para todo público', 1),
       ('A', 'Público en general', 1),
       ('B', 'Mayores de 15 años', 1),
       ('C', 'Mayores de 18 años', 1);

GO

-- ============================================================
-- instalacion/12-insert-genero.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 20 géneros cinematográficos
-- Autor:       Daniel Hilario

USE CineDB;

INSERT INTO Genero (Nombre, Activo)
VALUES ('Acción', 1),
       ('Comedia', 1),
       ('Drama', 1),
       ('Terror', 1),
       ('Animación', 1),
       ('Ciencia Ficción', 1),
       ('Romance', 1),
       ('Suspenso', 1),
       ('Aventura', 1),
       ('Documental', 1),
       ('Musical', 1),
       ('Histórico', 1),
       ('Crimen', 1),
       ('Bélico', 1),
       ('Biográfico', 1),
       ('Misterio', 1),
       ('Familiar', 1),
       ('Western', 1),
       ('Fantasía', 1),
       ('Policiaco', 1);

GO

-- ============================================================
-- instalacion/13-insert-sala.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 18 salas físicas del cine
-- Autor:       Daniel Hilario

USE CineDB;

-- idTipoSala: 1=2D  2=3D  3=IMAX  4=VIP
INSERT INTO Sala (idTipoSala, Nombre, Capacidad, Activo)
VALUES (1, 'Sala 1', 120, 1),
       (1, 'Sala 2', 120, 1),
       (1, 'Sala 3', 100, 1),
       (2, 'Sala 4', 110, 1),
       (2, 'Sala 5', 110, 1),
       (3, 'IMAX Norte', 200, 1),
       (3, 'IMAX Sur', 200, 1),
       (4, 'VIP Lounge', 40, 1),
       (4, 'VIP Premium', 30, 1),
       (1, 'Sala 10', 120, 1),
       (1, 'Sala 11', 100, 1),
       (1, 'Sala 12', 100, 1),
       (2, 'Sala 13', 110, 1),
       (2, 'Sala 14', 110, 1),
       (3, 'IMAX Este', 200, 1),
       (3, 'IMAX Oeste', 200, 1),
       (4, 'VIP Presidencial', 35, 1),
       (4, 'VIP Suite', 25, 1);

GO

-- ============================================================
-- instalacion/14-insert-cliente.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 40 clientes (exportados de Alumno - Sesiones 9 y 10)
-- Autor:       Daniel Hilario

USE CineDB;

-- Clientes 1-3 (origen: Técnica 1 - Sistemas Computacionales)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('García', 'López', 'Carlos', '8100000001', 'carlos.garcia@gmail.com',
        '2008-03-15', 1),
       ('Hernández', 'Ramírez', 'Ana', '8100000002', 'ana.hernandez@hotmail.com',
        '2007-12-20', 1),
       ('Rodríguez', 'Silva', 'Miguel', '8100000003', 'miguel.rodriguez@outlook.com',
        '2009-11-05', 1)

-- Clientes 4-6 (origen: Técnica 2 - Diseño de Imagen)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Gutiérrez', 'Peña', 'Andrea', '8100000026', 'andrea.gutierrez@hotmail.com',
        '2009-11-24', 1),
       ('Mendoza', 'Torres', 'Iván', '8100000027', 'ivan.mendoza@outlook.com',
        '2008-03-13', 1),
       ('Herrera', 'Soto', 'Camila', '8100000028', 'camila.herrera@yahoo.com.mx',
        '2007-10-19', 1)

-- Clientes 7-9 (origen: Técnica 3 - Actividad Física y Deporte)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('López', 'García', 'Andrés', '8100000051', 'andres.lopez@outlook.com',
        '2008-02-10', 1),
       ('Martínez', 'Flores', 'Diana', '8100000052', 'diana.martinez@yahoo.com.mx',
        '2007-11-18', 1),
       ('González', 'Torres', 'Kevin', '8100000053', 'kevin.gonzalez@gmail.com',
        '2009-10-07', 1)

-- Clientes 10-12 (origen: Técnica 4 - Artes)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Aguilar', 'Reyes', 'Vanessa', '8100000076', 'vanessa.aguilar@yahoo.com.mx',
        '2008-03-16', 1),
       ('Salinas', 'Díaz', 'Arturo', '8100000077', 'arturo.salinas@gmail.com',
        '2007-10-24', 1),
       ('Medina', 'García', 'Guadalupe', '8100000078', 'guadalupe.medina@hotmail.com',
        '2009-11-08', 1)

-- Clientes 13-14 (origen: Técnica 5 - Gastronomía Integral)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Sánchez', 'Fuentes', 'Erick', '8100000101', 'erick.sanchez@gmail.com',
        '2008-02-21', 1),
       ('Jiménez', 'Reyes', 'Angélica', '8100000102', 'angelica.jimenez@hotmail.com',
        '2007-11-05', 1)

-- Clientes 15-16 (origen: Técnica 6 - Diseño y Comunicación Visual)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('González', 'Ramírez', 'Paola', '8100000126', 'paola.gonzalez@hotmail.com',
        '2008-04-14', 1),
       ('Ramírez', 'López', 'Alan', '8100000127', 'alan.ramirez@outlook.com',
        '2007-11-07', 1)

-- Clientes 17-18 (origen: Técnica 7 - Diseño de Modas)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Reyes', 'Silva', 'Gabriela', '8100000151', 'gabriela.reyes@outlook.com',
        '2008-04-16', 1),
       ('Ortiz', 'Rivera', 'Jonathan', '8100000152', 'jonathan.ortiz@yahoo.com.mx',
        '2007-11-22', 1)

-- Clientes 19-20 (origen: Técnica 8 - Fisioterapia y Readaptación Físico Deportiva)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Cervantes', 'García', 'Laura', '8100000176', 'laura.cervantes@yahoo.com.mx',
        '2008-01-20', 1),
       ('Sandoval', 'Martínez', 'Javier', '8100000177', 'javier.sandoval@gmail.com',
        '2007-11-17', 1)

-- Clientes 21-23 (origen: Técnica 1 - Sistemas Computacionales)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Torres', 'Gutiérrez', 'Valeria', '8100000004', 'valeria.torres@yahoo.com.mx',
        '2008-07-22', 1),
       ('Pérez', 'Morales', 'Luis', '8100000005', 'luis.perez@gmail.com',
        '2007-10-14', 1),
       ('Sánchez', 'Vega', 'Sofía', '8100000006', 'sofia.sanchez@hotmail.com',
        '2009-12-30', 1)

-- Clientes 24-26 (origen: Técnica 2 - Diseño de Imagen)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Vega', 'Ramírez', 'Carlos', '8100000029', 'carlos.vega@gmail.com',
        '2009-12-07', 1),
       ('Navarro', 'Flores', 'Lucía', '8100000030', 'lucia.navarro@hotmail.com',
        '2008-05-25', 1),
       ('Castillo', 'García', 'Tomás', '8100000031', 'tomas.castillo@outlook.com',
        '2007-11-18', 1)

-- Clientes 27-29 (origen: Técnica 3 - Actividad Física y Deporte)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Ramírez', 'Pérez', 'Fernanda', '8100000054', 'fernanda.ramirez@hotmail.com',
        '2008-08-14', 1),
       ('Rodríguez', 'Sánchez', 'Eduardo', '8100000055', 'eduardo.rodriguez@outlook.com',
        '2007-12-03', 1),
       ('Cruz', 'Jiménez', 'Alejandra', '8100000056', 'alejandra.cruz@yahoo.com.mx',
        '2009-11-15', 1)

-- Clientes 30-32 (origen: Técnica 4 - Artes)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Lozano', 'Martínez', 'Rubén', '8100000079', 'ruben.lozano@outlook.com',
        '2008-07-21', 1),
       ('Fuentes', 'González', 'Sofía', '8100000080', 'sofia.fuentes@yahoo.com.mx',
        '2007-12-15', 1),
       ('Núñez', 'Rodríguez', 'Miguel', '8100000081', 'miguel.nunez@gmail.com',
        '2009-10-02', 1)

-- Clientes 33-34 (origen: Técnica 5 - Gastronomía Integral)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Gómez', 'Herrera', 'Miguel', '8100000103', 'miguel.gomez@outlook.com',
        '2009-10-30', 1),
       ('Delgado', 'Cruz', 'Jimena', '8100000104', 'jimena.delgado@yahoo.com.mx',
        '2008-09-16', 1)

-- Clientes 35-36 (origen: Técnica 6 - Diseño y Comunicación Visual)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Rodríguez', 'García', 'Valeria', '8100000128', 'valeria.rodriguez@yahoo.com.mx',
        '2009-10-21', 1),
       ('Hernández', 'Martínez', 'Carlos', '8100000129', 'carlos.hernandez@gmail.com',
        '2008-03-19', 1)

-- Clientes 37-38 (origen: Técnica 7 - Diseño de Modas)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Cruz', 'Gómez', 'Pamela', '8100000153', 'pamela.cruz@gmail.com',
        '2009-10-09', 1),
       ('Flores', 'Vargas', 'Sergio', '8100000154', 'sergio.flores@hotmail.com',
        '2008-02-15', 1)

-- Clientes 39-40 (origen: Técnica 8 - Fisioterapia y Readaptación Físico Deportiva)
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, CorreoElectronico,
                     FechaNacimiento, Activo)
VALUES ('Guerrero', 'González', 'Vanessa', '8100000178', 'vanessa.guerrero@hotmail.com',
        '2009-10-11', 1),
       ('Ibáñez', 'Rodríguez', 'Carlos', '8100000179', 'carlos.ibanez@outlook.com',
        '2008-03-18', 1)

GO

-- ============================================================
-- instalacion/15-insert-pelicula.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar catálogo de 30 películas (2023-2025)
-- Autor:       Daniel Hilario

USE CineDB;

-- idClasificacion: 1=AA  2=A  3=B  4=C
-- idGenero:        1=Acción      2=Comedia      3=Drama       4=Terror
--                  5=Animación   6=Ciencia Ficción  7=Romance  8=Suspenso
--                  9=Aventura   10=Documental  11=Musical    12=Histórico
--                 13=Crimen     14=Bélico      15=Biográfico 16=Misterio
--                 17=Familiar   18=Western     19=Fantasía   20=Policiaco

-- Películas 1-3: Clasificación AA — catálogo 2024
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (1, 5, 'Intensamente 2', 96, 'Kelsey Mann',
        2024, 1),
       (1, 5, 'Moana 2', 100, 'Dana Ledoux Miller',
        2024, 1),
       (1, 9, 'El Robot Salvaje', 102, 'Chris Sanders',
        2024, 1)

-- Películas 4-5: Clasificación A — catálogo 2024
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (2, 7, 'Wicked', 160, 'Jon M. Chu',
        2024, 1),
       (2, 8, 'Cónclave', 120, 'Edward Berger',
        2024, 1)

-- Películas 6-8: Clasificación B — catálogo 2024
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (3, 6, 'Dune: Parte Dos', 166, 'Denis Villeneuve',
        2024, 1),
       (3, 3, 'Oppenheimer', 180, 'Christopher Nolan',
        2023, 1),
       (3, 4, 'Un lugar en silencio: Día uno', 99, 'Michael Sarnoski',
        2024, 1)

-- Películas 9-15: Clasificación C — catálogo 2024
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (4, 1, 'Deadpool & Wolverine', 127, 'Shawn Levy',
        2024, 1),
       (4, 4, 'Alien: Romulus', 119, 'Fede Álvarez',
        2024, 1),
       (4, 4, 'La Sustancia', 141, 'Coralie Fargeat',
        2024, 1),
       (4, 1, 'Gladiator II', 148, 'Ridley Scott',
        2024, 1),
       (4, 1, 'Furiosa: De la saga Mad Max', 148, 'George Miller',
        2024, 1),
       (4, 3, 'Anora', 139, 'Sean Baker',
        2024, 1),
       (4, 3, 'El Brutalista', 215, 'Brady Corbet',
        2024, 1)

-- Películas 16-17: Clasificación AA — catálogo 2023 y 2025
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (1, 5, 'Spider-Man: Cruzando el Multiverso', 140, 'Joaquim Dos Santos, Kemp Powers',
        2023, 1),
       (1, 9, 'Un mundo de Minecraft', 101, 'Jared Hess',
        2025, 1)

-- Películas 18-19: Clasificación A — catálogo 2023
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (2, 2, 'Barbie', 114, 'Greta Gerwig',
        2023, 1),
       (2, 7, 'Past Lives', 106, 'Céline Song',
        2023, 1)

-- Películas 20-25: Clasificación B — catálogo 2023 y 2025
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (3, 1, 'Guardianes de la Galaxia Vol. 3', 149, 'James Gunn',
        2023, 1),
       (3, 12, 'Napoleón', 158, 'Ridley Scott',
        2023, 1),
       (3, 15, 'Los asesinos de la luna', 206, 'Martin Scorsese',
        2023, 1),
       (3, 6, 'Mickey 17', 137, 'Bong Joon-ho',
        2025, 1),
       (3, 1, 'Thunderbolts*', 127, 'Jake Schreier',
        2025, 1),
       (3, 1, 'Capitán América: Un nuevo mundo', 118, 'Julius Onah',
        2025, 1)

-- Películas 26-30: Clasificación C — catálogo 2023 y 2025
INSERT INTO Pelicula (idClasificacion, idGenero, Nombre, Duracion, Director,
                      AnioEstreno, Activo)
VALUES (4, 13, 'John Wick: Capítulo 4', 169, 'Chad Stahelski',
        2023, 1),
       (4, 2, 'Pobres criaturas', 141, 'Yorgos Lanthimos',
        2023, 1),
       (4, 8, 'Saltburn', 131, 'Emerald Fennell',
        2023, 1),
       (4, 13, 'El asesino', 118, 'David Fincher',
        2023, 1),
       (4, 4, 'Sinners', 137, 'Ryan Coogler',
        2025, 1)

GO

-- ============================================================
-- instalacion/16-insert-funcion.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 90 funciones — 3 por película, mayo y junio 2026
-- Autor:       Daniel Hilario

USE CineDB;

-- idSala:     1=Sala 1 (2D,$90)    2=Sala 2 (2D,$90)    3=Sala 3 (2D,$90)
--             4=Sala 4 (3D,$130)   5=Sala 5 (3D,$130)
--             6=IMAX Norte ($180)  7=IMAX Sur ($180)
--             8=VIP Lounge ($220)  9=VIP Premium ($220)
--            10=Sala 10 (2D,$90)  11=Sala 11 (2D,$90)  12=Sala 12 (2D,$90)
--            13=Sala 13 (3D,$130) 14=Sala 14 (3D,$130)
--            15=IMAX Este ($180)  16=IMAX Oeste ($180)
--            17=VIP Presidencial ($220)  18=VIP Suite ($220)
--
-- idPelicula (1-15): 1=Intensamente 2  2=Moana 2         3=El Robot Salvaje
--                    4=Wicked          5=Cónclave        6=Dune: Parte Dos
--                    7=Oppenheimer     8=Un lugar sil.   9=Deadpool & Wolverine
--                   10=Alien: Romulus 11=La Sustancia   12=Gladiator II
--                   13=Furiosa        14=Anora          15=El Brutalista
--
-- idPelicula (16-30): 16=Spider-Man    17=Minecraft      18=Barbie
--                     19=Past Lives   20=Guardianes V3   21=Napoleón
--                     22=Asesinos     23=Mickey 17       24=Thunderbolts*
--                     25=Cap América  26=John Wick 4     27=Pobres criaturas
--                     28=Saltburn     29=El asesino      30=Sinners

-- ── MAYO 2026 (funciones 1-45) ──────────────────────────────────────────────

-- Películas AA — salas 2D y 3D, horario familiar
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (2, 1, '2026-05-03', '16:00', 90.00),   -- Intensamente 2
       (5, 1, '2026-05-10', '14:30', 130.00),
       (2, 1, '2026-05-24', '11:00', 90.00),
       (1, 2, '2026-05-02', '15:00', 90.00),   -- Moana 2
       (4, 2, '2026-05-12', '13:00', 130.00),
       (1, 2, '2026-05-23', '17:00', 90.00),
       (3, 3, '2026-05-04', '16:00', 90.00),   -- El Robot Salvaje
       (4, 3, '2026-05-16', '15:30', 130.00),
       (3, 3, '2026-05-25', '18:00', 90.00)

-- Películas A — 3D e IMAX, horario nocturno
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (5, 4, '2026-05-01', '19:00', 130.00),  -- Wicked
       (7, 4, '2026-05-14', '18:00', 180.00),
       (5, 4, '2026-05-22', '20:00', 130.00),
       (8, 5, '2026-05-05', '20:00', 220.00),  -- Cónclave
       (9, 5, '2026-05-13', '19:30', 220.00),
       (8, 5, '2026-05-28', '21:00', 220.00)

-- Películas B — IMAX y VIP
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (6, 6, '2026-05-02', '20:00', 180.00),  -- Dune: Parte Dos
       (7, 6, '2026-05-15', '20:30', 180.00),
       (6, 6, '2026-05-29', '19:00', 180.00),
       (9, 7, '2026-05-06', '18:00', 220.00),  -- Oppenheimer
       (8, 7, '2026-05-17', '18:30', 220.00),
       (9, 7, '2026-05-30', '17:00', 220.00),
       (4, 8, '2026-05-03', '21:00', 130.00),  -- Un lugar en silencio: Día uno
       (2, 8, '2026-05-11', '20:30', 90.00),
       (4, 8, '2026-05-24', '20:00', 130.00)

-- Películas C — acción, terror y cine de autor
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (1, 9, '2026-05-01', '21:30', 90.00),   -- Deadpool & Wolverine
       (5, 9, '2026-05-09', '21:00', 130.00),
       (1, 9, '2026-05-21', '20:00', 90.00),
       (3, 10, '2026-05-07', '22:00', 90.00),  -- Alien: Romulus
       (2, 10, '2026-05-16', '22:00', 90.00),
       (3, 10, '2026-05-26', '21:30', 90.00),
       (9, 11, '2026-05-08', '21:00', 220.00), -- La Sustancia
       (8, 11, '2026-05-19', '22:00', 220.00),
       (9, 11, '2026-05-27', '22:00', 220.00),
       (7, 12, '2026-05-02', '21:00', 180.00), -- Gladiator II
       (6, 12, '2026-05-15', '21:30', 180.00),
       (7, 12, '2026-05-23', '22:00', 180.00),
       (6, 13, '2026-05-04', '17:00', 180.00), -- Furiosa
       (5, 13, '2026-05-18', '17:00', 130.00),
       (6, 13, '2026-05-31', '17:30', 180.00),
       (8, 14, '2026-05-06', '16:30', 220.00), -- Anora
       (9, 14, '2026-05-20', '16:00', 220.00),
       (9, 14, '2026-05-28', '16:30', 220.00),
       (8, 15, '2026-05-09', '14:00', 220.00), -- El Brutalista (215 min)
       (9, 15, '2026-05-17', '14:30', 220.00),
       (8, 15, '2026-05-30', '15:00', 220.00)

-- ── JUNIO 2026 (funciones 46-90) ─────────────────────────────────────────────

-- Películas AA — salas 2D y 3D, horario familiar
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (10, 18, '2026-06-01', '15:30', 90.00),  -- Barbie
       (13, 18, '2026-06-13', '14:00', 130.00),
       (10, 18, '2026-06-25', '16:00', 90.00),
       (11, 16, '2026-06-02', '16:00', 90.00),  -- Spider-Man: Cruzando el Multiverso
       (13, 16, '2026-06-14', '16:30', 130.00),
       (11, 16, '2026-06-26', '15:00', 90.00),
       (12, 17, '2026-06-03', '15:00', 90.00),  -- Un mundo de Minecraft
       (14, 17, '2026-06-15', '13:00', 130.00),
       (12, 17, '2026-06-27', '14:00', 90.00)

-- Películas A — salas VIP
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (17, 19, '2026-06-04', '20:00', 220.00), -- Past Lives
       (18, 19, '2026-06-16', '19:00', 220.00),
       (17, 19, '2026-06-28', '20:30', 220.00)

-- Películas B — IMAX y VIP
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (15, 20, '2026-06-01', '20:00', 180.00), -- Guardianes de la Galaxia Vol. 3
       (16, 20, '2026-06-14', '20:00', 180.00),
       (15, 20, '2026-06-28', '19:00', 180.00),
       (16, 21, '2026-06-02', '18:00', 180.00), -- Napoleón
       (15, 21, '2026-06-17', '18:30', 180.00),
       (16, 21, '2026-06-30', '19:30', 180.00),
       (18, 22, '2026-06-03', '17:30', 220.00), -- Los asesinos de la luna
       (17, 22, '2026-06-18', '16:30', 220.00),
       (18, 22, '2026-06-29', '17:00', 220.00),
       (15, 23, '2026-06-05', '21:00', 180.00), -- Mickey 17
       (16, 23, '2026-06-19', '21:30', 180.00),
       (15, 23, '2026-06-30', '21:00', 180.00),
       (14, 24, '2026-06-06', '19:00', 130.00), -- Thunderbolts*
       (13, 24, '2026-06-20', '20:00', 130.00),
       (14, 24, '2026-06-28', '21:00', 130.00),
       (13, 25, '2026-06-07', '18:30', 130.00), -- Capitán América: Un nuevo mundo
       (14, 25, '2026-06-21', '19:30', 130.00),
       (13, 25, '2026-06-27', '19:00', 130.00)

-- Películas C — 2D nocturno y VIP
INSERT INTO Funcion (idSala, idPelicula, Fecha, Hora, Precio)
VALUES (10, 26, '2026-06-01', '22:00', 90.00),  -- John Wick: Capítulo 4
       (12, 26, '2026-06-15', '21:30', 90.00),
       (10, 26, '2026-06-28', '22:00', 90.00),
       (18, 27, '2026-06-04', '22:00', 220.00), -- Pobres criaturas
       (17, 27, '2026-06-20', '22:00', 220.00),
       (18, 27, '2026-06-28', '22:00', 220.00),
       (11, 28, '2026-06-05', '22:00', 90.00),  -- Saltburn
       (12, 28, '2026-06-20', '22:00', 90.00),
       (11, 28, '2026-06-27', '22:00', 90.00),
       (12, 29, '2026-06-06', '22:00', 90.00),  -- El asesino
       (11, 29, '2026-06-21', '22:00', 90.00),
       (12, 29, '2026-06-28', '21:00', 90.00),
       (10, 30, '2026-06-07', '22:00', 90.00),  -- Sinners
       (12, 30, '2026-06-21', '20:00', 90.00),
       (10, 30, '2026-06-29', '21:30', 90.00)

GO

-- ============================================================
-- instalacion/17-insert-boleto.sql
-- ============================================================
-- Tema:        CineDB - Sesión Final
-- Descripción: Insertar 100 boletos vendidos en mayo y junio 2026
-- Autor:       Daniel Hilario

USE CineDB;

-- Clientes que compraron (mayo):   1,2,3,5,7,9,11,13,15,17,19  (11 de 20)
-- Clientes sin compras (mayo):     4,6,8,10,12,14,16,18,20
-- Clientes que compraron (junio):  21,22,24,25,27,30,31,33,35,37,39  (11 de 20 nuevos)
-- Clientes sin compras (junio):    23,26,28,29,32,34,36,38,40
--
-- Referencia funciones mayo (1-45):
--  1=Intensamente 2 (03-may)    2=Intensamente 2 (10-may)   3=Intensamente 2 (24-may)
--  4=Moana 2 (02-may)           5=Moana 2 (12-may)          6=Moana 2 (23-may)
--  7=El Robot Salvaje (04-may)  8=El Robot Salvaje (16-may)  9=El Robot Salvaje (25-may)
-- 10=Wicked (01-may)           11=Wicked (14-may)           12=Wicked (22-may)
-- 13=Cónclave (05-may)         14=Cónclave (13-may)         15=Cónclave (28-may)
-- 16=Dune (02-may)             17=Dune (15-may)             18=Dune (29-may)
-- 19=Oppenheimer (06-may)      20=Oppenheimer (17-may)      21=Oppenheimer (30-may)
-- 22=Un lugar (03-may)         23=Un lugar (11-may)         24=Un lugar (24-may)
-- 25=Deadpool (01-may)         26=Deadpool (09-may)         27=Deadpool (21-may)
-- 28=Alien (07-may)            29=Alien (16-may)            30=Alien (26-may)
-- 31=La Sustancia (08-may)     32=La Sustancia (19-may)     33=La Sustancia (27-may)
-- 34=Gladiator II (02-may)     35=Gladiator II (15-may)     36=Gladiator II (23-may)
-- 37=Furiosa (04-may)          38=Furiosa (18-may)          39=Furiosa (31-may)
-- 40=Anora (06-may)            41=Anora (20-may)            42=Anora (28-may)
-- 43=El Brutalista (09-may)    44=El Brutalista (17-may)    45=El Brutalista (30-may)
--
-- Referencia funciones junio (46-90):
-- 46=Barbie(06-01)        47=Barbie(06-13)        48=Barbie(06-25)
-- 49=Spider-Man(06-02)    50=Spider-Man(06-14)     51=Spider-Man(06-26)
-- 52=Minecraft(06-03)     53=Minecraft(06-15)      54=Minecraft(06-27)
-- 55=Past Lives(06-04)    56=Past Lives(06-16)     57=Past Lives(06-28)
-- 58=Guardianes(06-01)    59=Guardianes(06-14)     60=Guardianes(06-28)
-- 61=Napoleón(06-02)      62=Napoleón(06-17)       63=Napoleón(06-30)
-- 64=Asesinos(06-03)      65=Asesinos(06-18)       66=Asesinos(06-29)
-- 67=Mickey 17(06-05)     68=Mickey 17(06-19)      69=Mickey 17(06-30)
-- 70=Thunderbolts(06-06)  71=Thunderbolts(06-20)   72=Thunderbolts(06-28)
-- 73=Cap América(06-07)   74=Cap América(06-21)    75=Cap América(06-27)
-- 76=John Wick(06-01)     77=John Wick(06-15)      78=John Wick(06-28)
-- 79=Pobres criat.(06-04) 80=Pobres criat.(06-20)  81=Pobres criat.(06-28)
-- 82=Saltburn(06-05)      83=Saltburn(06-20)       84=Saltburn(06-27)
-- 85=El asesino(06-06)    86=El asesino(06-21)     87=El asesino(06-28)
-- 88=Sinners(06-07)       89=Sinners(06-21)        90=Sinners(06-29)

-- ── MAYO 2026 (boletos 1-50) ──────────────────────────────────────────────────

-- Cliente 1 — Carlos García (acción y ciencia ficción) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (25, 1, '2026-04-30', '20:00'),
       (34, 1, '2026-05-01', '18:30'),
       (16, 1, '2026-05-01', '18:00'),
       (37, 1, '2026-05-03', '15:00'),
       (26, 1, '2026-05-08', '20:00')

-- Cliente 2 — Ana Hernández (musicales y drama) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (19, 2, '2026-05-05', '21:00'),
       (40, 2, '2026-05-06', '09:00'),
       (11, 2, '2026-05-12', '11:00')

-- Cliente 3 — Miguel Rodríguez (ciencia ficción y acción) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (28, 3, '2026-05-07', '16:00'),
       (17, 3, '2026-05-13', '20:00'),
       (35, 3, '2026-05-13', '20:15'),
       (38, 3, '2026-05-17', '14:00')

-- Cliente 5 — Iván Mendoza (terror) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (22, 5, '2026-05-03', '13:00'),
       (28, 5, '2026-05-06', '17:00'),
       (31, 5, '2026-05-08', '12:00'),
       (33, 5, '2026-05-25', '19:00')

-- Cliente 7 — Andrés López (va con familia, compra boletos extra) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (4,  7, '2026-05-01', '09:30'),
       (4,  7, '2026-05-01', '09:30'),
       (1,  7, '2026-05-02', '10:00'),
       (1,  7, '2026-05-02', '10:00'),
       (7,  7, '2026-05-03', '11:00')

-- Cliente 9 — Kevin González (acción) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (25, 9, '2026-05-01', '10:00'),
       (36, 9, '2026-05-22', '18:00'),
       (39, 9, '2026-05-30', '15:00')

-- Cliente 11 — Arturo Salinas (sala VIP, cine de autor) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (13, 11, '2026-05-04', '16:00'),
       (43, 11, '2026-05-08', '20:00'),
       (20, 11, '2026-05-16', '12:00'),
       (44, 11, '2026-05-16', '19:00')

-- Cliente 13 — Erick Sánchez (terror y suspenso) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (22, 13, '2026-05-02', '14:00'),
       (23, 13, '2026-05-10', '19:00'),
       (29, 13, '2026-05-15', '20:00'),
       (32, 13, '2026-05-19', '11:00')

-- Cliente 15 — Paola González (animación y musicales, va con amiga) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (10, 15, '2026-04-29', '20:00'),
       (2,  15, '2026-05-09', '18:00'),
       (2,  15, '2026-05-09', '18:00'),
       (5,  15, '2026-05-11', '17:00'),
       (12, 15, '2026-05-21', '16:00')

-- Cliente 17 — Gabriela Reyes (variedad) — 6 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (10, 17, '2026-04-28', '11:00'),
       (14, 17, '2026-05-12', '14:00'),
       (8,  17, '2026-05-15', '10:00'),
       (41, 17, '2026-05-19', '10:00'),
       (42, 17, '2026-05-27', '18:00'),
       (18, 17, '2026-05-28', '12:00')

-- Cliente 19 — Laura Cervantes (cinéfila, última semana intensa) — 7 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (6,  19, '2026-05-22', '19:00'),
       (3,  19, '2026-05-23', '18:00'),
       (9,  19, '2026-05-24', '15:00'),
       (30, 19, '2026-05-25', '11:00'),
       (15, 19, '2026-05-27', '13:00'),
       (21, 19, '2026-05-29', '16:00'),
       (45, 19, '2026-05-29', '16:15')

-- ── JUNIO 2026 (boletos 51-100) ───────────────────────────────────────────────

-- Cliente 21 — Valeria Torres (animación, va con acompañante) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (46, 21, '2026-05-30', '19:00'),
       (46, 21, '2026-05-30', '19:00'),
       (49, 21, '2026-06-01', '14:00'),
       (52, 21, '2026-06-02', '10:00')

-- Cliente 22 — Luis Pérez (acción) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (58, 22, '2026-05-31', '20:00'),
       (70, 22, '2026-06-05', '17:00'),
       (73, 22, '2026-06-06', '16:00')

-- Cliente 24 — Carlos Vega (drama histórico) — 3 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (61, 24, '2026-06-01', '15:00'),
       (64, 24, '2026-06-02', '12:00'),
       (65, 24, '2026-06-17', '13:00')

-- Cliente 25 — Lucía Navarro (romance y animación) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (55, 25, '2026-06-03', '20:00'),
       (50, 25, '2026-06-13', '11:00'),
       (56, 25, '2026-06-15', '18:00'),
       (57, 25, '2026-06-27', '19:00')

-- Cliente 27 — Fernanda Ramírez (terror y suspenso) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (76, 27, '2026-05-31', '21:00'),
       (79, 27, '2026-06-03', '15:00'),
       (82, 27, '2026-06-04', '21:00'),
       (85, 27, '2026-06-05', '21:00'),
       (88, 27, '2026-06-06', '17:00')

-- Cliente 30 — Rubén Lozano (drama, cine de autor) — 6 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (61, 30, '2026-05-30', '10:00'),
       (64, 30, '2026-06-01', '14:00'),
       (67, 30, '2026-06-04', '19:00'),
       (62, 30, '2026-06-16', '11:00'),
       (66, 30, '2026-06-28', '15:00'),
       (63, 30, '2026-06-29', '14:00')

-- Cliente 31 — Sofía Fuentes (ciencia ficción y aventura) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (58, 31, '2026-05-30', '15:00'),
       (67, 31, '2026-06-04', '12:00'),
       (59, 31, '2026-06-13', '16:00'),
       (68, 31, '2026-06-18', '10:00'),
       (60, 31, '2026-06-27', '14:00')

-- Cliente 33 — Miguel Gómez (familia, va con hijo) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (46, 33, '2026-05-31', '10:00'),
       (46, 33, '2026-05-31', '10:00'),
       (52, 33, '2026-06-02', '09:00'),
       (52, 33, '2026-06-02', '09:00'),
       (53, 33, '2026-06-14', '11:00')

-- Cliente 35 — Valeria Rodríguez (terror y suspenso) — 4 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (80, 35, '2026-06-19', '21:00'),
       (83, 35, '2026-06-19', '20:00'),
       (84, 35, '2026-06-26', '18:00'),
       (89, 35, '2026-06-20', '15:00')

-- Cliente 37 — Pamela Cruz (acción y suspenso) — 6 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (71, 37, '2026-06-19', '14:00'),
       (74, 37, '2026-06-20', '13:00'),
       (86, 37, '2026-06-20', '21:00'),
       (72, 37, '2026-06-27', '16:00'),
       (78, 37, '2026-06-27', '20:00'),
       (87, 37, '2026-06-27', '22:00')

-- Cliente 39 — Vanessa Guerrero (animación, última semana) — 5 boletos
INSERT INTO Boleto (idFuncion, idCliente, FechaPago, HoraPago)
VALUES (48, 39, '2026-06-24', '18:00'),
       (51, 39, '2026-06-25', '15:00'),
       (54, 39, '2026-06-26', '12:00'),
       (75, 39, '2026-06-26', '19:00'),
       (90, 39, '2026-06-28', '17:00')

-- Sincroniza Funcion.CantidadVendida con los boletos vendidos de cada función
UPDATE Funcion
SET CantidadVendida = (SELECT COUNT(*) FROM Boleto B WHERE B.idFuncion = Funcion.idFuncion);

GO
