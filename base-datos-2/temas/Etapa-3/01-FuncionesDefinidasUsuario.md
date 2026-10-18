# Funciones definidas por el usuario

En la Etapa 1 se usaron las **funciones del sistema**: las de agregado (`SUM`, `COUNT`) y las escalares (`UPPER`, `ROUND`, `GETDATE`). SQL Server permite además crear **funciones propias**, con un nombre y un cálculo del negocio, que se usan dentro de una consulta igual que las del sistema.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)).

---

## Funciones del sistema y funciones definidas por el usuario

| | Del sistema | Definidas por el usuario |
|---|---|---|
| Quién las crea | SQL Server | Tú, con `CREATE FUNCTION` |
| Ejemplos | `UPPER`, `SUM`, `GETDATE` | `ufn_totalGastadoCliente` |
| Cómo se llaman | `UPPER(Nombre)` | `dbo.ufn_totalGastadoCliente(idCliente)`: con el esquema `dbo.` |
| Prefijo en el curso | — | `ufn_` |

## Función, vista y procedimiento

| | Vista | Función | Procedimiento almacenado |
|---|---|---|---|
| Recibe parámetros | No | Sí | Sí |
| Regresa | Una tabla | Un valor **o** una tabla | Resultados con `SELECT` y códigos de salida |
| Se usa dentro de un `SELECT` | Sí, en el `FROM` | Sí, en el `SELECT`, el `WHERE` o el `FROM` | No: se ejecuta con `EXEC` |
| Puede modificar tablas | — | **No** | Sí |
| Prefijo | `vw_` | `ufn_` | `usp_` |

La regla para elegir: si se necesita **calcular** algo para usarlo dentro de una consulta, es una función; si se necesita **hacer** algo (insertar, validar, actualizar), es un procedimiento.

---

## Tipos de funciones definidas por el usuario

| Tipo | Regresa | Se usa en | Ejemplo |
|------|---------|-----------|---------|
| **Escalar** | Un solo valor | `SELECT`, `WHERE`, `ORDER BY` | ¿Cuánto ha gastado el cliente 1? |
| **De tabla en línea** (*inline*) | Una tabla, resultado de **un** `SELECT` | `FROM` | Los servicios del vehículo 4 |
| **De tabla con varias instrucciones** (*multi-statement*) | Una tabla que se llena paso a paso | `FROM` | Un resumen del cliente 2 armado con varias consultas |

---

## Función escalar

```sql
CREATE FUNCTION ufn_nombreFuncion (@p_Parametro tipo)
RETURNS tipo_del_resultado
AS
BEGIN

	DECLARE @Resultado tipo_del_resultado

	-- cálculo

	RETURN @Resultado

END
```

| Parte | Qué es |
|-------|--------|
| `(@p_Parametro tipo)` | Los parámetros, **entre paréntesis** (en un procedimiento no llevan paréntesis) |
| `RETURNS tipo` | El tipo del valor que regresa (con **S** al final) |
| `RETURN valor` | Regresa el valor y termina la función (sin **S**) |

¿Cuánto ha gastado un cliente en el taller? Hay que sumar el costo de los servicios de **todos** sus vehículos:

```sql
CREATE FUNCTION ufn_totalGastadoCliente (@p_idCliente int)
RETURNS decimal(12,2)
AS
BEGIN

	DECLARE @Total decimal(12,2)

	SELECT
		@Total = SUM(S.CostoServicio)
	FROM Servicio AS S
	INNER JOIN Vehiculo AS V ON V.idVehiculo = S.idVehiculo
	WHERE V.idCliente = @p_idCliente

	RETURN ISNULL(@Total, 0)

END
```

