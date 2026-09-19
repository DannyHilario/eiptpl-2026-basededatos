# Ejercicio de Evidencia 1: `ufn_totalEspecialidadesPorMedico`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Función escalar `ufn_totalEspecialidadesPorMedico`

## Contexto

`MedicoEspecialidad` permite que un médico tenga varias especialidades (relación N:M). Para saber rápido "¿este médico es especialista en varias cosas, o solo en una?", hoy hay que contar manualmente las filas de esa tabla. Tu función responde eso con una sola llamada.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalEspecialidadesPorMedico` que reciba el id de un médico y regrese cuántas especialidades tiene registradas en `MedicoEspecialidad`.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico a contar |

**Regresa:** `int` — el número de especialidades de ese médico.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalEspecialidadesPorMedico` y recibe `@p_idMedico int`.
- [ ] Cuenta las filas de `MedicoEspecialidad` donde `idMedico = @p_idMedico`.
- [ ] Si el médico no tiene ninguna especialidad registrada, regresa `0`, nunca `NULL`.
- [ ] Si el `idMedico` no existe, también regresa `0`.

## Ejemplo de salida esperada

| Llamada | Resultado esperado | Por qué |
|---|---|---|
| `SELECT dbo.ufn_totalEspecialidadesPorMedico(1)` | `2` | El médico 1 (Carlos García López) tiene Medicina General y Cardiología |
| `SELECT dbo.ufn_totalEspecialidadesPorMedico(2)` | `1` | El médico 2 (Ana Hernández Ramírez) solo tiene Pediatría |
| `SELECT dbo.ufn_totalEspecialidadesPorMedico(10)` | `2` | El médico 10 (Mariana Delgado Ortiz) tiene Endocrinología y Medicina General |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_totalEspecialidadesPorMedico(1)  AS Total  -- esperado: 2
SELECT dbo.ufn_totalEspecialidadesPorMedico(2)  AS Total  -- esperado: 1
SELECT dbo.ufn_totalEspecialidadesPorMedico(99) AS Total  -- esperado: 0
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_MontoyaMorenoAnaValeria_2254069.txt
```
