# Ejercicio 1: Base de datos EscuelaDB

Copia y ejecuta los siguientes scripts en SSMS para preparar el entorno que usaremos en los ejercicios de consultas multitabla.

---

## Paso 1A: Crear la base de datos

Ejecuta este script primero:

```sql
-- Tema:        Ejercicio 1 - Etapa 4
-- Descripción: Crear base de datos EscuelaDB
-- Autor:       [Tu nombre]

CREATE DATABASE EscuelaDB;
```

---

## Paso 1B: Crear las tablas

Una vez creada la base de datos, asegúrate de tener seleccionada **EscuelaDB** en el dropdown de SSMS y ejecuta:

```sql
CREATE TABLE Tecnica (
    idTecnica INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTecnica INT NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    Edad INT,
    Sexo CHAR(1) NOT NULL,
    CURP CHAR(18),
    FechaNacimiento DATE NOT NULL,
    CONSTRAINT fk_Alumno_Tecnica FOREIGN KEY (idTecnica) REFERENCES Tecnica(idTecnica),
    CONSTRAINT chk_Alumno_Sexo CHECK (Sexo IN ('M', 'F'))
);
```

Puntos importantes:
- `Tecnica` debe crearse **antes** que `Alumno` porque la llave foránea `fk_Alumno_Tecnica` la referencia.
- El campo `Activo` en `Tecnica` es un booleano (`BIT`) que permite dar de baja una técnica sin eliminarla del catálogo (baja lógica).
- El `CHECK` en `Sexo` restringe los valores únicamente a `'M'` (Masculino) o `'F'` (Femenino).

---

## Paso 2: Insertar técnicas

```sql
INSERT INTO Tecnica (Descripcion, Activo)
VALUES ('Sistemas Computacionales', 1),
       ('Diseño de Imagen', 1),
       ('Actividad Física y Deporte', 1),
       ('Artes', 1),
       ('Gastronomía Integral', 1),
       ('Diseño y Comunicación Visual', 1),
       ('Diseño de Modas', 1),
       ('Fisioterapia y Readaptación Físico Deportiva', 1);
```

Después de ejecutar este script, los `idTecnica` generados automáticamente serán del 1 al 8 en el mismo orden de inserción.

---

## Paso 3: Insertar alumnos

Los 200 alumnos se insertan en bloques separados por técnica. Cada bloque es un `INSERT` independiente con 25 registros.

