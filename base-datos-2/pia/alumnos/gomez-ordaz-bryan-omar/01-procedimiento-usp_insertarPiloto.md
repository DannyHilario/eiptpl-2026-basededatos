# PIA VeloKart — Objeto 01 de 11: `usp_insertarPiloto`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Procedimiento almacenado `usp_insertarPiloto`

← [Regresar al caso VeloKart](README.md)

---

## Historia de usuario

**Como** encargado del mostrador, **quiero** registrar a un piloto que llega por primera vez, **para** asignarle carreras sin que se repita su registro ni se cuele alguien que no cumple la estatura mínima.

## Contexto

Es el paso 1 del [flujo de negocio](README.md#flujo-de-negocio): Marco llega, le piden nombre y teléfono, lo miden y lo registran. El teléfono identifica al piloto, y por seguridad solo se registra a quien mide **al menos 120 cm**. Un piloto nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarPiloto` que valide las reglas de arriba y, si todo es correcto, registre al piloto.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(100)` | Nombre del piloto |
| `@p_Telefono` | `varchar(15)` | Teléfono del piloto |
| `@p_Estatura` | `int` | Estatura en centímetros |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El teléfono no está registrado | `000001` | El teléfono ya está registrado |
| 2 | La estatura es de al menos 120 cm | `000002` | La estatura mínima es de 120 cm |
| 3 | Todo correcto | `000000` | Piloto registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarPiloto` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el teléfono no está registrado → `000001` *El teléfono ya está registrado*. Cuenta también a los pilotos dados de baja: su teléfono sigue siendo suyo.
- [ ] Valida: la estatura es de al menos 120 cm → `000002` *La estatura mínima es de 120 cm*. 120 sí se acepta; 119 no.
- [ ] Si todo es correcto, inserta al piloto **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Piloto registrado'`.

**Sugerencia** (no se califica): para la validación 1, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Ejemplo de salida esperada

`EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Piloto registrado |

Después, en tu tabla de pilotos aparece *Piloto de Prueba*, teléfono `8199990001`, 175 cm, activo.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: piloto nuevo
EXEC usp_insertarPiloto @p_Nombre = 'Piloto de Prueba', @p_Telefono = '8199990001', @p_Estatura = 175

-- 000001: el teléfono 8199990001 ya está registrado
EXEC usp_insertarPiloto @p_Nombre = 'Otro Piloto', @p_Telefono = '8199990001', @p_Estatura = 160

-- 000002: mide 110 cm
EXEC usp_insertarPiloto @p_Nombre = 'Piloto Bajito', @p_Telefono = '8199990002', @p_Estatura = 110

-- 000002: el límite; 119 no se acepta...
EXEC usp_insertarPiloto @p_Nombre = 'Piloto Límite', @p_Telefono = '8199990002', @p_Estatura = 119

-- 000000: ...y 120 sí
EXEC usp_insertarPiloto @p_Nombre = 'Piloto Límite', @p_Telefono = '8199990002', @p_Estatura = 120
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Piloto nuevo | `000000` | Piloto registrado |
| Teléfono repetido | `000001` | El teléfono ya está registrado |
| 110 cm | `000002` | La estatura mínima es de 120 cm |
| 119 cm | `000002` | La estatura mínima es de 120 cm |
| 120 cm | `000000` | Piloto registrado |

Al final, tu tabla de pilotos tiene **dos** pilotos nuevos: *Piloto de Prueba* (175 cm) y *Piloto Límite* (120 cm), los dos activos.
