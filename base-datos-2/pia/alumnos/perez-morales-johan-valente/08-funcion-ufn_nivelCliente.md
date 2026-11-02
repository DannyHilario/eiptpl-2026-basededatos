# PIA EnigmaRoom — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso EnigmaRoom](README.md)

---

## Historia de usuario

**Como** dueña de EnigmaRoom, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

EnigmaRoom clasifica a sus clientes según **cuántas partidas** tienen en total:

| Partidas | Nivel |
|---|---|
| 0 | **Sin partidas** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **correo electrónico**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico del cliente |

**Regresa:** `varchar(20)` — `'Sin partidas'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_CorreoCliente varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las partidas del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin partidas'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarPartida`](05-procedimiento-usp_registrarPartida.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreMedio = 'Redes sociales', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 partidas: Sin partidas
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('noexiste@correo.com') AS Nivel
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-01', @p_Jugadores = 4

-- 1 partida: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarPartida @p_NombreSalaEscape = 'La Cripta', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-02', @p_Jugadores = 5

-- 2 partidas: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarPartida @p_NombreSalaEscape = 'El Laboratorio', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPartida = '2026-12-03', @p_Jugadores = 3

-- 3 partidas: Frecuente
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
```
