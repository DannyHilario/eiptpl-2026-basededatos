-- Tema:        Ejercicio 2 - Hotel Vista (CursoDB)
-- Descripción: Instalación completa (base de datos, tablas y datos) en un solo script
-- Autor:       Daniel Hilario
--
-- Generado concatenando los scripts de instalacion/ en orden alfabético ('find instalacion -name "*.sql" | sort'),
-- que es el mismo orden de la tabla del README y respeta las llaves foráneas.
-- Requiere ejecutarse completo en SSMS (F5): se separa cada script con GO para que ninguno interfiera
-- con el batch del anterior.
-- Requiere que CursoDB ya exista: la crea el Ejercicio 1 (06-Ejercicio-1/instalacion/01-create-database.sql).

-- ============================================================
-- instalacion/02-create-tables.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Crear tablas del modelo relacional del hotel
-- Autor:       Daniel Hilario

USE CursoDB;

-- Tabla Huesped
CREATE TABLE Huesped (
    idHuesped INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Telefono VARCHAR(20),
    Correo VARCHAR(100) UNIQUE
);

-- Tabla TipoHabitacion
CREATE TABLE TipoHabitacion (
    idTipoHabitacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    TipoHabitacion VARCHAR(50) NOT NULL UNIQUE,
    PrecioPorNoche DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_TipoHabitacion_PrecioPorNoche CHECK (PrecioPorNoche > 0)
);

-- Tabla Habitacion
CREATE TABLE Habitacion (
    idHabitacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTipoHabitacion INT NOT NULL,
    NumeroHabitacion VARCHAR(10) NOT NULL,
    DescripcionHabitacion VARCHAR(200),
    CONSTRAINT uq_Habitacion_NumeroHabitacion UNIQUE (NumeroHabitacion),
    CONSTRAINT fk_Habitacion_TipoHabitacion
        FOREIGN KEY (idTipoHabitacion)
        REFERENCES TipoHabitacion(idTipoHabitacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla Reservacion
CREATE TABLE Reservacion (
    idReservacion INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idHuesped INT NOT NULL,
    idHabitacion INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    NumeroNoches INT NOT NULL,
    PrecioAlMomento DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Reservacion_Huesped
        FOREIGN KEY (idHuesped)
        REFERENCES Huesped(idHuesped)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_Reservacion_Habitacion
        FOREIGN KEY (idHabitacion)
        REFERENCES Habitacion(idHabitacion)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT chk_Reservacion_NumeroNoches CHECK (NumeroNoches > 0),
    CONSTRAINT chk_Reservacion_PrecioAlMomento CHECK (PrecioAlMomento > 0)
);

GO

-- ============================================================
-- instalacion/03-insert-tipohab.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar tipos de habitación
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO TipoHabitacion (TipoHabitacion, PrecioPorNoche)
VALUES ('Sencilla', 850.00),
       ('Doble', 1200.00),
       ('Suite', 2500.00)

GO

-- ============================================================
-- instalacion/04-insert-habitacion.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar habitaciones
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Habitacion (idTipoHabitacion, NumeroHabitacion, DescripcionHabitacion)
VALUES (1, '101', 'Planta baja, vista al jardín'),
       (1, '102', 'Planta baja, vista al patio'),
       (2, '201', 'Segunda planta, vista a la calle'),
       (2, '202', 'Segunda planta, vista a la piscina'),
       (2, '203', 'Segunda planta, balcón privado'),
       (3, '301', 'Planta alta, terraza privada'),
       (3, '302', 'Planta alta, jacuzzi y vista panorámica')

GO

-- ============================================================
-- instalacion/05-insert-huesped.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar huéspedes ficticios
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Huesped (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
VALUES ('Ramírez', 'Fuentes', 'Carlos', '81-5543-2210', 'carlos.ramirez@gmail.com'),
       ('Torres', 'Salinas', 'Ana', '33-6621-8845', 'ana.torres@hotmail.com'),
       ('Mendoza', 'Ríos', 'Patricia', '55-7734-1190', 'patricia.mendoza@outlook.com'),
       ('Guerrero', 'Ibáñez', 'Roberto', '81-9981-4422', 'roberto.guerrero@gmail.com'),
       ('Castillo', 'Vega', 'Sofía', '222-4456-9900', 'sofia.castillo@gmail.com'),
       ('Navarro', 'Cruz', 'Miguel', '33-5510-7723', 'miguel.navarro@yahoo.com'),
       ('Herrera', 'Mora', 'Daniela', '55-2231-6677', 'daniela.herrera@gmail.com'),
       ('Aguilar', 'Peña', 'Luis', '81-8890-3344', 'luis.aguilar@hotmail.com')

GO

-- ============================================================
-- instalacion/06-insert-reservacion.sql
-- ============================================================
-- Tema:        Ejercicio 2 - Hotel Vista
-- Descripción: Insertar reservaciones ficticias
-- Autor:       Daniel Hilario

USE CursoDB;

INSERT INTO Reservacion (idHuesped, idHabitacion, FechaIngreso, NumeroNoches, PrecioAlMomento)
VALUES (1, 1, '2026-03-10', 3, 850.00),
       (2, 3, '2026-03-12', 2, 1200.00),
       (3, 6, '2026-03-15', 5, 2500.00),
       (4, 2, '2026-03-18', 1, 850.00),
       (5, 4, '2026-03-20', 4, 1200.00),
       (6, 7, '2026-03-22', 3, 2500.00),
       (7, 5, '2026-03-25', 2, 1200.00),
       (8, 1, '2026-04-05', 7, 850.00),
       (1, 4, '2026-04-10', 2, 1200.00),
       (3, 7, '2026-04-18', 4, 2500.00)

GO
