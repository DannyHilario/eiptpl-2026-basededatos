# Modificar y eliminar un procedimiento almacenado

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)) y el procedimiento `usp_insertarVehiculo` de [Validaciones y códigos de salida](04-Validaciones.md).

---

## Ver el código de un procedimiento

Antes de modificar un procedimiento conviene ver cómo está:

| Forma | Cómo |
|-------|------|
| T-SQL | `EXEC sp_helptext 'usp_insertarVehiculo'` |
| SSMS | Explorador de objetos → la base de datos → **Programación** → **Procedimientos almacenados** → clic derecho → **Modificar** |

La opción **Modificar** de SSMS abre una ventana nueva con el código del procedimiento ya convertido en `ALTER PROCEDURE`, listo para editar y ejecutar.

Para listar los procedimientos de la base de datos:

```sql
SELECT name
FROM sys.procedures
ORDER BY name
```

---

## Modificar: ALTER PROCEDURE

`ALTER PROCEDURE` **reemplaza** el procedimiento completo por la nueva versión. Se escribe todo el procedimiento, no solo lo que cambia: lo que no se escriba, desaparece.

Nueva regla del negocio: **un cliente puede tener máximo 3 vehículos activos**. Se agrega una tercera validación a `usp_insertarVehiculo`:

```sql
ALTER PROCEDURE usp_insertarVehiculo
	@p_idCliente int,
	@p_Marca varchar(50),
	@p_Modelo varchar(50),
	@p_Anio int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idClienteExistente int,
			@VehiculosCliente int

	-- Validación 1: el cliente debe existir y estar activo

	SELECT
		@idClienteExistente = idCliente
	FROM Cliente
	WHERE idCliente = @p_idCliente
		AND Activo = 1

	IF @idClienteExistente IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El cliente no existe o no está activo'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 2: el año debe estar entre 1990 y el año siguiente al actual

	IF @p_Anio < 1990 OR @p_Anio > YEAR(GETDATE()) + 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'El año del vehículo no es válido'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	-- Validación 3 (nueva): un cliente puede tener máximo 3 vehículos activos

	SELECT
		@VehiculosCliente = COUNT(*)
	FROM Vehiculo
	WHERE idCliente = @p_idCliente
		AND Activo = 1

	IF @VehiculosCliente >= 3 BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El cliente ya tiene 3 vehículos activos'

		SELECT	@ErrCodigo as ErrCodigo,
				@ErrMensaje as ErrMensaje

		RETURN
	END

	INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio)
	VALUES (@p_idCliente, @p_Marca, @p_Modelo, @p_Anio)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
```

Lo que cambió:

| Parte | Antes | Después |
|-------|-------|---------|
| Variables | `@idClienteExistente` | `@idClienteExistente`, `@VehiculosCliente` |
| Validaciones | 000001 y 000002 | 000001, 000002 y **000003** |
| Parámetros, `INSERT` y mensaje de éxito | — | Sin cambio, pero **se vuelven a escribir** |

La validación 3 usa `COUNT(*)`, que nunca regresa `NULL` (sin filas regresa `0`): por eso se compara con `>=` en lugar de `IS NULL`.

### Probar la nueva validación

El cliente 1 tiene 2 vehículos. El tercero se acepta; el cuarto, ya no:

```sql
EXEC usp_insertarVehiculo 1, 'Kia', 'Rio', 2023
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000000 | Inserción correcta |

```sql
EXEC usp_insertarVehiculo 1, 'Ford', 'Figo', 2021
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000003 | El cliente ya tiene 3 vehículos activos |

Después de un `ALTER` se vuelven a probar **todos** los caminos, no solo el nuevo: un cambio puede romper lo que ya funcionaba.

### ¿Por qué ALTER y no DROP + CREATE?

| | `ALTER PROCEDURE` | `DROP` y luego `CREATE` |
|---|---|---|
| Permisos otorgados sobre el procedimiento | Se conservan | Se pierden |
| Mientras se ejecuta el cambio | El procedimiento sigue existiendo | Hay un momento en que no existe |
| Si el procedimiento no existe | Error | Funciona |

> En SQL Server 2016 SP1 y posteriores existe también `CREATE OR ALTER PROCEDURE`: lo crea si no existe y lo modifica si ya existe.

---

## Eliminar: DROP PROCEDURE

```sql
DROP PROCEDURE usp_obtenerVehiculosCliente
```

Se elimina el procedimiento; los datos de las tablas no se tocan. Después de eliminarlo, ejecutarlo marca error:

```sql
EXEC usp_obtenerVehiculosCliente 1
```

```
Msg 2812, Level 16, State 62
Could not find stored procedure 'usp_obtenerVehiculosCliente'.
```

Desde SSMS: clic derecho sobre el procedimiento → **Eliminar** → **Aceptar**.

> En un paquete de [reversa](../../../base-datos-1/temas/Etapa-3/07-InstalacionReversa.md), los procedimientos, las funciones, las vistas y los triggers se eliminan **antes** que las tablas. Ver el ejemplo de AutoFixDB: [`reversa/01-drop-objetos.sql`](../../sesiones/sesion-11/AutoFixDB/reversa/01-drop-objetos.sql).

---

## Resumen

- `sp_helptext` y la opción **Modificar** de SSMS muestran el código de un procedimiento.
- `ALTER PROCEDURE` reemplaza el procedimiento completo: se escribe entero, no solo lo que cambia.
- `ALTER` conserva los permisos; `DROP` + `CREATE` los pierde.
- Después de modificar, se prueban otra vez todos los caminos.
- `DROP PROCEDURE` elimina el procedimiento sin tocar los datos.
