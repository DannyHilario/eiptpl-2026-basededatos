# `trg_registroAuditoriaOperacionCliente`

Script: [`instalacion/05-AuditoriaOperacionCliente/02-trg-registro-auditoria.sql`](../../instalacion/05-AuditoriaOperacionCliente/02-trg-registro-auditoria.sql)

| Tabla | Momento | Eventos |
|-------|---------|---------|
| `Cliente` | `AFTER` | `INSERT`, `UPDATE`, `DELETE` |

Cada vez que se inserta, modifica o elimina un cliente, escribe en [`AuditoriaOperacionCliente`](../tablas/AuditoriaOperacionCliente.md) **un renglón por cada cliente afectado**, con el tipo de operación. El script vive en la carpeta de la auditoría, y no en la de `Cliente`, porque necesita que la tabla de auditoría ya exista.

## Cómo sabe qué operación fue

Un mismo trigger atiende los tres eventos, así que primero tiene que averiguar cuál ocurrió. Lo deduce **contando** las filas de `inserted` y `deleted`:

| Operación | Filas en `inserted` | Filas en `deleted` | `@Operacion` |
|-----------|---------------------|--------------------|--------------|
| `INSERT` | > 0 (los nuevos) | 0 | `I` |
| `UPDATE` | > 0 (valores nuevos) | > 0 (valores anteriores) | `U` |
| `DELETE` | 0 | > 0 (los eliminados) | `D` |
| Sentencia que no afectó filas | 0 | 0 | — (sale con `RETURN`) |

Después inserta en la auditoría **desde la tabla que tiene los clientes afectados**: `deleted` si fue un `DELETE` (porque en `inserted` no hay nada) e `inserted` en los otros dos casos.

```sql
INSERT INTO AuditoriaOperacionCliente (idCliente, TipoOperacion)
SELECT idCliente, @Operacion
FROM inserted
```

`FechaOperacion` no se escribe: la pone su `DEFAULT GETDATE()`.

## De la versión de clase a esta versión

En clase se escribió una primera versión que registraba **un renglón por sentencia**, solo con la fecha y el tipo. Al probarla aparecieron tres problemas, y esta versión los corrige:

| Problema en la versión de clase | Ejemplo | Corrección |
|----------------------------------|---------|------------|
| Una sentencia que no afecta filas **también dispara** el trigger. Con `inserted` y `deleted` vacíos, `@Operacion` quedaba en `NULL` y se registraba un renglón sin tipo | `DELETE FROM Cliente WHERE idCliente = 9999` | Si ambas tablas están vacías, `RETURN` antes de registrar |
| No se sabía **qué cliente** se tocó | La auditoría decía `U`, pero no a quién | Columna `idCliente` |
| Un `INSERT` de 15 clientes dejaba **un solo** renglón | El `INSERT` de 15 clientes de la clase | `INSERT … SELECT … FROM inserted`: un renglón por fila |

La tabla también ganó `NOT NULL` en todas sus columnas, el `DEFAULT GETDATE()` y el `CHECK` del tipo de operación.

La explicación completa del `IF` con `RETURN` (por qué una sentencia sin filas dejaba un renglón con tipo `NULL`) está en el [README de la sesión 11](../../../README.md#el-if-con-return-el-caso-que-faltaba).

## Resultados (pruebas 2 a 8 de [`pruebas.sql`](../../pruebas.sql))

| Sentencia | Renglones nuevos en la auditoría |
|-----------|----------------------------------|
| `INSERT` de 1 cliente (216) | 1 `I` (216) |
| `INSERT` de 3 clientes en una sentencia | 3 `I` (217, 218, 219) |
| `EXEC usp_insertarCliente …` con éxito | 1 `I` (220) |
| `EXEC usp_insertarCliente …` rechazado | Ninguno: no hubo `INSERT` |
| `UPDATE` del cliente 211 | 1 `U` (211) |
| `DELETE … WHERE idCliente >= 219` | 2 `D` (219 y 220) |
| `DELETE … WHERE idCliente = 9999` | Ninguno |

> `inserted` y `deleted` **no tienen orden garantizado**: el `INSERT` de 3 clientes puede quedar registrado como 219, 218, 217. Para ver la auditoría en orden, consúltala con `ORDER BY`.
