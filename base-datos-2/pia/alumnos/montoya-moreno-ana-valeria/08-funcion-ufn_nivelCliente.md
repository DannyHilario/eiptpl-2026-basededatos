# PIA SpaZen — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

SpaZen clasifica a sus clientes según **cuántas citas** tienen en total:

| Citas | Nivel |
|---|---|
| 0 | **Sin citas** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **correo electrónico**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico del cliente |

**Regresa:** `varchar(20)` — `'Sin citas'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_CorreoCliente varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las citas del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin citas'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarCita`](05-procedimiento-usp_registrarCita.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreZona = 'Norte', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 citas: Sin citas
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('noexiste@correo.com') AS Nivel
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5

-- 1 cita: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarCita @p_NombreServicio = 'Masaje con piedras calientes', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 4

-- 2 citas: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarCita @p_NombreServicio = 'Masaje relajante', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-03', @p_Calificacion = 3

-- 3 citas: Frecuente
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
```
