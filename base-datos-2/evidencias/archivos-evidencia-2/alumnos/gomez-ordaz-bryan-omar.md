# Ejercicios de Evidencia 2

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)

---

## Ejercicio 1: `usp_obtenerConsultoriosDisponibles`

### Contexto

Cuando alguien va a agendar una nueva consulta, es más útil preguntar "¿qué consultorios están libres a esta hora?" que ir probando uno por uno con `usp_insertarConsulta` hasta que uno no choque. Tu procedimiento responde justo eso: dada una fecha/hora, qué consultorios activos **no** tienen ya una consulta que se traslape con la ventana de 30 minutos.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Fecha` | `datetime` | Fecha y hora para la que se quiere agendar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerConsultoriosDisponibles` y recibe `@p_Fecha datetime`.
- [ ] No requiere validaciones de existencia (no recibe ningún id) — es puramente una consulta.
- [ ] Regresa (vía `SELECT`) los consultorios donde `Activo = 1` **y** que no tengan ninguna consulta registrada cuya ventana de 30 minutos se traslape con `[@p_Fecha, @p_Fecha + 30 minutos)`. La condición de traslape es la misma que usa [`usp_insertarConsulta`](../../../sesiones/sesion-7/HospitalDB/docs/procedimientos/usp_insertarConsulta.md#en-palabras-simples): dos ventanas de 30 minutos chocan si una empieza antes de que la otra termine, y viceversa.
- [ ] Usa `NOT EXISTS` (subconsulta correlacionada contra `Consulta`) para excluir los consultorios ocupados — no es un `IF EXISTS`/`IF NOT EXISTS` (eso solo aplica a validaciones dentro de un `IF`; aquí es una subconsulta normal dentro de un `SELECT`, sí está permitida).
- [ ] Muestra las columnas `idConsultorio` y `Nombre`.
- [ ] Si todos los consultorios activos están ocupados en ese horario, el `SELECT` regresa 0 filas.

### Ejemplo de salida esperada

`EXEC usp_obtenerConsultoriosDisponibles @p_Fecha = '2026-09-01T09:00:00'` — a esa hora, el Consultorio 1 ya está ocupado (consulta 1) y el Consultorio 2 también (consulta 2), pero los demás están libres:

| idConsultorio | Nombre |
|---|---|
| 3 | Consultorio 3 |
| 4 | Consultorio 4 |
| 5 | Consultorio 5 |
| ... | *(y así el resto que no choquen)* |

### Casos de prueba sugeridos

```sql
-- A esta hora exacta, Consultorio 1 y 2 están ocupados (no deben aparecer)
EXEC usp_obtenerConsultoriosDisponibles @p_Fecha = '2026-09-01T09:00:00'

-- A esta hora nadie tiene consulta agendada, deben aparecer los 10
EXEC usp_obtenerConsultoriosDisponibles @p_Fecha = '2026-12-01T09:00:00'
```

---

## Ejercicio 2: `usp_obtenerPacientesPorMedico`

### Contexto

Un médico puede haber atendido al mismo paciente varias veces. Para una lista de "mis pacientes" (no "mis consultas"), hay que quitar los duplicados. Tu procedimiento regresa esa lista sin repetidos.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerPacientesPorMedico` y recibe `@p_idMedico int`.
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Si el médico existe, regresa (vía `SELECT`) los pacientes **distintos** (usa `DISTINCT`) que tienen al menos una consulta con ese médico, con las columnas `idPaciente` y `NombrePaciente` (nombre completo).
- [ ] Si el mismo paciente tiene 2 consultas con ese médico, aparece **una sola vez** en el resultado.
- [ ] No imprime ningún mensaje de éxito `000000` — el resultado del `SELECT` es la respuesta.

### Ejemplo de salida esperada

`EXEC usp_obtenerPacientesPorMedico @p_idMedico = 6` (Sofía Sánchez Vega atendió al paciente 6 en la consulta 6, y al paciente 1 en la consulta 16 — dos pacientes distintos):

| idPaciente | NombrePaciente |
|---|---|
| 1 | Sergio Castro Ibarra |
| 6 | Carolina Salinas Herrera |

### Casos de prueba sugeridos

```sql
EXEC usp_obtenerPacientesPorMedico @p_idMedico = 6     -- 2 filas
EXEC usp_obtenerPacientesPorMedico @p_idMedico = 9999  -- error 000001
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_GomezOrdazBryanOmar_2254247_Ejercicio1.txt
EV2_GomezOrdazBryanOmar_2254247_Ejercicio2.txt
```
