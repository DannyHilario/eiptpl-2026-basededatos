# PIA MudaFacil — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

MudaFacil clasifica a sus clientes según **cuántas mudanzas** tienen en total:

| Mudanzas | Nivel |
|---|---|
| 0 | **Sin mudanzas** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **correo electrónico**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico del cliente |

**Regresa:** `varchar(20)` — `'Sin mudanzas'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_CorreoCliente varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta las mudanzas del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin mudanzas'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarMudanza`](05-procedimiento-usp_registrarMudanza.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreTipoVivienda = 'Casa', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 mudanzas: Sin mudanzas
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('noexiste@correo.com') AS Nivel
EXEC usp_registrarMudanza @p_NombrePaquete = 'Express', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-01', @p_Cargadores = 3

-- 1 mudanza: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarMudanza @p_NombrePaquete = 'Chico', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-02', @p_Cargadores = 2

-- 2 mudanzas: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarMudanza @p_NombrePaquete = 'Express', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaMudanza = '2026-12-03', @p_Cargadores = 4

-- 3 mudanzas: Frecuente
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
```
