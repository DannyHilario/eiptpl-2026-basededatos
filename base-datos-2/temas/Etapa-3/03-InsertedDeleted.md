# Las tablas inserted y deleted

Un trigger no recibe parámetros. Para saber **qué filas** afectó la sentencia que lo disparó, SQL Server le da dos tablas temporales: `inserted` y `deleted`. Son la herramienta central de cualquier trigger.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)) y parten de [Triggers](02-Triggers.md).

---

## Qué contienen

| Operación | `inserted` | `deleted` |
|-----------|------------|-----------|
| `INSERT` | Las filas nuevas | Vacía |
| `UPDATE` | Las filas con sus valores **nuevos** | Las mismas filas con sus valores **anteriores** |
| `DELETE` | Vacía | Las filas eliminadas |

- Tienen **las mismas columnas** que la tabla del trigger: `inserted` de un trigger sobre `Cliente` tiene `idCliente`, `PrimerApellido`, `Nombre`, `Correo`…
- Tienen **una fila por cada fila afectada**: si el `UPDATE` cambió 3 clientes, `deleted` tiene 3 filas (cómo eran) e `inserted` 3 filas (cómo quedaron).
- **Solo existen dentro de un trigger.** Fuera de él:

```sql
SELECT *
FROM inserted
```

```
Msg 208, Level 16, State 1
Invalid object name 'inserted'.
```

- Son de **solo lectura**: se consultan, no se modifican.

### Un UPDATE llena las dos

Dentro del trigger, un `UPDATE` se ve como "se quitó la versión anterior y se puso la nueva". Si se cambia el correo del cliente 201:

```
deleted                                           inserted
┌───────────┬────────┬──────────────────────────┐ ┌───────────┬────────┬────────────────────┐
│ idCliente │ Nombre │ Correo                   │ │ idCliente │ Nombre │ Correo             │
├───────────┼────────┼──────────────────────────┤ ├───────────┼────────┼────────────────────┤
│ 201       │ Renata │ renata.villarreal@gmail… │ │ 201       │ Renata │ renata.v@gmail.com │
└───────────┴────────┴──────────────────────────┘ └───────────┴────────┴────────────────────┘
        valores anteriores                                valores nuevos
```

Uniendo las dos por la llave primaria se tiene, en una sola fila, **el antes y el después**.

---

## Cómo saber qué operación disparó el trigger

Un trigger `AFTER INSERT, UPDATE, DELETE` corre con cualquiera de los tres eventos. Para saber cuál fue, se cuentan las filas de cada tabla:

| `inserted` | `deleted` | Operación |
|------------|-----------|-----------|
| Tiene filas | Tiene filas | `UPDATE` |
| Tiene filas | Vacía | `INSERT` |
| Vacía | Tiene filas | `DELETE` |
| Vacía | Vacía | La sentencia no afectó ninguna fila |

La última fila de la tabla es importante: **un trigger se dispara aunque la sentencia no afecte ninguna fila** (por ejemplo, `DELETE FROM Cliente WHERE idCliente = 9999`). El trigger debe revisar ese caso y no hacer nada.

Así lo hace `trg_registroAuditoriaOperacionCliente`, de la [sesión 11](../../sesiones/sesion-11/AutoFixDB/instalacion/05-AuditoriaOperacionCliente/02-trg-registro-auditoria.sql):

```sql
CREATE TRIGGER trg_registroAuditoriaOperacionCliente
ON Cliente
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

	DECLARE @RegistrosInsertados int,
			@RegistrosEliminados int,
			@Operacion char(1)

	-- Contar registros insertados y eliminados por la sentencia

	SELECT
		@RegistrosInsertados = COUNT(1)
	FROM inserted

	SELECT
		@RegistrosEliminados = COUNT(1)
	FROM deleted

	-- La sentencia no afectó ninguna fila: no hay nada que auditar

	IF @RegistrosInsertados = 0 AND @RegistrosEliminados = 0 BEGIN
		RETURN
	END

	-- Deducir la operación

	IF @RegistrosInsertados > 0 AND @RegistrosEliminados > 0 BEGIN
		SELECT @Operacion = 'U'
	END
	ELSE IF @RegistrosInsertados > 0 BEGIN
		SELECT @Operacion = 'I'
	END
	ELSE BEGIN
		SELECT @Operacion = 'D'
	END

	-- Un renglón por cada cliente afectado. FechaOperacion toma su DEFAULT GETDATE()

	IF @Operacion = 'D' BEGIN

		INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
		SELECT idCliente, @Operacion
		FROM deleted

	END
	ELSE BEGIN

		INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
		SELECT idCliente, @Operacion
		FROM inserted

	END

END
```

