# `usp_efectuarConsulta`

Script: [`instalacion/07-Consulta/04-usp-efectuar.sql`](../../instalacion/07-Consulta/04-usp-efectuar.sql)

Marca una consulta como efectuada (`Consulta.Efectuada = 1`). Es el primer paso del flujo de negocio de consulta → receta: una consulta se agenda, pero solo si en efecto se lleva a cabo puede después generar su receta (ver [`usp_generarReceta`](usp_generarReceta.md), paso separado y explícito — este SP **no** genera la receta).

## En palabras simples

Una consulta agendada no siempre ocurre: el paciente puede no presentarse, o puede cancelarse. Por eso, el sistema no asume que "agendada" significa "atendida" — necesita que alguien confirme explícitamente que sí pasó. Este SP es exactamente esa confirmación: pone en `1` el interruptor `Efectuada` de la consulta.

¿Por qué importa esto? Porque es el "candado" antes de generar una receta: [`usp_generarReceta`](usp_generarReceta.md) revisa este interruptor y se niega a crear una receta de una consulta que nunca se marcó como efectuada. Así, si un paciente falta a su cita, la consulta se queda registrada (para saber que se agendó) pero jamás genera una receta fantasma.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsulta` | `int` | Id de la consulta |

## Validaciones (orden en que se evalúan)

1. La consulta debe existir.
2. La consulta no debe estar ya efectuada (`Efectuada = 1`).
3. La fecha de ejecución del SP no puede ser anterior a `Consulta.Fecha` — no se puede marcar como efectuada una consulta que todavía no llega a su fecha programada.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | La consulta no existe | `idConsulta` inválido |
| `000002` | La consulta ya fue efectuada | `Efectuada` ya era `1` |
| `000003` | No se puede efectuar una consulta antes de su fecha programada | `GETDATE() < Consulta.Fecha` |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_efectuarConsulta @p_idConsulta = 16
```

## Casos de prueba sugeridos

```sql
-- Éxito: la consulta 16 ya pasó su fecha (2026-09-11) y no está efectuada
EXEC usp_efectuarConsulta @p_idConsulta = 16
SELECT Efectuada FROM Consulta WHERE idConsulta = 16

-- Consulta no existe
EXEC usp_efectuarConsulta @p_idConsulta = 9999

-- Consulta ya efectuada (correr el caso de éxito de arriba dos veces seguidas)
EXEC usp_efectuarConsulta @p_idConsulta = 16

-- Fecha programada todavía no llega (la consulta 17 es del 2026-10-01)
EXEC usp_efectuarConsulta @p_idConsulta = 17
```

## Relacionado con

[`usp_generarReceta`](usp_generarReceta.md) — el siguiente paso del flujo, una vez que la consulta ya está efectuada.
