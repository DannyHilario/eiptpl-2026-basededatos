# Ejercicio de Evidencia 1: `ufn_totalPacientesPorMedico`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Función escalar `ufn_totalPacientesPorMedico`

## Contexto

Un médico puede atender al mismo paciente varias veces (consultas de seguimiento). Contar "consultas" no es lo mismo que contar "pacientes distintos" — un médico con 5 consultas podría haber visto solo a 2 personas diferentes. Tu función responde específicamente eso: cuántos pacientes **distintos** ha atendido un médico.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalPacientesPorMedico` que reciba el id de un médico y regrese cuántos pacientes distintos aparecen en sus consultas.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico a contar |

**Regresa:** `int` — el número de pacientes distintos atendidos por ese médico.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalPacientesPorMedico` y recibe `@p_idMedico int`.
- [ ] Cuenta los valores **distintos** de `idPaciente` en `Consulta` donde `idMedico = @p_idMedico` (usa `COUNT(DISTINCT idPaciente)`).
- [ ] Si el mismo paciente aparece en 2 consultas distintas de ese médico, cuenta como **1**, no como 2.
- [ ] Si el médico no tiene ninguna consulta, regresa `0`, nunca `NULL`.

## Ejemplo de salida esperada

| Llamada | Resultado esperado | Por qué |
|---|---|---|
| `SELECT dbo.ufn_totalPacientesPorMedico(1)` | `2` | El médico 1 atendió al paciente 1 (consulta 1) y al paciente 11 (consulta 11) — dos pacientes distintos |
| `SELECT dbo.ufn_totalPacientesPorMedico(6)` | `2` | El médico 6 atendió al paciente 6 (consulta 6) y al paciente 1 (consulta 16) — dos pacientes distintos, aunque una de las consultas no se haya efectuado |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_totalPacientesPorMedico(1) AS TotalPacientes  -- esperado: 2
SELECT dbo.ufn_totalPacientesPorMedico(8) AS TotalPacientes  -- esperado: 1
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_HernandezPerezJoseIvan_2253557.txt
```
