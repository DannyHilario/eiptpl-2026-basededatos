# PIA ImprimeYa — Objeto 08 de 11: `ufn_nivelCliente`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Función escalar `ufn_nivelCliente`

← [Regresar al caso ImprimeYa](README.md)

---

## Historia de usuario

**Como** dueño de ImprimeYa, **quiero** saber qué tan seguido viene un cliente, **para** ofrecerle una promoción según su nivel.

## Contexto

ImprimeYa clasifica a sus clientes según **cuántos pedidos** tienen en total:

| Pedidos | Nivel |
|---|---|
| 0 | **Sin pedidos** |
| 1 o 2 | **Ocasional** |
| 3 o más | **Frecuente** |

Se busca al cliente por su **correo electrónico**. Un cliente dado de baja también tiene nivel.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_nivelCliente` que regrese el nivel según la tabla de arriba. Para elegirlo puedes usar `IF` / `ELSE` o `CASE` ([CASE](../../../temas/Etapa-4/03-Case.md)).

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoCliente` | `varchar(100)` | Correo electrónico del cliente |

**Regresa:** `varchar(20)` — `'Sin pedidos'`, `'Ocasional'` o `'Frecuente'`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_nivelCliente` y recibe `@p_CorreoCliente varchar(100)`.
- [ ] Regresa un valor de tipo `varchar(20)`.
- [ ] Si no existe un cliente con ese correo electrónico, regresa `NULL`.
- [ ] Cuenta los pedidos del cliente, aunque esté dado de baja.
- [ ] Regresa `'Sin pedidos'` con 0, `'Ocasional'` con 1 o 2 y `'Frecuente'` con 3 o más.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_registrarPedido`](05-procedimiento-usp_registrarPedido.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreGiro = 'Restaurante', @p_NombreNegocio = 'Negocio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- 0 pedidos: Sin pedidos
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel

-- No existe: NULL
SELECT dbo.ufn_nivelCliente('noexiste@correo.com') AS Nivel
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-01', @p_Paquetes = 2

-- 1 pedido: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarPedido @p_NombreProducto = 'Volantes media carta', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-02', @p_Paquetes = 3

-- 2 pedidos: Ocasional
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
EXEC usp_registrarPedido @p_NombreProducto = 'Tarjetas de presentación', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaPedido = '2026-12-03', @p_Paquetes = 1

-- 3 pedidos: Frecuente
SELECT dbo.ufn_nivelCliente('prueba1@correo.com') AS Nivel
```
