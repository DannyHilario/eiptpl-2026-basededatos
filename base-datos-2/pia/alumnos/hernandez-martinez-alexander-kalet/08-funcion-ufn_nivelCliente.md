# PIA QuintaSol — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso QuintaSol](README.md)

---

## Historia de usuario

**Como** dueña de QuintaSol, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

QuintaSol clasifica a sus clientes según **cuántos eventos** tienen en total:

| Eventos | Nivel |
|---|---|
| 0 | **Sin eventos** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **teléfono**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_TelefonoCliente` | `varchar(15)` | Teléfono del cliente |

**Regresa:** `varchar(20)` — `'Sin eventos'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_TelefonoCliente varchar(15)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese teléfono, regresa `NULL`.
- [ ] Cuenta los eventos del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin eventos'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarEvento`](05-procedimiento-usp_registrarEvento.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001'

-- 0 eventos: Sin eventos
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('8199999999') AS Nivel
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-01', @p_Invitados = 80

-- 1 evento: Ocasional
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel
EXEC usp_registrarEvento @p_NombreQuinta = 'El Encino', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-02', @p_Invitados = 120

-- 2 eventos: Ocasional
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel
EXEC usp_registrarEvento @p_NombreQuinta = 'Los Nogales', @p_TelefonoCliente = '8199990001', @p_FechaEvento = '2026-12-03', @p_Invitados = 50

-- 3 eventos: Frecuente
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel
```
