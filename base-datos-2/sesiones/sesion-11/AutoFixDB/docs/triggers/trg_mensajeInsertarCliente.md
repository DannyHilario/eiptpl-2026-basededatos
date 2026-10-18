# `trg_mensajeInsertarCliente`

Script: [`instalacion/01-Cliente/04-trg-mensaje-insertar.sql`](../../instalacion/01-Cliente/04-trg-mensaje-insertar.sql)

| Tabla | Momento | Evento |
|-------|---------|--------|
| `Cliente` | `AFTER` | `INSERT` |

Después de cada `INSERT` en `Cliente`, imprime en la pestaña **Mensajes** cuántos registros se insertaron. Es el primer trigger de la sesión 11: sirve para ver **cuándo** se dispara un trigger y qué hay en la tabla `inserted`.

## Cómo funciona

1. Termina un `INSERT` sobre `Cliente`.
2. SQL Server dispara el trigger **una vez**, con la tabla `inserted` llena con las filas que se acaban de insertar.
3. El trigger cuenta esas filas con `COUNT(1)` y las imprime con `PRINT`.

`CONVERT(varchar(10), @CantidadInsertada)` convierte el número a texto: `PRINT` no puede concatenar un texto con un `int` directamente.

## Resultados

| Sentencia | Mensaje |
|-----------|---------|
| `INSERT` de 1 cliente | `Registros correctamente insertados: 1` |
| `INSERT` de 3 clientes en una sola sentencia | `Registros correctamente insertados: 3` |
| `EXEC usp_insertarCliente …` con éxito | `Registros correctamente insertados: 1` |
| `UPDATE` o `DELETE` | Nada: el trigger es solo `AFTER INSERT` |

> El trigger se dispara **una vez por sentencia**, no una vez por fila: el `INSERT` de 3 clientes imprime **un** mensaje que dice 3.
