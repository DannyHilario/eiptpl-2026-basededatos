# Crear y ejecutar un procedimiento almacenado

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)).

---

## Sintaxis

```sql
CREATE PROCEDURE usp_nombreProcedimiento
	@p_Parametro1 tipo,
	@p_Parametro2 tipo = valor_por_defecto
AS
BEGIN

	-- instrucciones

END
```

| Parte | Qué es |
|-------|--------|
| `CREATE PROCEDURE` | Crea el procedimiento. También se puede escribir `CREATE PROC` |
| `usp_nombreProcedimiento` | El nombre, con prefijo `usp_` y en camelCase después del prefijo (`usp_insertarCliente`) |
| `@p_Parametro tipo` | Los parámetros que recibe, separados por comas. En el curso llevan el prefijo `@p_` para distinguirlos de las variables internas |
| `= valor_por_defecto` | Opcional: el valor que toma el parámetro si no se envía |
| `AS` | Separa el encabezado del cuerpo |
| `BEGIN ... END` | El cuerpo: las instrucciones que se ejecutan |

Como `CREATE VIEW`, **`CREATE PROCEDURE` debe ser la única sentencia de su lote**: en un script, va un `GO` antes. Todo lo que sigue al `AS` hasta el siguiente `GO` forma parte del procedimiento.

---

## Un procedimiento sin parámetros

```sql
CREATE PROCEDURE usp_obtenerTiposServicio
AS
BEGIN

	SELECT idTipoServicio, Descripcion, Costo
	FROM TipoServicio
	WHERE Activo = 1

END
```

Al ejecutar el `CREATE PROCEDURE`, SQL Server **no** ejecuta el `SELECT`: solo guarda el procedimiento y responde `Commands completed successfully`. El `SELECT` corre cada vez que alguien ejecuta el procedimiento.

---

## Ejecutar: EXEC

```sql
EXECUTE usp_obtenerTiposServicio
EXEC usp_obtenerTiposServicio
```

`EXECUTE` y `EXEC` son lo mismo.

---

## Parámetros

Un parámetro es un valor que se envía al procedimiento al ejecutarlo. Dentro del procedimiento se usa como una variable.

```sql
CREATE PROCEDURE usp_obtenerVehiculosCliente
	@p_idCliente int
AS
BEGIN

	SELECT idVehiculo, Marca, Modelo, Anio
	FROM Vehiculo
	WHERE idCliente = @p_idCliente

END
```

```sql
EXEC usp_obtenerVehiculosCliente 1
```

| idVehiculo | Marca | Modelo | Anio |
|------------|-------|--------|------|
| 1 | Nissan | Versa | 2020 |
| 2 | Chevrolet | Spark | 2018 |

Con un cliente sin vehículos, el procedimiento corre sin error y regresa la tabla vacía:

```sql
EXEC usp_obtenerVehiculosCliente 200
```

| idVehiculo | Marca | Modelo | Anio |
|------------|-------|--------|------|

Si no se envía un parámetro que no tiene valor por defecto, el procedimiento no se ejecuta:

```sql
EXEC usp_obtenerVehiculosCliente
```

```
Procedure or function 'usp_obtenerVehiculosCliente' expects parameter '@p_idCliente',
which was not supplied.
```

---

## Valores por defecto

Un parámetro con `= valor` es **opcional**: si no se envía, toma ese valor.

```sql
CREATE PROCEDURE usp_obtenerServiciosPeriodo
	@p_FechaInicio date,
	@p_FechaFin date = '2026-12-31'
AS
BEGIN

	SELECT idServicio, idVehiculo, FechaIngreso, CostoServicio
	FROM Servicio
	WHERE FechaIngreso BETWEEN @p_FechaInicio AND @p_FechaFin
	ORDER BY FechaIngreso, idServicio

END
```

Con los dos parámetros:

```sql
EXEC usp_obtenerServiciosPeriodo '2026-04-15', '2026-04-16'
```

| idServicio | idVehiculo | FechaIngreso | CostoServicio |
|------------|------------|--------------|---------------|
| 76 | 42 | 2026-04-15 | 1200.00 |
| 148 | 44 | 2026-04-15 | 3200.00 |
| 77 | 75 | 2026-04-16 | 450.00 |
| 149 | 78 | 2026-04-16 | 350.00 |

