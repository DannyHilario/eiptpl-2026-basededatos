# Vistas

Una **vista** es una consulta guardada en la base de datos con un nombre. Se consulta como si fuera una tabla, pero **no guarda datos**: cada vez que se usa, SQL Server ejecuta la consulta que la define y regresa los datos actuales de las tablas.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](01-Clausulas.md#base-de-datos-de-los-ejemplos)).

```
        Tablas (guardan los datos)                  Vista (guarda la consulta)
┌──────────┐ ┌──────────┐ ┌──────────────┐        ┌───────────────────────────┐
│ Servicio │ │ Vehiculo │ │ TipoServicio │ ─────► │ vw_ServicioDetalle        │
└──────────┘ └──────────┘ └──────────────┘        │ SELECT ... FROM Servicio  │
┌──────────┐                                      │ INNER JOIN ...            │
│ Cliente  │ ───────────────────────────────────► └───────────────────────────┘
└──────────┘
```

## ¿Para qué sirve?

| Ventaja | Ejemplo en AutoFixDB |
|---------|----------------------|
| **Simplifica** consultas que se repiten | Un `JOIN` de 4 tablas se escribe una vez; después basta `SELECT ... FROM vw_ServicioDetalle` |
| **Oculta** columnas o filas | Recepción ve nombre, teléfono y correo de los clientes activos, sin el resto de la tabla |
| **Da un nombre** a un cálculo de negocio | "Ingreso por tipo de servicio" queda como `vw_ResumenTipoServicio` |
| **Aísla** a quien consulta de la estructura | Si cambian las tablas, se ajusta la vista y las consultas que la usan siguen igual |

---

## Crear una vista

```sql
CREATE VIEW vw_NombreVista
AS
SELECT columnas
FROM tablas
WHERE condiciones
```

Las vistas se nombran con el prefijo `vw_`. Una vista que reúne cada servicio con su tipo, su vehículo y su cliente:

```sql
CREATE VIEW vw_ServicioDetalle
AS
SELECT S.idServicio, S.FechaIngreso, T.Descripcion AS TipoServicio, S.CostoServicio, V.Marca,
	V.Modelo, V.Anio, C.idCliente, C.Nombre + ' ' + C.PrimerApellido AS Cliente
FROM Servicio AS S
INNER JOIN TipoServicio AS T ON T.idTipoServicio = S.idTipoServicio
INNER JOIN Vehiculo AS V ON V.idVehiculo = S.idVehiculo
INNER JOIN Cliente AS C ON C.idCliente = V.idCliente
```

Reglas al crear una vista:

- **Cada columna necesita un nombre.** Una columna calculada (`C.Nombre + ' ' + C.PrimerApellido`) lleva alias; si no, SQL Server marca error.
- **No puede haber dos columnas con el mismo nombre.** Si dos tablas tienen una columna `Activo`, al menos una lleva alias.
- **No lleva `ORDER BY`.** El orden se pide al consultar la vista:

```
Msg 1033, Level 15, State 1
The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries,
and common table expressions, unless TOP, OFFSET or FOR XML is also specified.
```

- **`CREATE VIEW` debe ser la única sentencia de su lote.** En un script con más sentencias, va un `GO` antes y después del `CREATE VIEW`.

---

## Consultar una vista

Se consulta igual que una tabla:

```sql
SELECT TOP 5 idServicio, FechaIngreso, TipoServicio, CostoServicio, Cliente
FROM vw_ServicioDetalle
ORDER BY idServicio
```

| idServicio | FechaIngreso | TipoServicio | CostoServicio | Cliente |
|------------|--------------|--------------|---------------|---------|
| 1 | 2026-01-05 | Cambio de aceite | 450.00 | Ana Hernández |
| 2 | 2026-01-05 | Afinación | 850.00 | Daniela Jiménez |
| 3 | 2026-01-06 | Diagnóstico computarizado | 350.00 | Adriana Fuentes |
| 4 | 2026-01-07 | Revisión de frenos | 1200.00 | Valeria Torres |
| 5 | 2026-01-08 | Cambio de aceite | 450.00 | Iván Mendoza |

Sobre una vista funcionan `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY` y `JOIN`. ¿Qué clientes han gastado $5,000 o más en el taller?

```sql
SELECT Cliente, COUNT(*) AS Servicios, SUM(CostoServicio) AS TotalGastado
FROM vw_ServicioDetalle
GROUP BY idCliente, Cliente
HAVING SUM(CostoServicio) >= 5000
ORDER BY TotalGastado DESC
```

| Cliente | Servicios | TotalGastado |
|---------|-----------|--------------|
| Daniel Aguilar | 3 | 7250.00 |
| Carlos Vega | 2 | 6400.00 |
| Alejandro Ramírez | 4 | 5200.00 |
| Sergio Castro | 4 | 5200.00 |
| Erick Sánchez | 2 | 5000.00 |

Sin la vista, esta consulta necesitaría los tres `INNER JOIN`.

### Una vista con agrupación

Una vista también puede guardar un resumen. El ingreso de cada tipo de servicio, incluidos los que nunca se han hecho (por eso el `LEFT JOIN` y el `ISNULL`):

```sql
CREATE VIEW vw_ResumenTipoServicio
AS
SELECT T.idTipoServicio, T.Descripcion, COUNT(S.idServicio) AS Servicios, ISNULL(SUM(S.CostoServicio), 0) AS Ingreso
FROM TipoServicio AS T
LEFT JOIN Servicio AS S ON S.idTipoServicio = T.idTipoServicio
GROUP BY T.idTipoServicio, T.Descripcion
```

```sql
SELECT idTipoServicio, Descripcion, Servicios, Ingreso
FROM vw_ResumenTipoServicio
WHERE Ingreso > 30000
```

| idTipoServicio | Descripcion | Servicios | Ingreso |
|----------------|-------------|-----------|---------|
| 1 | Afinación | 40 | 34000.00 |
| 3 | Revisión de frenos | 31 | 37200.00 |
| 4 | Suspensión | 29 | 72500.00 |
| 6 | Cambio de llantas | 28 | 89600.00 |

El `WHERE Ingreso > 30000` funciona aunque `Ingreso` sea un `SUM`: dentro de la vista ya se calculó, y para quien la consulta es una columna más.

---

## Ver la definición de una vista

| Para… | Usa |
|-------|-----|
| Ver el código de una vista | `EXEC sp_helptext 'vw_ResumenTipoServicio'` |
| Listar las vistas de la base de datos | `SELECT name FROM sys.views` |
| Verla en SSMS | Explorador de objetos → la base de datos → **Vistas** → clic derecho → **Diseño** o **Generar script de vista como** |

---

## Modificar una vista: ALTER VIEW

`ALTER VIEW` reemplaza la definición completa de la vista. Se escribe la consulta **entera**, no solo lo que cambia:

```sql
CREATE VIEW vw_ClienteContacto
AS
SELECT idCliente, Nombre, PrimerApellido, Telefono, Correo
FROM Cliente
WHERE Activo = 1
```

```sql
-- Se agrega SegundoApellido: se vuelve a escribir toda la consulta
ALTER VIEW vw_ClienteContacto
AS
SELECT idCliente, Nombre, PrimerApellido, SegundoApellido, Telefono,
	Correo
FROM Cliente
WHERE Activo = 1
```

| idCliente | Nombre | PrimerApellido | SegundoApellido | Telefono | Correo |
|-----------|--------|----------------|-----------------|----------|--------|
| 1 | Carlos | García | López | 8100000001 | carlos.garcia@gmail.com |
| 2 | Ana | Hernández | Ramírez | 8100000002 | ana.hernandez@hotmail.com |

`ALTER VIEW` conserva los permisos que tenía la vista. Si en lugar de modificarla se elimina y se vuelve a crear, los permisos se pierden.

> **Cambiar el nombre.** Aunque existe `sp_rename`, el manual recomienda **eliminar** la vista y **crearla** con el nombre nuevo. En cualquiera de los dos casos, todo lo que usaba el nombre anterior (consultas, procedimientos, otras vistas) deja de funcionar hasta que se actualice.

---

## Eliminar una vista: DROP VIEW

```sql
DROP VIEW vw_ClienteContacto
```

Se elimina la definición de la vista; **los datos de las tablas no se tocan**. Si la vista no existe, marca error:

```
Msg 3701, Level 11, State 5
Cannot drop the view 'vw_ClienteContacto', because it does not exist or you do not have permission.
```

> Si se elimina una tabla con `DROP TABLE`, las vistas que la usaban **no** se eliminan solas: quedan rotas y se eliminan con `DROP VIEW`.

---

## Manipulación de datos a través de una vista

Una vista se puede usar en `INSERT`, `UPDATE` y `DELETE`. El cambio **no se guarda en la vista** (no guarda datos): se aplica a la **tabla base**.

```sql
UPDATE vw_ClienteContacto
SET Telefono = '8100000299'
WHERE idCliente = 215
```

```sql
SELECT idCliente, Nombre, Telefono
FROM Cliente
WHERE idCliente = 215
```

| idCliente | Nombre | Telefono |
|-----------|--------|----------|
| 215 | Lucía | 8100000299 |

La regla es que **cada sentencia puede afectar solo una tabla base**:

| Operación | Vista de una tabla | Vista de varias tablas |
|-----------|--------------------|------------------------|
| `UPDATE` | Sí | Solo si todas las columnas modificadas son de **la misma** tabla |
| `INSERT` | Sí, si las columnas que no están en la vista aceptan `NULL` o tienen `DEFAULT` | Solo si todas las columnas insertadas son de **la misma** tabla |
| `DELETE` | Sí | **No** |

En `vw_ServicioDetalle` (cuatro tablas), modificar solo `CostoServicio` funciona porque es columna de `Servicio`:

```sql
UPDATE vw_ServicioDetalle
SET CostoServicio = 460.00
WHERE idServicio = 1
```

Pero modificar a la vez una columna de `Servicio` y una de `Vehiculo`, o borrar una fila, no:

```sql
UPDATE vw_ServicioDetalle
SET CostoServicio = 500, Marca = 'Nissan'
WHERE idServicio = 1

DELETE FROM vw_ServicioDetalle
WHERE idServicio = 1
```

```
Msg 4405, Level 16, State 1
View or function 'vw_ServicioDetalle' is not updatable because the modification
affects multiple base tables.
```

Tampoco se pueden modificar columnas **calculadas** (`Cliente`, que es una concatenación) ni las de una vista con `GROUP BY` o funciones de agregado: no corresponden a una sola fila de una tabla.

### INSERT a través de una vista

```sql
INSERT INTO vw_ClienteContacto (Nombre, PrimerApellido, Telefono, Correo)
VALUES ('Prueba', 'Vista', '8100000300', 'prueba.vista@gmail.com')
```

| idCliente | Nombre | Activo |
|-----------|--------|--------|
| 216 | Prueba | 1 |

`Activo` no está en la vista, pero toma su `DEFAULT 1`; `idCliente` lo genera el `IDENTITY`. Si la tabla tuviera otra columna `NOT NULL` sin `DEFAULT` fuera de la vista, el `INSERT` fallaría.

> En AutoFixDB, este `INSERT` imprime `Registros correctamente insertados: 1`: el `INSERT` llega a la tabla `Cliente` y dispara sus [triggers](../Etapa-3/02-Triggers.md), igual que si se hubiera escrito sobre la tabla.

### Desde SSMS

El manual describe también la forma visual: Explorador de objetos → la base de datos → **Vistas** → clic derecho sobre la vista → **Editar las primeras 200 filas**. Ahí se modifican, insertan o eliminan filas directamente, con las mismas reglas: no se puede insertar ni eliminar si la vista usa más de una tabla base.

---

## Resumen

- Una vista es una consulta con nombre (prefijo `vw_`); no guarda datos, los lee de las tablas cada vez.
- Se crea con `CREATE VIEW`, se modifica con `ALTER VIEW` (escribiendo la consulta completa) y se elimina con `DROP VIEW`.
- Una vista no lleva `ORDER BY`; cada columna necesita un nombre único.
- Se consulta como una tabla: admite `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY` y `JOIN`.
- `INSERT`, `UPDATE` y `DELETE` a través de una vista modifican la tabla base, y solo pueden afectar **una** tabla base por sentencia; `DELETE` no funciona en vistas de varias tablas.
