# `usp_insertarConsulta`

Script: [`instalacion/07-Consulta/03-usp-insertar.sql`](../../instalacion/07-Consulta/03-usp-insertar.sql)

**Este es el SP que debe usarse para agendar una consulta.** Es el primer paso del flujo de negocio (ver [`README`](../../../README.md#flujo-de-negocio)): valida que paciente, médico y consultorio existan, y que el médico y el consultorio no tengan ya otra consulta agendada que se traslape en el tiempo.

## En palabras simples

Cada consulta ocupa a un médico y un consultorio durante 30 minutos. Este SP evita el error clásico de agenda: que a un médico (o a un consultorio) lo agenden dos veces al mismo tiempo. Antes de crear la consulta, busca si ya existe otra cita — de ese médico **o** de ese consultorio — cuya ventana de 30 minutos se cruce con la que se está pidiendo. Si encuentra alguna, rechaza la nueva.

**¿Cómo detecta que dos citas "se cruzan"?** Piensa en cada cita como un segmento de tiempo, no un solo punto: la cita nueva ocupa de `Fecha` a `Fecha + 30 minutos`, y lo mismo cada cita ya existente. Dos segmentos de tiempo se cruzan si **el que empieza antes todavía no termina cuando el otro ya empezó** — así es exactamente como lo revisa el `SELECT` del SP:

```sql
WHERE (idMedico = @p_idMedico OR idConsultorio = @p_idConsultorio)
AND Fecha < DATEADD(MINUTE, @DuracionMinutos, @p_Fecha)   -- la cita existente empezó antes de que termine la nueva
AND DATEADD(MINUTE, @DuracionMinutos, Fecha) > @p_Fecha   -- y la cita existente no había terminado cuando empieza la nueva
```

Si las dos condiciones son ciertas al mismo tiempo, los segmentos se traslapan — no hace falta que sea exactamente la misma hora, con que se encimen 1 minuto ya cuenta. La duración de 30 minutos está hardcodeada como una constante (`@DuracionMinutos`) porque, en este alcance, no existe una tabla de configuración/parámetros — es una regla de negocio fija que no se espera que cambie en el semestre.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente |
| `@p_idMedico` | `int` | Id del médico |
| `@p_idConsultorio` | `int` | Id del consultorio |
| `@p_Fecha` | `datetime` | Fecha y hora en que se agenda la consulta |

`Efectuada` no se recibe como parámetro: toda consulta nace con `Efectuada = 0` (el default de la columna) y solo cambia vía [`usp_efectuarConsulta`](usp_efectuarConsulta.md).

## Validaciones (orden en que se evalúan)

1. El paciente debe existir.
2. El médico debe existir.
3. El consultorio debe existir.
4. Ni el médico ni el consultorio deben tener ya otra consulta que se traslape con la ventana de 30 minutos de la consulta nueva (la duración de una consulta, `@DuracionMinutos = 30`, está hardcodeada — no hay tabla de parámetros en este alcance).

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El paciente no existe | `idPaciente` inválido |
| `000002` | El médico no existe | `idMedico` inválido |
| `000003` | El consultorio no existe | `idConsultorio` inválido |
| `000004` | El médico o el consultorio ya tienen una consulta agendada en ese horario | Traslape de horario |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarConsulta @p_idPaciente = 1, @p_idMedico = 1, @p_idConsultorio = 1, @p_Fecha = '2026-11-02T09:00:00'
```

## Casos de prueba sugeridos

```sql
-- Éxito: horario libre
EXEC usp_insertarConsulta @p_idPaciente = 1, @p_idMedico = 1, @p_idConsultorio = 1, @p_Fecha = '2026-11-02T09:00:00'

-- Paciente no existe
EXEC usp_insertarConsulta @p_idPaciente = 9999, @p_idMedico = 1, @p_idConsultorio = 1, @p_Fecha = '2026-11-02T09:00:00'

-- Médico no existe
EXEC usp_insertarConsulta @p_idPaciente = 1, @p_idMedico = 9999, @p_idConsultorio = 1, @p_Fecha = '2026-11-02T09:00:00'

-- Consultorio no existe
EXEC usp_insertarConsulta @p_idPaciente = 1, @p_idMedico = 1, @p_idConsultorio = 9999, @p_Fecha = '2026-11-02T09:00:00'

-- Traslape exacto: mismo médico y consultorio, misma hora que la consulta 1 (2026-09-01 09:00)
EXEC usp_insertarConsulta @p_idPaciente = 2, @p_idMedico = 1, @p_idConsultorio = 1, @p_Fecha = '2026-09-01T09:00:00'

-- Traslape parcial: mismo médico, arranca 15 minutos después de que empezó la consulta 1 (sigue dentro de su ventana de 30 min)
EXEC usp_insertarConsulta @p_idPaciente = 2, @p_idMedico = 1, @p_idConsultorio = 5, @p_Fecha = '2026-09-01T09:15:00'

-- Sin traslape: mismo médico, pero 30 minutos después (la ventana anterior ya terminó)
EXEC usp_insertarConsulta @p_idPaciente = 2, @p_idMedico = 1, @p_idConsultorio = 5, @p_Fecha = '2026-09-01T09:30:00'
```

## Relacionado con

[`usp_efectuarConsulta`](usp_efectuarConsulta.md) — el siguiente paso del flujo, una vez que la consulta ya se llevó a cabo.