### Técnica 1 — Sistemas Computacionales

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (1, 'García', 'López', 'Carlos', 17,
        'M', 'GALC080315NLHRRL06', '2008-03-15'),
       (1, 'Hernández', 'Ramírez', 'Ana', 18,
        'F', 'HERA071220NLMRNA09', '2007-12-20'),
       (1, 'Rodríguez', 'Silva', 'Miguel', 16,
        'M', 'ROSM091105NLHDGS07', '2009-11-05'),
       (1, 'Torres', 'Gutiérrez', 'Valeria', 17,
        'F', 'TOGV080722NLMRRV02', '2008-07-22'),
       (1, 'Pérez', 'Morales', 'Luis', 18,
        'M', 'PEML071014NLHRRM08', '2007-10-14'),
       (1, 'Sánchez', 'Vega', 'Sofía', 16,
        'F', 'SAVS091230NLMNNS04', '2009-12-30'),
       (1, 'Ramírez', 'Cruz', 'Alejandro', 19,
        'M', 'RACA061005NLHRCM01', '2006-10-05'),
       (1, 'Jiménez', 'Flores', 'Daniela', 17,
        'F', 'JIFD080818NLMMNF03', '2008-08-18'),
       (1, 'Gómez', 'Reyes', 'Ricardo', 18,
        'M', 'GORR070515NLHMMR07', '2007-05-15'),
       (1, 'Delgado', 'Ortiz', 'Mariana', 16,
        'F', 'DEOM091020NLMLLG05', '2009-10-20'),
       (1, 'Castro', 'Ibarra', 'Sergio', 17,
        'M', 'CAIS080807NLHSTR09', '2008-08-07'),
       (1, 'Morales', 'Sandoval', 'Fernanda', 18,
        'F', 'MOSF070625NLMRLL02', '2007-06-25'),
       (1, 'Vargas', 'Lozano', 'Eduardo', 19,
        'M', 'VALE060314NLHRRG06', '2006-03-14'),
       (1, 'Fuentes', 'Cervantes', 'Adriana', 17,
        'F', 'FUCA080912NLMNNN01', '2008-09-12'),
       (1, 'Aguilar', 'Mendoza', 'Daniel', 16,
        'M', 'AGMD091128NLHLLR04', '2009-11-28'),
       (1, 'Salinas', 'Herrera', 'Carolina', 18,
        'F', 'SAHC071003NLMLLN07', '2007-10-03'),
       (1, 'Medina', 'Castillo', 'Pablo', 17,
        'M', 'MECP080520NLHDNN08', '2008-05-20'),
       (1, 'Lozano', 'Guerrero', 'Elena', 16,
        'F', 'LOGE091215NLMZNN03', '2009-12-15'),
       (1, 'Núñez', 'Ramos', 'Francisco', 19,
        'M', 'NURF061102NLHNNM06', '2006-11-02'),
       (1, 'Reyes', 'Díaz', 'Victoria', 17,
        'F', 'REDV080406NLMYYY01', '2008-04-06'),
       (1, 'Ortiz', 'Peña', 'Gabriel', 18,
        'M', 'ORPG070825NLHRRZ05', '2007-08-25'),
       (1, 'Cruz', 'Navarro', 'Monserrat', 16,
        'F', 'CUNM091008NLMRRR09', '2009-10-08'),
       (1, 'Flores', 'Ibáñez', 'Héctor', 17,
        'M', 'FLIH080214NLHLLR02', '2008-02-14'),
       (1, 'Rivera', 'Moreno', 'Patricia', 18,
        'F', 'RIMP070929NLMVRR07', '2007-09-29'),
       (1, 'Silva', 'Espinoza', 'Roberto', 17,
        'M', 'SIER080617NLHLLV04', '2008-06-17');
```

### Técnica 2 — Diseño de Imagen

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (2, 'Gutiérrez', 'Peña', 'Andrea', 16,
        'F', 'GUPA091124NLMTTM08', '2009-11-24'),
       (2, 'Mendoza', 'Torres', 'Iván', 17,
        'M', 'METI080313NLHNDZ03', '2008-03-13'),
       (2, 'Herrera', 'Soto', 'Camila', 18,
        'F', 'HESC071019NLMRRR06', '2007-10-19'),
       (2, 'Vega', 'Ramírez', 'Carlos', 16,
        'M', 'VERC091207NLHGGS01', '2009-12-07'),
       (2, 'Navarro', 'Flores', 'Lucía', 17,
        'F', 'NAFL080525NLMVRR09', '2008-05-25'),
       (2, 'Castillo', 'García', 'Tomás', 18,
        'M', 'CAGT071118NLHSLL04', '2007-11-18'),
       (2, 'Espinoza', 'Jiménez', 'Renata', 16,
        'F', 'ESJR091003NLMSPN07', '2009-10-03'),
       (2, 'Moreno', 'Cruz', 'Rodrigo', 17,
        'M', 'MOCR080417NLHRRN02', '2008-04-17'),
       (2, 'Ibarra', 'Martínez', 'Paulina', 18,
        'F', 'IBMP071222NLMBRR08', '2007-12-22'),
       (2, 'Peña', 'González', 'Oscar', 19,
        'M', 'PEGO060809NLHNNL05', '2006-08-09'),
       (2, 'Soto', 'Rodríguez', 'Alicia', 16,
        'F', 'SOAR091130NLMTTD01', '2009-11-30'),
       (2, 'Cervantes', 'Hernández', 'Marco', 17,
        'M', 'CEHM080716NLHRRV06', '2008-07-16'),
       (2, 'Sandoval', 'Delgado', 'Isabella', 18,
        'F', 'SADI071024NLMNVL03', '2007-10-24'),
       (2, 'Guerrero', 'Castro', 'Emilio', 16,
        'M', 'GUCE091209NLHRRR09', '2009-12-09'),
       (2, 'Lozano', 'Vargas', 'Sandra', 17,
        'F', 'LOVS080325NLMZNL04', '2008-03-25'),
       (2, 'Ramos', 'Aguilar', 'Javier', 18,
        'M', 'RAAJ071106NLHMMS07', '2007-11-06'),
       (2, 'Díaz', 'Salinas', 'Verónica', 16,
        'F', 'DIAV091020NLMZZL02', '2009-10-20'),
       (2, 'Ibáñez', 'Medina', 'Ángel', 17,
        'M', 'IBMA080523NLHBNN08', '2008-05-23'),
       (2, 'Peña', 'Reyes', 'Karla', 18,
        'F', 'PERK071215NLMNNR05', '2007-12-15'),
       (2, 'Gómez', 'Lozano', 'Arturo', 19,
        'M', 'GOLA060712NLHMMZ01', '2006-07-12'),
       (2, 'Fuentes', 'Núñez', 'Stephanie', 16,
        'F', 'FUNS091108NLMNNN06', '2009-11-08'),
       (2, 'Torres', 'Ortiz', 'Jonathan', 17,
        'M', 'TOOJ080421NLHRRR04', '2008-04-21'),
       (2, 'Aguilar', 'Cervantes', 'Natalia', 18,
        'F', 'AGCN071009NLMGLL09', '2007-10-09'),
       (2, 'García', 'Guerrero', 'Jesús', 16,
        'M', 'GAGJ091125NLHRRR07', '2009-11-25'),
       (2, 'Hernández', 'Espinoza', 'Mónica', 17,
        'F', 'HEEM080614NLMNNS03', '2008-06-14');
```

