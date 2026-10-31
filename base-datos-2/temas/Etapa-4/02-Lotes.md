# Lotes y GO

Cuando ejecutas un script en SSMS, SQL Server no recibe el archivo completo de una vez ni instrucción por instrucción: lo recibe por **lotes**. Entender qué es un lote explica varias cosas que ya te pasaron en el curso: por qué `CREATE PROCEDURE` necesita un `GO` antes, por qué una variable "desaparece" o por qué un error de dedo impide que corra todo un bloque.

Los ejemplos no necesitan ninguna base de datos en particular: puedes ejecutarlos en cualquiera.

---

## Qué es un lote

Un **lote** (en inglés, *batch*) es un grupo de instrucciones que se envían **juntas** a SQL Server para que las ejecute.

Piénsalo como un paquete de mensajería: SSMS mete varias instrucciones en una caja, la cierra y la manda. SQL Server abre la caja, **revisa todo lo que trae** y, si está bien escrito, ejecuta las instrucciones una por una. Luego SSMS manda la siguiente caja.

## GO: dónde termina un lote

En SSMS, `GO` marca **dónde termina un lote** y empieza el siguiente. Este script tiene tres lotes:

```sql
PRINT 'Lote 1: primera instrucción'
PRINT 'Lote 1: segunda instrucción'
GO
PRINT 'Lote 2'
GO
PRINT 'Lote 3'
GO
```

Si un script no tiene ningún `GO`, todo el script es **un solo lote**.

> `GO` **no** es una instrucción de T-SQL: SQL Server nunca la ve. Es una señal para SSMS que significa "manda lo que llevas". Por eso va sola en su línea, no lleva punto y coma y no se puede usar dentro de un procedimiento.

### Qué se envía al presionar F5

| Qué tienes en el editor | Qué se ejecuta |
|---|---|
| Nada seleccionado | **Todo el archivo**, partido en lotes en cada `GO` |
| Un fragmento seleccionado | **Solo lo seleccionado**, partido en lotes si trae algún `GO` |

Seleccionar un fragmento y presionar F5 es lo que haces cuando ejecutas solo un caso de prueba: ese fragmento es un lote nuevo.

---

## Un lote se revisa completo antes de ejecutarse

Antes de ejecutar un lote, SQL Server lo **revisa completo**: que esté bien escrito y que cada variable esté declarada. Si encuentra un error de este tipo, **no ejecuta nada del lote**, ni siquiera las instrucciones que estaban bien. Los demás lotes del script sí se ejecutan.

```sql
PRINT 'Lote 1: primera instrucción'
PRINT 'Lote 1: segunda instrucción'
GO
PRINT 'Lote 2: empieza'
SELEC * FROM Cliente
PRINT 'Lote 2: termina'
GO
PRINT 'Lote 3: sí se ejecuta'
GO
```

```
Lote 1: primera instrucción
Lote 1: segunda instrucción
Msg 102, Level 15, State 1, Line 2
Incorrect syntax near 'SELEC'.
Lote 3: sí se ejecuta
```

Fíjate en dos cosas:

- **"Lote 2: empieza" no aparece**, aunque esa línea está bien escrita y va antes del error. Por `SELEC` (le falta la T), SQL Server rechazó el lote 2 completo.
- El mensaje dice **`Line 2`**, aunque en el archivo `SELEC` está en la línea 5. La línea se cuenta **desde el inicio del lote**, no del archivo: `SELEC` es la segunda línea del lote 2.

### Los errores al ejecutar son distintos

Un error que aparece **mientras** se ejecuta (un dato inválido, una división entre cero, una restricción) no detiene el lote: cancela **esa** instrucción y el lote sigue con la siguiente.

```sql
PRINT 'Antes del error'
SELECT 10 / 0 AS Resultado
PRINT 'Después del error'
GO
```

```
Antes del error
Msg 8134, Level 16, State 1, Line 2
Divide by zero error encountered.
Después del error
```

