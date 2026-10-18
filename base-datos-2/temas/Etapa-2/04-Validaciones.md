# Validaciones y códigos de salida

Un procedimiento que modifica datos debe **revisar antes de modificar**. Si algo no cumple las reglas del negocio, no inserta ni actualiza nada: regresa un **código** y un **mensaje** que explican qué pasó. Este es el patrón que se usa en todos los procedimientos del curso.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)) y se apoyan en [Variables e IF / ELSE](03-VariablesIfElse.md).

---

## ¿Por qué validar si la tabla ya tiene restricciones?

Las restricciones (`FOREIGN KEY`, `CHECK`, `UNIQUE`) protegen la tabla, pero no bastan:

| Situación | Sin validar en el procedimiento | Validando en el procedimiento |
|-----------|---------------------------------|-------------------------------|
| El cliente no existe | La `FOREIGN KEY` rechaza el `INSERT` con un error técnico (abajo) | `000001 - El cliente no existe o no está activo` |
| El cliente existe pero está **inactivo** | Se inserta: la `FOREIGN KEY` solo revisa que exista | Se rechaza: es una regla del negocio, no de la estructura |
| El año es 1985 | Se inserta: `Vehiculo` no tiene `CHECK` sobre `Anio` | `000002 - El año del vehículo no es válido` |

El error de la `FOREIGN KEY` es correcto, pero quien usa el sistema no lo entiende:

```
Msg 547, Level 16, State 1
The INSERT statement conflicted with the FOREIGN KEY constraint "fk_Vehiculo_Cliente".
The conflict occurred in database "AutoFixDB", table "dbo.Cliente", column 'idCliente'.
```

El procedimiento valida para dar **mensajes claros** y para aplicar **reglas que la estructura no puede expresar**. Las restricciones se quedan como la última línea de defensa.

---

## El patrón

Cada procedimiento regresa siempre **una fila con dos columnas**:

| Columna | Qué contiene |
|---------|--------------|
| `ErrCodigo` | `'000000'` si todo salió bien; `'000001'`, `'000002'`… para cada error |
| `ErrMensaje` | La explicación en palabras |

Y su cuerpo tiene siempre la misma forma:

```
1. DECLARE de @ErrCodigo, @ErrMensaje y las variables de validación
2. Por cada regla:
      SELECT ... FROM ... WHERE        → intentar encontrar el dato
      IF @variable IS NULL BEGIN       → ¿no se encontró? (o IS NOT NULL: ¿ya existe?)
          asignar código y mensaje
          SELECT del código y el mensaje
          RETURN                       → salir sin modificar nada
      END
3. La operación (INSERT, UPDATE o DELETE)
4. SELECT '000000' y el mensaje de éxito
```

`RETURN` termina el procedimiento en ese momento: lo que está debajo ya no se ejecuta. Por eso la operación solo se alcanza cuando **todas** las validaciones pasaron.

---

## Ejemplo: usp_insertarVehiculo

Reglas del negocio:

1. El vehículo se registra a un cliente que **existe** y está **activo**.
2. El año del vehículo va de 1990 al año siguiente al actual (los modelos del año próximo salen a la venta antes).

```sql
CREATE PROCEDURE usp_insertarVehiculo
	@p_idCliente int,
	@p_Marca varchar(50),
	@p_Modelo varchar(50),
	@p_Anio int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idClienteExistente int

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

	INSERT INTO Vehiculo (idCliente, Marca, Modelo, Anio)
	VALUES (@p_idCliente, @p_Marca, @p_Modelo, @p_Anio)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje

END
```

### Cómo funciona la validación 1

`@idClienteExistente` empieza en `NULL`. El `SELECT` busca al cliente con ese `idCliente` **y** `Activo = 1`:

| Caso | ¿El `SELECT` encuentra fila? | `@idClienteExistente` | Resultado |
|------|------------------------------|-----------------------|-----------|
| El cliente existe y está activo | Sí | El `idCliente` | Pasa a la validación 2 |
| El cliente existe pero está inactivo | No | `NULL` | `000001` |
| El cliente no existe | No | `NULL` | `000001` |

La validación 2 no necesita `SELECT`: el dato ya viene en el parámetro `@p_Anio`, y basta un `IF`.

---

## Probar cada camino

Un procedimiento con dos validaciones tiene **tres caminos**: un error por cada validación y el éxito. Se prueba cada uno:

```sql
-- Camino 000001: el cliente no existe
EXEC usp_insertarVehiculo 9999, 'Mazda', 'CX-3', 2022
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000001 | El cliente no existe o no está activo |

```sql
-- Camino 000002: el año no es válido
EXEC usp_insertarVehiculo 200, 'Mazda', 'CX-3', 1985
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000002 | El año del vehículo no es válido |

```sql
-- Camino 000000: todo correcto
EXEC usp_insertarVehiculo 200, 'Mazda', 'CX-3', 2022
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000000 | Inserción correcta |

Y se comprueba que el cambio quedó en la tabla, y que los dos intentos fallidos no insertaron nada:

```sql
SELECT idVehiculo, idCliente, Marca, Modelo, Anio
FROM Vehiculo
WHERE idCliente = 200
```

| idVehiculo | idCliente | Marca | Modelo | Anio |
|------------|-----------|-------|--------|------|
| 171 | 200 | Mazda | CX-3 | 2022 |

---

## Reglas del patrón

| Regla | Por qué |
|-------|---------|
| Cada validación tiene su **propio código** | Quien llama al procedimiento sabe exactamente qué falló |
| Los códigos se numeran en el orden en que se validan | Facilita leer el código y las pruebas |
| Cada error termina con `RETURN` | Garantiza que no se modifica nada si algo falló |
| El dato se guarda en una variable y se valida con `IS NULL` / `IS NOT NULL` | Es la convención del curso; no se usa `IF EXISTS (SELECT ...)` |
| El `SELECT` de validación va con `SELECT`, `FROM` y `WHERE` en líneas separadas | Legibilidad |
| `IS NULL` cuando el dato **debe existir**; `IS NOT NULL` cuando **no debe existir** | Ver la tabla de abajo |

| Pregunta de la regla | Ejemplo | Se valida con |
|----------------------|---------|---------------|
| ¿Existe? | El cliente al que se le registra el vehículo | `IF @idClienteExistente IS NULL` → error |
| ¿Ya está registrado? | El correo de un cliente nuevo ([`usp_insertarCliente`](../../sesiones/sesion-11/AutoFixDB/instalacion/01-Cliente/03-usp-insertar.sql)) | `IF @CorreoExistente IS NOT NULL` → error |

---

## Resumen

- Un procedimiento valida antes de modificar para dar mensajes claros y aplicar reglas que la estructura no expresa.
- Siempre regresa una fila con `ErrCodigo` y `ErrMensaje`: `'000000'` es éxito, y cada error tiene su código.
- Cada validación: `SELECT` a una variable, `IF @variable IS NULL` (o `IS NOT NULL`), código, mensaje y `RETURN`.
- La operación va al final: solo se alcanza si todas las validaciones pasaron.
- Se prueba un camino por cada código, y se revisa la tabla después de cada prueba.
