-- Tema:        CineDB - Sesión Final
-- Descripción: Colección de consultas de repaso que cubren los temas del curso
-- Autor:       Daniel Hilario

-- ============================================================
-- CONSULTA 01 — SELECT *
-- Ver todos los registros de una tabla completa.
-- Temas: SELECT *, FROM
-- ============================================================
SELECT *
FROM TipoSala

-- ============================================================
-- CONSULTA 02 — SELECT con columnas específicas y alias
-- Catálogo de películas activas mostrando solo las columnas
-- relevantes con nombres más descriptivos.
-- Temas: SELECT columnas, alias de columna (AS)
-- ============================================================
SELECT P.Nombre AS Pelicula, P.Director,
    P.AnioEstreno AS Año, P.Duracion AS DuracionMin
FROM Pelicula AS P
WHERE P.Activo = 1

-- ============================================================
-- CONSULTA 03 — WHERE con condición simple
-- Películas estrenadas exactamente en 2024.
-- Temas: WHERE con operador de igualdad (=)
-- ============================================================
SELECT P.Nombre AS Pelicula, P.Director,
    P.AnioEstreno AS Año
FROM Pelicula AS P
WHERE P.AnioEstreno = 2024

-- ============================================================
-- CONSULTA 04 — WHERE con AND
-- Películas activas estrenadas después de 2022 y con duración
-- mayor a 120 minutos.
-- Temas: WHERE con AND, operadores de comparación
-- ============================================================
SELECT P.Nombre AS Pelicula, P.Duracion AS DuracionMin,
    P.AnioEstreno AS Año
FROM Pelicula AS P
WHERE P.Activo = 1
    AND P.AnioEstreno > 2022
    AND P.Duracion > 120

-- ============================================================
-- CONSULTA 05 — WHERE con OR
-- Salas de tipo IMAX o VIP.
-- Temas: WHERE con OR
-- ============================================================
SELECT S.Nombre AS Sala, TS.Descripcion AS TipoSala,
    S.Capacidad, TS.Precio
FROM Sala AS S
    INNER JOIN TipoSala AS TS ON TS.idTipoSala = S.idTipoSala
WHERE TS.Descripcion = 'IMAX'
    OR TS.Descripcion = 'VIP'

-- ============================================================
-- CONSULTA 06 — WHERE con BETWEEN
-- Funciones programadas entre el 1 y el 15 de mayo de 2026.
-- Temas: WHERE con BETWEEN y fechas
-- ============================================================
SELECT F.idFuncion, F.Fecha, F.Hora,
    F.Precio, F.CantidadVendida
FROM Funcion AS F
WHERE F.Fecha BETWEEN '2026-05-01' AND '2026-05-15'
ORDER BY F.Fecha, F.Hora

-- ============================================================
-- CONSULTA 07 — WHERE con LIKE
-- Clientes cuyo primer apellido comienza con la letra G.
-- Temas: WHERE con LIKE y comodín %
-- ============================================================
SELECT C.PrimerApellido, C.SegundoApellido,
    C.Nombre, C.CorreoElectronico
FROM Cliente AS C
WHERE C.PrimerApellido LIKE 'G%'
ORDER BY C.PrimerApellido, C.Nombre

-- ============================================================
-- CONSULTA 08 — ORDER BY con múltiples columnas
-- Todas las funciones ordenadas primero por fecha y luego
-- por precio de mayor a menor.
-- Temas: ORDER BY ASC / DESC, múltiples criterios
-- ============================================================
SELECT F.idFuncion, F.Fecha, F.Hora,
    F.Precio, F.CantidadVendida
FROM Funcion AS F
ORDER BY F.Fecha ASC, F.Precio DESC

-- ============================================================
-- CONSULTA 09 — TOP
-- Las 5 salas con mayor capacidad.
-- Temas: TOP para limitar el número de filas devueltas
-- ============================================================
SELECT TOP 5 S.Nombre AS Sala, TS.Descripcion AS TipoSala,
    S.Capacidad
FROM Sala AS S
    INNER JOIN TipoSala AS TS ON TS.idTipoSala = S.idTipoSala
ORDER BY S.Capacidad DESC

-- ============================================================
-- CONSULTA 10 — INNER JOIN entre dos tablas
-- Cada película junto con el nombre de su género.
-- Temas: INNER JOIN, alias de tabla
-- ============================================================
SELECT P.Nombre AS Pelicula, G.Nombre AS Genero,
    P.Director, P.AnioEstreno AS Año
FROM Pelicula AS P
    INNER JOIN Genero AS G ON G.idGenero = P.idGenero
WHERE P.Activo = 1
ORDER BY G.Nombre, P.Nombre

-- ============================================================
-- CONSULTA 11 — INNER JOIN + WHERE
-- Boletos vendidos a un cliente específico, con el nombre
-- de la película de cada función.
-- Temas: INNER JOIN, WHERE para filtrar por clave
-- ============================================================
SELECT B.idBoleto, B.FechaPago,
    P.Nombre AS Pelicula, F.Fecha AS FechaFuncion,
    F.Precio
FROM Boleto AS B
    INNER JOIN Funcion AS F ON F.idFuncion = B.idFuncion
    INNER JOIN Pelicula AS P ON P.idPelicula = F.idPelicula
WHERE B.idCliente = 1
ORDER BY B.FechaPago

-- ============================================================
-- CONSULTA 12 — INNER JOIN entre tres tablas
-- Cada película con su género y su clasificación de edad.
-- Temas: INNER JOIN encadenado con tres tablas
-- ============================================================
SELECT P.Nombre AS Pelicula, G.Nombre AS Genero,
    C.Nombre AS Clasificacion, P.Director,
    P.AnioEstreno AS Año
