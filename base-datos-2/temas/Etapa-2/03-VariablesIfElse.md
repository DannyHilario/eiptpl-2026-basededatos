# Variables e IF / ELSE

Para que un procedimiento almacenado **tome decisiones** ("si el cliente no existe, regresa un mensaje; si existe, inserta") se necesitan dos herramientas: **variables**, para guardar datos mientras el código corre, e **`IF`/`ELSE`**, para elegir qué instrucciones se ejecutan.

Estos temas pertenecen a la Etapa 4 del manual (*Introducción a la programación Transact-SQL*), pero se ven aquí porque todo procedimiento con validaciones los usa. En la Etapa 4 se profundiza en ellos.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)). Se pueden ejecutar tal cual en una ventana de consulta de SSMS, fuera de un procedimiento.

---

## Variables

Una **variable** es un espacio con nombre que guarda **un valor** mientras se ejecuta el código. En T-SQL su nombre empieza con `@`.

### Declarar: DECLARE

```sql
DECLARE @Marca varchar(50)
DECLARE @TotalVehiculos int
```

Varias variables se pueden declarar en un solo `DECLARE`, separadas por comas:

```sql
DECLARE @Marca varchar(50),
		@TotalVehiculos int
```

Cada variable tiene un **tipo de dato**, igual que una columna. Una variable recién declarada vale `NULL` hasta que se le asigna algo.

### Asignar: SET y SELECT

| Forma | Ejemplo | Cuándo se usa |
|-------|---------|---------------|
| En el `DECLARE` | `DECLARE @Marca varchar(50) = 'Nissan'` | Para darle un valor inicial |
| `SET` | `SET @Marca = 'Nissan'` | Para asignar **un** valor fijo o un cálculo |
| `SELECT` | `SELECT @Total = COUNT(*) FROM Vehiculo WHERE Marca = @Marca` | Para guardar un dato **que sale de una tabla**; puede asignar varias variables a la vez |

```sql
DECLARE @Marca varchar(50),
		@TotalVehiculos int

SET @Marca = 'Nissan'

SELECT
	@TotalVehiculos = COUNT(*)
FROM Vehiculo
WHERE Marca = @Marca

PRINT 'Vehículos ' + @Marca + ': ' + CONVERT(varchar(10), @TotalVehiculos)
SELECT @Marca AS Marca, @TotalVehiculos AS TotalVehiculos
```

En la pestaña **Mensajes**:

```
Vehículos Nissan: 18
```

En la pestaña **Resultados**:

| Marca | TotalVehiculos |
|-------|----------------|
| Nissan | 18 |

Un `SELECT` que **asigna** variables no muestra nada en Resultados: solo guarda los valores. Un `SELECT` que no asigna (`SELECT @Marca AS Marca`) sí los muestra.

### Mostrar: PRINT y SELECT

| | `PRINT` | `SELECT` |
|---|---|---|
| Dónde aparece | Pestaña **Mensajes** | Pestaña **Resultados**, como tabla |
| Qué muestra | Un solo texto | Una o varias columnas |
| Uso típico | Mensajes de seguimiento mientras se prueba | Lo que el procedimiento regresa a quien lo llama |

### Asignar varias variables con un SELECT

```sql
DECLARE @Servicios int,
		@Ingreso decimal(12,2)

SELECT
	@Servicios = COUNT(*), @Ingreso = SUM(CostoServicio)
FROM Servicio
WHERE MONTH(FechaIngreso) = 4

SELECT @Servicios AS Servicios, @Ingreso AS Ingreso
```

| Servicios | Ingreso |
|-----------|---------|
| 27 | 37850.00 |

### Lo que hay que saber de la asignación con SELECT

**1. Si el `SELECT` no encuentra filas, la variable conserva el valor que tenía.**

```sql
DECLARE @Nombre varchar(100)
SET @Nombre = 'Sin asignar'

SELECT
	@Nombre = Nombre
FROM Cliente
WHERE idCliente = 9999

PRINT @Nombre
```

```
Sin asignar
```

No existe el cliente 9999, así que el `SELECT` no asignó nada. **Esta es la base de las validaciones**: se declara la variable (vale `NULL`), se intenta llenar con un `SELECT ... WHERE`, y si sigue en `NULL` es que no se encontró el dato (ver [Validaciones y códigos de salida](04-Validaciones.md)).

**2. Si el `SELECT` encuentra varias filas, la variable se queda con una de ellas.**

```sql
DECLARE @Ultimo varchar(100)

SELECT
	@Ultimo = Nombre
FROM Cliente
WHERE idCliente IN (1, 2, 3)

PRINT @Ultimo
```

```
Miguel
```

Una variable guarda un solo valor: SQL Server la sobrescribe con cada fila y se queda con la última que leyó, sin garantizar cuál es. Para asignar, el `WHERE` debe identificar **una** fila (por su llave primaria, por un valor `UNIQUE`) o usarse una función de agregado.

### Concatenar variables