`ISNULL(@Total, 0)` es necesario: un cliente sin servicios haría que `SUM` regresara `NULL` (ver [Funciones de agregado](../Etapa-1/02-FuncionesAgregado.md#cuando-no-hay-filas)), y "no ha gastado nada" es `0`, no "desconocido".

### Usar una función escalar

Sola:

```sql
SELECT dbo.ufn_totalGastadoCliente(1) AS TotalGastado
```

| TotalGastado |
|--------------|
| 1200.00 |

Con un cliente sin vehículos regresa `0.00`.

Para cada fila de una consulta:

```sql
SELECT TOP 5 idCliente, Nombre, PrimerApellido, dbo.ufn_totalGastadoCliente(idCliente) AS TotalGastado
FROM Cliente
ORDER BY idCliente
```

| idCliente | Nombre | PrimerApellido | TotalGastado |
|-----------|--------|----------------|--------------|
| 1 | Carlos | García | 1200.00 |
| 2 | Ana | Hernández | 4100.00 |
| 3 | Miguel | Rodríguez | 1650.00 |
| 4 | Valeria | Torres | 4900.00 |
| 5 | Luis | Pérez | 2050.00 |

En el `WHERE`:

```sql
SELECT idCliente, Nombre, PrimerApellido, dbo.ufn_totalGastadoCliente(idCliente) AS TotalGastado
FROM Cliente
WHERE dbo.ufn_totalGastadoCliente(idCliente) > 6000
```

| idCliente | Nombre | PrimerApellido | TotalGastado |
|-----------|--------|----------------|--------------|
| 15 | Daniel | Aguilar | 7250.00 |
| 29 | Carlos | Vega | 6400.00 |

### El prefijo dbo. es obligatorio

Las funciones escalares propias se llaman con su esquema. Sin `dbo.`, SQL Server la busca entre las del sistema y no la encuentra:

```sql
SELECT ufn_totalGastadoCliente(1)
```

```
Msg 195, Level 15, State 10
'ufn_totalGastadoCliente' is not a recognized built-in function name.
```

---

## Función de tabla en línea

Regresa el resultado de **un solo** `SELECT`. Es como una vista que recibe parámetros.

```sql
CREATE FUNCTION ufn_serviciosVehiculo (@p_idVehiculo int)
RETURNS TABLE
AS
RETURN
(
	SELECT S.idServicio, S.FechaIngreso, T.Descripcion, S.CostoServicio
	FROM Servicio AS S
	INNER JOIN TipoServicio AS T ON T.idTipoServicio = S.idTipoServicio
	WHERE S.idVehiculo = @p_idVehiculo
)
```

Diferencias con la escalar: `RETURNS TABLE`, no lleva `BEGIN ... END` ni `DECLARE`, y el `RETURN` va seguido del `SELECT` entre paréntesis.

Se usa en el `FROM`, como una tabla:

```sql
SELECT idServicio, FechaIngreso, Descripcion, CostoServicio
FROM dbo.ufn_serviciosVehiculo(4)
ORDER BY FechaIngreso
```

| idServicio | FechaIngreso | Descripcion | CostoServicio |
|------------|--------------|-------------|---------------|
| 187 | 2026-02-26 | Cambio de llantas | 3200.00 |
| 43 | 2026-02-27 | Cambio de aceite | 450.00 |

Como con las vistas, el `SELECT` interno no lleva `ORDER BY`: el orden se pide al consultar.

---

## Función de tabla con varias instrucciones

Declara una **variable de tabla**, la llena con una o varias instrucciones y la regresa. Sirve cuando el resultado no sale de un solo `SELECT`.

```sql
CREATE FUNCTION ufn_resumenCliente (@p_idCliente int)
RETURNS @Resumen TABLE (
	Concepto varchar(50),
	Valor decimal(12,2)
)
AS
BEGIN

	DECLARE @Vehiculos int,
			@Servicios int,
			@Total decimal(12,2)

	SELECT
		@Vehiculos = COUNT(*)
	FROM Vehiculo
	WHERE idCliente = @p_idCliente

	SELECT
		@Servicios = COUNT(*), @Total = SUM(S.CostoServicio)
	FROM Servicio AS S
	INNER JOIN Vehiculo AS V ON V.idVehiculo = S.idVehiculo
	WHERE V.idCliente = @p_idCliente

	INSERT INTO @Resumen (Concepto, Valor)
	VALUES ('Vehículos', @Vehiculos),
		   ('Servicios', @Servicios),
		   ('Total gastado', ISNULL(@Total, 0))

	RETURN

END
```

```sql
SELECT Concepto, Valor
FROM dbo.ufn_resumenCliente(2)
```

| Concepto | Valor |
|----------|-------|
| Vehículos | 2.00 |
| Servicios | 3.00 |
| Total gastado | 4100.00 |

El `INSERT` va sobre `@Resumen`, la tabla **de la función**, no sobre una tabla de la base de datos. El `RETURN` final, sin nada después, regresa `@Resumen` tal como quedó.

### ¿En línea o con varias instrucciones?

| | En línea | Con varias instrucciones |
|---|---|---|
| Cuerpo | Un `SELECT` | `BEGIN ... END` con las instrucciones que se necesiten |
| Columnas del resultado | Las del `SELECT` | Se declaran en `RETURNS @tabla TABLE (...)` |
| Rendimiento | Mejor: SQL Server la trata como parte de la consulta | Menor |
| Cuándo usarla | Siempre que el resultado salga de un solo `SELECT` | Cuando se necesitan varios pasos |

---

## Lo que una función no puede hacer

Una función **calcula y regresa**; no puede cambiar la base de datos. Dentro de una función no se permite `INSERT`, `UPDATE` ni `DELETE` sobre tablas de la base de datos (sí sobre su propia variable de tabla):

```sql
CREATE FUNCTION ufn_prueba (@p_idCliente int)
RETURNS int
AS
BEGIN
	UPDATE Cliente SET Activo = 1 WHERE idCliente = @p_idCliente
	RETURN 1
END
```

```
Msg 443, Level 16, State 15
Invalid use of a side-effecting operator 'UPDATE' within a function.
```

Tampoco puede usar `PRINT` ni ejecutar procedimientos almacenados. Si se necesita modificar datos, es un procedimiento.

---

## Modificar, eliminar y consultar funciones

| Acción | Instrucción |
|--------|-------------|
| Modificar | `ALTER FUNCTION ufn_totalGastadoCliente (...)` con la definición completa, igual que `ALTER PROCEDURE` |
| Eliminar | `DROP FUNCTION ufn_totalGastadoCliente` |
| Ver el código | `EXEC sp_helptext 'ufn_totalGastadoCliente'` |
| En SSMS | **Programación** → **Funciones** → **Funciones escalares** o **Funciones con valores de tabla** |

Para listar las funciones con su tipo:

```sql
SELECT name, type_desc
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF')
ORDER BY name
```

| name | type_desc |
|------|-----------|
| ufn_resumenCliente | SQL_TABLE_VALUED_FUNCTION |
| ufn_serviciosVehiculo | SQL_INLINE_TABLE_VALUED_FUNCTION |
| ufn_totalGastadoCliente | SQL_SCALAR_FUNCTION |

Como `CREATE VIEW` y `CREATE PROCEDURE`, **`CREATE FUNCTION` debe ser la única sentencia de su lote**: en un script lleva un `GO` antes y otro después.

---

## Resumen

- Una función definida por el usuario (prefijo `ufn_`) encapsula un cálculo para usarlo dentro de una consulta.
- **Escalar:** regresa un valor (`RETURNS tipo` ... `RETURN valor`); se llama con `dbo.` en el `SELECT` o el `WHERE`.
- **De tabla en línea:** `RETURNS TABLE` + `RETURN (SELECT ...)`; se usa en el `FROM`, como una vista con parámetros.
- **De tabla con varias instrucciones:** `RETURNS @tabla TABLE (...)`, se llena con instrucciones y termina con `RETURN`.
- Una función no puede modificar tablas de la base de datos; para eso está el procedimiento almacenado.
- Una función escalar que suma debe regresar `ISNULL(..., 0)` para los casos sin filas.
