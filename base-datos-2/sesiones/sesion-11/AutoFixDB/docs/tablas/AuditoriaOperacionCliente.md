# Tabla `AuditoriaOperacionCliente`

Scripts: [`instalacion/05-AuditoriaOperacionCliente/`](../../instalacion/05-AuditoriaOperacionCliente)

Bitácora de lo que les pasa a los clientes: **un renglón por cada cliente** que se inserta, se modifica o se elimina. Nadie escribe en esta tabla directamente; la llena el trigger [`trg_registroAuditoriaOperacionCliente`](../triggers/trg_registroAuditoriaOperacionCliente.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idAuditoriaOperacionCliente` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCliente` | `INT` | No | — | Cliente afectado por la operación |
| `TipoOperacion` | `CHAR(1)` | No | — | `I` = inserción, `U` = modificación, `D` = eliminación |
| `FechaOperacion` | `DATETIME` | No | `GETDATE()` | Fecha y hora en que ocurrió la operación |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idAuditoriaOperacionCliente)` | Llave primaria | Identifica cada renglón de la bitácora. |
| `CHECK (TipoOperacion IN ('I', 'U', 'D'))` | Check | Solo se aceptan los tres tipos de operación. |
| `DEFAULT GETDATE()` en `FechaOperacion` | Default | El trigger no tiene que calcular la fecha: la pone SQL Server. |

## ¿Por qué `idCliente` no tiene llave foránea?

Porque la auditoría debe **sobrevivir** a la eliminación del cliente. Si `idCliente` fuera llave foránea hacia `Cliente`:

- Un `DELETE` de un cliente con historial **fallaría**, porque su auditoría lo estaría referenciando.
- Y si se quitara la auditoría para poder borrarlo, se perdería justamente el registro que se quería guardar.

Una bitácora guarda **lo que pasó**, aunque lo que pasó ya no exista.

## Relacionada con

- [`Cliente`](Cliente.md) — sin llave foránea; la relación la mantienen los triggers.

## Datos iniciales

**Ninguno.** Los 215 clientes de la instalación se insertan **antes** de crear los triggers, así que la auditoría empieza vacía y solo registra lo que se haga después de instalar.