| Paso | Qué hace |
|------|----------|
| Contar | `COUNT(1)` de cada tabla. `COUNT(1)` y `COUNT(*)` cuentan lo mismo: todas las filas |
| `RETURN` si no hay filas | Sin esto, una sentencia que no afectó filas dejaba en la auditoría una fila con `TipoOperacion` en `NULL` (ver [lo que se mejoró después de clase](../../sesiones/sesion-11/README.md#6-lo-que-se-mejoró-después-de-clase)) |
| Deducir | La tabla de arriba, escrita con `IF`/`ELSE IF`/`ELSE` |
| Registrar | `INSERT ... SELECT` desde `deleted` (bajas) o desde `inserted` (altas y cambios): una fila por cliente |

---

## Ejemplo: historial de costos

En AutoFixDB, `TipoServicio.Costo` es el **costo actual** de cada servicio y `Servicio.CostoServicio` es lo que **se cobró** en cada servicio. Cuando el taller sube sus precios, los servicios anteriores conservan lo que se cobró; pero el costo anterior del catálogo se pierde: después del `UPDATE` ya nadie sabe cuánto costaba la afinación antes.

Un trigger puede guardar ese historial **automáticamente**, cada vez que alguien cambie un costo, sin importar desde dónde.

La tabla del historial:

```sql
CREATE TABLE HistorialCostoTipoServicio (
    idHistorialCostoTipoServicio INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idTipoServicio INT NOT NULL,
    CostoAnterior DECIMAL(10,2) NOT NULL,
    CostoNuevo DECIMAL(10,2) NOT NULL,
    FechaCambio DATETIME NOT NULL DEFAULT GETDATE()
);
```

El trigger:

```sql
CREATE TRIGGER trg_historialCostoTipoServicio
ON TipoServicio
AFTER UPDATE
AS
BEGIN

	SET NOCOUNT ON

	-- Solo se guardan las filas cuyo costo cambió:
	-- deleted trae el costo anterior e inserted el costo nuevo

	INSERT INTO HistorialCostoTipoServicio (idTipoServicio, CostoAnterior, CostoNuevo)
	SELECT I.idTipoServicio, D.Costo, I.Costo
	FROM inserted AS I
	INNER JOIN deleted AS D ON D.idTipoServicio = I.idTipoServicio
	WHERE I.Costo <> D.Costo

END
```

| Parte | Por qué |
|-------|---------|
| `AFTER UPDATE` | Solo un cambio puede modificar un costo existente |
| `INNER JOIN deleted ... ON idTipoServicio` | Pone en la misma fila el costo anterior (`D.Costo`) y el nuevo (`I.Costo`) de cada tipo de servicio |
| `WHERE I.Costo <> D.Costo` | Un `UPDATE` que cambia solo la descripción también dispara el trigger; sin este filtro, se guardaría un "cambio" de costo que no ocurrió |
| `INSERT ... SELECT` | Funciona con 1 fila o con todas: si el `UPDATE` sube 10 % todo el catálogo, se guardan 6 filas |

### Probarlo

Sube 10 % la Afinación y el Cambio de aceite, en una sola sentencia:

```sql
UPDATE TipoServicio
SET Costo = Costo * 1.10
WHERE idTipoServicio IN (1, 2)
```

```sql
SELECT idHistorialCostoTipoServicio, idTipoServicio, CostoAnterior, CostoNuevo
FROM HistorialCostoTipoServicio
```

| idHistorialCostoTipoServicio | idTipoServicio | CostoAnterior | CostoNuevo |
|------------------------------|----------------|---------------|------------|
| 1 | 2 | 450.00 | 495.00 |
| 2 | 1 | 850.00 | 935.00 |

Dos filas modificadas, dos filas de historial, en el orden que SQL Server eligió.

Cambia solo la descripción:

```sql
UPDATE TipoServicio
SET Descripcion = 'Afinación mayor'
WHERE idTipoServicio = 1
```

El trigger se dispara, pero el `WHERE I.Costo <> D.Costo` no encuentra filas: el historial sigue con 2 registros.

Y los servicios que ya se hicieron conservan lo que se cobró:

```sql
SELECT idServicio, idTipoServicio, CostoServicio
FROM Servicio
WHERE idServicio IN (1, 2)
```

| idServicio | idTipoServicio | CostoServicio |
|------------|----------------|---------------|
| 1 | 2 | 450.00 |
| 2 | 1 | 850.00 |

Ahora el taller tiene las tres cosas: el costo actual (`TipoServicio`), lo que se cobró en cada servicio (`Servicio`) y cuándo y cuánto cambió cada costo (`HistorialCostoTipoServicio`).

> El historial **no** forma parte de la instalación de AutoFixDB: es un ejemplo de estudio. Para quitarlo: `DROP TRIGGER trg_historialCostoTipoServicio` y `DROP TABLE HistorialCostoTipoServicio`.

---

## Comparar el valor anterior con el nuevo

El mismo `inserted INNER JOIN deleted` sirve para cualquier columna. En la sesión 11 hay un ejemplo que registra los cambios de correo de los clientes: [comparar el valor anterior con el nuevo](../../sesiones/sesion-11/README.md#9-para-profundizar-comparar-el-valor-anterior-con-el-nuevo).

> El `JOIN` entre `inserted` y `deleted` se hace por la **llave primaria**, que no cambia. Por eso las llaves primarias no se modifican con `UPDATE`: si cambiaran, ya no habría con qué emparejar el antes y el después.

---

## Resumen

- `inserted` trae las filas nuevas (o los valores nuevos); `deleted`, las filas eliminadas (o los valores anteriores).
- Un `INSERT` llena solo `inserted`, un `DELETE` solo `deleted` y un `UPDATE` las dos.
- Tienen las mismas columnas que la tabla, una fila por fila afectada, y solo existen dentro del trigger.
- Contando sus filas se deduce la operación; si las dos están vacías, la sentencia no afectó filas y el trigger no debe hacer nada.
- `inserted INNER JOIN deleted` por la llave primaria pone en la misma fila el valor anterior y el nuevo.
- Se trabaja con `INSERT ... SELECT` y `UPDATE ... JOIN`, nunca suponiendo que viene una sola fila.
