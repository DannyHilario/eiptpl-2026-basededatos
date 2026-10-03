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
