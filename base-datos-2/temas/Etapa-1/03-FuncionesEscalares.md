# Funciones escalares

Una **función escalar** recibe **un valor** y regresa **un valor**, fila por fila. Si una [función de agregado](02-FuncionesAgregado.md) convierte 200 filas en un número, una función escalar convierte 200 filas en 200 resultados: cada apellido en mayúsculas, cada fecha con otro formato, cada precio redondeado.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](01-Clausulas.md#base-de-datos-de-los-ejemplos)).

| | Función de agregado | Función escalar |
|---|---|---|
| Recibe | Muchas filas | Un valor de una fila |
| Regresa | Un valor por grupo | Un valor por fila |
| Ejemplos | `COUNT`, `SUM`, `AVG` | `UPPER`, `LEN`, `ROUND` |

---

## Los nombres del manual y los de SQL Server

El manual del curso presenta algunas funciones con los nombres que usa **Microsoft Access**. En SQL Server esos nombres no existen y marcan error. Esta es la equivalencia:

| En el manual | En SQL Server | Qué hace |
|--------------|---------------|----------|
| `UCASE()` | `UPPER()` | Convierte a mayúsculas |
| `LCASE()` | `LOWER()` | Convierte a minúsculas |
| `MID()` | `SUBSTRING()` | Extrae una parte del texto |
| `LEN()` | `LEN()` | Cuenta los caracteres |
| `ROUND()` | `ROUND()` | Redondea un número |
| `NOW()` | `GETDATE()` | Fecha y hora actuales |
| `FORMAT()` | `FORMAT()` | Da formato a un número o una fecha |

---

## Funciones de texto

| Función | Qué hace | Ejemplo | Resultado |
|---------|----------|---------|-----------|
| `UPPER(texto)` | Mayúsculas | `UPPER('García')` | `GARCÍA` |
| `LOWER(texto)` | Minúsculas | `LOWER('Carlos')` | `carlos` |
| `LEN(texto)` | Número de caracteres | `LEN('Carlos')` | `6` |
| `SUBSTRING(texto, inicio, cantidad)` | Extrae `cantidad` caracteres desde la posición `inicio` (la primera es 1) | `SUBSTRING('8100000001', 1, 2)` | `81` |
| `LEFT(texto, n)` | Los primeros `n` caracteres | `LEFT('8100000001', 2)` | `81` |
| `RIGHT(texto, n)` | Los últimos `n` caracteres | `RIGHT('8100000001', 4)` | `0001` |
| `CHARINDEX(buscado, texto)` | Posición donde aparece `buscado` (0 si no aparece) | `CHARINDEX('@', 'ana@gmail.com')` | `4` |
| `REPLACE(texto, buscado, nuevo)` | Reemplaza todas las apariciones | `REPLACE('a-b-c', '-', '/')` | `a/b/c` |

```sql
SELECT TOP 3 idCliente, UPPER(PrimerApellido) AS Apellido, LOWER(Nombre) AS Nombre, LEN(Nombre) AS Letras
FROM Cliente
ORDER BY idCliente
```

| idCliente | Apellido | Nombre | Letras |
|-----------|----------|--------|--------|
| 1 | GARCÍA | carlos | 6 |
| 2 | HERNÁNDEZ | ana | 3 |
| 3 | RODRÍGUEZ | miguel | 6 |

```sql
SELECT TOP 3 Correo, CHARINDEX('@', Correo) AS PosicionArroba, REPLACE(Correo, '@gmail.com', '@taller.mx') AS Reemplazo
FROM Cliente
ORDER BY idCliente
```

| Correo | PosicionArroba | Reemplazo |
|--------|----------------|-----------|
| carlos.garcia@gmail.com | 14 | carlos.garcia@taller.mx |
| ana.hernandez@hotmail.com | 14 | ana.hernandez@hotmail.com |
| miguel.rodriguez@outlook.com | 17 | miguel.rodriguez@outlook.com |

`REPLACE` solo cambia el texto si lo encuentra: los correos que no son de Gmail quedan igual.

> `LEN` no cuenta los espacios **al final** del texto: `LEN('Hola  ')` regresa `4`.

---

## Concatenación

En SQL Server el texto se une con el operador `+`, como en Base de Datos I:

```sql
SELECT TOP 3 V.Marca + ' ' + V.Modelo + ' (' + CAST(V.Anio AS VARCHAR(4)) + ')' AS Vehiculo, UPPER(C.PrimerApellido) + ', ' + C.Nombre AS Duenio
FROM Vehiculo AS V
INNER JOIN Cliente AS C ON C.idCliente = V.idCliente
ORDER BY V.idVehiculo
```

| Vehiculo | Duenio |
|----------|--------|
| Nissan Versa (2020) | GARCÍA, Carlos |
| Chevrolet Spark (2018) | GARCÍA, Carlos |
| Volkswagen Vento (2019) | HERNÁNDEZ, Ana |

Hay dos reglas al concatenar:

1. **Los números se convierten antes.** `Anio` es `INT`: si se suma a un texto sin convertirlo, SQL Server intenta convertir el **texto** a número y falla (ver [CAST y CONVERT](#cast-y-convert)).
2. **Texto + `NULL` = `NULL`.** Si cualquier parte es `NULL`, todo el resultado es `NULL`. Para columnas que aceptan `NULL`, como `SegundoApellido`, se usa `ISNULL`:

```sql
SELECT TOP 3 idCliente, Nombre + ' ' + PrimerApellido + ' ' + ISNULL(SegundoApellido, '') AS NombreCompleto
FROM Cliente
ORDER BY idCliente
```

| idCliente | NombreCompleto |
|-----------|----------------|
| 1 | Carlos García López |
| 2 | Ana Hernández Ramírez |
| 3 | Miguel Rodríguez Silva |

`ISNULL(valor, reemplazo)` regresa `valor` si no es `NULL`, y `reemplazo` si lo es.

---

## Funciones numéricas

| Función | Qué hace | Ejemplo | Resultado |
|---------|----------|---------|-----------|
| `ROUND(numero, decimales)` | Redondea a `decimales` posiciones | `ROUND(1312.567, 2)` | `1312.570` |
| | Con `0`, al entero | `ROUND(1312.567, 0)` | `1313.000` |
| | Con negativos, a decenas, centenas… | `ROUND(1312.567, -2)` | `1300.000` |
| `ABS(numero)` | Valor absoluto | `ABS(-5)` | `5` |
| `CEILING(numero)` | Entero hacia arriba | `CEILING(4.1)` | `5` |
| `FLOOR(numero)` | Entero hacia abajo | `FLOOR(4.9)` | `4` |

`ROUND` redondea, pero **conserva** la cantidad de decimales del tipo original: el promedio de `CostoServicio` sigue mostrando seis decimales.

```sql
SELECT AVG(CostoServicio) AS Promedio, ROUND(AVG(CostoServicio), 0) AS Redondeado, CAST(AVG(CostoServicio) AS DECIMAL(10,2)) AS ConDosDecimales
FROM Servicio
```

| Promedio | Redondeado | ConDosDecimales |
|----------|------------|-----------------|
| 1312.500000 | 1313.000000 | 1312.50 |

Para mostrar exactamente dos decimales se usa `CAST(... AS DECIMAL(10,2))`.

---

## CAST y CONVERT

Las dos cambian un valor de un tipo de dato a otro:

```sql
CAST(valor AS tipo)
CONVERT(tipo, valor)
CONVERT(tipo, valor, estilo)
```

```sql
SELECT 'Año: ' + CAST(2022 AS VARCHAR(4)) AS ConCast, 'Año: ' + CONVERT(VARCHAR(4), 2022) AS ConConvert
```

| ConCast | ConConvert |
|---------|------------|
| Año: 2022 | Año: 2022 |

`CONVERT` acepta un tercer parámetro, el **estilo**, para convertir fechas a texto. El estilo `103` es el formato `dd/mm/aaaa`:

```sql
SELECT CONVERT(VARCHAR(10), FechaIngreso, 103) AS Fecha
FROM Servicio
WHERE idServicio = 1
```

| Fecha |
|-------|
| 05/01/2026 |

Si se concatena un número sin convertirlo:

```sql
SELECT 'Año: ' + 2022
```

```
Msg 245, Level 16, State 1
Conversion failed when converting the varchar value 'Año: ' to data type int.
```

---

## Funciones de fecha

`DAY()`, `MONTH()` y `YEAR()` se vieron en Base de Datos I. En Base de Datos II se agregan:

| Función | Qué hace | Ejemplo | Resultado |
|---------|----------|---------|-----------|
| `GETDATE()` | Fecha y hora actuales del servidor | `GETDATE()` | `2026-10-17 18:30:12.123` (depende del momento) |
| `DATEADD(parte, cantidad, fecha)` | Suma días, meses o años | `DATEADD(DAY, 30, '2026-01-05')` | `2026-02-04 00:00:00.000` |
| `DATEDIFF(parte, inicio, fin)` | Diferencia entre dos fechas | `DATEDIFF(DAY, '2026-01-05', '2026-05-01')` | `116` |
| `DATENAME(parte, fecha)` | Nombre de la parte de la fecha | `DATENAME(MONTH, '2026-01-05')` | `January` (depende del idioma del servidor) |

`parte` puede ser `DAY`, `MONTH` o `YEAR`, entre otras.

Si cada servicio tiene 30 días de garantía, ¿hasta cuándo vence?

```sql
SELECT TOP 3 idServicio, FechaIngreso, DATEADD(DAY, 30, FechaIngreso) AS FinGarantia
FROM Servicio
ORDER BY idServicio
```

| idServicio | FechaIngreso | FinGarantia |
|------------|--------------|-------------|
| 1 | 2026-01-05 | 2026-02-04 |
| 2 | 2026-01-05 | 2026-02-04 |
| 3 | 2026-01-06 | 2026-02-05 |

¿Cuántos años tiene cada vehículo?

```sql
SELECT TOP 2 idVehiculo, Marca, Modelo, Anio, YEAR(GETDATE()) - Anio AS Antiguedad
FROM Vehiculo
ORDER BY idVehiculo
```

| idVehiculo | Marca | Modelo | Anio | Antiguedad |
|------------|-------|--------|------|------------|
| 1 | Nissan | Versa | 2020 | 6 |
| 2 | Chevrolet | Spark | 2018 | 8 |

> Con `GETDATE()` el resultado depende del día en que se ejecuta. Estos se obtuvieron en 2026.

---

## FORMAT

`FORMAT(valor, formato)` convierte un número o una fecha en texto con el formato indicado. Con un tercer parámetro se indica la cultura (`'es-MX'`):

```sql
SELECT TOP 3 idServicio, FORMAT(FechaIngreso, 'dd/MM/yyyy') AS Fecha, FORMAT(CostoServicio, 'C', 'es-MX') AS Costo
FROM Servicio
ORDER BY idServicio
```

| idServicio | Fecha | Costo |
|------------|-------|-------|
| 1 | 05/01/2026 | $450.00 |
| 2 | 05/01/2026 | $850.00 |
| 3 | 06/01/2026 | $350.00 |

| Formato | Significado |
|---------|-------------|
| `dd`, `MM`, `yyyy` | Día, mes y año con dos, dos y cuatro dígitos (`MM` en mayúsculas: `mm` son minutos) |
| `C` | Moneda |
| `N2` | Número con separador de miles y dos decimales |

> `FORMAT` regresa **texto**. Úsalo solo para mostrar: si se ordena por una columna formateada, se ordena alfabéticamente (`'10/01/2026'` antes que `'15/12/2025'` y antes que `'20/01/2026'`).

---

## Funciones escalares dentro de otras cláusulas

Una función escalar puede ir en `WHERE`, `GROUP BY` y `ORDER BY`, no solo en el `SELECT`. ¿Cuántos clientes hay de cada proveedor de correo?

```sql
SELECT SUBSTRING(Correo, CHARINDEX('@', Correo) + 1, 50) AS Dominio, COUNT(*) AS Clientes
FROM Cliente
GROUP BY SUBSTRING(Correo, CHARINDEX('@', Correo) + 1, 50)
ORDER BY Clientes DESC, Dominio
```

| Dominio | Clientes |
|---------|----------|
| gmail.com | 54 |
| hotmail.com | 54 |
| outlook.com | 54 |
| yahoo.com.mx | 53 |

`CHARINDEX` encuentra la posición de la `@` y `SUBSTRING` toma lo que sigue.

---

## Resumen

- Una función escalar regresa un valor por cada fila.
- En SQL Server, `UCASE`, `LCASE`, `MID` y `NOW` del manual son `UPPER`, `LOWER`, `SUBSTRING` y `GETDATE`.
- Al concatenar con `+`, los números se convierten con `CAST` o `CONVERT`, y los `NULL` se reemplazan con `ISNULL`.
- `ROUND` redondea; `CAST(... AS DECIMAL(10,2))` fija los decimales que se muestran.
- `GETDATE`, `DATEADD` y `DATEDIFF` trabajan con la fecha actual y con intervalos.
- `FORMAT` regresa texto: sirve para mostrar, no para ordenar ni calcular.
