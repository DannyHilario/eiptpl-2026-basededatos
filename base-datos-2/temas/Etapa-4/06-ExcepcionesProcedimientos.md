# Manejo de excepciones en procedimientos almacenados

En la [Etapa 2](../Etapa-2/04-Validaciones.md), los procedimientos validan lo que conocen y responden con `ErrCodigo` y `ErrMensaje`. Pero siempre queda algo que no se validó: una restricción que nadie revisó, un dato que cambió entre la validación y el `INSERT`. Cuando eso falla, el procedimiento termina con un error en rojo, y quien lo llamó recibe **otra cosa** que el `ErrCodigo` que esperaba.

Una **excepción** es justo eso: un error que no se previó. Este tema junta las validaciones de la Etapa 2 con `TRY … CATCH`, para que el procedimiento responda **siempre** de la misma forma.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4.

---

## Ejemplo: usp_agregarArticuloPedido

Agrega un artículo a un pedido. Reglas del negocio:

- El pedido debe existir.
- Solo se agregan artículos a un pedido en estatus **Creado**.
- El artículo debe existir y estar activo.
- La línea lleva el precio **vigente** del artículo.

```sql
CREATE PROCEDURE usp_agregarArticuloPedido
	@p_idPedido int,
	@p_idArticulo int,
	@p_Cantidad int
AS
BEGIN

	DECLARE @ErrCodigo varchar(10),
			@ErrMensaje varchar(200),

			@idEstatusPedido int,
			@PrecioUnitario decimal(10,2)

	-- Validación 1: el pedido existe

	SELECT
		@idEstatusPedido = idEstatusPedido
	FROM Pedido
	WHERE idPedido = @p_idPedido

	IF @idEstatusPedido IS NULL BEGIN

		SELECT 	@ErrCodigo = '000001',
				@ErrMensaje = 'El pedido no existe'

		SELECT	@ErrCodigo AS ErrCodigo,
				@ErrMensaje AS ErrMensaje

		RETURN
	END

	-- Validación 2: solo se agregan artículos a un pedido en estatus Creado

	IF @idEstatusPedido <> 1 BEGIN

		SELECT 	@ErrCodigo = '000002',
				@ErrMensaje = 'Solo se pueden agregar artículos a un pedido en estatus Creado'

		SELECT	@ErrCodigo AS ErrCodigo,
				@ErrMensaje AS ErrMensaje

		RETURN
	END

	-- Validación 3: el artículo existe y está activo; de paso se obtiene su precio vigente

	SELECT
		@PrecioUnitario = PrecioUnitario
	FROM Articulo
	WHERE idArticulo = @p_idArticulo AND Activo = 1

	IF @PrecioUnitario IS NULL BEGIN

		SELECT 	@ErrCodigo = '000003',
				@ErrMensaje = 'El artículo no existe o está dado de baja'

		SELECT	@ErrCodigo AS ErrCodigo,
				@ErrMensaje AS ErrMensaje

		RETURN
	END

	-- Alta de la línea con el precio vigente. Lo que no se validó arriba
	-- (por ejemplo, el artículo repetido o una cantidad de 0) lo atrapa el CATCH

	BEGIN TRY

		INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
		VALUES (@p_idPedido, @p_idArticulo, @p_Cantidad, @PrecioUnitario)

		SELECT 	@ErrCodigo = '000000',
				@ErrMensaje = 'Artículo agregado al pedido'

	END TRY
	BEGIN CATCH

		SELECT 	@ErrCodigo = '999999',
				@ErrMensaje = 'Error ' + CONVERT(varchar(10), ERROR_NUMBER()) + ': ' + ERROR_MESSAGE()

	END CATCH

	SELECT	@ErrCodigo AS ErrCodigo,
			@ErrMensaje AS ErrMensaje

END
```

### Dos tipos de error

| | Validaciones (`000001` a `000003`) | Excepción (`999999`) |
|---|---|---|
| ¿Se previó? | Sí: son las reglas del negocio | No: es lo que se escapó a las validaciones |
| ¿Quién la detecta? | Un `IF` | El `CATCH` |
| ¿Qué mensaje da? | Uno escrito para el usuario | El de SQL Server, con su número |

El `999999` es una red de seguridad. Si un error se repite seguido, conviene convertirlo en una validación con su propio código y un mensaje claro.

---

## Probar cada camino

```sql
EXEC usp_agregarArticuloPedido 6, 9, 2      -- pedido 6 (Creado), cacahuate x 2
EXEC usp_agregarArticuloPedido 999, 9, 2    -- el pedido no existe
EXEC usp_agregarArticuloPedido 3, 9, 2      -- el pedido 3 ya se envió
EXEC usp_agregarArticuloPedido 6, 999, 2    -- el artículo no existe
EXEC usp_agregarArticuloPedido 6, 9, 1      -- el cacahuate ya está en el pedido 6
EXEC usp_agregarArticuloPedido 6, 10, 0     -- cantidad 0
```

| Llamada | ErrCodigo | ErrMensaje |
|---------|-----------|------------|
| Pedido 6, artículo 9 | `000000` | Artículo agregado al pedido |
| Pedido 999 | `000001` | El pedido no existe |
| Pedido 3 (Enviado) | `000002` | Solo se pueden agregar artículos a un pedido en estatus Creado |
| Artículo 999 | `000003` | El artículo no existe o está dado de baja |
| Artículo repetido | `999999` | Error 2627: Violation of UNIQUE KEY constraint 'uq_DetallePedido_Pedido_Articulo'. … The duplicate key value is (6, 9). |
| Cantidad 0 | `999999` | Error 547: The INSERT statement conflicted with the CHECK constraint "chk_DetallePedido_Cantidad". … |

Las seis llamadas responden **con la misma forma**: un `ErrCodigo` y un `ErrMensaje`, sin mensajes en rojo. Al final, el pedido 6 tiene 4 líneas y $158.50: los triggers de `DetallePedido` recalcularon la cabecera con la única línea que sí se agregó.

> Los dos `999999` son candidatos a validación: "el artículo ya está en el pedido" y "la cantidad debe ser mayor a cero" son reglas del negocio conocidas, y merecen su propio código.

> Este procedimiento es un ejemplo de estudio y **no** forma parte de la instalación de TiendaDB. Para quitarlo: `DROP PROCEDURE usp_agregarArticuloPedido`.

---

## Resumen

- Una excepción es un error que no se previó en las validaciones.
- Las validaciones van primero, como *guard clauses*: un `IF` con su código propio y `RETURN`; la instrucción que modifica datos va dentro de `TRY`.
- El `CATCH` convierte cualquier error inesperado en un `ErrCodigo` genérico (`999999`) con el número y el mensaje de SQL Server.
- Así el procedimiento responde **siempre** igual, pase lo que pase.
- Un `999999` que se repite seguido es una validación que falta.
