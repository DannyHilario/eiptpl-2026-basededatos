# T-SQL como lenguaje de programación

**Transact-SQL** (T-SQL) es el SQL de SQL Server más lo que lo convierte en un lenguaje de programación: variables, decisiones (`IF`, `CASE`), manejo de errores y transacciones. Con SQL "puro" se consulta y se modifica; con T-SQL además se **decide** qué hacer según lo que se encuentra.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4.

---

## Lo que ya se vio en la Etapa 2

Buena parte del temario de esta etapa se adelantó, porque sin ella no se pueden escribir procedimientos almacenados:

| Tema del temario | Dónde está |
|------------------|------------|
| Declaración y asignación de variables | [Variables e IF / ELSE](../Etapa-2/03-VariablesIfElse.md#variables) |
| `IF` e `IF - ELSE` | [Variables e IF / ELSE](../Etapa-2/03-VariablesIfElse.md#if--else) |
| `IF` anidados | [IF anidados](../Etapa-2/03-VariablesIfElse.md#if-anidados) |
| Validar con `IF @variable IS NULL` | [Validaciones y códigos de salida](../Etapa-2/04-Validaciones.md) |

Este tema agrega lo que falta: cómo SQL Server ejecuta el código por **lotes** e `IF EXISTS`.

---

## Lotes y GO

Un **lote** es el conjunto de instrucciones que se envían juntas a SQL Server para ejecutarse. En SSMS, `GO` marca dónde termina un lote y empieza el siguiente.

> `GO` **no** es una instrucción de T-SQL: es una indicación para SSMS de "manda lo que llevas". Por eso no lleva punto y coma ni se puede usar dentro de un procedimiento.

Dos consecuencias importantes:

**1. Una variable solo vive dentro de su lote.** Después de `GO`, ya no existe:

```sql
DECLARE @idCliente int = 7
PRINT 'Antes de GO: ' + CONVERT(varchar(10), @idCliente)
GO
PRINT 'Después de GO: ' + CONVERT(varchar(10), @idCliente)
GO
```

```
Antes de GO: 7
Msg 137, Level 15, State 2, Line 1
Must declare the scalar variable "@idCliente".
```

El segundo lote ni siquiera empieza: SQL Server revisa el lote completo antes de ejecutarlo, encuentra una variable que no se declaró en ese lote y lo rechaza entero.

**2. `CREATE PROCEDURE`, `CREATE FUNCTION` y `CREATE TRIGGER` deben ser la primera instrucción de su lote.** Por eso en un script van precedidos de `GO`, como en el [`instalar-completo.sql`](../../sesiones/sesion-12/TiendaDB/instalar-completo.sql) de TiendaDB.

---

## IF EXISTS

`EXISTS` pregunta si una consulta regresa **al menos una fila**. Con `IF`, se usa para decidir según si algo existe o no:

```sql
IF EXISTS (SELECT idPedido FROM Pedido WHERE idCliente = 7 AND idEstatusPedido = 1) BEGIN
	PRINT 'El cliente 7 tiene un pedido abierto'
END
ELSE BEGIN
	PRINT 'El cliente 7 no tiene pedidos abiertos'
END
```

```
El cliente 7 tiene un pedido abierto
```

La consulta dentro de `EXISTS` no regresa datos al usuario: solo responde sí o no. También existe `IF NOT EXISTS (...)`.

### Por qué en el curso se usa una variable

La misma pregunta se puede contestar guardando el dato en una variable y validando con `IS NULL`, que es el patrón de la [Etapa 2](../Etapa-2/04-Validaciones.md):

```sql
DECLARE @idPedido int

SELECT
	@idPedido = idPedido
FROM Pedido
WHERE idCliente = 7 AND idEstatusPedido = 1

IF @idPedido IS NOT NULL BEGIN
	PRINT 'El cliente 7 tiene abierto el pedido ' + CONVERT(varchar(10), @idPedido)
END
```

```
El cliente 7 tiene abierto el pedido 8
```

| | `IF EXISTS (SELECT ...)` | Variable + `IS NULL` |
|---|---|---|
| Responde si existe | Sí | Sí |
| Además da el dato | No | Sí: el `idPedido`, que casi siempre se necesita después |
| Se lee | En una línea, con una consulta dentro del `IF` | En pasos: consultar, guardar, decidir |

Por eso, en los procedimientos del curso las validaciones se escriben con variable. `IF EXISTS` hay que reconocerlo, porque se encuentra en mucho código, pero no se usa en los ejercicios.

---

## Control de flujo

Las instrucciones que deciden qué se ejecuta y en qué orden:

| Instrucción | Para qué | Dónde se ve |
|-------------|----------|-------------|
| `BEGIN … END` | Agrupa varias instrucciones en un bloque | Desde la Etapa 2 |
| `IF … ELSE` | Ejecuta un bloque u otro según una condición | [Etapa 2](../Etapa-2/03-VariablesIfElse.md#if--else) |
| `RETURN` | Termina el procedimiento o el trigger en ese momento | [Etapa 2](../Etapa-2/04-Validaciones.md) y los triggers de la [sesión 12](../../sesiones/sesion-12) |
| `CASE` | Elige un **valor** según una condición, dentro de una consulta | [Tema 02](02-Case.md) |
| `TRY … CATCH` | Ejecuta un bloque y, si falla, otro | [Tema 03](03-Errores.md) |

---

## Resumen

- T-SQL es SQL más variables, decisiones, manejo de errores y transacciones.
- Un lote se envía y se ejecuta junto; `GO` separa lotes en SSMS y no es T-SQL.
- Una variable no sobrevive al `GO`.
- `CREATE PROCEDURE`, `CREATE FUNCTION` y `CREATE TRIGGER` deben ser la primera instrucción de su lote.
- `IF EXISTS (SELECT ...)` responde si una consulta regresa filas; en el curso se prefiere guardar el dato en una variable y validar con `IS NULL`, porque además se obtiene el dato.
