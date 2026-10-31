# Sesión 13 — La bitácora de estatus y los procedimientos del pedido

Continúa con **TiendaDB**, la base que se construyó en la [sesión 12](../sesion-12). En esa sesión el primer estatus de un pedido se registró **a mano** en la bitácora, y los cambios de estatus no se registraban. En esta se resolvió con tres objetos sobre `Pedido`: un trigger que registra cada cambio de estatus y dos procedimientos almacenados para crear y modificar pedidos.

> No hay base nueva: TiendaDB se instala desde [`sesion-12/TiendaDB/`](../sesion-12/TiendaDB), que ya incluye los objetos de esta sesión. Su documentación está en el [README de TiendaDB](../sesion-12/TiendaDB/README.md).

---

## Cómo se desarrolló la clase

Sábado 31 de octubre de 2026.

| Hora | Qué se hizo |
|------|-------------|
| 9:10 – 9:23 | Trigger de la **bitácora de estatus**, primera versión: registraba con cualquier `UPDATE` de `Pedido` |
| 9:18 – 10:01 | Pruebas: se cambió el estatus de un pedido y se revisaron la bitácora y la cabecera |
| 9:54 – 10:04 | Procedimiento para **modificar** un pedido: dirección y costo de envío |
| 9:57 | Segunda versión del trigger: solo registra si el estatus cambió |
| 9:57 – 10:04 | Procedimiento para **crear** un pedido y registrar su primer estatus |

## Qué se hizo en esta sesión

| # | Objeto | Script | Qué hace |
|---|--------|--------|----------|
| 1 | `trg_actualizarEstatusPedido` | [`08-BitacoraEstatusPedido/02-trg-actualizar-estatus-pedido.sql`](../sesion-12/TiendaDB/instalacion/08-BitacoraEstatusPedido/02-trg-actualizar-estatus-pedido.sql) | `AFTER UPDATE` sobre `Pedido`: registra en la bitácora cada cambio de estatus |
| 2 | `usp_crearPedido` | [`06-Pedido/02-usp-crear.sql`](../sesion-12/TiendaDB/instalacion/06-Pedido/02-usp-crear.sql) | Crea un pedido en estatus Creado y registra ese estatus en la bitácora |
| 3 | `usp_actualizarPedido` | [`06-Pedido/03-usp-actualizar.sql`](../sesion-12/TiendaDB/instalacion/06-Pedido/03-usp-actualizar.sql) | Cambia la dirección y el costo de envío de un pedido en estatus Creado |
| 4 | Pruebas 13 a 19 | [`pruebas.sql`](../sesion-12/TiendaDB/pruebas.sql) | Los procedimientos y la bitácora, paso a paso, con los resultados esperados |

## Prerequisito

Instala TiendaDB desde [`sesion-12/TiendaDB/instalar-completo.sql`](../sesion-12/TiendaDB/instalar-completo.sql).

---

## Contenido de estudio

### 1. El trigger de la bitácora de estatus

La regla del negocio: cada vez que un pedido cambia de estatus, queda registrado en `BitacoraEstatusPedido`. Si lo hace un trigger, la bitácora queda completa aunque el estatus se cambie con un `UPDATE` escrito a mano.

#### Primera versión

```sql
CREATE TRIGGER trg_actualizarEstatusPedido
ON Pedido
AFTER UPDATE
AS
BEGIN
	DECLARE
		@idEstatusPedidoActual int,
		@idPedido int

	-- Obtener el idEstatusPedido más actual (inserted). El viejo no nos sirve (deleted)

	SELECT
		@idEstatusPedidoActual = idEstatusPedido,
		@idPedido = idPedido
	FROM inserted

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
	VALUES (
		@idPedido,
		@idEstatusPedidoActual,
		GETDATE(),
		GETDATE(),
		GETDATE()
	)
END
```

Funciona cuando cambia el estatus, pero el trigger se dispara con **cualquier** `UPDATE` de `Pedido`, y `Pedido` se actualiza por muchas razones:

| Quién hace el `UPDATE` | Qué cambia |
|------------------------|------------|
| Los triggers de `DetallePedido` (sesión 12) | `CantidadArticulos` y `Total`, al agregar, cambiar o quitar una línea |
| `usp_actualizarPedido` | `DireccionEntrega` y `CostoEnvio` |

