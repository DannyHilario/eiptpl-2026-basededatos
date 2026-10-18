# Sesión 11 — Triggers

Primera sesión de **triggers** (disparadores), sobre **AutoFixDB**, el taller mecánico de Base de Datos I. Se le agregaron un procedimiento almacenado, una tabla de auditoría y dos triggers, y se probó cuándo y cómo se dispara cada uno.

> Desde esta sesión, AutoFixDB se instala con su **versión de Base de Datos II**: [`AutoFixDB/`](AutoFixDB). La de Base de Datos I queda congelada.

---

## Qué se hizo en esta sesión

| # | Objeto | Script | Qué hace |
|---|--------|--------|----------|
| 1 | `AutoFixDB` | [`instalar-completo.sql`](AutoFixDB/instalar-completo.sql) | Base del taller: clientes, vehículos, tipos de servicio y servicios |
| 2 | `usp_insertarCliente` | [`01-Cliente/03-usp-insertar.sql`](AutoFixDB/instalacion/01-Cliente/03-usp-insertar.sql) | Alta de un cliente validando que el correo y el teléfono no se repitan |
| 3 | 15 clientes nuevos | [`01-Cliente/02-insert.sql`](AutoFixDB/instalacion/01-Cliente/02-insert.sql) | Un solo `INSERT` de 15 filas, para ver cuántas veces se dispara un trigger |
| 4 | `trg_mensajeInsertarCliente` | [`01-Cliente/04-trg-mensaje-insertar.sql`](AutoFixDB/instalacion/01-Cliente/04-trg-mensaje-insertar.sql) | `AFTER INSERT`: imprime cuántos clientes se insertaron |
| 5 | `AuditoriaOperacionCliente` | [`05-AuditoriaOperacionCliente/01-create-table.sql`](AutoFixDB/instalacion/05-AuditoriaOperacionCliente/01-create-table.sql) | Bitácora de operaciones sobre clientes |
| 6 | `trg_registroAuditoriaOperacionCliente` | [`05-AuditoriaOperacionCliente/02-trg-registro-auditoria.sql`](AutoFixDB/instalacion/05-AuditoriaOperacionCliente/02-trg-registro-auditoria.sql) | `AFTER INSERT, UPDATE, DELETE`: registra cada cliente afectado y el tipo de operación |
| 7 | Pruebas | [`pruebas.sql`](AutoFixDB/pruebas.sql) | `INSERT`, `UPDATE`, `DELETE`, SP y activación/desactivación de triggers, con resultados esperados |

La documentación completa de cada tabla, del procedimiento y de los triggers está en el [README de AutoFixDB](AutoFixDB/README.md).

## Prerequisito

Instala AutoFixDB desde [`AutoFixDB/instalar-completo.sql`](AutoFixDB/instalar-completo.sql). Si tienes la de Base de Datos I, ejecuta primero su reversa: las dos usan el nombre `AutoFixDB`.

---

## Contenido de estudio

