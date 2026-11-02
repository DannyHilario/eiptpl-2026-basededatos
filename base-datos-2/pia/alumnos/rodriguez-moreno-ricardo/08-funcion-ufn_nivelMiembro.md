# PIA EspacioUno — Objeto 08 de 11: `ufn_nivelMiembro`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Función escalar `ufn_nivelMiembro`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** saber qué tan seguido viene un miembro, **para** ofrecerle una promoción según su nivel.

## Contexto

EspacioUno clasifica a sus miembros según **cuántas reservas** tienen en total:

| Reservas | Nivel |
|---|---|
| 0 | **Sin reservas** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al miembro por su **correo electrónico**. Un miembro dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelMiembro` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoMiembro` | `varchar(100)` | Correo electrónico del miembro |

**Regresa:** `varchar(20)` — `'Sin reservas'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelMiembro` y recibe `@p_CorreoMiembro varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un miembro con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las reservas del miembro, aunque esté dado de baja.
- [ ] Regresa `'Sin reservas'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md), [`usp_registrarReserva`](05-procedimiento-usp_registrarReserva.md).

```sql
-- Preparación: el miembro de prueba
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'

-- 0 reservas: Sin reservas
SELECT dbo.ufn_nivelMiembro('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelMiembro('noexiste@correo.com') AS Nivel
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2

-- 1 reserva: Ocasional
SELECT dbo.ufn_nivelMiembro('prueba1@correo.com') AS Nivel
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Terraza', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 3

-- 2 reservas: Ocasional
SELECT dbo.ufn_nivelMiembro('prueba1@correo.com') AS Nivel
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Ventana', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-03', @p_Horas = 1

-- 3 reservas: Frecuente
SELECT dbo.ufn_nivelMiembro('prueba1@correo.com') AS Nivel
```
