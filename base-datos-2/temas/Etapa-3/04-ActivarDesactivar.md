# Activación y desactivación de triggers

Un trigger está **activo** desde que se crea: se dispara con cada evento de su tabla. A veces conviene **apagarlo** por un momento sin eliminarlo, y volver a encenderlo después, con el mismo código.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)) y el trigger `trg_historialCostoTipoServicio` de [inserted y deleted](03-InsertedDeleted.md#ejemplo-historial-de-costos).

---

## ¿Cuándo se desactiva un trigger?

| Situación | Por qué |
|-----------|---------|
| **Carga masiva** de datos (por ejemplo, migrar miles de clientes de otro sistema) | Un trigger de mensaje o de auditoría haría la carga más lenta y llenaría la auditoría con registros que no son operaciones reales |
| **Corrección de datos** por parte del administrador | Para que un ajuste técnico no quede registrado como un cambio del negocio |
| **Buscar un error** | Para saber si un comportamiento extraño viene del trigger o de otra parte |

> Mientras un trigger está desactivado **no hace nada**, y lo que pasó en ese tiempo **no se recupera** al activarlo. Si la auditoría estuvo apagada durante una carga, esos registros no quedan auditados. Desactivar un trigger es una decisión que debe tomarse a propósito, y debe volver a activarse en cuanto termine el trabajo.

---

## Sintaxis

```sql
-- Un trigger
DISABLE TRIGGER trg_nombre ON NombreTabla;
ENABLE TRIGGER trg_nombre ON NombreTabla;

-- Todos los triggers de una tabla
DISABLE TRIGGER ALL ON NombreTabla;
ENABLE TRIGGER ALL ON NombreTabla;

-- Todos los triggers de una tabla, con ALTER TABLE
ALTER TABLE NombreTabla DISABLE TRIGGER ALL;
ALTER TABLE NombreTabla ENABLE TRIGGER ALL;

-- Un trigger, con ALTER TABLE
ALTER TABLE NombreTabla DISABLE TRIGGER trg_nombre;
ALTER TABLE NombreTabla ENABLE TRIGGER trg_nombre;
```

Las dos formas (`DISABLE TRIGGER ... ON` y `ALTER TABLE ... DISABLE TRIGGER`) hacen lo mismo.

> **El punto y coma es obligatorio antes de `DISABLE TRIGGER` y `ENABLE TRIGGER`.** Si en el mismo lote hay otra instrucción antes, esa instrucción debe terminar con `;`. Si no, SQL Server no reconoce dónde empieza el `DISABLE` y marca un error de sintaxis aunque la instrucción esté bien escrita:
>
> ```sql
> SELECT COUNT(*) FROM Cliente
> DISABLE TRIGGER trg_mensajeInsertarCliente ON Cliente
> ```
>
> ```
> Msg 156, Level 15, State 1
> Incorrect syntax near the keyword 'TRIGGER'.
> ```
>
> Con `SELECT COUNT(*) FROM Cliente;` funciona. Por eso, en este tema todas estas instrucciones terminan con `;`.

> **Ojo con el manual del curso.** En la sección 3.5 indica:
>
> ```sql
> ALTER TRIGGER nombre_trigger ENABLE;
> ALTER TRIGGER nombre_trigger DISABLE;
> ALTER TABLE nombre_tabla ENABLE ALL TRIGGERS;
> ALTER TABLE nombre_tabla DISABLE ALL TRIGGERS;
> ```
>
> **Ninguna de las cuatro existe en SQL Server.** `ALTER TRIGGER` sirve para cambiar el código del trigger, no para activarlo o desactivarlo; y con `ALTER TABLE` el orden correcto es `DISABLE TRIGGER ALL`, no `DISABLE ALL TRIGGERS`. Marcan:
>
> ```
> Msg 102, Level 15, State 1
> Incorrect syntax near 'DISABLE'.
>
> Msg 156, Level 15, State 1
> Incorrect syntax near the keyword 'ALL'.
> ```
>
> Las correctas son las de arriba.

---

## Ejemplo

Con `trg_historialCostoTipoServicio` creado y dos cambios de costo ya registrados en el historial:

### 1. Desactivar

```sql
DISABLE TRIGGER trg_historialCostoTipoServicio ON TipoServicio;
```

### 2. Comprobar que está desactivado

```sql
SELECT name, is_disabled
FROM sys.triggers
WHERE name = 'trg_historialCostoTipoServicio'
```

| name | is_disabled |
|------|-------------|
| trg_historialCostoTipoServicio | 1 |

`is_disabled` vale `1` si está desactivado y `0` si está activo.

### 3. Modificar con el trigger apagado

```sql
UPDATE TipoServicio
SET Costo = 400.00
WHERE idTipoServicio = 5
```

```sql
SELECT COUNT(*) AS Registros
FROM HistorialCostoTipoServicio
```

| Registros |
|-----------|
| 2 |

El Diagnóstico computarizado cambió de 350.00 a 400.00, pero el historial sigue con los 2 registros anteriores: ese cambio **no quedó registrado**.

### 4. Volver a activar

```sql
ENABLE TRIGGER trg_historialCostoTipoServicio ON TipoServicio;
```

A partir de aquí, cada cambio de costo vuelve a quedar en el historial. El cambio a 400.00 no aparece: ocurrió mientras el trigger estaba apagado.

---

## Desactivar todos los triggers de una tabla

`Cliente` tiene dos triggers: el del mensaje y el de la auditoría. Para una carga masiva se apagan los dos:

```sql
ALTER TABLE Cliente DISABLE TRIGGER ALL;

-- ... la carga ...

ALTER TABLE Cliente ENABLE TRIGGER ALL;
```

O solo uno, dejando el otro trabajando:

```sql
DISABLE TRIGGER trg_mensajeInsertarCliente ON Cliente;
```

Con el mensaje apagado, un `INSERT` en `Cliente` ya no imprime `Registros correctamente insertados`, pero la auditoría sigue registrando el alta. Las pruebas 9 a 11 de [`pruebas.sql`](../../sesiones/sesion-11/AutoFixDB/pruebas.sql) de la sesión 11 lo comprueban.

---

## Ver el estado de todos los triggers

```sql
SELECT T.name AS TriggerName, OBJECT_NAME(T.parent_id) AS Tabla, T.is_disabled
FROM sys.triggers AS T
ORDER BY Tabla, TriggerName
```

| TriggerName | Tabla | is_disabled |
|-------------|-------|-------------|
| trg_mensajeInsertarCliente | Cliente | 0 |
| trg_registroAuditoriaOperacionCliente | Cliente | 0 |
| trg_historialCostoTipoServicio | TipoServicio | 0 |

Antes de terminar un trabajo con triggers desactivados, esta consulta confirma que todos volvieron a `0`.

---

## Desactivar contra eliminar

| | `DISABLE TRIGGER` | `DROP TRIGGER` |
|---|---|---|
| El código | Se conserva | Se pierde |
| Para volver a usarlo | `ENABLE TRIGGER` | Volver a escribir el `CREATE TRIGGER` |
| Aparece en `sys.triggers` | Sí, con `is_disabled = 1` | No |
| Cuándo | Pausas temporales | El trigger ya no se necesita |

---

## Resumen

- Un trigger se desactiva con `DISABLE TRIGGER trg_nombre ON Tabla` y se activa con `ENABLE TRIGGER trg_nombre ON Tabla`.
- `ALL` en lugar del nombre, o `ALTER TABLE Tabla DISABLE|ENABLE TRIGGER ALL`, afecta todos los triggers de la tabla.
- `ALTER TRIGGER ... ENABLE` / `DISABLE`, como aparece en el manual, **no es válido** en SQL Server.
- `sys.triggers.is_disabled` dice si cada trigger está activo (`0`) o desactivado (`1`).
- Lo que ocurre mientras un trigger está desactivado no se registra nunca: se reactiva en cuanto termina el trabajo.