| Tipo de error | Cuándo aparece | Qué pasa con el lote | Ejemplos |
|---|---|---|---|
| De escritura | Al **revisar** el lote | No se ejecuta **nada** del lote | `Msg 102` (sintaxis), `Msg 137` (variable no declarada) |
| De ejecución | Al **ejecutar** una instrucción | Se cancela esa instrucción y **el lote sigue** | `Msg 8134` (división entre cero), `Msg 547` (`CHECK` o llave foránea), `Msg 2627` (`UNIQUE`) |

Los errores de ejecución son los que se atrapan con `TRY … CATCH` ([Errores y TRY CATCH](04-Errores.md)). Los de escritura no se pueden atrapar: el lote ni siquiera empieza.

---

## Una variable vive dentro de su lote

Una variable existe desde su `DECLARE` hasta el **final del lote**. Después de `GO`, ya no existe:

```sql
DECLARE @Total int = 5
PRINT 'Total: ' + CONVERT(varchar(10), @Total)
GO
PRINT 'Total: ' + CONVERT(varchar(10), @Total)
GO
```

```
Total: 5
Msg 137, Level 15, State 2, Line 1
Must declare the scalar variable "@Total".
```

El segundo lote no conoce a `@Total`: para SQL Server es un paquete nuevo, sin nada de lo que traía el anterior. Y como "variable no declarada" es un error de escritura, el segundo lote no se ejecuta.

Por eso, cuando pruebas un procedimiento seleccionando solo unas líneas, tienen que ir **dentro de lo seleccionado** el `DECLARE` y todo lo que use la variable.

---

## CREATE va solo en su lote

`CREATE PROCEDURE`, `CREATE FUNCTION`, `CREATE TRIGGER` y `CREATE VIEW` tienen una regla especial: deben ser la **primera instrucción de su lote**.

```sql
PRINT 'Creando el procedimiento'
CREATE PROCEDURE usp_saludarLote
AS
BEGIN
	PRINT 'Hola'
END
GO
```

```
Msg 111, Level 15, State 1, Procedure usp_saludarLote, Line 4
'CREATE/ALTER PROCEDURE' must be the first statement in a query batch.
```

Como es un error de escritura, tampoco se ejecuta el `PRINT`: el lote completo se rechaza.

Y la regla tiene una segunda mitad: **todo lo que sigue al `CREATE` hasta el siguiente `GO` forma parte del objeto**. Si escribes una prueba justo debajo del `END` sin un `GO` de por medio, la prueba queda guardada **dentro** del procedimiento ([Escribir pruebas debajo del procedimiento sin GO](../Etapa-2/02-CrearEjecutar.md#escribir-pruebas-debajo-del-procedimiento-sin-go)).

La forma correcta: un `GO` antes del `CREATE` y otro después del `END`.

```sql
CREATE PROCEDURE usp_saludarLote
AS
BEGIN
	PRINT 'Hola'
END
GO
EXEC usp_saludarLote
GO
```

```
Hola
```

### En los scripts del curso

En los paquetes de instalación del curso, **cada objeto va en su propio archivo**: un archivo por tabla, por procedimiento, por función, por vista o por trigger. Como cada archivo se ejecuta aparte, cada uno es su propio lote, y el `CREATE` siempre queda primero sin necesidad de `GO`.

Cuando sí juntas varios objetos en un mismo archivo (por ejemplo, un `instalar-completo.sql`), necesitas un `GO` después de cada uno.

---

## Resumen

- Un **lote** es un grupo de instrucciones que se envían juntas a SQL Server.
- En SSMS, `GO` marca dónde termina un lote. No es T-SQL: es una señal para SSMS.
- Sin `GO`, todo el script es un solo lote. Con un fragmento seleccionado, F5 solo envía ese fragmento.
- SQL Server **revisa el lote completo** antes de ejecutarlo: un error de escritura (sintaxis, variable no declarada) impide que se ejecute **cualquier** instrucción del lote.
- Un error **al ejecutar** solo cancela esa instrucción; el lote sigue.
- El número de línea de un error se cuenta desde el inicio del lote.
- Una variable vive hasta el final de su lote.
- `CREATE PROCEDURE`, `FUNCTION`, `TRIGGER` y `VIEW` deben ser lo primero del lote, y todo lo que sigue hasta el `GO` forma parte del objeto.
