# `usp_generarReceta`

Script: [`instalacion/08-Receta/03-usp-generar.sql`](../../instalacion/08-Receta/03-usp-generar.sql)

**Este es el SP que debe usarse para crear una receta.** Es un paso separado y explícito de [`usp_efectuarConsulta`](usp_efectuarConsulta.md) — marcar una consulta como efectuada no genera la receta automáticamente; alguien debe invocar este SP después.

## En palabras simples

Este SP es el que "convierte" una consulta ya atendida en una receta médica que el paciente puede llevarse a farmacia. No cualquier consulta puede generar una receta: tiene que haberse efectuado de verdad (ver [`usp_efectuarConsulta`](usp_efectuarConsulta.md)) y no puede tener ya una receta generada antes (una consulta = como máximo una receta, nunca dos).

Si alguien intenta generar la receta de una consulta que nunca ocurrió, el SP lo rechaza — así se evita el caso raro de una receta médica sin que el paciente haya sido atendido. Cuando todo está en orden, el SP simplemente crea el renglón en `Receta` con el estatus inicial `1 Creada`, listo para que el médico empiece a agregarle medicamentos (`DetalleReceta`).

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsulta` | `int` | Id de la consulta ya efectuada |

## Validaciones (orden en que se evalúan)

1. La consulta debe existir.
2. La consulta debe estar efectuada (`Consulta.Efectuada = 1`) — si nunca se llevó a cabo, no genera receta y el registro queda huérfano a propósito (constancia de que se agendó pero no ocurrió).
3. La fecha de ejecución del SP no puede ser anterior a `Consulta.Fecha`.
4. La consulta no debe tener ya una receta generada (relación 1:1 con `Receta`).

## Qué hace, en orden

1. Corre las 4 validaciones de arriba (con `RETURN` si alguna falla).
2. `INSERT INTO Receta (idConsulta, idEstatusReceta) VALUES (@p_idConsulta, 1)` — crea la receta en estatus `1 Creada`.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La consulta no existe | `idConsulta` inválido |
| `000002` | La consulta no ha sido efectuada | `Consulta.Efectuada = 0` |
| `000003` | No se puede generar la receta antes de la fecha programada de la consulta | `GETDATE() < Consulta.Fecha` |
| `000004` | La consulta ya tiene una receta generada | Ya existe un renglón en `Receta` con ese `idConsulta` |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_efectuarConsulta @p_idConsulta = 16
EXEC usp_generarReceta @p_idConsulta = 16
```

## Casos de prueba sugeridos

```sql
-- Éxito: efectuar la consulta 16 y generar su receta
EXEC usp_efectuarConsulta @p_idConsulta = 16
EXEC usp_generarReceta @p_idConsulta = 16
SELECT * FROM Receta WHERE idConsulta = 16

-- Consulta no existe
EXEC usp_generarReceta @p_idConsulta = 9999

-- Consulta no efectuada (la 17 nunca se marcó con usp_efectuarConsulta)
EXEC usp_generarReceta @p_idConsulta = 17

-- Consulta ya tiene receta (cualquiera de las 15 originales, ej. idConsulta = 1)
EXEC usp_generarReceta @p_idConsulta = 1
```

## Relacionado con

[`usp_efectuarConsulta`](usp_efectuarConsulta.md) — el paso previo obligatorio. [`usp_cambiarEstatusReceta`](usp_cambiarEstatusReceta.md) — el siguiente paso del flujo, una vez que la receta ya existe (farmacia).
