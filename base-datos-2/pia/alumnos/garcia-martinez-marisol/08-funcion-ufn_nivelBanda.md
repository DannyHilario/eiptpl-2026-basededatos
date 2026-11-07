# PIA SalaRock — Objeto 08 de 11: `ufn_nivelBanda`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Función escalar `ufn_nivelBanda`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** saber qué tan seguido viene una banda, **para** ofrecerle una promoción según su nivel.

## Contexto

SalaRock clasifica a sus bandas según **cuántos ensayos** tienen en total:

| Ensayos | Nivel |
|---|---|
| 0 | **Sin ensayos** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca a la banda por su **nombre de banda**. Una banda dada de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelBanda` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreBanda` | `varchar(50)` | Nombre de la banda |

**Regresa:** `varchar(20)` — `'Sin ensayos'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelBanda` y recibe `@p_NombreBanda varchar(50)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe una banda con ese nombre de banda, regresa `NULL`.
- [ ] Cuenta los ensayos de la banda, aunque esté dada de baja.
- [ ] Regresa `'Sin ensayos'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md), [`usp_registrarEnsayo`](05-procedimiento-usp_registrarEnsayo.md).

```sql
-- Preparación: la banda de prueba
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'

-- 0 ensayos: Sin ensayos
SELECT dbo.ufn_nivelBanda('Banda de Prueba') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelBanda('NoExiste99') AS Nivel
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 2

-- 1 ensayo: Ocasional
SELECT dbo.ufn_nivelBanda('Banda de Prueba') AS Nivel
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Joplin', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 3

-- 2 ensayos: Ocasional
SELECT dbo.ufn_nivelBanda('Banda de Prueba') AS Nivel
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-03', @p_Horas = 1

-- 3 ensayos: Frecuente
SELECT dbo.ufn_nivelBanda('Banda de Prueba') AS Nivel
```
