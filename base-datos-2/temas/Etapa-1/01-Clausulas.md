# Cláusulas SQL

Una consulta se arma con **cláusulas**: cada una hace un trabajo distinto sobre los datos. En Base de Datos I se vieron `SELECT`, `FROM`, `WHERE` y `ORDER BY` (ver [Consultas simples](../../../base-datos-1/temas/Etapa-3/06-ConsultasSimples.md)). En Base de Datos II se agregan tres: `DISTINCT`, `GROUP BY` y `HAVING`.

## Base de datos de los ejemplos

Todos los ejemplos de las etapas 1, 2 y 3 usan **AutoFixDB**, el taller mecánico que se instala en la [sesión 11](../../sesiones/sesion-11/AutoFixDB). Se ejecutaron en SQL Server sobre una instalación limpia; los resultados que se muestran son los reales.

| Tabla | Qué guarda | Registros |
|-------|------------|-----------|
| `Cliente` | Dueños de los vehículos | 215 |
| `TipoServicio` | Catálogo de servicios, con su costo actual | 6 |
| `Vehiculo` | Vehículos de cada cliente | 170 |
| `Servicio` | Cada servicio que se le hizo a un vehículo, con el costo que se cobró | 200 |

---

## Las cláusulas de una consulta

| Cláusula | Qué hace | ¿Obligatoria? |
|----------|----------|---------------|
| `SELECT` | Indica qué columnas o cálculos se muestran | Sí |
| `FROM` | Indica de qué tabla o tablas salen los datos | Sí, si se leen tablas |
| `WHERE` | Filtra **filas** antes de agrupar | No |
| `GROUP BY` | Junta en un solo renglón las filas que tienen el mismo valor | No |
| `HAVING` | Filtra **grupos** después de agrupar | No |
| `ORDER BY` | Ordena el resultado | No |

Se escriben siempre en este orden:

```sql
SELECT columnas
FROM tabla
WHERE condicion_sobre_filas
GROUP BY columnas_de_agrupacion
HAVING condicion_sobre_grupos
ORDER BY columnas_de_orden
```

### El orden en que SQL Server las procesa

El orden en que se **escriben** no es el orden en que se **ejecutan**. SQL Server las procesa así:

```
1. FROM       → toma las tablas (y sus JOIN)
2. WHERE      → descarta las filas que no cumplen la condición
3. GROUP BY   → junta las filas restantes en grupos
4. HAVING     → descarta los grupos que no cumplen la condición
5. SELECT     → calcula las columnas y los alias
6. ORDER BY   → ordena el resultado
```

Este orden explica dos reglas que se usan todo el tiempo:

- En `WHERE` **no** se puede usar una función de agregado (`COUNT`, `SUM`…): cuando corre `WHERE`, todavía no hay grupos que contar. Para filtrar por un conteo o una suma se usa `HAVING`.
- En `ORDER BY` **sí** se puede usar el alias definido en el `SELECT`, porque `ORDER BY` corre después. En `WHERE` y en `HAVING`, no.

---

## DISTINCT

`DISTINCT` elimina las filas repetidas del resultado. Se escribe inmediatamente después de `SELECT`.

La tabla `Vehiculo` tiene 170 vehículos, pero solo 10 marcas distintas:

```sql
SELECT DISTINCT Marca
FROM Vehiculo
ORDER BY Marca
```

| Marca |
|-------|
| Chevrolet |
| Ford |
| Honda |
| Hyundai |
| Kia |
| Mazda |
| Nissan |
| Seat |
| Toyota |
| Volkswagen |

Con más de una columna, `DISTINCT` elimina las filas en las que **todas** las columnas se repiten. Hay 18 vehículos Nissan, pero solo 4 combinaciones de marca y modelo:

```sql
SELECT DISTINCT Marca, Modelo
FROM Vehiculo
WHERE Marca = 'Nissan'
```

| Marca | Modelo |
|-------|--------|
| Nissan | March |
| Nissan | NP300 |
| Nissan | Sentra |
| Nissan | Versa |

> `DISTINCT` responde "¿qué valores hay?". Si la pregunta es "¿cuántos hay de cada uno?", se usa `GROUP BY`.

---

## GROUP BY

`GROUP BY` junta en **un solo renglón** todas las filas que tienen el mismo valor en una o más columnas. Casi siempre se usa con una [función de agregado](02-FuncionesAgregado.md), que calcula un valor por cada grupo.

¿Cuántos vehículos hay de cada marca?

```sql
SELECT Marca, COUNT(*) AS Vehiculos
FROM Vehiculo
GROUP BY Marca
ORDER BY Vehiculos DESC
```

| Marca | Vehiculos |
|-------|-----------|
| Nissan | 18 |
| Toyota | 17 |
| Volkswagen | 17 |
| Chevrolet | 17 |
| Ford | 17 |
| Honda | 17 |
| Hyundai | 17 |
| Kia | 17 |
| Mazda | 17 |
| Seat | 16 |

Visualmente, `GROUP BY` hace esto:

```
Vehiculo (170 filas)                 Resultado (10 filas)
┌────────────┬───────────┐           ┌────────────┬───────────┐
│ Nissan     │ Versa     │──┐        │ Marca      │ Vehiculos │
│ Nissan     │ Sentra    │──┼──────► │ Nissan     │ 18        │
│ ... 16 más │           │──┘        │ Toyota     │ 17        │
│ Toyota     │ Yaris     │──┐        │ ...        │           │
│ ... 16 más │           │──┴──────► │            │           │
└────────────┴───────────┘           └────────────┴───────────┘
```

### Agrupar con JOIN

El agrupamiento funciona igual sobre tablas combinadas. ¿Cuántos servicios se han hecho de cada tipo y cuánto han dejado?