### Técnica 3 — Actividad Física y Deporte

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (3, 'López', 'García', 'Andrés', 17,
        'M', 'LOGA080210NLHPPG02', '2008-02-10'),
       (3, 'Martínez', 'Flores', 'Diana', 18,
        'F', 'MAFD071118NLMRRN07', '2007-11-18'),
       (3, 'González', 'Torres', 'Kevin', 16,
        'M', 'GOTK091007NLHNZR05', '2009-10-07'),
       (3, 'Ramírez', 'Pérez', 'Fernanda', 17,
        'F', 'RAPF080814NLMMRR01', '2008-08-14'),
       (3, 'Rodríguez', 'Sánchez', 'Eduardo', 18,
        'M', 'ROSE071203NLHDRL08', '2007-12-03'),
       (3, 'Cruz', 'Jiménez', 'Alejandra', 16,
        'F', 'CRJA091115NLMRZM04', '2009-11-15'),
       (3, 'Flores', 'Gómez', 'Bryan', 17,
        'M', 'FLGB080629NLHLLM06', '2008-06-29'),
       (3, 'Reyes', 'Vargas', 'Estefanía', 18,
        'F', 'REVE071014NLMYYY09', '2007-10-14'),
       (3, 'Sánchez', 'Delgado', 'Cristian', 19,
        'M', 'SADC060523NLHNNC03', '2006-05-23'),
       (3, 'Jiménez', 'Castro', 'Ximena', 16,
        'F', 'JICX091201NLMMMN07', '2009-12-01'),
       (3, 'Vega', 'Morales', 'Sebastián', 17,
        'M', 'VEMS080918NLHGGS02', '2008-09-18'),
       (3, 'Morales', 'Ramos', 'Lizeth', 18,
        'F', 'MORL071025NLMRLS08', '2007-10-25'),
       (3, 'Delgado', 'Fuentes', 'Gerardo', 16,
        'M', 'DEFG091112NLHLLG05', '2009-11-12'),
       (3, 'Castro', 'Aguilar', 'Pamela', 17,
        'F', 'CAAP080307NLMSTR01', '2008-03-07'),
       (3, 'Gutiérrez', 'Salinas', 'Alan', 18,
        'M', 'GUSA071119NLHTRL06', '2007-11-19'),
       (3, 'Torres', 'Medina', 'Brenda', 16,
        'F', 'TOMB091024NLMRRR04', '2009-10-24'),
       (3, 'Silva', 'Lozano', 'Óscar', 17,
        'M', 'SILO080515NLHLLV09', '2008-05-15'),
       (3, 'Peña', 'Guerrero', 'Yesenia', 18,
        'F', 'PEGY071220NLMNNR03', '2007-12-20'),
       (3, 'Navarro', 'Ibarra', 'Ricardo', 17,
        'M', 'NAIR080408NLHVRM07', '2008-04-08'),
       (3, 'Herrera', 'Espinoza', 'Samantha', 16,
        'F', 'HEES091006NLMRRR02', '2009-10-06'),
       (3, 'Ibarra', 'Soto', 'Emmanuel', 17,
        'M', 'IBSE080722NLHBRM08', '2008-07-22'),
       (3, 'Castillo', 'Cervantes', 'Paola', 18,
        'F', 'CACP071113NLMSLL05', '2007-11-13'),
       (3, 'Espinoza', 'Sandoval', 'Hugo', 16,
        'M', 'ESSH091028NLHSPN01', '2009-10-28'),
       (3, 'Moreno', 'Mendoza', 'Itzel', 17,
        'F', 'MOMI080615NLMRRN06', '2008-06-15'),
       (3, 'Sandoval', 'Herrera', 'Alexis', 18,
        'M', 'SAHA071009NLHNDL09', '2007-10-09');
