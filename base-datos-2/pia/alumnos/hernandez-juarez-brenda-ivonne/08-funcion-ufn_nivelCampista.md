# PIA CampoVerde — Objeto 08 de 11: `ufn_nivelCampista`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Función escalar `ufn_nivelCampista`

← [Regresar al caso CampoVerde](README.md)

---

## Historia de usuario

**Como** dueña de CampoVerde, **quiero** saber qué tan seguido viene un campista, **para** ofrecerle una promoción según su nivel.

## Contexto

CampoVerde clasifica a sus campistas según **cuántas rentas** tienen en total:

| Rentas | Nivel |
|---|---|
| 0 | **Sin rentas** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al campista por su **teléfono**. Un campista dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCampista` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_TelefonoCampista` | `varchar(15)` | Teléfono del campista |

**Regresa:** `varchar(20)` — `'Sin rentas'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCampista` y recibe `@p_TelefonoCampista varchar(15)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un campista con ese teléfono, regresa `NULL`.
- [ ] Cuenta las rentas del campista, aunque esté dado de baja.
- [ ] Regresa `'Sin rentas'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCampista`](01-procedimiento-usp_insertarCampista.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: el campista de prueba
EXEC usp_insertarCampista @p_Nombre = 'Campista de Prueba', @p_Telefono = '8199990001', @p_Ciudad = 'Monterrey'

-- 0 rentas: Sin rentas
SELECT dbo.ufn_nivelCampista('8199990001') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCampista('8199999999') AS Nivel
EXEC usp_registrarRenta @p_CodigoTienda = 'T-01', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-01', @p_Noches = 2

-- 1 renta: Ocasional
SELECT dbo.ufn_nivelCampista('8199990001') AS Nivel
EXEC usp_registrarRenta @p_CodigoTienda = 'T-02', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-02', @p_Noches = 3

-- 2 rentas: Ocasional
SELECT dbo.ufn_nivelCampista('8199990001') AS Nivel
EXEC usp_registrarRenta @p_CodigoTienda = 'T-01', @p_TelefonoCampista = '8199990001', @p_FechaLlegada = '2026-12-03', @p_Noches = 1

-- 3 rentas: Frecuente
SELECT dbo.ufn_nivelCampista('8199990001') AS Nivel
```