Solo con el primero, `@p_FechaFin` vale `'2026-12-31'`:

```sql
EXEC usp_obtenerServiciosPeriodo '2026-04-19'
```

| idServicio | idVehiculo | FechaIngreso | CostoServicio |
|------------|------------|--------------|---------------|
| 79 | 23 | 2026-04-20 | 3200.00 |

> Los parámetros con valor por defecto se colocan **al final** de la lista. Así se pueden omitir sin tener que nombrar los demás.

---

## Enviar los parámetros por posición o por nombre

| Forma | Ejemplo | Regla |
|-------|---------|-------|
| **Por posición** | `EXEC usp_obtenerServiciosPeriodo '2026-01-05', '2026-01-06'` | Los valores van en el mismo orden en que se declararon los parámetros |
| **Por nombre** | `EXEC usp_obtenerServiciosPeriodo @p_FechaFin = '2026-01-06', @p_FechaInicio = '2026-01-05'` | El orden no importa |

```sql
EXEC usp_obtenerServiciosPeriodo @p_FechaFin = '2026-01-06', @p_FechaInicio = '2026-01-05'
```

| idServicio | idVehiculo | FechaIngreso | CostoServicio |
|------------|------------|--------------|---------------|
| 1 | 3 | 2026-01-05 | 450.00 |
| 2 | 15 | 2026-01-05 | 850.00 |
| 3 | 27 | 2026-01-06 | 350.00 |

Por nombre es más fácil de leer cuando el procedimiento tiene muchos parámetros: `EXEC usp_insertarVehiculo @p_idCliente = 200, @p_Marca = 'Mazda', ...` deja claro qué es cada valor.

---

## Un procedimiento que modifica datos

Un procedimiento puede hacer `INSERT`, `UPDATE` y `DELETE`. [`usp_insertarCliente`](../../sesiones/sesion-11/AutoFixDB/instalacion/01-Cliente/03-usp-insertar.sql), de la sesión 11, inserta un cliente con los cinco datos que recibe:

```sql
EXEC usp_insertarCliente 'Garza', 'Leal', 'Mónica', '8100000220', 'monica.garza@gmail.com'
```

Lo que hace por dentro (validar y luego insertar) se ve en [Validaciones y códigos de salida](04-Validaciones.md).

---

## Errores comunes

### Crear un procedimiento que ya existe

```
Msg 2714, Level 16, State 3
There is already an object named 'usp_insertarVehiculo' in the database.
```

Para cambiar un procedimiento que ya existe se usa `ALTER PROCEDURE` (ver [Modificar y eliminar](05-ModificarEliminar.md)).

### Olvidar el GO antes del CREATE

Si antes del `CREATE PROCEDURE` hay otra sentencia en el mismo lote, SQL Server marca error: `'CREATE/ALTER PROCEDURE' must be the first statement in a query batch`.

### Escribir pruebas debajo del procedimiento sin GO

```sql
CREATE PROCEDURE usp_obtenerTiposServicio
AS
BEGIN
	SELECT idTipoServicio, Descripcion, Costo
	FROM TipoServicio
END

EXEC usp_obtenerTiposServicio   -- ¡queda DENTRO del procedimiento!
```

Sin un `GO` después del `END`, el `EXEC` se guarda como parte del procedimiento: cada vez que se ejecuta, se llama a sí mismo, hasta que SQL Server lo detiene en la llamada 32:

```
Msg 217, Level 16, State 1
Maximum stored procedure, function, trigger, or view nesting level exceeded (limit 32).
```

Las pruebas van después de un `GO`, o se ejecutan seleccionándolas aparte.

---

## Resumen

- `CREATE PROCEDURE usp_nombre` crea el procedimiento; crearlo no lo ejecuta.
- Se ejecuta con `EXEC` (o `EXECUTE`), seguido de los valores de sus parámetros.
- Los parámetros se declaran con `@p_Nombre tipo`; con `= valor` son opcionales y van al final.
- Los valores se envían por posición o por nombre (`@p_Nombre = valor`).
- `CREATE PROCEDURE` debe ser la primera sentencia de su lote: en un script, va un `GO` antes y otro después.
