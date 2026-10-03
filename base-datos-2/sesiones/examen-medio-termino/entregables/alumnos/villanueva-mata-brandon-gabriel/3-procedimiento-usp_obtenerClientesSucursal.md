# Examen de Medio Término — Ejercicio 3 de 3: `usp_obtenerClientesSucursal`

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerClientesSucursal`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente de sucursal, **quiero** consultar la lista de clientes de mi sucursal con sus datos de contacto, **para** poder comunicarme con ellos.

## Contexto

Cada cliente pertenece a una sucursal (`Cliente.idSucursal`). Tu procedimiento regresa los clientes de una sucursal con su nombre completo, teléfono, correo y si están activos.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerClientesSucursal` que valide que la sucursal exista y regrese sus clientes.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idSucursal` | `int` | Id de la sucursal |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La sucursal existe | `000001` | La sucursal no existe |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerClientesSucursal` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Si una validación falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`.
- [ ] Valida: la sucursal existe → `000001` *La sucursal no existe*.
- [ ] Si todo es correcto, regresa con un `SELECT` (no con las variables de error) las columnas `idCliente`, `NombreCliente` (nombre, primer apellido y segundo apellido concatenados con espacios), `Telefono`, `CorreoElectronico` y `Activo`, de todos los clientes de esa sucursal, ordenadas por `idCliente`.
- [ ] Si no hay filas que mostrar, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerClientesSucursal @p_idSucursal = 4`

| idCliente | NombreCliente | Telefono | CorreoElectronico | Activo |
|---|---|---|---|---|
| 4 | Valeria Torres Gutiérrez | 8112340004 | valeria.torres@correo.mx | 1 |
| 9 | Ricardo Gómez Reyes | 8112340009 | ricardo.gomez@correo.mx | 1 |
| 25 | Roberto Silva Espinoza | 8112340025 | roberto.silva@correo.mx | 1 |
| 26 | Andrea Gutiérrez Peña | 8112340026 | andrea.gutierrez@correo.mx | 1 |
| 30 | Lucía Navarro Flores | 8112340030 | lucia.navarro@correo.mx | 1 |

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Sucursal Apodaca: 5 clientes
EXEC usp_obtenerClientesSucursal @p_idSucursal = 4

-- Sucursal Guadalupe, sin clientes: 0 filas, no es error
EXEC usp_obtenerClientesSucursal @p_idSucursal = 5

-- 000001: la sucursal no existe
EXEC usp_obtenerClientesSucursal @p_idSucursal = 9999
```

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
