# PIA RutaNorte — Objeto 08 de 11: `ufn_nivelPasajero`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Función escalar `ufn_nivelPasajero`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** saber qué tan seguido viene un pasajero, **para** ofrecerle una promoción según su nivel.

## Contexto

RutaNorte clasifica a sus pasajeros según **cuántos boletos** tienen en total:

| Boletos | Nivel |
|---|---|
| 0 | **Sin boletos** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al pasajero por su **correo electrónico**. Un pasajero dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelPasajero` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/02-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoPasajero` | `varchar(100)` | Correo electrónico del pasajero |

**Regresa:** `varchar(20)` — `'Sin boletos'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelPasajero` y recibe `@p_CorreoPasajero varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un pasajero con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta los boletos del pasajero, aunque esté dado de baja.
- [ ] Regresa `'Sin boletos'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPasajero`](01-procedimiento-usp_insertarPasajero.md), [`usp_registrarBoleto`](05-procedimiento-usp_registrarBoleto.md).

```sql
-- Preparación: el pasajero de prueba
EXEC usp_insertarPasajero @p_NombreTipoPasajero = 'Adulto', @p_Nombre = 'Pasajero de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 boletos: Sin boletos
SELECT dbo.ufn_nivelPasajero('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelPasajero('noexiste@correo.com') AS Nivel
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-01', @p_Asiento = 12

-- 1 boleto: Ocasional
SELECT dbo.ufn_nivelPasajero('prueba1@correo.com') AS Nivel
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-REY', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-02', @p_Asiento = 20

-- 2 boletos: Ocasional
SELECT dbo.ufn_nivelPasajero('prueba1@correo.com') AS Nivel
EXEC usp_registrarBoleto @p_ClaveRuta = 'MTY-SAL', @p_CorreoPasajero = 'prueba1@correo.com', @p_FechaViaje = '2026-12-03', @p_Asiento = 5

-- 3 boletos: Frecuente
SELECT dbo.ufn_nivelPasajero('prueba1@correo.com') AS Nivel
```