```

### Técnica 4 — Artes

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (4, 'Aguilar', 'Reyes', 'Vanessa', 17,
        'F', 'AGRV080316NLMGLL04', '2008-03-16'),
       (4, 'Salinas', 'Díaz', 'Arturo', 18,
        'M', 'SADA071024NLHLNS08', '2007-10-24'),
       (4, 'Medina', 'García', 'Guadalupe', 16,
        'F', 'MEGG091108NLMDNN02', '2009-11-08'),
       (4, 'Lozano', 'Martínez', 'Rubén', 17,
        'M', 'LOMR080721NLHZNN07', '2008-07-21'),
       (4, 'Fuentes', 'González', 'Sofía', 18,
        'F', 'FUGS071215NLMNNS05', '2007-12-15'),
       (4, 'Núñez', 'Rodríguez', 'Miguel', 16,
        'M', 'NUMB091002NLHNNM01', '2009-10-02'),
       (4, 'Reyes', 'Ramírez', 'Fernanda', 17,
        'F', 'RERF080517NLMYYR06', '2008-05-17'),
       (4, 'Ortiz', 'Cruz', 'Jonathan', 18,
        'M', 'ORCJ071130NLHRRZ09', '2007-11-30'),
       (4, 'Cruz', 'Flores', 'Priscila', 16,
        'F', 'CRFP091214NLMRZM04', '2009-12-14'),
       (4, 'Flores', 'Reyes', 'Daniel', 17,
        'M', 'FLRD080826NLHLLR07', '2008-08-26'),
       (4, 'Rivera', 'Sánchez', 'Karina', 18,
        'F', 'RISK071012NLMVRR03', '2007-10-12'),
       (4, 'Gómez', 'Torres', 'Alejandro', 16,
        'M', 'GOTA091119NLHMMR08', '2009-11-19'),
       (4, 'Vargas', 'Jiménez', 'Valeria', 17,
        'F', 'VAJV080405NLMRRG02', '2008-04-05'),
       (4, 'Fuentes', 'Gómez', 'Héctor', 18,
        'M', 'FUGH071227NLHNNS07', '2007-12-27'),
       (4, 'Delgado', 'Vargas', 'Nadia', 16,
        'F', 'DEVN091016NLMLLG01', '2009-10-16'),
       (4, 'Castro', 'Delgado', 'Iván', 17,
        'M', 'CADI080623NLHSTT07', '2008-06-23'),
       (4, 'Morales', 'Castro', 'Cristina', 18,
        'F', 'MOCC071108NLMRLS04', '2007-11-08'),
       (4, 'Ramos', 'Morales', 'Kevin', 16,
        'M', 'RAMK091122NLHMMS09', '2009-11-22'),
       (4, 'Díaz', 'Ramos', 'Brenda', 17,
        'F', 'DIRB080314NLMZZL05', '2008-03-14'),
       (4, 'Ibáñez', 'Fuentes', 'Pablo', 18,
        'M', 'IBFP071019NLHBNN08', '2007-10-19'),
       (4, 'Gutiérrez', 'Medina', 'Liliana', 16,
        'F', 'GUML091207NLMTTM03', '2009-12-07'),
       (4, 'Torres', 'Aguilar', 'Emilio', 17,
        'M', 'TOAE080518NLHRRR06', '2008-05-18'),
       (4, 'García', 'Salinas', 'Maricruz', 18,
        'F', 'GASM071125NLMRRR01', '2007-11-25'),
       (4, 'Hernández', 'Lozano', 'Axel', 16,
        'M', 'HELA091009NLHNNS07', '2009-10-09'),
       (4, 'Rodríguez', 'Núñez', 'Esmeralda', 17,
        'F', 'RONE080714NLMDRL04', '2008-07-14');
```

