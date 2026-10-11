# Consultas simples

Una **consulta simple** obtiene datos de **una sola tabla**. En [DML](02-DML.md) vimos lo básico: `SELECT`, `WHERE` con operadores de comparación, `AND`, `OR` y `ORDER BY`. Este tema completa todo lo que se usa en el curso para filtrar, ordenar y presentar resultados.

## Tablas de ejemplo

Todas las consultas de este tema usan la base de datos de **TecnoShop**, una tienda de artículos de cómputo, y se ejecutaron en SQL Server con estos datos.

**Cliente**

| idCliente | Nombre | PrimerApellido | Ciudad | CorreoElectronico | FechaRegistro |
|-----------|--------|----------------|--------|-------------------|---------------|
| 1 | Rosa | Leal | Monterrey | rosa.leal@gmail.com | 2025-11-04 |
| 2 | Iván | Soto | Guadalupe | NULL | 2026-01-15 |
| 3 | Mariana | Cantú | San Nicolás | mariana.cantu@hotmail.com | 2026-01-28 |
| 4 | Jorge | Medina | Monterrey | jorge.medina@gmail.com | 2026-02-10 |
| 5 | Martha | Ríos | Apodaca | NULL | 2026-03-03 |
| 6 | Luis | Garza | Guadalupe | luis.garza@outlook.com | 2026-03-21 |

**Producto**

| idProducto | Nombre | Categoria | Precio | Existencia |
|------------|--------|-----------|--------|------------|
| 1 | Mouse inalámbrico | Accesorios | 250.00 | 40 |
| 2 | Teclado mecánico | Accesorios | 1480.00 | 12 |
| 3 | Monitor 24 pulgadas | Monitores | 3200.00 | 8 |
| 4 | Monitor 27 pulgadas | Monitores | 5400.00 | 0 |
| 5 | Laptop 14 pulgadas | Laptops | 14999.00 | 5 |
| 6 | Memoria USB 64 GB | Almacenamiento | 189.00 | 75 |
| 7 | Disco SSD 1 TB | Almacenamiento | 1350.00 | 20 |
| 8 | Mousepad | Accesorios | 99.00 | 0 |

---

## Alias con AS

Un **alias** le da otro nombre a una columna o a una tabla **solo durante la consulta**. No cambia nada en la base de datos.

### Alias de columna

Sirve para que el resultado tenga encabezados más claros:

```sql
SELECT Nombre AS Producto, Precio AS PrecioUnitario
FROM Producto
WHERE Categoria = 'Monitores';
```

| Producto | PrecioUnitario |
|----------|----------------|
| Monitor 24 pulgadas | 3200.00 |
| Monitor 27 pulgadas | 5400.00 |

### Alias de tabla

Sirve para escribir menos. Después del alias, cada columna se escribe como `alias.columna`:

```sql
SELECT P.Nombre, P.Precio
FROM Producto AS P
WHERE P.Existencia = 0;
```

| Nombre | Precio |
|--------|--------|
| Monitor 27 pulgadas | 5400.00 |
| Mousepad | 99.00 |

En una consulta de una sola tabla es opcional; en las consultas multitabla es casi obligatorio (ver [INNER JOIN](../Etapa-4/02-INNER-JOIN.md)).

---

## Operadores de comparación

| Operador | Significado | Ejemplo |
|----------|-------------|---------|
| `=` | Igual | `Ciudad = 'Monterrey'` |
| `<>` o `!=` | Distinto | `Categoria <> 'Laptops'` |
| `>` / `<` | Mayor / menor que | `Precio > 1000` |
| `>=` / `<=` | Mayor o igual / menor o igual | `Existencia >= 10` |
| `!<` | No menor que (equivale a `>=`) | `Precio !< 3200` |
| `!>` | No mayor que (equivale a `<=`) | `Precio !> 3200` |

`!<` y `!>` vienen en el manual, pero son exclusivos de SQL Server; `>=` y `<=` dicen lo mismo y funcionan en cualquier motor.

---

## AND, OR y NOT

| Operador | Regresa la fila cuando… |
|----------|-------------------------|
| `AND` | Se cumplen **las dos** condiciones |
| `OR` | Se cumple **al menos una** |
| `NOT` | La condición **no** se cumple |

```sql
SELECT Nombre, Categoria
FROM Producto
WHERE NOT Categoria = 'Accesorios';
```

| Nombre | Categoria |
|--------|-----------|
| Monitor 24 pulgadas | Monitores |
| Monitor 27 pulgadas | Monitores |
| Laptop 14 pulgadas | Laptops |
| Memoria USB 64 GB | Almacenamiento |
| Disco SSD 1 TB | Almacenamiento |

### Paréntesis

Cuando se combinan `AND` y `OR`, SQL Server evalúa primero el `AND`. Usa **paréntesis** para decir exactamente qué quieres:

