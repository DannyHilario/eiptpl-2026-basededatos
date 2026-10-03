# Examen de Medio Término — Ejercicio 3 de 3: `usp_obtenerTarjetasCliente`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerTarjetasCliente`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** consultar todas las tarjetas de un cliente con su producto, límite y saldo, **para** tener un panorama completo de su crédito con el banco.

## Contexto

Un cliente puede tener de 0 a 3 tarjetas. Cada tarjeta guarda el id de su producto (`idTipoTarjetaCredito`); el nombre del producto está en `TipoTarjetaCredito`. Tu procedimiento regresa las tarjetas del cliente ya con el nombre del producto. Incluye también las tarjetas canceladas y vencidas.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerTarjetasCliente` que valide que el cliente exista y regrese sus tarjetas.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El cliente existe | `000001` | El cliente no existe |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerTarjetasCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Si una validación falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`.
- [ ] Valida: el cliente existe → `000001` *El cliente no existe*.
- [ ] Si todo es correcto, regresa con un `SELECT` (no con las variables de error) las columnas `idTarjeta`, `NumeroTarjeta`, `Producto` (de `TipoTarjetaCredito.Nombre`), `LimiteCredito`, `SaldoActual`, `FechaVencimiento` y `Activo`, de todas las tarjetas del cliente, ordenadas por `idTarjeta`.
- [ ] Si no hay filas que mostrar, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerTarjetasCliente @p_idCliente = 21`

| idTarjeta | NumeroTarjeta | Producto | LimiteCredito | SaldoActual | FechaVencimiento | Activo |
|---|---|---|---|---|---|---|
| 29 | 1111000000000029 | Banquito Básica | 6000.00 | 0.00 | 2025-09-14 | 1 |
| 30 | 2222000000000030 | Banquito Gold | 30000.00 | 14250.00 | 2028-02-10 | 1 |
| 31 | 3333000000000031 | Banquito Platinum | 500000.00 | 250000.00 | 2029-12-12 | 1 |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Cliente con 3 tarjetas
EXEC usp_obtenerTarjetasCliente @p_idCliente = 21

-- Cliente sin tarjetas: 0 filas, no es error
EXEC usp_obtenerTarjetasCliente @p_idCliente = 25

-- 000001: el cliente no existe
EXEC usp_obtenerTarjetasCliente @p_idCliente = 9999
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
