# `usp_insertarBitacoraEstatusReceta`

Script: [`instalacion/11-BitacoraEstatusReceta/02-usp-insertar.sql`](../../instalacion/11-BitacoraEstatusReceta/02-usp-insertar.sql)

> **No lo ejecutes directamente para cambiar el estatus de una receta.** Este SP solo inserta el renglón de bitácora; no actualiza `Receta.idEstatusReceta`. Para cambiar el estatus de una receta usa [`usp_cambiarEstatusReceta`](usp_cambiarEstatusReceta.md), que sí llama a este SP internamente **y** actualiza el estatus vigente.

Registra una transición de estatus de una receta en `BitacoraEstatusReceta`.

## En palabras simples

Piensa en `BitacoraEstatusReceta` como el "diario" de una receta: cada vez que la receta cambia de estatus (de Creada a En atención, de En atención a Surtida, etc.), este SP escribe una línea nueva en ese diario con la fecha en que pasó. Nunca borra ni modifica líneas anteriores — solo agrega. Así, con el tiempo, se puede reconstruir toda la historia de una receta con un simple `SELECT`, sin tener que preguntarle a nadie "¿cuándo se surtió esto?".

Antes de escribir la línea nueva, el SP se asegura de tres cosas: que la receta exista, que el estatus al que quiere pasar exista, y que ese cambio de estatus tenga sentido (no se puede pasar de "Surtida" a "Cancelada", por ejemplo — ver la explicación completa abajo).

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idReceta` | `int` | Id de la receta |
| `@p_idEstatusNuevo` | `int` | Id del estatus al que transiciona |

`EstatusActual` no se recibe como parámetro: el SP lo lee internamente de `Receta.idEstatusReceta` en el momento de la ejecución.

## Validaciones (orden en que se evalúan)

1. La receta debe existir.
2. El estatus nuevo debe existir en `EstatusReceta`.
3. La transición del estatus actual al estatus nuevo debe ser una de las permitidas: `1 Creada → 2 En atención`, `2 → 3 Surtida`, `2 → 4 Surtida parcialmente`, `4 → 3`, `1 → 5 Cancelada`, `2 → 5`. Cualquier otra combinación (incluyendo `3 → 4` o cancelar desde `3`/`4`) es inválida.

## ¿Cómo funciona la validación de la transición? (explicado sin jerga)

Esta es la parte del SP que más preguntas suele generar, así que vale la pena detenerse. En el script se ve así:

```sql
SET @TransicionValida = 0

IF @idEstatusActual = 1 AND @p_idEstatusNuevo = 2 SET @TransicionValida = 1
IF @idEstatusActual = 2 AND @p_idEstatusNuevo = 3 SET @TransicionValida = 1
IF @idEstatusActual = 2 AND @p_idEstatusNuevo = 4 SET @TransicionValida = 1
IF @idEstatusActual = 4 AND @p_idEstatusNuevo = 3 SET @TransicionValida = 1
IF @idEstatusActual = 1 AND @p_idEstatusNuevo = 5 SET @TransicionValida = 1
IF @idEstatusActual = 2 AND @p_idEstatusNuevo = 5 SET @TransicionValida = 1

IF @TransicionValida = 0 BEGIN
	-- error 000003
END
```

**La idea, en una frase:** `@TransicionValida` es un semáforo que arranca en rojo (`0`, "este cambio no está permitido") y el SP solo lo pone en verde (`1`) si el cambio que le están pidiendo aparece en su lista de movimientos permitidos. Al final, si el semáforo sigue en rojo, se rechaza el cambio.

Esa "lista de movimientos permitidos" es exactamente el mapa de estatus que se explica en el [README de la sesión](../../../README.md#los-estatus-de-una-receta-visto-como-mapa):

| Si la receta está en... | ...se puede mover a... |
|---|---|
| `1 Creada` | `2 En atención`, o directo a `5 Cancelada` |
| `2 En atención` | `3 Surtida`, `4 Surtida parcialmente`, o `5 Cancelada` |
| `3 Surtida` | *(nada — ya es un estado final)* |
| `4 Surtida parcialmente` | `3 Surtida` |
| `5 Cancelada` | *(nada — ya es un estado final)* |

Cada uno de los 6 `IF` es, literalmente, una fila de esa tabla convertida a código: "si el estatus actual es X y me piden pasar a Y, entonces este cambio sí es válido". Como una receta solo tiene **un** estatus actual y solo se pide pasar a **un** estatus nuevo, nunca se van a activar dos de esos `IF` al mismo tiempo — como mucho uno de ellos va a ser cierto (o ninguno, si el cambio no está permitido). Por eso no hace falta usar `ELSE`: no son alternativas encadenadas de una misma pregunta, son 6 preguntas independientes que se hacen una por una, y con que una sola sea cierta basta para poner el semáforo en verde.

Si repasas la lista, notarás que **no** existe ningún `IF` para `3 → 4`, ni para `3 → 5`, ni para `4 → 5`. Eso es intencional: `3 Surtida` y `5 Cancelada` son estados finales (ninguna fila de la tabla parte de ellos), y una receta parcialmente surtida (`4`) ya no se puede cancelar, solo completarse (`4 → 3`). Como esas combinaciones nunca aparecen en la lista, ninguno de los 6 `IF` las enciende, el semáforo se queda en rojo, y el SP las rechaza automáticamente — sin necesidad de escribir una validación "negativa" aparte para cada caso prohibido.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La receta no existe | `idReceta` inválido |
| `000002` | El estatus nuevo no existe | `idEstatusNuevo` inválido |
| `000003` | La transición de estatus no es válida | La combinación estatus actual → estatus nuevo no está en la lista de transiciones permitidas |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
-- Receta 1 está en estatus 1 (Creada); pasa a 2 (En atención)
EXEC usp_insertarBitacoraEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 2
```

## Casos de prueba sugeridos

```sql
-- Éxito: verificar el renglón nuevo en BitacoraEstatusReceta
EXEC usp_insertarBitacoraEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 2
SELECT * FROM BitacoraEstatusReceta WHERE idReceta = 1

-- Receta no existe
EXEC usp_insertarBitacoraEstatusReceta @p_idReceta = 9999, @p_idEstatusNuevo = 2

-- Estatus nuevo no existe
EXEC usp_insertarBitacoraEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 9999

-- Transición inválida (receta 8 está en estatus 3 Surtida; intentar pasar a 4)
EXEC usp_insertarBitacoraEstatusReceta @p_idReceta = 8, @p_idEstatusNuevo = 4

-- Transición inválida (receta 3 está en estatus 5 Cancelada; intentar cancelar otra vez no aplica,
-- pero cancelar desde 3/4 tampoco: receta 8 en estatus 3, intentar pasar a 5)
EXEC usp_insertarBitacoraEstatusReceta @p_idReceta = 8, @p_idEstatusNuevo = 5
```

## Instalación

Depende de que [`usp_cambiarEstatusReceta`](usp_cambiarEstatusReceta.md) exista **al momento de ejecutarse**, aunque no al crearse: SQL Server resuelve nombres de objetos referenciados dentro de un procedimiento hasta que se invoca (deferred name resolution), no cuando se hace el `CREATE PROCEDURE`. Por eso el paquete de instalación puede crear este SP (carpeta `11-BitacoraEstatusReceta`) después del de `usp_cambiarEstatusReceta` (carpeta `08-Receta`) sin error — solo importa que ambos existan antes del primer `EXEC usp_cambiarEstatusReceta`.
