# Operadores para definir los criterios de consulta

Los **operadores** construyen las condiciones de `WHERE` y `HAVING`: deciden qué filas o qué grupos se quedan en el resultado. Casi todos se vieron en Base de Datos I ([Consultas simples](../../../base-datos-1/temas/Etapa-3/06-ConsultasSimples.md)); aquí se repasan y se profundiza en `LIKE`, en la combinación de condiciones y en los errores con `NULL`.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](01-Clausulas.md#base-de-datos-de-los-ejemplos)).

---

## Los operadores

| Tipo | Operadores |
|------|------------|
| Comparación | `=`, `<>`, `>`, `<`, `>=`, `<=` |
| Lógicos | `AND`, `OR`, `NOT` |
| Rango | `BETWEEN ... AND ...` |
| Lista | `IN (...)` |
| Patrón | `LIKE` |
| Valor nulo | `IS NULL`, `IS NOT NULL` |

---

## Comparación

| Operador | Significa | Ejemplo |
|----------|-----------|---------|
| `=` | Igual | `Marca = 'Nissan'` |
| `<>` | Distinto | `Marca <> 'Nissan'` |
| `>` / `<` | Mayor / menor | `Anio > 2020` |
| `>=` / `<=` | Mayor o igual / menor o igual | `FechaIngreso >= '2026-04-18'` |

Los textos y las fechas van entre comillas simples. Las fechas se escriben en formato `'aaaa-mm-dd'`, que SQL Server interpreta igual sin importar el idioma del servidor.

```sql
SELECT idServicio, FechaIngreso, CostoServicio
FROM Servicio
WHERE FechaIngreso >= '2026-04-18'
```

| idServicio | FechaIngreso | CostoServicio |
|------------|--------------|---------------|
| 79 | 2026-04-20 | 3200.00 |

---

## BETWEEN

`BETWEEN a AND b` es un rango **incluyente**: equivale a `>= a AND <= b`.

```sql
SELECT idTipoServicio, Descripcion, Costo
FROM TipoServicio
WHERE Costo BETWEEN 850 AND 2500
```

| idTipoServicio | Descripcion | Costo |
|----------------|-------------|-------|
| 1 | Afinación | 850.00 |
| 3 | Revisión de frenos | 1200.00 |
| 4 | Suspensión | 2500.00 |

Afinación (850) y Suspensión (2500) aparecen porque los extremos se incluyen. `NOT BETWEEN` regresa lo contrario: Cambio de aceite, Diagnóstico computarizado y Cambio de llantas.

Con fechas, `BETWEEN` se usa para periodos. Los servicios de febrero:

```sql
SELECT COUNT(*) AS Servicios
FROM Servicio
WHERE FechaIngreso BETWEEN '2026-02-01' AND '2026-02-28'
```

| Servicios |
|-----------|
| 60 |

> Si la columna fuera `DATETIME` (con hora), `'2026-02-28'` significaría el 28 de febrero **a las 00:00**, y los servicios de ese día después de medianoche quedarían fuera. `FechaIngreso` es `DATE`, sin hora, así que aquí no hay ese problema.

---

## IN

`IN` compara contra una **lista** de valores. Sustituye a varios `OR` sobre la misma columna:

```sql
-- Estas dos condiciones son equivalentes
WHERE Marca = 'Nissan' OR Marca = 'Toyota' OR Marca = 'Honda'
WHERE Marca IN ('Nissan', 'Toyota', 'Honda')
```

```sql
SELECT Marca, COUNT(*) AS Vehiculos
FROM Vehiculo
WHERE Marca IN ('Nissan', 'Toyota', 'Honda')
GROUP BY Marca
```

| Marca | Vehiculos |
|-------|-----------|
| Honda | 17 |
| Nissan | 18 |
| Toyota | 17 |

`NOT IN` regresa los demás: 118 vehículos de otras marcas.

---

## LIKE

`LIKE` compara texto contra un **patrón**. El patrón usa comodines:

| Comodín | Significa | Ejemplo | Coincide con |
|---------|-----------|---------|--------------|
| `%` | Cero o más caracteres cualesquiera | `'Mar%'` | Mariana, Marco, Maricruz |
| `_` | Exactamente un carácter | `'_na'` | Ana |
| `[ ]` | Un carácter de la lista o del rango | `'[AEIOU]%'` | Aguilar, Elizondo, Ortiz |
| `[^ ]` | Un carácter que **no** esté en la lista | `'[^AEIOU]%'` | García, Hernández |

### Inicio, fin y contenido

| Patrón | Busca |
|--------|-------|
| `'A%'` | Que **empiece** con A |
| `'%a'` | Que **termine** con a |
| `'%ar%'` | Que **contenga** "ar" en cualquier parte |
| `'%@gmail.com'` | Correos de Gmail |

### Rangos y listas de caracteres

Los corchetes representan **una sola** posición. ¿Qué apellidos empiezan con vocal?

```sql
SELECT DISTINCT PrimerApellido
FROM Cliente
WHERE PrimerApellido LIKE '[AEIOU]%'
ORDER BY PrimerApellido
```

| PrimerApellido |
|----------------|
| Aguilar |
| Arizpe |
| Elizondo |
| Escamilla |
| Espinoza |
| Ibáñez |
| Ibarra |
| Ortiz |

Son 23 clientes; los otros 192 cumplen `LIKE '[^AEIOU]%'`. Entre corchetes también se pueden escribir rangos: `'[A-C]%'` busca nombres que empiecen con A, B o C, y `'%[0-9]%'` busca textos que contengan un dígito:

```sql
SELECT DISTINCT Modelo
FROM Vehiculo
WHERE Modelo LIKE '%[0-9]%'
ORDER BY Modelo
```

| Modelo |
|--------|
| CX-30 |
| CX-5 |
| F-150 |
| Grand i10 |
| Mazda2 |
| Mazda3 |
| NP300 |
| RAV4 |
| S10 |

### El guion bajo

`_` exige **exactamente** un carácter. `'_a%'` busca nombres cuya **segunda** letra sea "a": Camila, Daniel, Karla, Laura, Mariana, Natalia, Pablo, Valeria…

> En la configuración de SQL Server que se usa en el curso, `LIKE` no distingue mayúsculas de minúsculas: `'a%'` y `'A%'` regresan lo mismo.

---

## AND, OR y los paréntesis

`AND` se evalúa **antes** que `OR`, igual que la multiplicación antes que la suma. Por eso estas dos consultas no regresan lo mismo:

```sql
SELECT COUNT(*) AS Vehiculos
FROM Vehiculo
WHERE Marca = 'Nissan' OR Marca = 'Toyota' AND Anio >= 2021
```

| Vehiculos |
|-----------|
| 25 |

```sql
SELECT COUNT(*) AS Vehiculos
FROM Vehiculo
WHERE (Marca = 'Nissan' OR Marca = 'Toyota') AND Anio >= 2021
```

| Vehiculos |
|-----------|
| 13 |

La primera se lee "todos los Nissan (18), **o** los Toyota de 2021 en adelante (7)". La segunda, "los Nissan o Toyota, **y** que sean de 2021 en adelante" (6 Nissan y 7 Toyota). **Cuando se mezclan `AND` y `OR`, siempre se usan paréntesis**, aunque el resultado coincida: dejan clara la intención.

---

## IS NULL

`NULL` significa "sin valor" o "desconocido". No es cero ni texto vacío, y **no se puede comparar con `=`**:

```sql
-- INCORRECTO: nunca regresa filas, aunque haya NULL
WHERE SegundoApellido = NULL

-- CORRECTO
WHERE SegundoApellido IS NULL
```

La comparación `= NULL` no marca error: simplemente regresa 0 filas, y por eso es un error difícil de ver.

El uso más común de `IS NULL` es encontrar **ausencias** con `LEFT JOIN`, como en Base de Datos I. Los clientes que no tienen vehículo:

```sql
SELECT TOP 3 C.idCliente, C.Nombre, C.PrimerApellido
FROM Cliente AS C
LEFT JOIN Vehiculo AS V ON V.idCliente = C.idCliente
WHERE V.idVehiculo IS NULL
ORDER BY C.idCliente
```

| idCliente | Nombre | PrimerApellido |
|-----------|--------|----------------|
| 156 | Tomás | Gómez |
| 157 | Karla | Vargas |
| 158 | Bryan | Delgado |

Sin el `TOP 3` son 60 clientes.

---

## Resumen

- Los operadores de comparación, `BETWEEN`, `IN`, `LIKE` e `IS NULL` construyen las condiciones de `WHERE` y `HAVING`.
- `BETWEEN` incluye los dos extremos.
- `IN` sustituye a varios `OR` sobre la misma columna.
- En `LIKE`, `%` es cualquier cantidad de caracteres, `_` es uno solo, `[ ]` es uno de una lista o rango y `[^ ]` es uno que no esté en la lista.
- `AND` se evalúa antes que `OR`: al mezclarlos se usan paréntesis.
- `NULL` se busca con `IS NULL`, nunca con `= NULL`.
