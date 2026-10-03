# Examen de Medio Término — Ejercicio 3 de 3: `usp_eliminarCliente`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Procedimiento almacenado `usp_eliminarCliente`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** dar de baja a un cliente que ya no quiere trabajar con el banco, **para** que deje de aparecer como cliente activo, siempre que no le deba nada al banco.

## Contexto

En `SistemaBancarioBD` los clientes no se borran: se hace una **baja lógica**, poniendo `Activo = 0`, para conservar su historial.

El banco no permite dar de baja a un cliente que todavía **debe dinero**: si alguna de sus tarjetas tiene `SaldoActual > 0`, la baja se rechaza. Para revisarlo, cuenta con `COUNT` cuántas tarjetas del cliente tienen saldo mayor a cero y guarda el resultado en una variable.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_eliminarCliente` que valide las reglas de arriba y, si todo es correcto, dé de baja al cliente.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El cliente existe | `000001` | El cliente no existe |
| 2 | El cliente no está ya dado de baja (`Activo = 1`) | `000002` | El cliente ya está dado de baja |
| 3 | Ninguna tarjeta del cliente tiene `SaldoActual > 0` | `000003` | El cliente tiene tarjetas con saldo pendiente |
| 4 | Todo correcto | `000000` | Cliente dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el cliente existe → `000001` *El cliente no existe*.
- [ ] Valida: el cliente no está ya dado de baja (`Activo = 1`) → `000002` *El cliente ya está dado de baja*.
- [ ] Valida: ninguna tarjeta del cliente tiene `SaldoActual > 0` → `000003` *El cliente tiene tarjetas con saldo pendiente*.
- [ ] Si todo es correcto, actualiza el cliente con `Activo = 0` y `FechaUltimaModificacion = GETDATE()`. No usa `DELETE`.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cliente dado de baja'`.

## Ejemplo de salida esperada

`EXEC usp_eliminarCliente @p_idCliente = 25`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Cliente dado de baja |

El cliente 25 no tiene tarjetas. Después, `SELECT Activo FROM Cliente WHERE idCliente = 25` muestra `0`.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito: el cliente 25 no tiene tarjetas
EXEC usp_eliminarCliente @p_idCliente = 25
SELECT idCliente, Activo
FROM Cliente
WHERE idCliente = 25

-- Éxito: la clienta 2 tiene una tarjeta, pero con saldo 0
EXEC usp_eliminarCliente @p_idCliente = 2

-- 000002: el cliente 25 ya se dio de baja en el primer caso
EXEC usp_eliminarCliente @p_idCliente = 25

-- 000001: el cliente no existe
EXEC usp_eliminarCliente @p_idCliente = 9999

-- 000003: el cliente 1 debe 3,250.00 en su tarjeta 1
EXEC usp_eliminarCliente @p_idCliente = 1
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
