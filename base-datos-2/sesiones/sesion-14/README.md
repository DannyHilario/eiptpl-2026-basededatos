# Sesión 14 — Manejo de excepciones en procedimientos almacenados

Sábado 7 de noviembre de 2026. Tema de la Etapa 4: [Manejo de excepciones en procedimientos almacenados](../../temas/Etapa-4/05-ExcepcionesProcedimientos.md).

Los procedimientos de **CompuStoreDB** ([sesión 5-6](../sesion-5-6)) validan con `IF` y responden con `ErrCodigo` y `ErrMensaje`. En esta sesión se prueban con datos que **ninguna validación revisa** y se ve qué pasa. Luego se les agrega `TRY … CATCH` y se repiten las mismas pruebas.

CompuStoreDB no tiene triggers: todo lo que pasa en esta sesión ocurre dentro del procedimiento.

---

## Antes de empezar

1. Instala CompuStoreDB **desde cero**: ejecuta completo [`sesion-5-6/CompuStoreDB/instalar-completo.sql`](../sesion-5-6/CompuStoreDB/instalar-completo.sql). Si ya la tenías, elimínala antes con `DROP DATABASE CompuStoreDB`.
2. Selecciona `CompuStoreDB` en el dropdown de SSMS.

| Archivo | Qué hace |
|---------|----------|
| [`01-pruebas-usp-insertar-categoria.sql`](01-pruebas-usp-insertar-categoria.sql) | 3 casos de prueba de `usp_insertarCategoria` |
| [`02-alter-usp-insertar-categoria.sql`](02-alter-usp-insertar-categoria.sql) | `usp_insertarCategoria` con `TRY … CATCH` |
| [`03-pruebas-usp-insertar-cliente.sql`](03-pruebas-usp-insertar-cliente.sql) | 7 casos de prueba de `usp_insertarCliente` |
| [`04-alter-usp-insertar-cliente.sql`](04-alter-usp-insertar-cliente.sql) | `usp_insertarCliente` con `TRY … CATCH` |

Cada archivo de pruebas se ejecuta **completo dos veces**: antes y después de su `ALTER`. Empieza borrando lo que dejó la ejecución anterior, así que se puede repetir cuantas veces se quiera.

---

## Paso 1 · usp_insertarCategoria, como está ahorita

Así termina hoy el procedimiento (instalado desde la sesión 5-6):

```sql
	-- ... validación: la categoría no debe existir (000001) ...

	INSERT INTO Categoria (Nombre)
	VALUES (@p_Nombre)

	SELECT 	@ErrCodigo = '000000',
			@ErrMensaje = 'Inserción correcta'

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje
```

Ejecuta completo [`01-pruebas-usp-insertar-categoria.sql`](01-pruebas-usp-insertar-categoria.sql):

| Caso | Llamada | Qué prueba | Resultado |
|------|---------|------------|-----------|
| 1 | `'Gaming'` | Camino feliz | `000000` Inserción correcta |
| 2 | `'Laptops'` | Validación: ya existe | `000001` La categoría ya está registrada |
| 3 | `NULL` | **Nadie valida el `NULL`**, y `Nombre` es `NOT NULL` | Error en rojo **y** `000000` Inserción correcta |

El caso 3 es el importante:

```
Msg 515, Level 16, State 2, Procedure usp_insertarCategoria, Line 30
Cannot insert the value NULL into column 'Nombre', table 'CompuStoreDB.dbo.Categoria'; column does not allow nulls. INSERT fails.
The statement has been terminated.
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000000 | Inserción correcta |

**El procedimiento miente.** El `INSERT` falló, pero respondió que todo salió bien. Un error no detiene el procedimiento: se cancela **esa** instrucción y sigue con la siguiente, que asigna el `000000` ([Errores y TRY CATCH](../../temas/Etapa-4/03-Errores.md#qué-pasa-con-el-resto-del-script)). Quien lo llamó (una aplicación, otro procedimiento) solo lee `ErrCodigo` y cree que la categoría existe.

La consulta de verificación lo confirma: hay 12 categorías, las 11 originales y `Gaming`. La del caso 3 no está.

---

## Paso 2 · Agregar TRY … CATCH

Ejecuta [`02-alter-usp-insertar-categoria.sql`](02-alter-usp-insertar-categoria.sql). Las validaciones quedan **igual**; solo cambia el final:

```sql
	-- ... validación: la categoría no debe existir (000001) ...

	BEGIN TRY

		INSERT INTO Categoria (Nombre)
		VALUES (@p_Nombre)

		SELECT 	@ErrCodigo = '000000',
				@ErrMensaje = 'Inserción correcta'

	END TRY
	BEGIN CATCH

		SELECT 	@ErrCodigo = '999999',
				@ErrMensaje = 'Error ' + CONVERT(varchar(10), ERROR_NUMBER()) + ': ' + ERROR_MESSAGE()

	END CATCH

	SELECT	@ErrCodigo as ErrCodigo,
			@ErrMensaje as ErrMensaje