### Técnica 5 — Gastronomía Integral

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (5, 'Sánchez', 'Fuentes', 'Erick', 17,
        'M', 'SAFE080221NLHNNC02', '2008-02-21'),
       (5, 'Jiménez', 'Reyes', 'Angélica', 18,
        'F', 'JIRA071105NLMMMN08', '2007-11-05'),
       (5, 'Gómez', 'Herrera', 'Miguel', 16,
        'M', 'GOMM091030NLHMMR05', '2009-10-30'),
       (5, 'Delgado', 'Cruz', 'Jimena', 17,
        'F', 'DECJ080916NLMLLG03', '2008-09-16'),
       (5, 'Castro', 'Flores', 'Roberto', 18,
        'M', 'CAFR071201NLHSTR09', '2007-12-01'),
       (5, 'Morales', 'Torres', 'Gabriela', 16,
        'F', 'MOTG091124NLMRLS01', '2009-11-24'),
       (5, 'Vargas', 'Sánchez', 'Luis', 17,
        'M', 'VASL080307NLHRRG07', '2008-03-07'),
       (5, 'Fuentes', 'Jiménez', 'Karla', 18,
        'F', 'FUJK071020NLMNNN04', '2007-10-20'),
       (5, 'Aguilar', 'Vega', 'Diego', 16,
        'M', 'AGVD091115NLHLLR08', '2009-11-15'),
       (5, 'Salinas', 'Morales', 'Stephanie', 17,
        'F', 'SAMS080823NLMLLN02', '2008-08-23'),
       (5, 'Medina', 'Delgado', 'Jorge', 18,
        'M', 'MEDJ071012NLHDNN06', '2007-10-12'),
       (5, 'Lozano', 'Castro', 'Estefanía', 16,
        'F', 'LOCE091208NLMZNL09', '2009-12-08'),
       (5, 'Núñez', 'Moreno', 'Sergio', 17,
        'M', 'NUMS080514NLHNNM03', '2008-05-14'),
       (5, 'Reyes', 'Navarro', 'Daniela', 18,
        'F', 'REND071128NLMYYY07', '2007-11-28'),
       (5, 'Ortiz', 'Espinoza', 'Marco', 16,
        'M', 'OTEM091003NLHRRZ05', '2009-10-03'),
       (5, 'Cruz', 'Sandoval', 'Adriana', 17,
        'F', 'CRSA080619NLMRZM01', '2008-06-19'),
       (5, 'Flores', 'Ibarra', 'Tomás', 18,
        'M', 'FLIT071115NLHLLR08', '2007-11-15'),
       (5, 'Rivera', 'Guerrero', 'Paulina', 16,
        'F', 'RIGP091022NLMVRR04', '2009-10-22'),
       (5, 'Gómez', 'Peña', 'Alejandro', 17,
        'M', 'GOPA080717NLHMMR02', '2008-07-17'),
       (5, 'Hernández', 'Mendoza', 'Lorena', 18,
        'F', 'HEML071009NLMNLS06', '2007-10-09'),
       (5, 'Rodríguez', 'Cervantes', 'Hugo', 16,
        'M', 'ROCH091218NLHDRG09', '2009-12-18'),
       (5, 'Torres', 'Galván', 'Sandra', 17,
        'F', 'TOGS080411NLMRRM03', '2008-04-11'),
       (5, 'García', 'Romero', 'Arturo', 18,
        'M', 'GARA071023NLHRRR07', '2007-10-23'),
       (5, 'López', 'Castillo', 'Vanessa', 16,
        'F', 'LOCV091109NLMPPG05', '2009-11-09'),
       (5, 'Martínez', 'Ibáñez', 'Eduardo', 17,
        'M', 'MAEI080626NLHRRN01', '2008-06-26');
