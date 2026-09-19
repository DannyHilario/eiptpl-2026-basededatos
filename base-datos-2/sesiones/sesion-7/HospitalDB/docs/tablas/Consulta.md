# Tabla `Consulta`

Script: [`instalacion/07-Consulta/01-create-table.sql`](../../instalacion/07-Consulta/01-create-table.sql)

Hecho — una consulta médica, que une [`Paciente`](Paciente.md), [`Medico`](Medico.md) y [`Consultorio`](Consultorio.md).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idConsulta` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idPaciente` | `INT` | No | — | FK a `Paciente` |
| `idMedico` | `INT` | No | — | FK a `Medico` |
| `idConsultorio` | `INT` | No | — | FK a `Consultorio` |
| `Fecha` | `DATETIME` | No | — | Fecha y hora programada de la consulta (dura 30 minutos, no se guarda porque es fija) |
| `Efectuada` | `BIT` | No | `0` | `1` = la consulta sí se llevó a cabo, `0` = agendada pero aún sin confirmar (o no se presentó el paciente) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idConsulta)` | Llave primaria | Identifica cada consulta de forma única. |
| `FOREIGN KEY (idPaciente)` / `(idMedico)` / `(idConsultorio)` | Llave foránea | Solo permite referenciar registros que existan en sus catálogos. |

No tiene `Activo`: es una tabla de hechos, no un catálogo.

## `Efectuada` — por qué existe

Una consulta se puede agendar con anticipación, pero no siempre se lleva a cabo (el paciente no se presenta, se cancela, etc.) y el modelo no captura el motivo — solo el hecho. `Efectuada` empieza en `0` y pasa a `1` únicamente vía [`usp_efectuarConsulta`](../procedimientos/usp_efectuarConsulta.md), que valida que la fecha programada ya haya pasado. Una consulta con `Efectuada = 0` cuya fecha ya pasó queda como constancia de que se agendó pero nunca ocurrió — no genera receta.

## Flujo de negocio

1. Se agenda la consulta vía [`usp_insertarConsulta`](../procedimientos/usp_insertarConsulta.md), que valida que el médico y el consultorio no tengan ya otra consulta en la misma ventana de 30 minutos. `Efectuada` queda en `0` por default.
2. Cuando la consulta efectivamente ocurre, [`usp_efectuarConsulta`](../procedimientos/usp_efectuarConsulta.md) marca `Efectuada = 1`.
3. Solo entonces [`usp_generarReceta`](../procedimientos/usp_generarReceta.md) puede generar la `Receta` de esa consulta (paso separado, no automático).
4. En farmacia, [`usp_cambiarEstatusReceta`](../procedimientos/usp_cambiarEstatusReceta.md) mueve el estatus de la receta (surtida, surtida parcialmente o cancelada).

## Relacionada con

[`Receta`](Receta.md) — la receta que genera (1:1), solo si `Efectuada = 1`.
