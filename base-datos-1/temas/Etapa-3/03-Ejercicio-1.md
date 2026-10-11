# Ejercicio 1: Crear e insertar datos en la tabla Alumno

Copia y ejecuta los siguientes scripts en SSMS para preparar el entorno que usaremos en los ejercicios del tema DML.

---

## Paso 1A: Crear la base de datos

Ejecuta este script primero:

```sql
-- Tema:        Ejercicio 1
-- Descripción: Crear base de datos CursoDB
-- Autor:       [Tu nombre]

CREATE DATABASE CursoDB;
```

---

## Paso 1B: Crear la tabla

Una vez creada la base de datos, asegúrate de tener seleccionada **CursoDB** en el dropdown de SSMS y ejecuta:

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Edad INT,
    CorreoElectronico VARCHAR(100),
    Ciudad VARCHAR(50),
    Sexo CHAR(1) NOT NULL
);
```

---

## Paso 2, Opción A: INSERT individual por registro

Esta forma es la más explícita. Cada `INSERT` es una instrucción independiente.

```sql
INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Méndez', 'García', 'Carlos', '2003-07-15', 22,
        'carlos.mendez@cursodb.com', 'Monterrey', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Torres', 'López', 'Ana', '2005-04-22', 20,
        'ana.torres@cursodb.com', 'Guadalajara', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Ramos', 'Vázquez', 'Luis', '2002-11-08', 23,
        'luis.ramos@cursodb.com', 'Monterrey', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Pérez', 'Sánchez', 'María', '2004-09-30', 21,
        'maria.perez@cursodb.com', 'Ciudad de México', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Salinas', 'Mora', 'Jorge', '2006-06-14', 19,
        'jorge.salinas@cursodb.com', 'Guadalajara', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Herrera', 'Blanco', 'Sofía', '2001-12-03', 24,
        'sofia.herrera@cursodb.com', 'Monterrey', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Castillo', 'Reyes', 'Diego', '2004-02-19', 22,
        'diego.castillo@cursodb.com', 'Ciudad de México', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Cruz', 'Díaz', 'Valentina', '2005-08-07', 20,
        'valentina.cruz@cursodb.com', 'Puebla', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Flores', 'Gutiérrez', 'Andrés', '2004-10-25', 21,
        'andres.flores@cursodb.com', 'Monterrey', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Reyes', 'Torres', 'Camila', '2002-05-11', 23,
        'camila.reyes@cursodb.com', 'Guadalajara', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Vega', 'Moreno', 'Ricardo', '2006-10-28', 19,
        'ricardo.vega@cursodb.com', 'Puebla', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Morales', 'Jiménez', 'Isabela', '2003-09-16', 22,
        'isabela.morales@cursodb.com', 'Ciudad de México', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Ortiz', 'Hernández', 'Fernando', '2000-08-04', 25,
        'fernando.ortiz@cursodb.com', 'Monterrey', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Jiménez', 'Vargas', 'Lucía', '2005-11-20', 20,
        'lucia.jimenez@cursodb.com', 'Guadalajara', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Ruiz', 'Romero', 'Sebastián', '2004-06-09', 21,
        'sebastian.ruiz@cursodb.com', 'Puebla', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Gómez', 'Navarro', 'Daniela', '2002-03-17', 23,
        'daniela.gomez@cursodb.com', 'Monterrey', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Vargas', 'Castro', 'Emilio', '2003-09-02', 22,
        'emilio.vargas@cursodb.com', 'Ciudad de México', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Soto', 'Mendoza', 'Natalia', '2005-07-13', 20,
        'natalia.soto@cursodb.com', 'Guadalajara', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Núñez', 'Fuentes', 'Alejandro', '2001-04-27', 24,
        'alejandro.nunez@cursodb.com', 'Monterrey', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Guerrero', 'Ibarra', 'Renata', '2004-12-05', 21,
        'renata.guerrero@cursodb.com', 'Puebla', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Delgado', 'Peña', 'Iván', '2003-04-18', 22,
        'ivan.delgado@cursodb.com', 'Ciudad de México', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Aguilar', 'Sandoval', 'Mariana', '2006-08-23', 19,
        'mariana.aguilar@cursodb.com', 'Monterrey', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Romero', 'Cervantes', 'Tomás', '2002-07-31', 23,
        'tomas.romero@cursodb.com', 'Guadalajara', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Medina', 'Lozano', 'Valeria', '2006-02-14', 20,
        'valeria.medina@cursodb.com', 'Puebla', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Sandoval', 'Fuentes', 'Rodrigo', '2000-05-08', 25,
        'rodrigo.sandoval@cursodb.com', 'Monterrey', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Ibarra', 'Ortega', 'Paulina', '2003-11-26', 22,
        'paulina.ibarra@cursodb.com', 'Ciudad de México', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Cervantes', 'Mendoza', 'Óscar', '2004-08-12', 21,
        'oscar.cervantes@cursodb.com', 'Guadalajara', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Peña', 'Salinas', 'Gabriela', '2005-10-01', 20,
        'gabriela.pena@cursodb.com', 'Monterrey', 'F');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Lozano', 'Herrera', 'Mateo', '2003-01-19', 23,
        'mateo.lozano@cursodb.com', 'Puebla', 'M');

INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Fuentes', 'Ramos', 'Alicia', '2006-12-07', 19,
        'alicia.fuentes@cursodb.com', 'Ciudad de México', 'F');