```

### Técnica 6 — Diseño y Comunicación Visual

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (6, 'González', 'Ramírez', 'Paola', 17,
        'F', 'GORP080414NLMNZR06', '2008-04-14'),
       (6, 'Ramírez', 'López', 'Alan', 18,
        'M', 'RALA071107NLHRMR02', '2007-11-07'),
       (6, 'Rodríguez', 'García', 'Valeria', 16,
        'F', 'ROGV091021NLMDRL09', '2009-10-21'),
       (6, 'Hernández', 'Martínez', 'Carlos', 17,
        'M', 'HEMC080319NLHNNS04', '2008-03-19'),
       (6, 'García', 'González', 'Camila', 18,
        'F', 'GAGC071214NLMRRR07', '2007-12-14'),
       (6, 'Torres', 'Rodríguez', 'Sergio', 16,
        'M', 'TORS091106NLHRRR03', '2009-11-06'),
       (6, 'Pérez', 'Hernández', 'Andrea', 17,
        'F', 'PEHA080723NLMRRM08', '2008-07-23'),
       (6, 'Sánchez', 'Torres', 'Emilio', 18,
        'M', 'SATE071011NLHNNC01', '2007-10-11'),
       (6, 'Jiménez', 'Pérez', 'Natalia', 16,
        'F', 'JIPN091215NLMMMN05', '2009-12-15'),
       (6, 'Vega', 'Sánchez', 'Rodrigo', 17,
        'M', 'VESR080828NLHGGR09', '2008-08-28'),
       (6, 'Morales', 'Vega', 'Isabella', 18,
        'F', 'MOVI071103NLMRLS06', '2007-11-03'),
       (6, 'Delgado', 'Morales', 'Daniel', 16,
        'M', 'DEMD091009NLHLLG03', '2009-10-09'),
       (6, 'Castro', 'Jiménez', 'Mariana', 17,
        'F', 'CAJM080516NLMSTR07', '2008-05-16'),
       (6, 'Gutiérrez', 'Reyes', 'Pablo', 18,
        'M', 'GURP071224NLHTRL02', '2007-12-24'),
       (6, 'Torres', 'Cruz', 'Estefanía', 16,
        'F', 'TOCE091017NLMRRR08', '2009-10-17'),
       (6, 'Flores', 'Delgado', 'Miguel', 17,
        'M', 'FLDM080311NLHLLR05', '2008-03-11'),
       (6, 'Rivera', 'Castro', 'Alejandra', 18,
        'F', 'RICA071209NLMVRR01', '2007-12-09'),
       (6, 'Gómez', 'Gutiérrez', 'Oscar', 16,
        'M', 'GOGU091025NLHMMR04', '2009-10-25'),
       (6, 'Vargas', 'Aguilar', 'Camila', 17,
        'F', 'VAAC080612NLMRRG09', '2008-06-12'),
       (6, 'Fuentes', 'Salinas', 'Ricardo', 18,
        'M', 'FUSR071018NLHNNS06', '2007-10-18'),
       (6, 'Aguilar', 'Medina', 'Lucía', 16,
        'F', 'AGML091113NLMGLL07', '2009-11-13'),
       (6, 'Salinas', 'Lozano', 'Fernando', 17,
        'M', 'SALF080724NLHLLN03', '2008-07-24'),
       (6, 'Medina', 'Fuentes', 'Brenda', 18,
        'F', 'MEFB071108NLMDNN08', '2007-11-08'),
       (6, 'Lozano', 'Núñez', 'Luis', 16,
        'M', 'LONL091226NLHZNN02', '2009-12-26'),
       (6, 'Núñez', 'Ortiz', 'Vanessa', 17,
        'F', 'NUOV080319NLMNNR05', '2008-03-19');
```

