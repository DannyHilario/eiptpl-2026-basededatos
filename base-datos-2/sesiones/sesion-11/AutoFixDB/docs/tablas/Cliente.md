# Tabla `Cliente`

Scripts: [`instalacion/01-Cliente/`](../../instalacion/01-Cliente)

Catálogo de clientes del taller (215 en la instalación: los 200 de Base de Datos I y 15 agregados en la sesión 11): los dueños de los vehículos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `PrimerApellido` | `VARCHAR(50)` | No | — | Primer apellido |
| `SegundoApellido` | `VARCHAR(50)` | **Sí** | — | Segundo apellido (opcional: no todos los clientes tienen dos apellidos) |
| `Nombre` | `VARCHAR(100)` | No | — | Nombre(s) |
| `Telefono` | `VARCHAR(15)` | No | — | Teléfono de contacto |
| `Correo` | `VARCHAR(100)` | No | — | Correo electrónico |
| `Activo` | `BIT` | No | `1` | `1` = activo, `0` = dado de baja |

> **Igual que en Base de Datos I.** `Telefono` y `Correo` **no** tienen `UNIQUE`: por eso [`usp_insertarCliente`](../procedimientos/usp_insertarCliente.md) valida que no se repitan antes de insertar. Un `INSERT` escrito directamente sí puede repetirlos.

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idCliente)` | Llave primaria | Identifica cada cliente. |
| `DEFAULT 1` en `Activo` | Default | Todo renglón nuevo nace activo. |

## Relacionada con

- [`Vehiculo`](Vehiculo.md) — la referencia por `idCliente` (1:N).
- [`AuditoriaOperacionCliente`](AuditoriaOperacionCliente.md) — **sin llave foránea**: la llenan los triggers de `Cliente`.

## Objetos de Base de Datos II sobre esta tabla

| Objeto | Tipo | Qué hace |
|--------|------|----------|
| [`usp_insertarCliente`](../procedimientos/usp_insertarCliente.md) | Procedimiento almacenado | Alta de un cliente validando correo y teléfono |
| [`trg_mensajeInsertarCliente`](../triggers/trg_mensajeInsertarCliente.md) | Trigger `AFTER INSERT` | Informa cuántos clientes se insertaron |
| [`trg_registroAuditoriaOperacionCliente`](../triggers/trg_registroAuditoriaOperacionCliente.md) | Trigger `AFTER INSERT, UPDATE, DELETE` | Registra cada cliente afectado en la auditoría |
