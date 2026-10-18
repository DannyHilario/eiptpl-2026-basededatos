# Procedimientos almacenados

Un **procedimiento almacenado** (*stored procedure*, SP) es un conjunto de instrucciones T-SQL guardado en la base de datos con un nombre. Se ejecuta cuando alguien lo llama con `EXEC`, y puede recibir **parámetros**, tomar **decisiones** y hacer **varias operaciones** en una sola llamada.

Los ejemplos usan **AutoFixDB** (ver [Cláusulas SQL](../Etapa-1/01-Clausulas.md#base-de-datos-de-los-ejemplos)).

---

## Vista contra procedimiento almacenado

Una [vista](../Etapa-1/05-Vistas.md) guarda **una consulta**. Un procedimiento almacenado guarda **un programa**.

| | Vista | Procedimiento almacenado |
|---|---|---|
| Contiene | Un solo `SELECT` | Cualquier cantidad de instrucciones |
| Parámetros | No | Sí |
| Puede modificar datos | Solo como destino de un `INSERT`/`UPDATE`/`DELETE` | Sí, dentro de su código |
| Decisiones (`IF`/`ELSE`) | No | Sí |
| Se usa con | `SELECT ... FROM vw_...` | `EXEC usp_...` |
| Prefijo | `vw_` | `usp_` |

## ¿Para qué sirve?

| Ventaja | Qué significa |
|---------|---------------|
| **Reglas de negocio en un solo lugar** | "No se registra un vehículo de un cliente inactivo" se programa una vez en el SP, y todas las aplicaciones que lo usan la respetan |
| **Validar antes de modificar** | El SP revisa los datos y, si algo está mal, regresa un mensaje en lugar de insertar |
| **Menos tráfico** | La aplicación envía `EXEC usp_insertarVehiculo 200, 'Mazda', 'CX-3', 2022` en lugar de todas las consultas de validación |
| **Seguridad** | Se puede dar permiso de ejecutar el SP sin dar permiso sobre las tablas |
| **Reutilización** | El mismo SP se usa desde SSMS, desde una aplicación web o desde otro SP |

En AutoFixDB, [`usp_insertarCliente`](../../sesiones/sesion-11/AutoFixDB/docs/procedimientos/usp_insertarCliente.md) es un ejemplo: antes de dar de alta a un cliente revisa que su correo y su teléfono no estén registrados.

---

## Tipos de procedimientos almacenados

| Tipo | Quién lo crea | Cómo se reconoce | Ejemplo |
|------|---------------|------------------|---------|
| **Definidos por el usuario** | Tú | Prefijo `usp_` en el curso | `usp_insertarCliente` |
| **Temporales** | Tú, para la sesión actual | Empiezan con `#` (locales) o `##` (globales) | `#usp_contarClientes` |
| **Del sistema** | SQL Server | Prefijo `sp_` | `sp_help`, `sp_helptext`, `sp_rename` |
| **Extendidos** | Programas externos (DLL) | Prefijo `xp_` | `xp_cmdshell` |

### Definidos por el usuario

Son los que se construyen en el curso. Se guardan en la base de datos donde se crean y existen hasta que se eliminan con `DROP PROCEDURE`. Se ven en SSMS en **Programación → Procedimientos almacenados**.

### Temporales

Se guardan en la base de datos del sistema `tempdb` y desaparecen solos:

| Prefijo | Quién lo puede usar | Cuándo desaparece |
|---------|---------------------|-------------------|
| `#` (local) | Solo la conexión que lo creó | Al cerrar esa conexión |
| `##` (global) | Todas las conexiones | Cuando se cierra la conexión que lo creó y nadie más lo está usando |

```sql
CREATE PROCEDURE #usp_contarClientes
AS
BEGIN
	SELECT COUNT(*) AS Clientes
	FROM Cliente
END
```

```sql
EXEC #usp_contarClientes
```

| Clientes |
|----------|
| 215 |

Si se cierra la pestaña de SSMS y se abre otra, `#usp_contarClientes` ya no existe.

### Del sistema

Vienen con SQL Server y sirven para consultar y administrar la base de datos. Los más útiles en el curso:

| Procedimiento | Qué hace |
|---------------|----------|
| `EXEC sp_help 'Cliente'` | Describe un objeto: columnas, tipos, llaves, restricciones y quién lo referencia |
| `EXEC sp_helptext 'usp_insertarCliente'` | Muestra el código de un procedimiento, una vista, una función o un trigger |
| `EXEC sp_rename 'NombreViejo', 'NombreNuevo'` | Cambia el nombre de un objeto |

> **No uses el prefijo `sp_` en tus procedimientos.** Cuando SQL Server ve un nombre que empieza con `sp_`, primero lo busca en la base de datos `master`, entre los del sistema. Además de ser más lento, si algún día existe uno del sistema con el mismo nombre, se ejecuta ese y no el tuyo. Por eso en el curso se usa `usp_` (*user stored procedure*).

### Extendidos

Ejecutan programas externos a SQL Server. Microsoft los marca como **obsoletos**: se conservan por compatibilidad, pero no deben usarse en desarrollos nuevos. En el curso no se usan.

---

## Resumen

- Un procedimiento almacenado es un programa T-SQL guardado en la base de datos, que se ejecuta con `EXEC`.
- A diferencia de una vista, recibe parámetros, ejecuta varias instrucciones y toma decisiones.
- Sirve para centralizar reglas de negocio, validar antes de modificar y controlar permisos.
- Hay cuatro tipos: definidos por el usuario (`usp_`), temporales (`#` y `##`), del sistema (`sp_`) y extendidos (`xp_`, obsoletos).
- Nunca se usa el prefijo `sp_` para procedimientos propios.