```

---

## Paso 2, Opción B: INSERT de todos los registros en una sola instrucción

Esta forma es más eficiente. Un solo `INSERT` envía todos los registros al servidor de una vez.

```sql
INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Méndez', 'García', 'Carlos', '2003-07-15', 22,
        'carlos.mendez@cursodb.com', 'Monterrey', 'M'),
       ('Torres', 'López', 'Ana', '2005-04-22', 20,
        'ana.torres@cursodb.com', 'Guadalajara', 'F'),
       ('Ramos', 'Vázquez', 'Luis', '2002-11-08', 23,
        'luis.ramos@cursodb.com', 'Monterrey', 'M'),
       ('Pérez', 'Sánchez', 'María', '2004-09-30', 21,
        'maria.perez@cursodb.com', 'Ciudad de México', 'F'),
       ('Salinas', 'Mora', 'Jorge', '2006-06-14', 19,
        'jorge.salinas@cursodb.com', 'Guadalajara', 'M'),
       ('Herrera', 'Blanco', 'Sofía', '2001-12-03', 24,
        'sofia.herrera@cursodb.com', 'Monterrey', 'F'),
       ('Castillo', 'Reyes', 'Diego', '2004-02-19', 22,
        'diego.castillo@cursodb.com', 'Ciudad de México', 'M'),
       ('Cruz', 'Díaz', 'Valentina', '2005-08-07', 20,
        'valentina.cruz@cursodb.com', 'Puebla', 'F'),
       ('Flores', 'Gutiérrez', 'Andrés', '2004-10-25', 21,
        'andres.flores@cursodb.com', 'Monterrey', 'M'),
       ('Reyes', 'Torres', 'Camila', '2002-05-11', 23,
        'camila.reyes@cursodb.com', 'Guadalajara', 'F'),
       ('Vega', 'Moreno', 'Ricardo', '2006-10-28', 19,
        'ricardo.vega@cursodb.com', 'Puebla', 'M'),
       ('Morales', 'Jiménez', 'Isabela', '2003-09-16', 22,
        'isabela.morales@cursodb.com', 'Ciudad de México', 'F'),
       ('Ortiz', 'Hernández', 'Fernando', '2000-08-04', 25,
        'fernando.ortiz@cursodb.com', 'Monterrey', 'M'),
       ('Jiménez', 'Vargas', 'Lucía', '2005-11-20', 20,
        'lucia.jimenez@cursodb.com', 'Guadalajara', 'F'),
       ('Ruiz', 'Romero', 'Sebastián', '2004-06-09', 21,
        'sebastian.ruiz@cursodb.com', 'Puebla', 'M'),
       ('Gómez', 'Navarro', 'Daniela', '2002-03-17', 23,
        'daniela.gomez@cursodb.com', 'Monterrey', 'F'),
       ('Vargas', 'Castro', 'Emilio', '2003-09-02', 22,
        'emilio.vargas@cursodb.com', 'Ciudad de México', 'M'),
       ('Soto', 'Mendoza', 'Natalia', '2005-07-13', 20,
        'natalia.soto@cursodb.com', 'Guadalajara', 'F'),
       ('Núñez', 'Fuentes', 'Alejandro', '2001-04-27', 24,
        'alejandro.nunez@cursodb.com', 'Monterrey', 'M'),
       ('Guerrero', 'Ibarra', 'Renata', '2004-12-05', 21,
        'renata.guerrero@cursodb.com', 'Puebla', 'F'),
       ('Delgado', 'Peña', 'Iván', '2003-04-18', 22,
        'ivan.delgado@cursodb.com', 'Ciudad de México', 'M'),
       ('Aguilar', 'Sandoval', 'Mariana', '2006-08-23', 19,
        'mariana.aguilar@cursodb.com', 'Monterrey', 'F'),
       ('Romero', 'Cervantes', 'Tomás', '2002-07-31', 23,
        'tomas.romero@cursodb.com', 'Guadalajara', 'M'),
       ('Medina', 'Lozano', 'Valeria', '2006-02-14', 20,
        'valeria.medina@cursodb.com', 'Puebla', 'F'),
       ('Sandoval', 'Fuentes', 'Rodrigo', '2000-05-08', 25,
        'rodrigo.sandoval@cursodb.com', 'Monterrey', 'M'),
       ('Ibarra', 'Ortega', 'Paulina', '2003-11-26', 22,
        'paulina.ibarra@cursodb.com', 'Ciudad de México', 'F'),
       ('Cervantes', 'Mendoza', 'Óscar', '2004-08-12', 21,
        'oscar.cervantes@cursodb.com', 'Guadalajara', 'M'),
       ('Peña', 'Salinas', 'Gabriela', '2005-10-01', 20,
        'gabriela.pena@cursodb.com', 'Monterrey', 'F'),
       ('Lozano', 'Herrera', 'Mateo', '2003-01-19', 23,
        'mateo.lozano@cursodb.com', 'Puebla', 'M'),
       ('Fuentes', 'Ramos', 'Alicia', '2006-12-07', 19,
        'alicia.fuentes@cursodb.com', 'Ciudad de México', 'F');
```

---

## Verificación

Una vez ejecutados los pasos anteriores, confirma que los datos quedaron correctamente:

```sql
SELECT *
FROM Alumno;
```

Deberías ver 30 registros con sus `idAlumno` generados automáticamente del 1 al 30.