```sql
-- Accesorios que están agotados o que tienen muchas piezas
SELECT Nombre, Categoria, Existencia
FROM Producto
WHERE Categoria = 'Accesorios' AND (Existencia = 0 OR Existencia > 30);
```

| Nombre | Categoria | Existencia |
|--------|-----------|------------|
| Mouse inalámbrico | Accesorios | 40 |
| Mousepad | Accesorios | 0 |

Sin los paréntesis, SQL Server lee `(Categoria = 'Accesorios' AND Existencia = 0) OR Existencia > 30`, y el resultado incluye también la Memoria USB 64 GB: tiene 75 piezas, aunque no es accesorio.

---

## BETWEEN: rangos

`BETWEEN a AND b` regresa los valores **entre `a` y `b`, incluidos ambos extremos**. Equivale a `>= a AND <= b`.

```sql
SELECT Nombre, Precio
FROM Producto
WHERE Precio BETWEEN 1000 AND 5000
ORDER BY Precio;
```

| Nombre | Precio |
|--------|--------|
| Disco SSD 1 TB | 1350.00 |
| Teclado mecánico | 1480.00 |
| Monitor 24 pulgadas | 3200.00 |

También funciona con fechas:

```sql
SELECT Nombre, FechaRegistro
FROM Cliente
WHERE FechaRegistro BETWEEN '2026-01-01' AND '2026-02-28';
```

| Nombre | FechaRegistro |
|--------|---------------|
| Iván | 2026-01-15 |
| Mariana | 2026-01-28 |
| Jorge | 2026-02-10 |

> Si la columna es `DATETIME` (con hora), `BETWEEN '2026-01-01' AND '2026-02-28'` deja fuera lo que ocurrió el 28 de febrero **después de las 00:00**. Con `DATE` no hay ese problema.

---

## LIKE: patrones de texto

`LIKE` compara un texto contra un **patrón** con comodines:

| Comodín | Significa | Patrón | Coincide con |
|---------|-----------|--------|--------------|
| `%` | Cualquier cantidad de caracteres (incluso ninguno) | `'Mar%'` | Mariana, Martha, Mario |
| `_` | Exactamente **un** carácter | `'_uis'` | Luis |
| `[ ]` | Un carácter de la lista | `'[MR]%'` | lo que empieza con M o con R |
| `[^ ]` | Un carácter que **no** está en la lista | `'[^MR]%'` | lo que no empieza con M ni con R |

```sql
-- Empieza con "Mar"
SELECT Nombre, PrimerApellido
FROM Cliente
WHERE Nombre LIKE 'Mar%';
```

| Nombre | PrimerApellido |
|--------|----------------|
| Mariana | Cantú |
| Martha | Ríos |

```sql
-- Termina con "@gmail.com"
SELECT Nombre, CorreoElectronico
FROM Cliente
WHERE CorreoElectronico LIKE '%@gmail.com';
```

| Nombre | CorreoElectronico |
|--------|-------------------|
| Rosa | rosa.leal@gmail.com |
| Jorge | jorge.medina@gmail.com |

```sql
-- Contiene "monitor" en cualquier parte
SELECT Nombre
FROM Producto
WHERE Nombre LIKE '%monitor%';
```

| Nombre |
|--------|
| Monitor 24 pulgadas |
| Monitor 27 pulgadas |

> Con la configuración normal de SQL Server, `LIKE` **no distingue mayúsculas de minúsculas**: `'%monitor%'` encuentra "Monitor".

| Patrón | Se lee |
|--------|--------|
| `'A%'` | Empieza con A |
| `'%A'` | Termina con A |
| `'%A%'` | Contiene A |

---

## IN: lista de valores

`IN` regresa las filas cuyo valor está **en una lista**. Es una forma corta de escribir varios `OR`:

```sql
SELECT Nombre, Ciudad
FROM Cliente
WHERE Ciudad IN ('Guadalupe', 'Apodaca');
-- equivale a: WHERE Ciudad = 'Guadalupe' OR Ciudad = 'Apodaca'
```

| Nombre | Ciudad |
|--------|--------|
| Iván | Guadalupe |
| Martha | Apodaca |
| Luis | Guadalupe |

`NOT IN` regresa las que **no** están en la lista:

```sql
SELECT Nombre, Categoria
FROM Producto
WHERE Categoria NOT IN ('Accesorios', 'Monitores');
```

| Nombre | Categoria |
|--------|-----------|
| Laptop 14 pulgadas | Laptops |
| Memoria USB 64 GB | Almacenamiento |
| Disco SSD 1 TB | Almacenamiento |

---

## IS NULL: valores vacíos

`NULL` significa **"no hay dato"**. No es cero ni un texto vacío: es la ausencia de valor. Por eso **no se compara con `=`**, sino con `IS NULL`:

