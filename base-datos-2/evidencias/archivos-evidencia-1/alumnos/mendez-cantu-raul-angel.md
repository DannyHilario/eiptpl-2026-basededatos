# Ejercicio de Evidencia 1: `ufn_nombreCompletoPaciente`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Función escalar `ufn_nombreCompletoPaciente`

## Contexto

`Paciente` guarda el nombre en tres columnas separadas (`Nombre`, `PrimerApellido`, `SegundoApellido`). Cada vez que alguien necesita mostrar el nombre completo de un paciente, tiene que concatenar las tres a mano — y arriesgarse a que el segundo apellido (que puede ser `NULL`) rompa el resultado. Tu función resuelve esa concatenación una sola vez, bien hecha.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nombreCompletoPaciente` que reciba el id de un paciente y regrese su nombre completo como una sola cadena.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente |

**Regresa:** `varchar(150)` — el nombre completo del paciente.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nombreCompletoPaciente` y recibe `@p_idPaciente int`.
- [ ] Regresa `Nombre + ' ' + PrimerApellido`, y si `SegundoApellido` no es `NULL`, lo agrega al final con un espacio antes.
- [ ] Si `SegundoApellido` es `NULL`, el resultado **no** debe traer un espacio de más al final ni la palabra `NULL` pegada al texto — usa `ISNULL(' ' + SegundoApellido, '')` en vez de concatenar la columna directo con `+`.
- [ ] Si el `idPaciente` no existe, regresa `NULL` (no genera error).

## Ejemplo de salida esperada

| Llamada | Resultado esperado |
|---|---|
| `SELECT dbo.ufn_nombreCompletoPaciente(1)` | `'Sergio Castro Ibarra'` |
| `SELECT dbo.ufn_nombreCompletoPaciente(5)` | `'Daniel Aguilar Mendoza'` |
| `SELECT dbo.ufn_nombreCompletoPaciente(9999)` | `NULL` |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_nombreCompletoPaciente(1) AS NombreCompleto  -- esperado: 'Sergio Castro Ibarra'
SELECT dbo.ufn_nombreCompletoPaciente(8) AS NombreCompleto  -- esperado: 'Elena Lozano Guerrero'

-- Prueba con un paciente sin segundo apellido (no rompe el resultado)
UPDATE Paciente SET SegundoApellido = NULL WHERE idPaciente = 1
SELECT dbo.ufn_nombreCompletoPaciente(1) AS NombreCompleto  -- esperado: 'Sergio Castro' (sin espacio de más)
UPDATE Paciente SET SegundoApellido = 'Ibarra' WHERE idPaciente = 1  -- revierte el cambio de prueba
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_MendezCantuRaulAngel_2212484.txt
```