En esos casos el trigger vuelve a registrar el estatus **actual**. Como la bitácora tiene `UNIQUE (idPedido, idEstatusPedido)`, ese registro se rechaza, y el error **deshace la operación original**: agregar un artículo o cambiar la dirección falla. Es el mismo efecto que el error de la primera versión del trigger de cabecera en la [sesión 12](../sesion-12/README.md#el-error-de-la-primera-versión).

#### Segunda versión: comparar con `deleted`

En un `UPDATE`, `deleted` tiene la fila como estaba. Si el estatus de `inserted` es igual al de `deleted`, no hay nada que registrar:

```sql
ALTER TRIGGER trg_actualizarEstatusPedido
ON Pedido
AFTER UPDATE
AS
BEGIN

	DECLARE
		@idEstatusPedidoActual int,
		@idEstatusPedidoAnterior int,
		@idPedido int

	-- El estatus nuevo (inserted) y el anterior (deleted)

	SELECT
		@idEstatusPedidoActual = idEstatusPedido,
		@idPedido = idPedido
	FROM inserted

	SELECT
		@idEstatusPedidoAnterior = idEstatusPedido
	FROM deleted

	-- Si el estatus no cambió (por ejemplo, se recalculó la cabecera), no hay nada que registrar

	IF @idEstatusPedidoActual = @idEstatusPedidoAnterior OR @idPedido IS NULL BEGIN
		RETURN
	END

	INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
	VALUES (
		@idPedido,
		@idEstatusPedidoActual,
		GETDATE(),
		GETDATE(),
		GETDATE()
	)
END
```

El `@idPedido IS NULL` cubre el `UPDATE` que no encontró ninguna fila: el trigger se dispara con las tablas vacías, como en el [histórico de precios](../sesion-12/README.md#2-primer-trigger-el-histórico-de-precios).

#### La versión que se instala

Con variables, un `UPDATE` que cambia el estatus de **varios** pedidos registra solo uno. La versión del paquete hace la misma comparación con un `INNER JOIN` entre `inserted` y `deleted`, y registra un renglón por cada pedido que cambió:

```sql
INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido, FechaCambio, FechaCreacion, FechaUltimaModificacion)
SELECT I.idPedido, I.idEstatusPedido, GETDATE(), GETDATE(), GETDATE()
FROM inserted I
INNER JOIN deleted D ON D.idPedido = I.idPedido
WHERE I.idEstatusPedido <> D.idEstatusPedido
```

Detalle completo en la [documentación del trigger](../sesion-12/TiendaDB/docs/triggers/trg_actualizarEstatusPedido.md).

### 2. Crear un pedido: `usp_crearPedido`

El trigger solo atiende `UPDATE`: un pedido nuevo no *cambia* de estatus, nace en Creado. Por eso el primer estatus lo registra el procedimiento, con el mismo `SCOPE_IDENTITY()` que en la sesión 12 se usó a mano ([sesión 12, sección 3](../sesion-12/README.md#3-crear-un-pedido-scope_identity)):

```sql
INSERT INTO Pedido (idCliente, DireccionEntrega, CostoEnvio)
VALUES (@p_idCliente, @p_DireccionEntrega, @p_CostoEnvio)

SELECT @idPedido = SCOPE_IDENTITY()

INSERT INTO BitacoraEstatusPedido (idPedido, idEstatusPedido)
VALUES (@idPedido, 1)
```

Valida que el cliente exista y esté activo, que la dirección no venga vacía y que el envío no sea negativo. Si todo sale bien, regresa el `idPedido` junto con `ErrCodigo` y `ErrMensaje`. Ver la [documentación del procedimiento](../sesion-12/TiendaDB/docs/procedimientos/usp_crearPedido.md).

### 3. Modificar un pedido: `usp_actualizarPedido`

Cambia la dirección y el costo de envío, **solo mientras el pedido está en Creado**: una vez enviado, ya no se modifica. El cliente, el estatus y los totales no se tocan aquí.

Su `UPDATE` dispara `trg_actualizarEstatusPedido`. Con la primera versión del trigger, este procedimiento fallaba; con la comparación contra `deleted`, el trigger no registra nada porque el estatus no cambió. Ver la [documentación del procedimiento](../sesion-12/TiendaDB/docs/procedimientos/usp_actualizarPedido.md).

### 4. Lo que falta

| Pendiente | Qué pasa hoy |
|-----------|--------------|
| **Las transiciones de estatus** | Nada impide un cambio inválido, como de Enviado a Creado. El `UNIQUE` de la bitácora lo detiene solo si ese estatus ya estaba registrado |

La [Etapa 4](../../temas/Etapa-4) (programación T-SQL, `CASE` y manejo de errores) se ve en la **sesión 14**, el sábado 7 de noviembre, con TiendaDB.

---

## Resumen

| Concepto | En una frase |
|----------|--------------|
| `AFTER UPDATE` | Se dispara con cualquier `UPDATE` de la tabla, cambie o no la columna que nos interesa |
| `inserted` contra `deleted` | Comparar la fila como quedó con la fila como estaba dice qué cambió de verdad |
| Error dentro de un trigger | Deshace también la sentencia que lo disparó |
| `INSERT … SELECT` desde `inserted` | Atiende un `UPDATE` que cambia varias filas; las variables solo guardan una |
| Primer estatus en el procedimiento | Un `INSERT` no dispara un trigger `AFTER UPDATE` |