FROM Pelicula AS P
    INNER JOIN Genero AS G ON G.idGenero = P.idGenero
    INNER JOIN Clasificacion AS C ON C.idClasificacion = P.idClasificacion
WHERE P.Activo = 1
ORDER BY C.Nombre, G.Nombre, P.Nombre

-- ============================================================
-- CONSULTA 13 — INNER JOIN entre cinco tablas
-- Detalle completo de cada función: sala, tipo de sala,
-- precio y película proyectada.
-- Temas: INNER JOIN encadenado con cinco tablas
-- ============================================================
SELECT F.idFuncion, P.Nombre AS Pelicula,
    S.Nombre AS Sala, TS.Descripcion AS TipoSala,
    F.Fecha, F.Hora, F.Precio
FROM Funcion AS F
    INNER JOIN Pelicula AS P ON P.idPelicula = F.idPelicula
    INNER JOIN Sala AS S ON S.idSala = F.idSala
    INNER JOIN TipoSala AS TS ON TS.idTipoSala = S.idTipoSala
    INNER JOIN Clasificacion AS CL ON CL.idClasificacion = P.idClasificacion
ORDER BY F.Fecha, F.Hora

-- ============================================================
-- CONSULTA 14 — INNER JOIN + WHERE + ORDER BY combinados
-- Funciones del mes de junio 2026 en salas 3D, ordenadas
-- por precio descendente.
-- Temas: INNER JOIN, WHERE con funciones de fecha y =, ORDER BY
-- ============================================================
SELECT F.idFuncion, P.Nombre AS Pelicula,
    S.Nombre AS Sala, F.Fecha, F.Hora, F.Precio
FROM Funcion AS F
    INNER JOIN Sala AS S ON S.idSala = F.idSala
    INNER JOIN TipoSala AS TS ON TS.idTipoSala = S.idTipoSala
    INNER JOIN Pelicula AS P ON P.idPelicula = F.idPelicula
WHERE TS.Descripcion = '3D'
    AND MONTH(F.Fecha) = 6
    AND YEAR(F.Fecha) = 2026
ORDER BY F.Precio DESC

-- ============================================================
-- CONSULTA 15 — LEFT JOIN: todos los registros del lado izquierdo
-- Todos los clientes con sus boletos comprados. Los clientes
-- sin boletos aparecen con NULL en las columnas de Boleto.
-- Temas: LEFT JOIN, NULL en columnas sin coincidencia
-- ============================================================
SELECT C.Nombre, C.PrimerApellido,
    B.idBoleto, B.FechaPago
FROM Cliente AS C
    LEFT JOIN Boleto AS B ON B.idCliente = C.idCliente
ORDER BY C.PrimerApellido, C.Nombre

-- ============================================================
-- CONSULTA 16 — LEFT JOIN + IS NULL: detectar sin relación
-- Clientes registrados que nunca han comprado un boleto.
-- Temas: LEFT JOIN + WHERE IS NULL para encontrar ausencias
-- ============================================================
SELECT C.idCliente, C.Nombre,
    C.PrimerApellido, C.CorreoElectronico
FROM Cliente AS C
    LEFT JOIN Boleto AS B ON B.idCliente = C.idCliente
WHERE B.idBoleto IS NULL
ORDER BY C.PrimerApellido, C.Nombre

-- ============================================================
-- CONSULTA 17 — RIGHT JOIN: todos los registros del lado derecho
-- Todas las películas con sus funciones programadas. Las películas
-- sin funciones aparecen con NULL en las columnas de Funcion.
-- Temas: RIGHT JOIN, NULL en columnas sin coincidencia
-- ============================================================
SELECT P.Nombre AS Pelicula, P.Director,
    F.idFuncion, F.Fecha, F.Hora
FROM Funcion AS F
    RIGHT JOIN Pelicula AS P ON F.idPelicula = P.idPelicula
WHERE P.Activo = 1
ORDER BY P.Nombre, F.Fecha

-- ============================================================
-- CONSULTA 18 — RIGHT JOIN + IS NULL: detectar sin relación
-- Películas del catálogo que aún no tienen funciones programadas.
-- Temas: RIGHT JOIN + WHERE IS NULL para encontrar ausencias
-- ============================================================
SELECT P.idPelicula, P.Nombre AS Pelicula,
    P.Director, P.AnioEstreno AS Año
FROM Funcion AS F
    RIGHT JOIN Pelicula AS P ON F.idPelicula = P.idPelicula
WHERE F.idFuncion IS NULL
    AND P.Activo = 1
ORDER BY P.Nombre

-- ============================================================
-- CONSULTA 19 — Funciones de fecha: MONTH y YEAR
-- Boletos comprados durante mayo de 2026, mostrando el nombre
-- del cliente y el precio pagado.
-- Temas: MONTH(), YEAR(), AND en WHERE
-- ============================================================
SELECT C.Nombre, C.PrimerApellido,
    B.FechaPago, F.Precio
FROM Boleto AS B
    INNER JOIN Cliente AS C ON C.idCliente = B.idCliente
    INNER JOIN Funcion AS F ON F.idFuncion = B.idFuncion
WHERE MONTH(B.FechaPago) = 5
    AND YEAR(B.FechaPago) = 2026
ORDER BY B.FechaPago

-- ============================================================
-- CONSULTA 20 — Concatenación de cadenas
-- Nombre completo del cliente en una sola columna, construido
-- uniendo tres campos de texto con el operador +.
-- Temas: concatenación con +, alias de columna
-- ============================================================
SELECT C.Nombre + ' ' + C.PrimerApellido
    + ' ' + C.SegundoApellido AS NombreCompleto,
    C.CorreoElectronico, C.Telefono
FROM Cliente AS C
WHERE C.Activo = 1
ORDER BY C.PrimerApellido, C.Nombre
