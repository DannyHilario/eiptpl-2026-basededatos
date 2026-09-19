# Ejercicio de Evidencia 1: `ufn_edadPaciente`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Función escalar `ufn_edadPaciente`

## Contexto

`Paciente.FechaNacimiento` guarda la fecha de nacimiento, pero nadie quiere restar fechas a mano para saber la edad de alguien. Tu función calcula la edad en años **cumplidos** de un paciente al día de hoy.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_edadPaciente` que reciba el id de un paciente y regrese su edad actual en años cumplidos, usando `Paciente.FechaNacimiento` y la fecha de hoy (`GETDATE()`).

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente |

**Regresa:** `int` — la edad del paciente en años cumplidos.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_edadPaciente` y recibe `@p_idPaciente int`.
- [ ] Calcula la edad como años **completos cumplidos**, no como la simple diferencia de años de calendario.
- [ ] **Ojo con el caso borde más común:** `DATEDIFF(YEAR, FechaNacimiento, GETDATE())` por sí solo está mal — cuenta cuántas fronteras de "1 de enero" cruzó, no si ya pasó el cumpleaños este año. Tienes que restarle 1 si el cumpleaños de este año todavía no ha ocurrido (comparando mes y día de `FechaNacimiento` contra el mes y día de hoy).
- [ ] Si el `idPaciente` no existe, regresa `NULL` (no genera error).

## Ejemplo de salida esperada — con fecha de hoy 19 de septiembre de 2026

| Paciente | FechaNacimiento | ¿Ya pasó el cumpleaños este año? | Edad correcta |
|---|---|---|---|
| Sergio Castro Ibarra (id 1) | 1978-04-12 | Sí (12 de abril ya pasó) | **48** |
| Daniel Aguilar Mendoza (id 5) | 2001-09-30 | **No** (30 de septiembre todavía no llega) | **24**, no 25 |

El segundo caso es justo el que revela un cálculo mal hecho: si tu función regresa `25` para el paciente 5 el 19 de septiembre de 2026, tiene el bug de arriba — su cumpleaños 25 todavía no ha llegado.

> Como usa `GETDATE()`, el resultado exacto depende del día en que lo ejecutes — lo importante es que la **lógica** del cumpleaños-ya-pasado-o-no esté bien resuelta, no un número fijo.

## Casos de prueba sugeridos

```sql
-- Paciente cuyo cumpleaños ya pasó este año
SELECT dbo.ufn_edadPaciente(1) AS Edad  -- Sergio Castro Ibarra, nacido 1978-04-12

-- Paciente cuyo cumpleaños NO ha pasado este año (el caso que revela el bug si existe)
SELECT dbo.ufn_edadPaciente(5) AS Edad  -- Daniel Aguilar Mendoza, nacido 2001-09-30

-- Paciente que no existe — no debe dar error
SELECT dbo.ufn_edadPaciente(9999) AS Edad  -- esperado: NULL
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_VillanuevaMataBrandonGabriel_2253572.txt
```
