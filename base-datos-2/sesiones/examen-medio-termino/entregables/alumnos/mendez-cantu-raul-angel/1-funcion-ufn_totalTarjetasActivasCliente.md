# Examen de Medio Término — Ejercicio 1 de 3: `ufn_totalTarjetasActivasCliente`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Función escalar `ufn_totalTarjetasActivasCliente`
**Valor:** 20 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** saber cuántas tarjetas activas tiene un cliente, **para** saber de un vistazo cuántos productos de crédito tiene con el banco.

## Contexto

Un cliente puede tener de 0 a 3 tarjetas, y algunas de ellas pueden estar canceladas (`Activo = 0`). Una tarjeta cancelada ya no cuenta como producto del cliente.

Tu función cuenta solo las tarjetas **activas** (`Activo = 1`) de un cliente. Las tarjetas vencidas que no se han cancelado **sí** cuentan, porque siguen teniendo `Activo = 1`.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalTarjetasActivasCliente` que reciba el id de un cliente y regrese cuántas tarjetas con `Activo = 1` tiene.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente |

**Regresa:** `int` — el número de tarjetas activas del cliente.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalTarjetasActivasCliente` y recibe `@p_idCliente int`.
- [ ] Regresa un valor de tipo `int`.
- [ ] Cuenta únicamente las tarjetas del cliente con `Activo = 1` (usa `COUNT`).
- [ ] Si el cliente no tiene tarjetas, o todas están canceladas, regresa `0`.
- [ ] Si el `idCliente` no existe, regresa `0` (no genera error).

## Ejemplo de salida esperada

| Cliente | Sus tarjetas | Resultado esperado |
|---|---|---|
| 21 — Gabriel Ortiz | 3 tarjetas, todas con `Activo = 1` (una de ellas vencida) | **3** |
| 18 — Elena Lozano | 2 tarjetas, una cancelada | **1** |
| 6 — Sofía Sánchez | 1 tarjeta, cancelada | **0** |
| 25 — Roberto Silva | No tiene tarjetas | **0** |
| 9999 | No existe | **0** |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
SELECT dbo.ufn_totalTarjetasActivasCliente(21) AS TarjetasActivas    -- esperado: 3
SELECT dbo.ufn_totalTarjetasActivasCliente(18) AS TarjetasActivas    -- esperado: 1
SELECT dbo.ufn_totalTarjetasActivasCliente(6) AS TarjetasActivas     -- esperado: 0
SELECT dbo.ufn_totalTarjetasActivasCliente(25) AS TarjetasActivas    -- esperado: 0
SELECT dbo.ufn_totalTarjetasActivasCliente(9999) AS TarjetasActivas  -- esperado: 0
```

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_MendezCantuRaulAngel_2212484_Ejercicio1.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 1 | Funciones*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
