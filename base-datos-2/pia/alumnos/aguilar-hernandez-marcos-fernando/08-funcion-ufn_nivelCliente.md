# PIA BiciRuta — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso BiciRuta](README.md)

---

## Historia de usuario

**Como** dueño de BiciRuta, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

BiciRuta clasifica a sus clientes según **cuántas rentas** tienen en total:

| Rentas | Nivel |
|---|---|
| 0 | **Sin rentas** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **correo electrónico**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico del cliente |

**Regresa:** `varchar(20)` — `'Sin rentas'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_CorreoCliente varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las rentas del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin rentas'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarRenta`](05-procedimiento-usp_registrarRenta.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_Nombre = 'Cliente de Prueba', @p_Telefono = '8199990001', @p_CorreoElectronico = 'prueba1@correo.com'

-- 0 rentas: Sin rentas
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('noexiste@correo.com') AS Nivel
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-01', @p_Horas = 2

-- 1 renta: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0002', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-02', @p_Horas = 3

-- 2 rentas: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarRenta @p_NumeroSerie = 'UR-0001', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaRenta = '2026-12-03', @p_Horas = 1

-- 3 rentas: Frecuente
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
```
