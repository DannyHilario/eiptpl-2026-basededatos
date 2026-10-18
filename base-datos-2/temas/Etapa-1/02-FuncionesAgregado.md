# Funciones de agregado

Una **función de agregado** recibe **muchas filas** y regresa **un solo valor**: cuántas son, cuánto suman, cuál es la mayor. Son la base de cualquier reporte: "¿cuánto se vendió?", "¿cuál fue el servicio más caro?", "¿cuántos clientes hay?".

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](01-Clausulas.md#base-de-datos-de-los-ejemplos)).

---

## Las cinco funciones

| Función | Qué regresa | Tipos de columna |
|---------|-------------|------------------|
| `COUNT` | Cuántas filas hay | Cualquiera |
| `SUM` | La suma de los valores | Numéricos |
| `AVG` | El promedio de los valores | Numéricos |
| `MIN` | El valor más pequeño | Números, fechas y texto |
| `MAX` | El valor más grande | Números, fechas y texto |

Las cinco sobre la tabla `Servicio`:

```sql
SELECT COUNT(*) AS TotalServicios, SUM(CostoServicio) AS Ingreso, AVG(CostoServicio) AS Promedio, MIN(CostoServicio) AS Minimo, MAX(CostoServicio) AS Maximo
FROM Servicio
```

| TotalServicios | Ingreso | Promedio | Minimo | Maximo |
|----------------|---------|----------|--------|--------|
| 200 | 262500.00 | 1312.500000 | 350.00 | 3200.00 |

Sin `GROUP BY`, la función trabaja sobre **toda la tabla** (o sobre las filas que deja el `WHERE`) y el resultado es un solo renglón. Con `GROUP BY`, regresa un valor **por grupo** (ver [GROUP BY](01-Clausulas.md#group-by)).

---

## COUNT

`COUNT` tiene tres formas, y no cuentan lo mismo:

| Forma | Qué cuenta |
|-------|------------|
| `COUNT(*)` | Todas las filas |
| `COUNT(columna)` | Las filas en las que esa columna **no es `NULL`** |
| `COUNT(DISTINCT columna)` | Los valores distintos de la columna, sin contar `NULL` |

```sql
SELECT COUNT(DISTINCT Marca) AS Marcas, COUNT(DISTINCT idCliente) AS ClientesConVehiculo
FROM Vehiculo
```

| Marcas | ClientesConVehiculo |
|--------|---------------------|
| 10 | 155 |

Hay 215 clientes, pero solo 155 aparecen en `Vehiculo`: 60 clientes no tienen vehículo registrado.

### COUNT(*) contra COUNT(columna) en un LEFT JOIN

La diferencia importa con `LEFT JOIN`. Un cliente sin vehículos aparece **una vez**, con las columnas de `Vehiculo` en `NULL`:

```sql
SELECT C.idCliente, C.Nombre, COUNT(*) AS ConAsterisco, COUNT(V.idVehiculo) AS ConColumna
FROM Cliente AS C
LEFT JOIN Vehiculo AS V ON V.idCliente = C.idCliente
WHERE C.idCliente IN (1, 16, 200)
GROUP BY C.idCliente, C.Nombre
```

| idCliente | Nombre | ConAsterisco | ConColumna |
|-----------|--------|--------------|------------|
| 1 | Carlos | 2 | 2 |
| 16 | Carolina | 1 | 1 |
| 200 | Monserrat | 1 | **0** |

`COUNT(*)` dice que Monserrat tiene 1 vehículo porque cuenta la fila que agregó el `LEFT JOIN`. `COUNT(V.idVehiculo)` dice la verdad: esa fila tiene `idVehiculo` en `NULL` y no se cuenta. **Para contar los registros relacionados en un `LEFT JOIN`, se cuenta una columna de la tabla de la derecha.**

---

## SUM y AVG

`SUM` suma y `AVG` promedia. Las dos **ignoran los `NULL`**.

### AVG con enteros

Si la columna es entera (`INT`), `AVG` regresa un entero y **descarta los decimales**:

```sql
SELECT AVG(Anio) AS PromedioAnio, AVG(CAST(Anio AS DECIMAL(10,2))) AS PromedioExacto
FROM Vehiculo
```

| PromedioAnio | PromedioExacto |
|--------------|----------------|
| 2019 | 2019.905882 |

Para obtener el promedio con decimales, la columna se convierte antes con `CAST` (ver [Funciones escalares](03-FuncionesEscalares.md#cast-y-convert)).

### Cuando no hay filas

Si el `WHERE` no deja ninguna fila, `SUM`, `AVG`, `MIN` y `MAX` regresan `NULL`, y `COUNT` regresa `0`. No hay servicios en junio:

```sql
SELECT SUM(CostoServicio) AS Total, COUNT(*) AS Servicios
FROM Servicio
WHERE FechaIngreso >= '2026-06-01'
```

| Total | Servicios |
|-------|-----------|
| NULL | 0 |

Para mostrar `0` en lugar de `NULL` se usa `ISNULL(SUM(CostoServicio), 0)`. Este detalle se vuelve importante en las [funciones definidas por el usuario](../Etapa-3/01-FuncionesDefinidasUsuario.md), que deben regresar un número aunque no haya filas.

---

## MIN y MAX

Además de números, `MIN` y `MAX` funcionan con **fechas** (la más antigua y la más reciente) y con **texto** (el primero y el último en orden alfabético):

```sql
SELECT T.Descripcion, MIN(S.FechaIngreso) AS PrimerServicio, MAX(S.FechaIngreso) AS UltimoServicio
FROM Servicio AS S
INNER JOIN TipoServicio AS T ON T.idTipoServicio = S.idTipoServicio
GROUP BY T.Descripcion
ORDER BY T.Descripcion
```

| Descripcion | PrimerServicio | UltimoServicio |
|-------------|----------------|----------------|
| Afinación | 2026-01-05 | 2026-04-17 |
| Cambio de aceite | 2026-01-05 | 2026-04-16 |
| Cambio de llantas | 2026-01-09 | 2026-04-20 |
| Diagnóstico computarizado | 2026-01-06 | 2026-04-16 |
| Revisión de frenos | 2026-01-07 | 2026-04-15 |
| Suspensión | 2026-01-08 | 2026-04-17 |

```sql
SELECT MIN(PrimerApellido) AS Primero, MAX(PrimerApellido) AS Ultimo
FROM Cliente
```

| Primero | Ultimo |
|---------|--------|
| Aguilar | Zambrano |

---

## Errores comunes

### Mezclar columnas y funciones de agregado sin GROUP BY

```sql
-- INCORRECTO: MAX regresa un solo valor, pero hay 200 valores de idTipoServicio
SELECT idTipoServicio, MAX(CostoServicio)
FROM Servicio
```

SQL Server marca el error 8120. Si se quiere el máximo **por tipo**, se agrega `GROUP BY idTipoServicio`; si se quiere el máximo de toda la tabla, se quita `idTipoServicio`.

### Usar una función de agregado en WHERE

La condición sobre un conteo o una suma va en `HAVING`, no en `WHERE` (ver [HAVING](01-Clausulas.md#having)).

---

## Resumen

- `COUNT`, `SUM`, `AVG`, `MIN` y `MAX` reciben muchas filas y regresan un valor.
- `COUNT(*)` cuenta filas; `COUNT(columna)` no cuenta los `NULL`; `COUNT(DISTINCT columna)` cuenta valores distintos.
- En un `LEFT JOIN`, para contar los registros relacionados se cuenta una columna de la tabla de la derecha.
- `AVG` sobre una columna `INT` regresa un entero: para obtener decimales se usa `CAST`.
- Sin filas, `SUM`, `AVG`, `MIN` y `MAX` regresan `NULL`; `ISNULL(..., 0)` lo cambia por `0`.