### Técnica 7 — Diseño de Modas

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (7, 'Reyes', 'Silva', 'Gabriela', 17,
        'F', 'RESG080416NLMYYY04', '2008-04-16'),
       (7, 'Ortiz', 'Rivera', 'Jonathan', 18,
        'M', 'ORIJ071122NLHRRZ07', '2007-11-22'),
       (7, 'Cruz', 'Gómez', 'Pamela', 16,
        'F', 'CRGP091009NLMRZM02', '2009-10-09'),
       (7, 'Flores', 'Vargas', 'Sergio', 17,
        'M', 'FLVS080215NLHLLR09', '2008-02-15'),
       (7, 'Rivera', 'Fuentes', 'Daniela', 18,
        'F', 'RIFD071127NLMVRR05', '2007-11-27'),
       (7, 'Gómez', 'Aguilar', 'Tomás', 16,
        'M', 'GOAT091014NLHMMR01', '2009-10-14'),
       (7, 'Vargas', 'Salinas', 'Karla', 17,
        'F', 'VASK080821NLMRRG06', '2008-08-21'),
       (7, 'Delgado', 'Medina', 'Bryan', 18,
        'M', 'DEMB071106NLHLLG03', '2007-11-06'),
       (7, 'Castro', 'Lozano', 'Monserrat', 16,
        'F', 'CALM091219NLMSTR08', '2009-12-19'),
       (7, 'Morales', 'Núñez', 'Gerardo', 17,
        'M', 'MONG080523NLHRLS04', '2008-05-23'),
       (7, 'Ramos', 'Reyes', 'Alicia', 18,
        'F', 'RARA071011NLMMMS09', '2007-10-11'),
       (7, 'Díaz', 'Ortiz', 'Eduardo', 16,
        'M', 'DIOE091016NLHZZL07', '2009-10-16'),
       (7, 'Ibáñez', 'Cruz', 'Natalia', 17,
        'F', 'IBCN080623NLMBNN03', '2008-06-23'),
       (7, 'Gutiérrez', 'Flores', 'Axel', 18,
        'M', 'GUFA071110NLHTRL08', '2007-11-10'),
       (7, 'Torres', 'Hernández', 'Sofía', 16,
        'F', 'TOHS091022NLMRRR05', '2009-10-22'),
       (7, 'Pérez', 'Rodríguez', 'Emilio', 17,
        'M', 'PERI080309NLHRRM01', '2008-03-09'),
       (7, 'Sánchez', 'González', 'Victoria', 18,
        'F', 'SAGV071225NLMNNC04', '2007-12-25'),
       (7, 'Jiménez', 'Martínez', 'Luis', 16,
        'M', 'JIML091108NLHMMR02', '2009-11-08'),
       (7, 'Vega', 'Castillo', 'Patricia', 17,
        'F', 'VECP080714NLMGGR06', '2008-07-14'),
       (7, 'Morales', 'Espinoza', 'Hugo', 18,
        'M', 'MOEH071019NLHRLS09', '2007-10-19'),
       (7, 'Delgado', 'Sandoval', 'Cristina', 16,
        'F', 'DESC091117NLMLLG03', '2009-11-17'),
       (7, 'Castro', 'Guerrero', 'Javier', 17,
        'M', 'CAGJ080422NLHSTR07', '2008-04-22'),
       (7, 'Herrera', 'Mendoza', 'Renata', 18,
        'F', 'HEMR071213NLMRRR02', '2007-12-13'),
       (7, 'Ibarra', 'Peña', 'Diego', 16,
        'M', 'IBPD091004NLHBRR05', '2009-10-04'),
       (7, 'Espinoza', 'Ibarra', 'Adriana', 17,
        'F', 'EIIA080518NLMSPN01', '2008-05-18');
```

### Técnica 8 — Fisioterapia y Readaptación Físico Deportiva

```sql
INSERT INTO Alumno (idTecnica, PrimerApellido, SegundoApellido, Nombre, Edad,
                    Sexo, CURP, FechaNacimiento)
