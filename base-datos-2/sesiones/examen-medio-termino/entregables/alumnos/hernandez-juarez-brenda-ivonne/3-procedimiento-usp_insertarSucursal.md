# Examen de Medio Término — Ejercicio 3 de 3: `usp_insertarSucursal`

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)
**Objeto a crear:** Procedimiento almacenado `usp_insertarSucursal`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente regional, **quiero** dar de alta una sucursal nueva, **para** empezar a asignarle clientes, sin duplicar nombres ni teléfonos.

## Contexto

Dar de alta una sucursal es insertar un renglón en `Sucursal`. El nombre y el teléfono de cada sucursal son únicos: no puede haber dos sucursales con el mismo nombre ni con el mismo teléfono. Validarlo en el procedimiento permite regresar un mensaje claro en lugar del error del motor.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarSucursal` que valide las reglas de arriba y, si todo es correcto, inserte la sucursal.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre de la sucursal |
| `@p_Direccion` | `varchar(200)` | Dirección completa |
| `@p_Telefono` | `varchar(15)` | Teléfono |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | No existe otra sucursal con ese nombre | `000001` | Ya existe una sucursal con ese nombre |
| 2 | No existe otra sucursal con ese teléfono | `000002` | Ya existe una sucursal con ese teléfono |
| 3 | Todo correcto | `000000` | Sucursal registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarSucursal` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: no existe otra sucursal con ese nombre → `000001` *Ya existe una sucursal con ese nombre*.
- [ ] Valida: no existe otra sucursal con ese teléfono → `000002` *Ya existe una sucursal con ese teléfono*.
- [ ] Si todo es correcto, inserta la sucursal en `Sucursal` con nombre, dirección y teléfono. `Activo`, `FechaCreacion` y `FechaUltimaModificacion` toman su valor por defecto.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Sucursal registrada'`.

## Ejemplo de salida esperada

`EXEC usp_insertarSucursal @p_Nombre = 'Sucursal San Nicolás', @p_Direccion = 'Av. Universidad 500, Col. Anáhuac, San Nicolás de los Garza, N.L.', @p_Telefono = '8180000006'`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Sucursal registrada |

Después, `SELECT * FROM Sucursal WHERE idSucursal = 6` muestra la Sucursal San Nicolás, activa.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito
EXEC usp_insertarSucursal @p_Nombre = 'Sucursal San Nicolás', @p_Direccion = 'Av. Universidad 500, Col. Anáhuac, San Nicolás de los Garza, N.L.', @p_Telefono = '8180000006'
SELECT idSucursal, Nombre, Telefono, Activo
FROM Sucursal
WHERE idSucursal = 6

-- 000001: ya existe la Sucursal Centro
EXEC usp_insertarSucursal @p_Nombre = 'Sucursal Centro', @p_Direccion = 'Calle 1', @p_Telefono = '8180000099'

-- 000002: el teléfono 8180000001 ya es de la Sucursal Centro
EXEC usp_insertarSucursal @p_Nombre = 'Sucursal Escobedo', @p_Direccion = 'Calle 1', @p_Telefono = '8180000001'
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
