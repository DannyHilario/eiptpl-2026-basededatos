# Ejercicio de Evidencia 1: `ufn_totalConsultasPorMedico`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Función escalar `ufn_totalConsultasPorMedico`

## Contexto

Para medir la carga de trabajo de un médico, es útil saber cuántas consultas tiene agendadas en total (se hayan efectuado o no). Tu función responde esa pregunta con una sola llamada.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalConsultasPorMedico` que reciba el id de un médico y regrese el total de consultas asociadas a él en la tabla `Consulta`.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico a contar |

**Regresa:** `int` — el número total de consultas de ese médico.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalConsultasPorMedico` y recibe `@p_idMedico int`.
- [ ] Cuenta **todas** las filas de `Consulta` donde `idMedico = @p_idMedico`, sin importar el valor de `Efectuada` (cuenta agendadas y efectuadas por igual).
- [ ] Si el médico no tiene ninguna consulta, regresa `0`, nunca `NULL`.
- [ ] Si el `idMedico` no existe, también regresa `0`.

## Ejemplo de salida esperada

| Llamada | Resultado esperado | Por qué |
|---|---|---|
| `SELECT dbo.ufn_totalConsultasPorMedico(1)` | `2` | El médico 1 (Carlos García López) atiende las consultas 1 y 11 |
| `SELECT dbo.ufn_totalConsultasPorMedico(8)` | `1` | El médico 8 (Daniela Jiménez Flores) solo atiende la consulta 8 |
| `SELECT dbo.ufn_totalConsultasPorMedico(6)` | `2` | El médico 6 (Sofía Sánchez Vega) atiende la consulta 6 (efectuada) y la 16 (aún no efectuada) — cuentan ambas |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_totalConsultasPorMedico(1) AS Total  -- esperado: 2
SELECT dbo.ufn_totalConsultasPorMedico(8) AS Total  -- esperado: 1
SELECT dbo.ufn_totalConsultasPorMedico(6) AS Total  -- esperado: 2
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_HernandezJuarezBrendaIvonne_2253945.txt
```
