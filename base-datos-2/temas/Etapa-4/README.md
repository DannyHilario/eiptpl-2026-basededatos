# Etapa 4 — Introducción a la programación Transact-SQL

Propuesta de cómo se ve la Etapa 4 en el curso. El temario oficial ([ContenidoTematico.md](../../ContenidoTematico.md)) se cubre completo, pero en un orden distinto al del libro.

## Por qué en otro orden

El libro deja para el final todo lo que es "programar" en T-SQL: variables, `IF`, `CASE`, errores y transacciones. En la práctica, las variables y el `IF` se necesitan **antes**: un procedimiento almacenado con validaciones no se puede escribir sin ellos. Por eso ya se vieron en la [Etapa 2](../Etapa-2/03-VariablesIfElse.md).

Lo que **sí** conviene dejar al final es el manejo de errores, las transacciones y `THROW`: tienen sentido cuando ya hay un procedimiento que modifica varias tablas o un trigger que tiene que rechazar un cambio. En TiendaDB ([sesión 12](../../sesiones/sesion-12)) aparecieron justamente esos problemas, y cada tema de esta etapa resuelve uno:

| Problema de TiendaDB | Tema que lo resuelve |
|----------------------|----------------------|
| Al quitar la última línea de un pedido, `SUM` regresa `NULL` y el trigger falla | [04 · Errores de valor nulo](04-ValoresNulos.md) |
| Si falla la tercera línea de un pedido, el pedido queda a medias | [05 · Transacciones](05-Transacciones.md) |
| Agregar artículos a un pedido que ya se envió | [06 · Excepciones en procedimientos almacenados](06-ExcepcionesProcedimientos.md) |
| Nada impide un cambio de estatus inválido, como de Enviado a Creado | [07 · THROW](07-Throw.md) |

## Temas

| # | Tema | Temario oficial |
|---|------|-----------------|
| 01 | [T-SQL como lenguaje de programación](01-ProgramacionTSQL.md) | Descripción de Transact SQL para la programación · Declaración y asignación de variables · Control de flujo · `IF`, `IF-ELSE`, `IF EXISTS` · `IF` anidados |
| 02 | [CASE](02-Case.md) | Estructura de control `CASE` · `CASE` con `ORDER BY` · `CASE` con `GROUP BY` · `UPDATE` con `CASE` · `INSERT` con `CASE` |
| 03 | [Errores y TRY CATCH](03-Errores.md) | Gestión de errores en Transact SQL · Funciones `ERROR` |
| 04 | [Errores de valor nulo](04-ValoresNulos.md) | Manejo de errores de valor nulo con `TRY CATCH` |
| 05 | [Transacciones con TRY CATCH](05-Transacciones.md) | Transacciones con instrucción `TRY CATCH` |
| 06 | [Excepciones en procedimientos almacenados](06-ExcepcionesProcedimientos.md) | Manejo de excepciones en procedimientos almacenados |
| 07 | [THROW](07-Throw.md) | `THROW` |

El tema 01 es corto: las variables y el `IF` ya se vieron en la Etapa 2, y aquí solo se agrega lo que falta del temario (`IF EXISTS`, los lotes y `GO`).

## Base de datos de los ejemplos

Todos los ejemplos usan **TiendaDB** con pedidos de ejemplo:

1. Instala TiendaDB desde [`sesiones/sesion-12/TiendaDB/instalar-completo.sql`](../../sesiones/sesion-12/TiendaDB/instalar-completo.sql).
2. Ejecuta completo [`datos-ejemplo.sql`](datos-ejemplo.sql): agrega 8 pedidos de octubre de 2026 con sus líneas y su bitácora.

Quedan así:

| idPedido | Cliente | Estatus | Líneas | Total | Envío |
|----------|---------|---------|--------|-------|-------|
| 1 | 1 | Entregado | 3 | 246.00 | 35.00 |
| 2 | 2 | Entregado | 3 | 199.00 | 35.00 |
| 3 | 3 | Enviado | 3 | 98.50 | 0.00 |
| 4 | 4 | Cancelado | 1 | 300.00 | 35.00 |
| 5 | 5 | Creado | 2 | 320.00 | 35.00 |
| 6 | 1 | Creado | 3 | 126.50 | 0.00 |
| 7 | 6 | Entregado | 3 | 244.50 | 35.00 |
| 8 | 7 | Creado | 0 | 0.00 | 35.00 |

Cada tema parte de esos datos. Algunos ejemplos los modifican: si quieres repetir un tema desde el principio, reinstala TiendaDB y vuelve a ejecutar `datos-ejemplo.sql`.