```sql
SELECT Nombre, PrimerApellido
FROM Cliente
WHERE CorreoElectronico IS NULL;
```

| Nombre | PrimerApellido |
|--------|----------------|
| Iván | Soto |
| Martha | Ríos |

Y lo contrario, con `IS NOT NULL`:

```sql
SELECT Nombre, CorreoElectronico
FROM Cliente
WHERE CorreoElectronico IS NOT NULL;
```

| Nombre | CorreoElectronico |
|--------|-------------------|
| Rosa | rosa.leal@gmail.com |
| Mariana | mariana.cantu@hotmail.com |
| Jorge | jorge.medina@gmail.com |
| Luis | luis.garza@outlook.com |

> **Error común:** `WHERE CorreoElectronico = NULL` no marca error, pero regresa **0 filas**, aunque haya correos vacíos. Siempre `IS NULL`.

`IS NULL` es también la base para encontrar registros **sin relación** en otra tabla, con `LEFT JOIN` (ver [LEFT JOIN y RIGHT JOIN](../Etapa-4/03-LEFT-RIGHT-JOIN.md)).

---

## ORDER BY con varias columnas

Se ordena por la primera columna; cuando hay empate, por la segunda, y así sucesivamente. Cada columna lleva su propio `ASC` o `DESC`:

```sql
SELECT Categoria, Nombre, Precio
FROM Producto
ORDER BY Categoria, Precio DESC;
```

| Categoria | Nombre | Precio |
|-----------|--------|--------|
| Accesorios | Teclado mecánico | 1480.00 |
| Accesorios | Mouse inalámbrico | 250.00 |
| Accesorios | Mousepad | 99.00 |
| Almacenamiento | Disco SSD 1 TB | 1350.00 |
| Almacenamiento | Memoria USB 64 GB | 189.00 |
| Laptops | Laptop 14 pulgadas | 14999.00 |
| Monitores | Monitor 27 pulgadas | 5400.00 |
| Monitores | Monitor 24 pulgadas | 3200.00 |

Las categorías van de la A a la Z (`ASC` es el orden por omisión), y dentro de cada categoría, del precio más alto al más bajo.

---

## TOP: los primeros N

`TOP n` regresa solo las primeras `n` filas. Casi siempre va con `ORDER BY`, para que "las primeras" signifique algo:

```sql
SELECT TOP 3 Nombre, Precio
FROM Producto
ORDER BY Precio DESC;
```

| Nombre | Precio |
|--------|--------|
| Laptop 14 pulgadas | 14999.00 |
| Monitor 27 pulgadas | 5400.00 |
| Monitor 24 pulgadas | 3200.00 |

> Sin `ORDER BY`, `TOP 3` regresa tres filas cualesquiera.

---

## Funciones de fecha: DAY, MONTH y YEAR

Extraen una parte de una fecha, como número:

| Función | Regresa | `'2026-03-21'` |
|---------|---------|----------------|
| `DAY(fecha)` | El día | `21` |
| `MONTH(fecha)` | El mes | `3` |
| `YEAR(fecha)` | El año | `2026` |

```sql
-- Clientes registrados en marzo de 2026
SELECT Nombre, FechaRegistro
FROM Cliente
WHERE MONTH(FechaRegistro) = 3 AND YEAR(FechaRegistro) = 2026;
```

| Nombre | FechaRegistro |
|--------|---------------|
| Martha | 2026-03-03 |
| Luis | 2026-03-21 |

> `MONTH(FechaRegistro) = 3` solo, sin el año, regresaría los marzos de **todos** los años.

---

## Concatenación con +

El operador `+` une textos. Para que no queden pegados, se agrega un espacio `' '` entre ellos:

```sql
SELECT Nombre + ' ' + PrimerApellido AS NombreCompleto, Ciudad
FROM Cliente
WHERE Ciudad = 'Monterrey';
```

| NombreCompleto | Ciudad |
|----------------|--------|
| Rosa Leal | Monterrey |
| Jorge Medina | Monterrey |

> Si alguna de las partes es `NULL`, todo el resultado es `NULL`: `'Rosa' + NULL` da `NULL`.

---

## Resumen

| Necesito… | Uso |
|-----------|-----|
| Otro nombre para una columna o tabla | `AS` |
| Un rango, incluidos los extremos | `BETWEEN a AND b` |
| Texto que empieza, termina o contiene algo | `LIKE` con `%` y `_` |
| Uno de varios valores | `IN (…)` |
| Lo contrario de una condición | `NOT`, `NOT IN`, `IS NOT NULL` |
| Filas sin dato | `IS NULL` (nunca `= NULL`) |
| Ordenar por varias columnas | `ORDER BY col1, col2 DESC` |
| Solo las primeras N filas | `TOP n` + `ORDER BY` |
| Parte de una fecha | `DAY()`, `MONTH()`, `YEAR()` |
| Unir textos | `+` |