```sql
SELECT T.Descripcion, COUNT(*) AS Servicios, SUM(S.CostoServicio) AS Ingreso
FROM Servicio AS S
INNER JOIN TipoServicio AS T ON T.idTipoServicio = S.idTipoServicio
GROUP BY T.Descripcion
ORDER BY Ingreso DESC
```

| Descripcion | Servicios | Ingreso |
|-------------|-----------|---------|
| Cambio de llantas | 28 | 89600.00 |
| Suspensión | 29 | 72500.00 |
| Revisión de frenos | 31 | 37200.00 |
| Afinación | 40 | 34000.00 |
| Cambio de aceite | 40 | 18000.00 |
| Diagnóstico computarizado | 32 | 11200.00 |

### Agrupar por un cálculo

Se puede agrupar por el resultado de una función. ¿Cuántos servicios hubo cada mes?

```sql
SELECT MONTH(FechaIngreso) AS Mes, COUNT(*) AS Servicios, SUM(CostoServicio) AS Ingreso
FROM Servicio
GROUP BY MONTH(FechaIngreso)
ORDER BY Mes
```

| Mes | Servicios | Ingreso |
|-----|-----------|---------|
| 1 | 57 | 71100.00 |
| 2 | 60 | 79900.00 |
| 3 | 56 | 73650.00 |
| 4 | 27 | 37850.00 |

> En `GROUP BY` se repite la expresión completa (`MONTH(FechaIngreso)`), no el alias `Mes`: cuando corre `GROUP BY`, el alias todavía no existe.

### La regla de oro de GROUP BY

**Toda columna del `SELECT` que no esté dentro de una función de agregado debe aparecer en el `GROUP BY`.**

```sql
-- INCORRECTO: Modelo no está en el GROUP BY ni dentro de una función de agregado
SELECT Marca, Modelo, COUNT(*) AS Vehiculos
FROM Vehiculo
GROUP BY Marca
```

```
Msg 8120, Level 16, State 1
Column 'Vehiculo.Modelo' is invalid in the select list because it is not contained
in either an aggregate function or the GROUP BY clause.
```

El error tiene sentido: el grupo "Nissan" tiene 4 modelos distintos y SQL Server no sabe cuál de ellos mostrar en el único renglón del grupo. Hay dos formas de corregirlo, según la pregunta:

```sql
-- Contar por marca: se quita Modelo
SELECT Marca, COUNT(*) AS Vehiculos
FROM Vehiculo
GROUP BY Marca

-- Contar por marca y modelo: Modelo se agrega al GROUP BY
SELECT Marca, Modelo, COUNT(*) AS Vehiculos
FROM Vehiculo
GROUP BY Marca, Modelo
```

---

## HAVING

`HAVING` filtra **grupos**, igual que `WHERE` filtra filas. Se escribe después de `GROUP BY` y su condición normalmente usa una función de agregado.

¿Qué tipos de servicio se han hecho 35 veces o más?

```sql
SELECT T.Descripcion, COUNT(*) AS Servicios
FROM Servicio AS S
INNER JOIN TipoServicio AS T ON T.idTipoServicio = S.idTipoServicio
GROUP BY T.Descripcion
HAVING COUNT(*) >= 35
```

| Descripcion | Servicios |
|-------------|-----------|
| Afinación | 40 |
| Cambio de aceite | 40 |

### WHERE y HAVING en la misma consulta

| | `WHERE` | `HAVING` |
|---|---|---|
| Filtra | Filas | Grupos |
| Se ejecuta | Antes de agrupar | Después de agrupar |
| Puede usar `COUNT`, `SUM`, etc. | No | Sí |

Las dos pueden ir juntas. ¿Qué marcas tienen 10 o más vehículos de modelo 2020 en adelante?

```sql
SELECT Marca, COUNT(*) AS Vehiculos
FROM Vehiculo
WHERE Anio >= 2020
GROUP BY Marca
HAVING COUNT(*) >= 10
ORDER BY Vehiculos DESC
```

| Marca | Vehiculos |
|-------|-----------|
| Hyundai | 12 |
| Kia | 11 |
| Mazda | 11 |
| Toyota | 11 |
| Honda | 10 |
| Seat | 10 |

Paso a paso: `WHERE` deja solo los vehículos de 2020 en adelante, `GROUP BY` los junta por marca y `HAVING` descarta las marcas con menos de 10. Nissan tiene 18 vehículos en total, pero no aparece: menos de 10 de ellos son de 2020 en adelante.

---

## Errores comunes

### Usar una función de agregado en WHERE

```sql
-- INCORRECTO
SELECT Marca, COUNT(*) AS Vehiculos
FROM Vehiculo
WHERE COUNT(*) >= 17
GROUP BY Marca
```

```
Msg 147, Level 15, State 1
An aggregate may not appear in the WHERE clause unless it is in a subquery contained
in a HAVING clause or a select list, and the column being aggregated is an outer reference.
```

La condición sobre el conteo va en `HAVING COUNT(*) >= 17`.

### Usar el alias en HAVING

```sql
-- INCORRECTO: el alias Vehiculos no existe todavía cuando corre HAVING
HAVING Vehiculos >= 17

-- CORRECTO
HAVING COUNT(*) >= 17
```

---

## Resumen

- Las cláusulas se escriben en el orden `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, pero se ejecutan `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `SELECT`, `ORDER BY`.
- `DISTINCT` quita las filas repetidas del resultado.
- `GROUP BY` junta en un renglón las filas con el mismo valor; se usa con funciones de agregado.
- Toda columna del `SELECT` que no esté en una función de agregado debe ir en el `GROUP BY`.
- `WHERE` filtra filas antes de agrupar; `HAVING` filtra grupos después de agrupar.
