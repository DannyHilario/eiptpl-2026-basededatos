# Ejercicio de Evidencia 1: `ufn_nombreCompletoMedico`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Función escalar `ufn_nombreCompletoMedico`

## Contexto

Igual que con `Paciente`, `Medico` guarda el nombre en tres columnas separadas (`Nombre`, `PrimerApellido`, `SegundoApellido`). Tu función resuelve esa concatenación una sola vez.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nombreCompletoMedico` que reciba el id de un médico y regrese su nombre completo como una sola cadena.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico |

**Regresa:** `varchar(150)` — el nombre completo del médico.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nombreCompletoMedico` y recibe `@p_idMedico int`.
- [ ] Regresa `Nombre + ' ' + PrimerApellido + ' ' + SegundoApellido` (las tres columnas son `NOT NULL`, siempre tienen valor).
- [ ] Si el `idMedico` no existe, regresa `NULL` (no genera error).

## Ejemplo de salida esperada

| Llamada | Resultado esperado |
|---|---|
| `SELECT dbo.ufn_nombreCompletoMedico(5)` | `'Luis Pérez Morales'` |
| `SELECT dbo.ufn_nombreCompletoMedico(1)` | `'Carlos García López'` |
| `SELECT dbo.ufn_nombreCompletoMedico(9999)` | `NULL` |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_nombreCompletoMedico(5) AS NombreCompleto  -- esperado: 'Luis Pérez Morales'
SELECT dbo.ufn_nombreCompletoMedico(9) AS NombreCompleto  -- esperado: 'Ricardo Gómez Reyes'
SELECT dbo.ufn_nombreCompletoMedico(9999) AS NombreCompleto  -- esperado: NULL
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_MoralesAzuaraEduardoGabriel_2254090.txt
```