VALUES (8, 'Cervantes', 'García', 'Laura', 17,
        'F', 'CEGL080120NLMRRV04', '2008-01-20'),
       (8, 'Sandoval', 'Martínez', 'Javier', 18,
        'M', 'SAMJ071117NLHNDL08', '2007-11-17'),
       (8, 'Guerrero', 'González', 'Vanessa', 16,
        'F', 'GUEV091011NLMRRR05', '2009-10-11'),
       (8, 'Ibáñez', 'Rodríguez', 'Carlos', 17,
        'M', 'IBRC080318NLHBNN01', '2008-03-18'),
       (8, 'Espinoza', 'Hernández', 'Paola', 18,
        'F', 'EEHP071123NLMSPN06', '2007-11-23'),
       (8, 'Moreno', 'Torres', 'Alexis', 16,
        'M', 'MOTA091207NLHRRN09', '2009-12-07'),
       (8, 'Navarro', 'Pérez', 'Estefanía', 17,
        'F', 'NAPE080916NLMVRR03', '2008-09-16'),
       (8, 'Soto', 'Sánchez', 'Miguel', 18,
        'M', 'SOSM071102NLHTTS07', '2007-11-02'),
       (8, 'Castillo', 'Jiménez', 'Yesenia', 16,
        'F', 'CAJY091025NLMSLL02', '2009-10-25'),
       (8, 'Peña', 'Vega', 'Daniel', 17,
        'M', 'PEVD080513NLHNNR08', '2008-05-13'),
       (8, 'Valdez', 'Cruz', 'Lorena', 18,
        'F', 'VACL071219NLMLLZ04', '2007-12-19'),
       (8, 'Galván', 'Flores', 'Roberto', 16,
        'M', 'GAFR091103NLHLLV07', '2009-11-03'),
       (8, 'Téllez', 'Reyes', 'Adriana', 17,
        'F', 'TERA080407NLMLLR01', '2008-04-07'),
       (8, 'Romero', 'Delgado', 'Kevin', 18,
        'M', 'RODK071015NLHMMR06', '2007-10-15'),
       (8, 'Reséndez', 'Castro', 'Itzel', 16,
        'F', 'RECI091120NLMRRC03', '2009-11-20'),
       (8, 'García', 'Lozano', 'Sebastián', 17,
        'M', 'GALS080626NLHRRS09', '2008-06-26'),
       (8, 'López', 'Morales', 'Brenda', 18,
        'F', 'LOMB071209NLMPPG02', '2007-12-09'),
       (8, 'Martínez', 'Ramos', 'Eduardo', 16,
        'M', 'MARE091014NLHRRN07', '2009-10-14'),
       (8, 'González', 'Vargas', 'Pamela', 17,
        'F', 'GOVP080821NLMNZR05', '2008-08-21'),
       (8, 'Ramírez', 'Fuentes', 'Alan', 18,
        'M', 'RAFA071103NLHRMR01', '2007-11-03'),
       (8, 'Rodríguez', 'Aguilar', 'Cristina', 16,
        'F', 'ROAC091216NLMDRL08', '2009-12-16'),
       (8, 'Hernández', 'Salinas', 'Tomás', 17,
        'M', 'HEST080412NLHNNS03', '2008-04-12'),
       (8, 'García', 'Medina', 'Valeria', 18,
        'F', 'GAMV071026NLMRRR06', '2007-10-26'),
       (8, 'Torres', 'Cervantes', 'Diego', 16,
        'M', 'TOCD091118NLHRRR04', '2009-11-18'),
       (8, 'Pérez', 'Sandoval', 'Monserrat', 17,
        'F', 'PESM080305NLMRRM09', '2008-03-05');
```

---

## Verificación

Una vez ejecutados todos los pasos, confirma que los datos quedaron correctamente:

```sql
SELECT *
FROM Tecnica;
```

Deberías ver 8 técnicas con sus `idTecnica` del 1 al 8 y `Activo = 1` en todas.

```sql
SELECT *
FROM Alumno;
```

Deberías ver 200 registros. Verifica que la columna `idTecnica` varíe entre 1 y 8.

```sql
SELECT A.idAlumno, A.Nombre, A.PrimerApellido, T.Descripcion
FROM Alumno AS A
INNER JOIN Tecnica AS T ON A.idTecnica = T.idTecnica
ORDER BY T.Descripcion ASC;
```

Deberías ver 200 registros, cada uno con la descripción de su técnica correspondiente.
