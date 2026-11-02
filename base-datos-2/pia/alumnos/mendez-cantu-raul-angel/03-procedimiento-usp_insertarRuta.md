# PIA RutaNorte — Objeto 03 de 11: `usp_insertarRuta`

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)
**Objeto a crear:** Procedimiento almacenado `usp_insertarRuta`

← [Regresar al caso RutaNorte](README.md)

---

## Historia de usuario

**Como** gerente de RutaNorte, **quiero** dar de alta una ruta nueva, **para** que empiece a acumular boletos.

## Contexto

Cada ruta tiene una clave de ruta que **no se repite** y un **precio** mayor a cero. Además: la duración debe ser mayor a cero. Una ruta nueva siempre se registra **activa**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarRuta` que valide las reglas de arriba y, si todo es correcto, registre la ruta.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Clave` | `varchar(10)` | Clave de la ruta |
| `@p_Origen` | `varchar(50)` | Ciudad de origen |
| `@p_Destino` | `varchar(50)` | Ciudad de destino |
| `@p_DuracionHoras` | `int` | Duración del viaje, en horas |
| `@p_Precio` | `decimal(10,2)` | Precio |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La clave de ruta no existe | `000001` | La clave de ruta ya existe |
| 2 | La duración es mayor a cero | `000002` | La duración debe ser mayor a cero |
| 3 | El precio es mayor a cero | `000003` | El precio debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Ruta registrada |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarRuta` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la clave de ruta no existe → `000001` *La clave de ruta ya existe*.
- [ ] Valida: la duración es mayor a cero → `000002` *La duración debe ser mayor a cero*.
- [ ] Valida: el precio es mayor a cero → `000003` *El precio debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta la ruta **activa**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Ruta registrada'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: una ruta nueva
EXEC usp_insertarRuta @p_Clave = 'MTY-ZAC', @p_Origen = 'Monterrey', @p_Destino = 'Zacatecas', @p_DuracionHoras = 6, @p_Precio = 180.00

-- 000001: 'MTY-SAL' ya existe
EXEC usp_insertarRuta @p_Clave = 'MTY-SAL', @p_Origen = 'Monterrey', @p_Destino = 'Zacatecas', @p_DuracionHoras = 6, @p_Precio = 180.00

-- 000002: DuracionHoras = 0
EXEC usp_insertarRuta @p_Clave = 'MTY-ZAC 2', @p_Origen = 'Monterrey', @p_Destino = 'Zacatecas', @p_DuracionHoras = 0, @p_Precio = 180.00

-- 000003: precio 0
EXEC usp_insertarRuta @p_Clave = 'MTY-ZAC 2', @p_Origen = 'Monterrey', @p_Destino = 'Zacatecas', @p_DuracionHoras = 6, @p_Precio = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Una ruta nueva | `000000` | Ruta registrada |
| 'MTY-SAL' ya existe | `000001` | La clave de ruta ya existe |
| DuracionHoras = 0 | `000002` | La duración debe ser mayor a cero |
| Precio 0 | `000003` | El precio debe ser mayor a cero |
