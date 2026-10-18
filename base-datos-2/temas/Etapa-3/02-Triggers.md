# Triggers

Un **trigger** (disparador) es código T-SQL asociado a una **tabla** que SQL Server ejecuta **automáticamente** cuando ocurre un evento sobre ella: un `INSERT`, un `UPDATE` o un `DELETE`. Nadie lo llama con `EXEC` y no recibe parámetros: se **dispara** solo, y no se puede saltar. Cualquier sentencia que modifique la tabla lo activa, venga de SSMS, de una aplicación o de un procedimiento almacenado.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)), que trae instalados los dos triggers construidos en la [sesión 11](../../sesiones/sesion-11).

---

## Procedimiento almacenado contra trigger

| | Procedimiento almacenado | Trigger |
|---|---|---|
| Cómo se ejecuta | Alguien lo llama: `EXEC usp_...` | Solo, cuando ocurre el evento |
| Parámetros | Sí | No: trabaja con las tablas [`inserted` y `deleted`](03-InsertedDeleted.md) |
| Está asociado a | La base de datos | **Una tabla** y uno o más eventos |
| Se puede evitar | Sí: basta no llamarlo | No, mientras esté [activo](04-ActivarDesactivar.md) |
| Prefijo en el curso | `usp_` | `trg_` |

## ¿Para qué sirve?

