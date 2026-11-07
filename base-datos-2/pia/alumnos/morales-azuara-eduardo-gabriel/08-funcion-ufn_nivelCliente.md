# PIA GuardaTodo — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso GuardaTodo](README.md)

---

## Historia de usuario

**Como** dueña de GuardaTodo, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

GuardaTodo clasifica a sus clientes según **cuántos contratos** tienen en total:

| Contratos | Nivel |
|---|---|
| 0 | **Sin contratos** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **teléfono**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_TelefonoCliente` | `varchar(15)` | Teléfono del cliente |

**Regresa:** `varchar(20)` — `'Sin contratos'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_TelefonoCliente varchar(15)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese teléfono, regresa `NULL`.
- [ ] Cuenta los contratos del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin contratos'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarContrato`](05-procedimiento-usp_registrarContrato.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- 0 contratos: Sin contratos
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('8199999999') AS Nivel
EXEC usp_registrarContrato @p_NumeroBodega = 'B-101', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-01', @p_Meses = 2

-- 1 contrato: Ocasional
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel
EXEC usp_registrarContrato @p_NumeroBodega = 'B-102', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-02', @p_Meses = 3

-- 2 contratos: Ocasional
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel
EXEC usp_registrarContrato @p_NumeroBodega = 'B-101', @p_TelefonoCliente = '8199990001', @p_FechaInicio = '2026-12-03', @p_Meses = 1

-- 3 contratos: Frecuente
SELECT dbo.ufn_nivelCliente('8199990001') AS Nivel
```
