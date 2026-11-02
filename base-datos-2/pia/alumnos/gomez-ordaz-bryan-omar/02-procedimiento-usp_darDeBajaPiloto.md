# PIA VeloKart — Objeto 02 de 11: `usp_darDeBajaPiloto`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_darDeBajaPiloto`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** encargado del mostrador, **quiero** dar de baja a un piloto que ya no regresa, **para** que ya no se le asignen carreras sin perder su historial.

## Contexto

En VeloKart un piloto **no se borra**: se da de baja, para conservar sus carreras. Al piloto se le busca por su **teléfono**, que es lo que el encargado tiene a la mano.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_darDeBajaPiloto` que valide las reglas de abajo y, si todo es correcto, marque al piloto como dado de baja.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Telefono` | `varchar(15)` | Teléfono del piloto |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El piloto existe | `000001` | El piloto no existe |
| 2 | El piloto está activo | `000002` | El piloto ya está dado de baja |
| 3 | Todo correcto | `000000` | Piloto dado de baja |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_darDeBajaPiloto` y recibe `@p_Telefono varchar(15)`.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el piloto existe → `000001` *El piloto no existe*.
- [ ] Valida: el piloto está activo → `000002` *El piloto ya está dado de baja*.
- [ ] Si todo es correcto, marca al piloto como dado de baja con un `UPDATE`. **No** lo borra.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Piloto dado de baja'`.

**Sugerencia** (no se califica): obtén el id del piloto y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, y revísalas con `IF`.

## Ejemplo de salida esperada

`EXEC usp_darDeBajaPiloto @p_Telefono = '8199990001'` (después de registrar al piloto de prueba)

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Piloto dado de baja |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarPiloto`](01-procedimiento-usp_insertarPiloto.md).

```sql
-- Preparación: el piloto de prueba
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175

-- 000001: nadie tiene ese teléfono
EXEC usp_darDeBajaPiloto @p_Telefono = '8199999999'

-- 000000: se da de baja
EXEC usp_darDeBajaPiloto @p_Telefono = '8199990001'

-- 000002: ya estaba dado de baja
EXEC usp_darDeBajaPiloto @p_Telefono = '8199990001'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Teléfono que no existe | `000001` | El piloto no existe |
| Primera baja | `000000` | Piloto dado de baja |
| Segunda baja | `000002` | El piloto ya está dado de baja |

Al final, *Piloto de Prueba* sigue en tu tabla de pilotos, pero **dado de baja**.