El tema completo está en la [Etapa 3 — Funciones y triggers](../../README.md#etapa-3--funciones-y-triggers). Aquí está lo que se vio en clase, en el orden en que se construyó.

### 1. Qué es un trigger

Un **trigger** es código que SQL Server ejecuta **solo**, automáticamente, cuando ocurre un evento sobre una tabla: un `INSERT`, un `UPDATE` o un `DELETE`. Nadie lo llama con `EXEC`: se dispara.

| | Procedimiento almacenado | Trigger |
|---|---|---|
| ¿Quién lo ejecuta? | Quien escribe `EXEC` | SQL Server, cuando ocurre el evento |
| ¿Recibe parámetros? | Sí | No: recibe las tablas `inserted` y `deleted` |
| ¿Se puede evitar? | Basta con no llamarlo | No, mientras esté activo: cualquier `INSERT` lo dispara, venga de donde venga |

Esa última fila es la razón de existir de un trigger: **garantiza** que algo pase siempre. El procedimiento `usp_insertarCliente` valida correos repetidos, pero solo si se usa; un `INSERT` escrito a mano se lo salta. En cambio, ningún `INSERT` se salta el trigger de auditoría.

### 2. Sintaxis

```sql
CREATE TRIGGER trg_nombreDelTrigger
ON NombreTabla
AFTER INSERT, UPDATE, DELETE      -- uno o varios eventos
AS
BEGIN
    -- instrucciones
END
```

| Momento | Cuándo se ejecuta |
|---------|-------------------|
| `AFTER` (o `FOR`, que es lo mismo) | **Después** de que la operación se completó y pasó todas las restricciones |
| `INSTEAD OF` | **En lugar de** la operación: la operación original **no** ocurre, a menos que el trigger la haga |

En clase se usó `AFTER`. El `INSTEAD OF` está explicado más abajo.

### 3. El primer trigger: un mensaje después de insertar

```sql
CREATE TRIGGER trg_mensajeInsertarCliente
ON Cliente
AFTER INSERT
AS
BEGIN

	DECLARE @CantidadInsertada int

	SELECT
		@CantidadInsertada = COUNT(1)
	FROM inserted

	PRINT 'Registros correctamente insertados: ' + CONVERT(varchar(10), @CantidadInsertada)

END
```

`inserted` es una **tabla especial**: dentro del trigger, contiene las filas que la sentencia acaba de insertar. Tiene las mismas columnas que `Cliente`.

| Prueba | Mensaje |
|--------|---------|
| `INSERT` de 1 cliente | `Registros correctamente insertados: 1` |
| `INSERT` de 15 clientes en **una** sentencia | `Registros correctamente insertados: 15` |
| `EXEC usp_insertarCliente …` | `Registros correctamente insertados: 1` |

Dos lecciones de esta prueba:

- **El trigger se dispara una vez por sentencia, no una vez por fila.** El `INSERT` de 15 clientes lo disparó **una** vez, con 15 filas en `inserted`. Por eso un trigger siempre debe pensarse para **varias** filas.
- **Al trigger no le importa quién insertó.** El `INSERT` que hace el procedimiento almacenado lo dispara igual que uno escrito a mano.

### 4. Las tablas inserted y deleted

| Operación | `inserted` | `deleted` |
|-----------|------------|-----------|
| `INSERT` | Las filas nuevas | Vacía |
| `UPDATE` | Las filas con sus valores **nuevos** | Las mismas filas con sus valores **anteriores** |
| `DELETE` | Vacía | Las filas eliminadas |

Un `UPDATE` se ve, dentro del trigger, como "borrar la versión anterior e insertar la nueva": por eso llena **las dos** tablas.

Solo existen **dentro** de un trigger. Fuera de él, `SELECT * FROM inserted` marca error.

### 5. La auditoría

El segundo trigger atiende los tres eventos y deja una bitácora en `AuditoriaOperacionCliente`. Como un mismo trigger recibe `INSERT`, `UPDATE` y `DELETE`, primero **deduce** cuál ocurrió, contando las filas de `inserted` y de `deleted` con la tabla del punto 4:

```sql
-- Primero: si la sentencia no afectó filas, no hay nada que auditar (ver el punto 6)
IF @RegistrosInsertados = 0 AND @RegistrosEliminados = 0 BEGIN
	RETURN
END

IF @RegistrosInsertados > 0 AND @RegistrosEliminados > 0 BEGIN
	SELECT @Operacion = 'U'
END
ELSE IF @RegistrosInsertados > 0 BEGIN
	SELECT @Operacion = 'I'
END
ELSE BEGIN
	SELECT @Operacion = 'D'
END
```

Y después registra un renglón por cada cliente afectado:

```sql
INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
SELECT idCliente, @Operacion
FROM inserted     -- o FROM deleted, si fue un DELETE
```

### 6. Lo que se mejoró después de clase

La versión de clase registraba **un renglón por sentencia**, con solo la fecha y el tipo. Al probarla aparecieron tres problemas, que la versión del repositorio ya corrige:

| Problema | Cómo se vio | Corrección |
|----------|-------------|------------|
| Una sentencia que **no afecta ninguna fila** también dispara el trigger. Con `inserted` y `deleted` vacíos, ninguna condición se cumplía y se registraba un renglón con tipo `NULL` | `DELETE FROM Cliente WHERE idCliente = 9999` | Si las dos tablas están vacías, el trigger sale con `RETURN` sin registrar nada |
| No se sabía **qué cliente** se modificó o eliminó | La auditoría decía `U`, pero no a quién | Columna `idCliente` |
| Un `INSERT` de 15 clientes dejaba **un** solo renglón | El `INSERT` de los 15 clientes | `INSERT … SELECT … FROM inserted`: un renglón por cliente |

La tabla también ganó `NOT NULL` en todas sus columnas, un `DEFAULT GETDATE()` en la fecha y un `CHECK` que solo acepta `I`, `U` o `D`.

#### El IF con RETURN: el caso que faltaba

Antes de deducir la operación, la versión corregida revisa si la sentencia afectó alguna fila:

```sql
IF @RegistrosInsertados = 0 AND @RegistrosEliminados = 0 BEGIN
	RETURN
END
```

**Por qué hace falta.** SQL Server dispara el trigger **una vez por sentencia**, no una vez por fila, y lo dispara **aunque la sentencia no afecte ninguna fila**:

```sql
DELETE FROM Cliente
WHERE idCliente = 9999   -- no existe: no se borra nada, pero el trigger se ejecuta
```

En ese caso el trigger entra con las dos tablas vacías. Es un cuarto caso que no aparece en la tabla del punto 4:

| Sentencia | `inserted` | `deleted` |
|-----------|------------|-----------|
| `INSERT` | Filas | Vacía |
| `UPDATE` | Filas | Filas |
| `DELETE` | Vacía | Filas |
| **Cualquiera que no afecte filas** | **Vacía** | **Vacía** |

**Qué pasaba en la versión de clase.** La deducción solo contemplaba los tres primeros renglones. Con las dos tablas vacías no se cumplía ninguna condición (`inserted > 0 AND deleted > 0`, `inserted > 0`, `deleted > 0`), así que `@Operacion` se quedaba en `NULL`. Aun así, el trigger seguía hasta el `INSERT` de la auditoría y dejaba un renglón con `TipoOperacion` en `NULL`: el registro de una operación que nunca ocurrió.

**Qué hace el RETURN.** Termina el trigger en ese momento, antes de deducir la operación y antes del `INSERT`: si nada cambió, no hay nada que auditar. Además, hace seguro el `ELSE` final de la deducción: como ya se descartó que las dos tablas estén vacías, si no es `U` ni `I`, por fuerza es `D`.

**Cuándo pasa en la práctica.** Más seguido de lo que parece: un `UPDATE` o `DELETE` cuyo `WHERE` no encuentra nada, un `INSERT ... SELECT` cuyo `SELECT` no regresa filas, o un procedimiento que intenta actualizar un registro que ya no existe. La prueba 8 de [`pruebas.sql`](AutoFixDB/pruebas.sql) lo comprueba: el `DELETE` del cliente 9999 no deja nada en la auditoría.

> **La regla:** un trigger debe funcionar con **muchas** filas, con **una** y con **cero**.

> **¿Por qué `idCliente` no tiene llave foránea?** Porque la auditoría debe sobrevivir al cliente: con llave foránea, borrar un cliente con historial fallaría. Una bitácora guarda lo que pasó, aunque ya no exista.

Las pruebas 2 a 8 de [`pruebas.sql`](AutoFixDB/pruebas.sql) muestran cada caso con su resultado esperado.

### 7. Activar y desactivar triggers

Un trigger está **activo** desde que se crea. Se puede desactivar sin borrarlo, por ejemplo para una carga masiva de datos, y volver a activar:

```sql
-- Un trigger
DISABLE TRIGGER trg_mensajeInsertarCliente ON Cliente;
ENABLE TRIGGER trg_mensajeInsertarCliente ON Cliente;

-- Todos los triggers de una tabla
ALTER TABLE Cliente DISABLE TRIGGER ALL;
ALTER TABLE Cliente ENABLE TRIGGER ALL;

-- ¿Cuáles están desactivados?
SELECT name, is_disabled
FROM sys.triggers;
```

Con `trg_mensajeInsertarCliente` desactivado, un `INSERT` ya no imprime nada, pero el de auditoría sigue registrando (prueba 9).

> **Ojo con el manual del curso.** En la sección 3.5 indica `ALTER TRIGGER nombre ENABLE;`, `ALTER TRIGGER nombre DISABLE;` y `ALTER TABLE tabla DISABLE ALL TRIGGERS;`. **Esa sintaxis no existe en SQL Server**: marca `Incorrect syntax near 'ENABLE'` o `Incorrect syntax near the keyword 'ALL'`. Las correctas son las de arriba (detalle en [Activación y desactivación de triggers](../../temas/Etapa-3/04-ActivarDesactivar.md)).

> Mientras un trigger está desactivado, **no hace nada**: si la auditoría estaba apagada durante una carga, esos clientes no quedan auditados.

### 8. INSTEAD OF: hacer otra cosa en lugar de la operación

Un trigger `INSTEAD OF` **reemplaza** la operación. Por ejemplo, en un taller no conviene borrar un vehículo que tiene servicios: es mejor darlo de baja. Este trigger convierte cualquier `DELETE` de `Vehiculo` en una baja lógica:

```sql
CREATE TRIGGER trg_bajaLogicaVehiculo
ON Vehiculo
INSTEAD OF DELETE
AS
BEGIN

	-- En lugar de borrar, se marca el vehículo como inactivo

	UPDATE V
	SET Activo = 0
	FROM Vehiculo V
	INNER JOIN deleted D ON D.idVehiculo = V.idVehiculo

	PRINT 'Vehículo dado de baja (no se eliminó)'

END
```

```sql
DELETE FROM Vehiculo
WHERE idVehiculo IN (166, 167);
-- Mensaje: Vehículo dado de baja (no se eliminó)
-- Los vehículos 166 y 167 siguen existiendo, con Activo = 0
```

En un `INSTEAD OF DELETE`, `deleted` contiene las filas que **se iban a** borrar. El `UPDATE … FROM … INNER JOIN deleted` marca como inactivas justamente esas.

> Este trigger **no** forma parte de la instalación de AutoFixDB: es un ejemplo. Si lo pruebas, elimínalo después con `DROP TRIGGER trg_bajaLogicaVehiculo;`.

### 9. Para profundizar: comparar el valor anterior con el nuevo

En un `UPDATE`, unir `deleted` con `inserted` por la llave primaria permite ver **qué cambió**:

```sql
CREATE TRIGGER trg_cambioCorreoCliente
ON Cliente
AFTER UPDATE
AS
BEGIN

	SELECT D.idCliente, D.Correo AS CorreoAnterior, I.Correo AS CorreoNuevo
	FROM deleted D
	INNER JOIN inserted I ON I.idCliente = D.idCliente
	WHERE D.Correo <> I.Correo

END
```

```sql
UPDATE Cliente
SET Correo = 'renata.v@gmail.com'
WHERE idCliente = 201;
```

| idCliente | CorreoAnterior | CorreoNuevo |
|-----------|----------------|-------------|
| 201 | renata.villarreal@gmail.com | renata.v@gmail.com |

Es la base para una auditoría más completa, que guarde el valor anterior y el nuevo de cada columna que cambió.

> Igual que el anterior, es un ejemplo y no está en la instalación.

---

## Resumen

| Concepto | En una frase |
|----------|--------------|
| Trigger | Código que SQL Server ejecuta solo cuando ocurre un `INSERT`, `UPDATE` o `DELETE` |
| `AFTER` / `FOR` | Se ejecuta después de la operación |
| `INSTEAD OF` | Se ejecuta en lugar de la operación |
| `inserted` | Las filas nuevas (`INSERT`) o con sus valores nuevos (`UPDATE`) |
| `deleted` | Las filas eliminadas (`DELETE`) o con sus valores anteriores (`UPDATE`) |
| Frecuencia | Una vez por **sentencia**, con todas las filas afectadas en `inserted`/`deleted` |
| Activar / desactivar | `ENABLE TRIGGER` / `DISABLE TRIGGER … ON Tabla` |