Las mismas reglas de la [concatenación](../Etapa-1/03-FuncionesEscalares.md#concatenación):

```sql
DECLARE @Total int = 18
PRINT 'Total: ' + @Total
```

```
Msg 245, Level 16, State 1
Conversion failed when converting the varchar value 'Total: ' to data type int.
```

Se corrige con `CONVERT(varchar(10), @Total)`. Y si una variable vale `NULL`, todo el texto queda en `NULL`: `PRINT` no imprime nada.

### Alcance: una variable vive dentro de su lote

Una variable existe desde su `DECLARE` hasta el final del **lote** (hasta el siguiente `GO`) o, dentro de un procedimiento, hasta su `END`.

```sql
DECLARE @Marca varchar(50) = 'Nissan'
GO
PRINT @Marca
```

```
Msg 137, Level 15, State 2
Must declare the scalar variable "@Marca".
```

### Parámetros y variables

Dentro de un procedimiento, los **parámetros** también son variables: se usan igual, pero su valor llega desde el `EXEC`. En el curso se distinguen por el nombre:

| | Parámetro | Variable interna |
|---|---|---|
| Se declara | En el encabezado del procedimiento | Con `DECLARE`, dentro del `BEGIN ... END` |
| Recibe su valor | Del `EXEC` | De un `SET` o un `SELECT` |
| Nombre en el curso | `@p_idCliente` | `@idClienteExistente`, `@ErrCodigo` |

---

## IF / ELSE

`IF` evalúa una condición. Si es verdadera, ejecuta su bloque; si es falsa y hay `ELSE`, ejecuta el bloque del `ELSE`.

```sql
IF condicion BEGIN

	-- instrucciones si la condición es verdadera

END
ELSE BEGIN

	-- instrucciones si la condición es falsa

END
```

La condición se escribe con los mismos [operadores](../Etapa-1/04-Operadores.md) del `WHERE`: `=`, `<>`, `>`, `AND`, `OR`, `NOT`, `BETWEEN`, `IN`, `IS NULL`…

```sql
DECLARE @Ingreso decimal(12,2)

SELECT
	@Ingreso = SUM(CostoServicio)
FROM Servicio
WHERE MONTH(FechaIngreso) = 4

IF @Ingreso >= 50000 BEGIN

	PRINT 'Meta cumplida'

END
ELSE BEGIN

	PRINT 'Faltan ' + CONVERT(varchar(20), 50000 - @Ingreso) + ' para la meta'

END
```

```
Faltan 12150.00 para la meta
```

### Siempre con BEGIN y END

Sin `BEGIN ... END`, el `IF` controla **solo la siguiente instrucción**. La sangría no cuenta:

```sql
DECLARE @Costo decimal(10,2) = 100

IF @Costo > 3000
	PRINT 'Servicio caro'
	PRINT 'Esta línea se imprime siempre'
```

```
Esta línea se imprime siempre
```

La segunda línea parece estar dentro del `IF`, pero no lo está: se ejecuta siempre. Por eso, en el curso, **todo `IF` y todo `ELSE` llevan `BEGIN ... END`**, aunque contengan una sola instrucción.

### IF con IS NULL

La combinación más usada en los procedimientos: buscar un dato y decidir si se encontró.

```sql
DECLARE @Nombre varchar(100)

SELECT
	@Nombre = Nombre
FROM Cliente
WHERE idCliente = 9999

IF @Nombre IS NULL BEGIN

	PRINT 'El cliente no existe'

END
```

```
El cliente no existe
```

> En el curso **no** se escribe `IF EXISTS (SELECT ...)` ni `IF NOT EXISTS (SELECT ...)`. Siempre se guarda el dato en una variable con `SELECT`, `FROM` y `WHERE` en líneas separadas, y se valida con `IF @variable IS NULL` o `IS NOT NULL`.

### IF anidados

Un `IF` puede ir dentro de otro, para decidir entre más de dos casos:

```sql
DECLARE @idCliente int = 200,
		@Vehiculos int

SELECT
	@Vehiculos = COUNT(*)
FROM Vehiculo
WHERE idCliente = @idCliente

IF @Vehiculos = 0 BEGIN

	PRINT 'El cliente no tiene vehículos'

END
ELSE BEGIN

	IF @Vehiculos = 1 BEGIN

		PRINT 'El cliente tiene un vehículo'

	END
	ELSE BEGIN

		PRINT 'El cliente tiene ' + CONVERT(varchar(10), @Vehiculos) + ' vehículos'

	END

END
```

| `@idCliente` | Mensaje |
|--------------|---------|
| 200 | El cliente no tiene vehículos |
| 16 | El cliente tiene un vehículo |
| 1 | El cliente tiene 2 vehículos |

---

## Resumen

- Las variables empiezan con `@`, se declaran con `DECLARE` y su tipo, y valen `NULL` hasta que se les asigna algo.
- `SET` asigna un valor; `SELECT @var = columna FROM ... WHERE ...` asigna un dato de una tabla.
- Si el `SELECT` no encuentra filas, la variable conserva su valor: así se detecta que un dato no existe.
- Una variable vive hasta el `GO` o hasta el `END` del procedimiento.
- `IF`/`ELSE` elige qué bloque se ejecuta; en el curso siempre llevan `BEGIN ... END`.
- Las validaciones se hacen con `IF @variable IS NULL`, no con `IF EXISTS (SELECT ...)`.
