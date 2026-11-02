# PIA VeloKart — Objeto 03 de 11: `usp_insertarKart`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_insertarKart`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** dueño de VeloKart, **quiero** dar de alta un kart nuevo indicando su tipo, **para** que pueda salir a la pista y empiece a acumular carreras.

## Contexto

Cada kart es de **un solo** tipo, tiene un número pintado que **no se repite** y una fecha de alta. Solo se pueden dar de alta karts de un tipo que el negocio **sigue manejando**: si un tipo está dado de baja, ya no se compran karts de ese tipo. Un kart nuevo siempre se registra **activo**.

Quien registra el kart conoce el **nombre** del tipo (por ejemplo, *Estándar*), no su id: el procedimiento lo busca.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarKart` que valide las reglas de arriba y, si todo es correcto, registre el kart.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_NombreTipoKart` | `varchar(30)` | Nombre del tipo de kart (Infantil, Estándar, Profesional) |
| `@p_NumeroKart` | `varchar(10)` | Número pintado en el kart, por ejemplo `K-20` |
| `@p_FechaAlta` | `date` | Día en que empieza a usarse en la pista |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El tipo de kart existe | `000001` | El tipo de kart no existe |
| 2 | El tipo de kart está activo | `000002` | El tipo de kart está dado de baja |
| 3 | El número de kart no existe | `000003` | El número de kart ya existe |
| 4 | Todo correcto | `000000` | Kart registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarKart` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el tipo de kart existe → `000001` *El tipo de kart no existe*.
- [ ] Valida: el tipo de kart está activo → `000002` *El tipo de kart está dado de baja*.
- [ ] Valida: el número de kart no existe → `000003` *El número de kart ya existe*. Cuenta también los karts dados de baja: su número no se reutiliza.
- [ ] Si todo es correcto, inserta el kart con el id del tipo que encontró, **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Kart registrado'`.

**Sugerencia** (no se califica): obtén el id del tipo y si está activo en variables con un solo `SELECT ... FROM ... WHERE`, buscando por el nombre.

## Ejemplo de salida esperada

`EXEC usp_insertarKart @p_NombreTipoKart = 'Estándar', @p_NumeroKart = 'K-20', @p_FechaAlta = '2026-11-01'`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Kart registrado |

Después, en tu tabla de karts aparece el `K-20`, de tipo Estándar, con fecha de alta 01/11/2026, activo.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: kart nuevo
EXEC usp_insertarKart @p_NombreTipoKart = 'Estándar', @p_NumeroKart = 'K-20', @p_FechaAlta = '2026-11-01'

-- 000001: VeloKart no maneja karts Turbo
EXEC usp_insertarKart @p_NombreTipoKart = 'Turbo', @p_NumeroKart = 'K-21', @p_FechaAlta = '2026-11-01'

-- 000003: el K-07 ya existe
EXEC usp_insertarKart @p_NombreTipoKart = 'Infantil', @p_NumeroKart = 'K-07', @p_FechaAlta = '2026-11-01'

-- 000003: el K-09 está dado de baja, pero su número sigue siendo suyo
EXEC usp_insertarKart @p_NombreTipoKart = 'Estándar', @p_NumeroKart = 'K-09', @p_FechaAlta = '2026-11-01'

-- 000002: tipo dado de baja. Como ningún procedimiento da de baja un tipo,
-- hazlo directamente en tu tabla (cambia los nombres por los de tu modelo)
-- y regrésalo a activo al terminar
UPDATE <TuTablaDeTiposDeKart> SET <ColumnaActivo> = 0 WHERE <ColumnaNombre> = 'Profesional'
EXEC usp_insertarKart @p_NombreTipoKart = 'Profesional', @p_NumeroKart = 'K-21', @p_FechaAlta = '2026-11-01'
UPDATE <TuTablaDeTiposDeKart> SET <ColumnaActivo> = 1 WHERE <ColumnaNombre> = 'Profesional'
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| `K-20`, Estándar | `000000` | Kart registrado |
| Tipo Turbo | `000001` | El tipo de kart no existe |
| `K-07` | `000003` | El número de kart ya existe |
| `K-09` (dado de baja) | `000003` | El número de kart ya existe |
| Profesional dado de baja | `000002` | El tipo de kart está dado de baja |

Al final, tu tabla de karts tiene **un** kart nuevo, el `K-20`.