| Uso | Ejemplo en AutoFixDB |
|-----|----------------------|
| **Auditoría**: dejar registro de quién cambió qué y cuándo | `trg_registroAuditoriaOperacionCliente` guarda cada alta, cambio y baja de clientes |
| **Historial** de un dato que cambia | Guardar el costo anterior de un servicio cada vez que sube (ver [inserted y deleted](03-InsertedDeleted.md#ejemplo-historial-de-costos)) |
| **Copiar o sincronizar** información en otra tabla, sin que quien hizo el `INSERT` tenga que hacer nada | La misma auditoría: el `INSERT` en `Cliente` llena `AuditoriaOperacionCliente` |
| **Reglas difíciles de expresar con constraints** | Convertir un `DELETE` de vehículo en una baja lógica (ver [INSTEAD OF](#instead-of-hacer-otra-cosa-en-lugar-de-la-operación)) |
| **Avisos** | `trg_mensajeInsertarCliente` imprime cuántos clientes se insertaron |

### Cuándo no usarlo

Un trigger es **invisible** para quien escribe el `INSERT`: hace cosas que no se ven en la sentencia. Por eso:

- Si una regla se puede expresar con una restricción (`CHECK`, `UNIQUE`, `FOREIGN KEY`), se usa la restricción.
- Si una validación debe regresar un mensaje claro a quien hace la operación, va en un [procedimiento almacenado](../Etapa-2/04-Validaciones.md).
- El trigger se reserva para lo que debe pasar **siempre**, sin importar desde dónde se modifique la tabla.

---

## Tipos de triggers

| Tipo | Se dispara con | En el curso |
|------|----------------|-------------|
| **DML** | `INSERT`, `UPDATE`, `DELETE` sobre una tabla | Sí |
| **DDL** | `CREATE`, `ALTER`, `DROP` sobre objetos de la base de datos | No |

Los triggers DML pueden ser de dos momentos:

| Momento | Cuándo corre | La operación original… |
|---------|--------------|------------------------|
| `AFTER` (o `FOR`, que es lo mismo) | **Después** de que la operación se hizo y pasó las restricciones | Ya ocurrió |
| `INSTEAD OF` | **En lugar** de la operación | **No ocurre**: solo se ejecuta lo que diga el trigger |

> El manual habla de triggers que se ejecutan "antes o después" del evento. SQL Server **no** tiene triggers `BEFORE`: tiene `AFTER` e `INSTEAD OF`. Lo que en otros motores se haría "antes", en SQL Server se hace con `INSTEAD OF`.

---

## Sintaxis

```sql
CREATE TRIGGER trg_nombreTrigger
ON NombreTabla
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

	-- instrucciones

END
```

| Parte | Qué es |
|-------|--------|
| `trg_nombreTrigger` | El nombre, con prefijo `trg_` y en camelCase: qué hace y sobre qué tabla (`trg_mensajeInsertarCliente`) |
| `ON NombreTabla` | La tabla a la que pertenece |
| `AFTER` / `FOR` / `INSTEAD OF` | El momento |
| `INSERT, UPDATE, DELETE` | Los eventos que lo disparan: uno, dos o los tres, separados por comas |
| `BEGIN ... END` | El cuerpo |

Igual que `CREATE PROCEDURE`, **`CREATE TRIGGER` debe ser la única sentencia de su lote**: en un script lleva un `GO` antes y otro después.

---

## Ejemplo 1: un mensaje después de insertar

El primer trigger de la [sesión 11](../../sesiones/sesion-11/AutoFixDB/docs/triggers/trg_mensajeInsertarCliente.md):

```sql
CREATE TRIGGER trg_mensajeInsertarCliente
ON Cliente
AFTER INSERT
AS
BEGIN

	DECLARE @CantidadInsertada int

	-- inserted tiene una fila por cada cliente que insertó la sentencia

	SELECT
		@CantidadInsertada = COUNT(1)
	FROM inserted

	PRINT 'Registros correctamente insertados: ' + CONVERT(varchar(10), @CantidadInsertada)

END
```

`inserted` es una tabla que SQL Server llena con las filas que acaba de insertar la sentencia (ver [inserted y deleted](03-InsertedDeleted.md)).

### Se dispara una vez por sentencia, no una vez por fila

```sql
INSERT INTO Cliente (PrimerApellido, SegundoApellido, Nombre, Telefono, Correo)
VALUES ('Salinas', 'Cruz', 'Iker', '8100000217', 'iker.salinas@gmail.com'),
       ('Quiroga', 'Peña', 'Ximena', '8100000218', 'ximena.quiroga@gmail.com'),
       ('Tamez', 'Rocha', 'Mateo', '8100000219', 'mateo.tamez@gmail.com')
```

```
Registros correctamente insertados: 3
```

Un solo mensaje con `3`, no tres mensajes con `1`. Este es **el punto más importante** de los triggers en SQL Server: el trigger corre **una vez por sentencia**, y `inserted` trae **todas** las filas que afectó. Un trigger que supone que viene una sola fila funciona en las pruebas con un registro y falla cuando alguien inserta varios.

### Cualquier camino lo dispara

`usp_insertarCliente` también hace un `INSERT` en `Cliente`, así que también imprime el mensaje:

```sql
EXEC usp_insertarCliente 'Ibarra', 'Solís', 'Paula', '8100000220', 'paula.ibarra@gmail.com'
```

```
Registros correctamente insertados: 1
```

| ErrCodigo | ErrMensaje |
|-----------|------------|
| 000000 | Inserción correcta |

Lo mismo pasa con un `INSERT` a través de una [vista](../Etapa-1/05-Vistas.md#insert-a-través-de-una-vista) de `Cliente`.

---

## Ejemplo 2: la auditoría

`trg_registroAuditoriaOperacionCliente` se dispara con los **tres** eventos y guarda, en la tabla `AuditoriaOperacionCliente`, una fila por cada cliente afectado con el tipo de operación (`I`, `U` o `D`). Su código y cómo deduce la operación están en [inserted y deleted](03-InsertedDeleted.md#cómo-saber-qué-operación-disparó-el-trigger) y en su [documentación](../../sesiones/sesion-11/AutoFixDB/docs/triggers/trg_registroAuditoriaOperacionCliente.md).

```sql
UPDATE Cliente
SET Activo = Activo
WHERE idCliente BETWEEN 1 AND 3
```

```sql
SELECT idCliente, TipoOperacion
FROM AuditoriaOperacionCliente
WHERE TipoOperacion = 'U'
```

| idCliente | TipoOperacion |
|-----------|---------------|
| 3 | U |
| 2 | U |
| 1 | U |

Un `UPDATE` de tres clientes deja tres filas en la auditoría. El orden en que llegan no está garantizado.

> `AuditoriaOperacionCliente` **no** tiene llave foránea hacia `Cliente`: si la tuviera, no se podría borrar un cliente con historial, y la auditoría de los clientes eliminados se perdería.

---

## INSTEAD OF: hacer otra cosa en lugar de la operación

En un taller no conviene **borrar** un vehículo: tiene servicios que se deben conservar. De hecho, la llave foránea de `Servicio` no lo permite:

```sql
DELETE FROM Vehiculo
WHERE idVehiculo = 1
```

```
Msg 547, Level 16, State 1
The DELETE statement conflicted with the REFERENCE constraint "fk_Servicio_Vehiculo".
The conflict occurred in database "AutoFixDB", table "dbo.Servicio", column 'idVehiculo'.
```

Un trigger `INSTEAD OF DELETE` convierte cualquier `DELETE` de `Vehiculo` en una **baja lógica**: en lugar de borrar, marca `Activo = 0`.

```sql
CREATE TRIGGER trg_bajaLogicaVehiculo
ON Vehiculo
INSTEAD OF DELETE
AS
BEGIN

	SET NOCOUNT ON

	-- El DELETE no ocurre: en su lugar se desactivan los vehículos que se querían borrar.
	-- deleted trae esas filas

	UPDATE V
	SET Activo = 0
	FROM Vehiculo AS V
	INNER JOIN deleted AS D ON D.idVehiculo = V.idVehiculo

END
```

```sql
DELETE FROM Vehiculo
WHERE idVehiculo = 1
```

```sql
SELECT idVehiculo, Marca, Modelo, Activo
FROM Vehiculo
WHERE idVehiculo = 1
```

| idVehiculo | Marca | Modelo | Activo |
|------------|-------|--------|--------|
| 1 | Nissan | Versa | 0 |

El vehículo sigue en la tabla, con sus servicios, y `Vehiculo` tiene las mismas filas que antes del `DELETE`. Quien escribió el `DELETE` no tuvo que saber nada de bajas lógicas.

`UPDATE V ... FROM Vehiculo AS V INNER JOIN deleted AS D` es un `UPDATE` con `JOIN`: actualiza las filas de `Vehiculo` que coinciden con las de `deleted`. Así funciona aunque el `DELETE` haya sido de varios vehículos.

> Este trigger **no** forma parte de la instalación de AutoFixDB: es un ejemplo de estudio. Si lo creas para probarlo, elimínalo después con `DROP TRIGGER trg_bajaLogicaVehiculo`.

---

## SET NOCOUNT ON dentro de un trigger

Cada `INSERT` o `UPDATE` que hace un trigger imprime su propio `(1 row affected)`. En AutoFixDB, un `INSERT` de un cliente muestra **dos** mensajes de filas afectadas: el del `INSERT` en `Cliente` y el del `INSERT` que hace la auditoría. Para que el trigger no agregue mensajes, su primera instrucción es `SET NOCOUNT ON`, como en `trg_bajaLogicaVehiculo`.

---

## Modificar, eliminar y consultar triggers

| Acción | Instrucción |
|--------|-------------|
| Modificar | `ALTER TRIGGER trg_nombre ON Tabla AFTER ... AS BEGIN ... END`, con la definición completa |
| Eliminar | `DROP TRIGGER trg_nombre` (sin `ON Tabla`) |
| Ver el código | `EXEC sp_helptext 'trg_nombre'` |
| En SSMS | Explorador de objetos → la tabla → **Desencadenadores** |

Al eliminar una tabla con `DROP TABLE`, sus triggers se eliminan con ella.

Para ver todos los triggers de la base de datos, a qué tabla pertenecen y si son `INSTEAD OF`:

```sql
SELECT T.name AS TriggerName, OBJECT_NAME(T.parent_id) AS Tabla, T.is_instead_of_trigger, T.is_disabled
FROM sys.triggers AS T
ORDER BY Tabla, TriggerName
```

| TriggerName | Tabla | is_instead_of_trigger | is_disabled |
|-------------|-------|-----------------------|-------------|
| trg_mensajeInsertarCliente | Cliente | 0 | 0 |
| trg_registroAuditoriaOperacionCliente | Cliente | 0 | 0 |
| trg_bajaLogicaVehiculo | Vehiculo | 1 | 0 |

---

## Errores comunes

### Suponer que viene una sola fila

```sql
-- INCORRECTO: si la sentencia afectó 3 clientes, @idCliente se queda con uno solo
DECLARE @idCliente int

SELECT
	@idCliente = idCliente
FROM inserted

INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
VALUES (@idCliente, 'I')
```

```sql
-- CORRECTO: un INSERT ... SELECT copia todas las filas de inserted
INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
SELECT idCliente, 'I'
FROM inserted
```

### Dejar la prueba dentro del trigger

Igual que con los procedimientos, todo lo que está después del `AS` y antes del siguiente `GO` forma parte del trigger. Uno de los ejemplos del manual deja el `UPDATE` de prueba pegado al `CREATE TRIGGER`, sin `GO`: ese `UPDATE` queda **dentro** del trigger y se ejecuta cada vez que el trigger se dispara. La prueba va después de un `GO`.

### Regresar resultados con SELECT

Un trigger no debe tener un `SELECT` que muestre datos: quien hizo el `INSERT` recibiría una tabla que no esperaba. Para avisar se usa `PRINT`; para guardar, un `INSERT ... SELECT`.

---

## Resumen

- Un trigger (prefijo `trg_`) es código asociado a una tabla que se ejecuta solo con `INSERT`, `UPDATE` o `DELETE`; no recibe parámetros ni se llama con `EXEC`.
- `AFTER` (o `FOR`) corre después de la operación; `INSTEAD OF` corre en su lugar y la operación original no ocurre.
- Se dispara **una vez por sentencia**: debe funcionar con 1, con muchas y con 0 filas.
- Lo disparan todos los caminos: SSMS, aplicaciones, procedimientos almacenados y vistas.
- Se usa para auditoría, historial, sincronización y reglas que deben cumplirse siempre; las validaciones con mensaje van en procedimientos.
- `CREATE TRIGGER` va solo en su lote; se modifica con `ALTER TRIGGER` y se elimina con `DROP TRIGGER`.
