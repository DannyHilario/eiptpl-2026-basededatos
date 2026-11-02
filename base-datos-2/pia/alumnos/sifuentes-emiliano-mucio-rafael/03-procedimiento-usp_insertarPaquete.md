# PIA MudaFacil — Objeto 03 de 11: `usp_insertarPaquete`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Procedimiento almacenado `usp_insertarPaquete`

← [Regresar al caso MudaFacil](README.md)

---

## Historia de usuario

**Como** dueño de MudaFacil, **quiero** dar de alta un paquete nuevo, **para** que empiece a acumular mudanzas.

## Contexto

Cada paquete tiene un nombre de paquete que **no se repite** y un **precio por mudanza** mayor a cero. Además: la capacidad debe ser mayor a cero. Un paquete nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarPaquete` que valide las reglas de arriba y, si todo es correcto, registre el paquete.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(30)` | Nombre del paquete |
| `@p_CapacidadToneladas` | `decimal(4,1)` | Capacidad del camión, en toneladas |
| `@p_Precio` | `decimal(10,2)` | Precio por mudanza |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El nombre de paquete no existe | `000001` | El nombre de paquete ya existe |
| 2 | La capacidad es mayor a cero | `000002` | La capacidad debe ser mayor a cero |
| 3 | El precio por mudanza es mayor a cero | `000003` | El precio por mudanza debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Paquete registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarPaquete` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el nombre de paquete no existe → `000001` *El nombre de paquete ya existe*.
- [ ] Valida: la capacidad es mayor a cero → `000002` *La capacidad debe ser mayor a cero*.
- [ ] Valida: el precio por mudanza es mayor a cero → `000003` *El precio por mudanza debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta el paquete **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Paquete registrado'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un paquete nuevo
EXEC usp_insertarPaquete @p_Nombre = 'Paquete de Prueba', @p_CapacidadToneladas = 2.0, @p_Precio = 1800.00

-- 000001: 'Express' ya existe
EXEC usp_insertarPaquete @p_Nombre = 'Express', @p_CapacidadToneladas = 2.0, @p_Precio = 1800.00

-- 000002: CapacidadToneladas = 0
EXEC usp_insertarPaquete @p_Nombre = 'Paquete de Prueba 2', @p_CapacidadToneladas = 0, @p_Precio = 1800.00

-- 000003: precio 0
EXEC usp_insertarPaquete @p_Nombre = 'Paquete de Prueba 2', @p_CapacidadToneladas = 2.0, @p_Precio = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un paquete nuevo | `000000` | Paquete registrado |
| 'Express' ya existe | `000001` | El nombre de paquete ya existe |
| CapacidadToneladas = 0 | `000002` | La capacidad debe ser mayor a cero |
| Precio 0 | `000003` | El precio por mudanza debe ser mayor a cero |