```

Dos cambios:

- El `000000` se mudó **dentro del `TRY`**, después del `INSERT`. Si el `INSERT` falla, el control salta al `CATCH` y el `000000` nunca se asigna.
- El `CATCH` arma el `999999` con el número y el mensaje del error ([funciones ERROR](../../temas/Etapa-4/03-Errores.md)).

El `SELECT` final quedó **fuera** del `TRY … CATCH`: responde igual en los dos caminos.

---

## Paso 3 · Las mismas pruebas, después

Ejecuta otra vez completo [`01-pruebas-usp-insertar-categoria.sql`](01-pruebas-usp-insertar-categoria.sql):

| Caso | Antes | Después |
|------|-------|---------|
| 1 · `'Gaming'` | `000000` | `000000` |
| 2 · `'Laptops'` | `000001` | `000001` |
| 3 · `NULL` | Error en rojo y `000000` | `999999` Error 515: Cannot insert the value NULL into column 'Nombre', … |

Los casos 1 y 2 no cambian: el `TRY … CATCH` no estorba a lo que ya funcionaba. El caso 3 ya no sale en rojo y ya no miente.

---

## Paso 4 · usp_insertarCliente, como está ahorita

Este procedimiento valida **más** que el de categoría: el sexo (`000001`), el correo (`000002`) y el teléfono (`000003`). Aun así, se le escapan cosas.

Ejecuta completo [`03-pruebas-usp-insertar-cliente.sql`](03-pruebas-usp-insertar-cliente.sql):

| Caso | Datos | Qué prueba | Resultado |
|------|-------|------------|-----------|
| 1 | Jorge Salas | Camino feliz | `000000` |
| 2 | Sexo `'X'` | Validación del sexo | `000001` El sexo debe ser M o F |
| 3 | Correo de Carlos García | Validación del correo | `000002` El correo ya está registrado |
| 4 | Sexo `NULL` | **La validación existe, pero el `NULL` la esquiva** | `Msg 515` en rojo **y** `000000` |
| 5 | Primer apellido `NULL` | **Nadie valida el primer apellido** | `Msg 515` en rojo **y** `000000` |
| 6 | Pedro, sin teléfono | Primer cliente sin teléfono | `000000` |
| 7 | Laura, sin teléfono | **Segundo cliente sin teléfono** | `Msg 2627` en rojo **y** `000000` |

Los tres casos en rojo son tres formas distintas de que algo se escape:

**Caso 4: una validación que no cubre el `NULL`.** La validación es `IF @p_Sexo NOT IN ('M', 'F')`. Con `NULL`, la condición no es verdadera (cualquier comparación con `NULL` da "desconocido"), el `IF` no entra y el `NULL` llega al `INSERT`.

```
Msg 515, Level 16, State 2, Procedure usp_insertarCliente, Line 67
Cannot insert the value NULL into column 'Sexo', table 'CompuStoreDB.dbo.Cliente'; column does not allow nulls. INSERT fails.
```

**Caso 5: una validación que nunca se escribió.** `PrimerApellido` es `NOT NULL`, pero el procedimiento no lo revisa.

**Caso 7: una restricción que nadie tomó en cuenta.** `Telefono` es `UNIQUE`, y un `UNIQUE` admite **un solo** `NULL`. Pedro (caso 6) entró sin teléfono; Laura, que tampoco trae, ya no cabe. La validación del teléfono se salta los `NULL` a propósito (`@p_Telefono IS NOT NULL AND …`), así que no lo detecta.

```
Msg 2627, Level 14, State 1, Procedure usp_insertarCliente, Line 67
Violation of UNIQUE KEY constraint 'UQ__Cliente__4EC50480FC3CB748'. Cannot insert duplicate key in object 'dbo.Cliente'. The duplicate key value is (<NULL>).
```

> El nombre `UQ__Cliente__…` lo inventa SQL Server porque la restricción se creó sin nombre: en cada instalación termina distinto.

En los tres, el procedimiento vuelve a responder `000000 Inserción correcta`. La consulta de verificación muestra que de los 7 casos solo entraron **Jorge y Pedro**.

---

## Paso 5 · Agregar TRY … CATCH a usp_insertarCliente

Ejecuta [`04-alter-usp-insertar-cliente.sql`](04-alter-usp-insertar-cliente.sql). Es el mismo cambio del paso 2: las tres validaciones quedan igual, y el `INSERT` con su `000000` entran al `TRY`.

---

## Paso 6 · Las mismas pruebas, después

Ejecuta otra vez completo [`03-pruebas-usp-insertar-cliente.sql`](03-pruebas-usp-insertar-cliente.sql):

| Caso | Antes | Después |
|------|-------|---------|
| 1 · Jorge | `000000` | `000000` |
| 2 · Sexo `'X'` | `000001` | `000001` |
| 3 · Correo repetido | `000002` | `000002` |
| 4 · Sexo `NULL` | Rojo y `000000` | `999999` Error 515: Cannot insert the value NULL into column 'Sexo', … |
| 5 · Apellido `NULL` | Rojo y `000000` | `999999` Error 515: Cannot insert the value NULL into column 'PrimerApellido', … |
| 6 · Pedro sin teléfono | `000000` | `000000` |
| 7 · Laura sin teléfono | Rojo y `000000` | `999999` Error 2627: Violation of UNIQUE KEY constraint 'UQ__Cliente__…' … |

Las siete llamadas responden con la misma forma: un `ErrCodigo` y un `ErrMensaje`, sin nada en rojo y sin mentir.

> Entre Jorge y Pedro el `idCliente` brinca (por ejemplo, de 26 a 29). No es un error: un `INSERT` que falla también consume su número de `IDENTITY`.

---

## Para cerrar: validación o excepción

| | Validación (`000001`, `000002`, …) | Excepción (`999999`) |
|---|---|---|
| ¿Se previó? | Sí: es una regla del negocio | No: es lo que se escapó |
| ¿Quién la detecta? | Un `IF` | El `CATCH` |
| ¿Qué mensaje da? | Uno escrito para el usuario | El de SQL Server, en inglés y con su número |

El `999999` es la **red de seguridad**, no reemplaza a las validaciones. Cada `999999` que aparece es una validación que falta. Las de hoy:

| Caso | Validación que falta |
|------|----------------------|
| Categoría `NULL` | El nombre es obligatorio |
| Sexo `NULL` | El sexo es obligatorio (o cambiar la condición para que el `NULL` no la esquive) |
| Primer apellido `NULL` | El primer apellido es obligatorio |
| Segundo cliente sin teléfono | Decidir la regla: ¿el teléfono es obligatorio, o la restricción `UNIQUE` está mal planteada? |

## Resumen

- Sin `TRY … CATCH`, un error dentro de un procedimiento cancela **solo esa instrucción**: el procedimiento sigue y puede responder `000000` aunque no haya guardado nada.
- El `INSERT` y el `000000` van juntos **dentro del `TRY`**; el `999999` va en el `CATCH`; el `SELECT` que responde va **después** de los dos.
- Las validaciones se quedan igual: el `TRY … CATCH` atrapa lo que se les escapa.
- Un `NULL` esquiva un `IF` con `NOT IN`, y un `UNIQUE` admite un solo `NULL`.
- Cada `999999` señala una validación que falta.
