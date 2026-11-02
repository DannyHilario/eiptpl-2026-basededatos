# PIA AsesorPro — Objeto 03 de 11: `usp_insertarAsesor`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Procedimiento almacenado `usp_insertarAsesor`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** dar de alta un asesor nuevo, **para** que empiece a acumular asesorías.

## Contexto

Cada asesor tiene un correo electrónico que **no se repite** y una **tarifa por hora** mayor a cero. Además: un asesor debe tener al menos 1 año de experiencia. Un asesor nuevo siempre se registra **activo**.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarAsesor` que valide las reglas de arriba y, si todo es correcto, registre el asesor.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_Nombre` | `varchar(100)` | Nombre del asesor |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_Materia` | `varchar(50)` | Materia que imparte |
| `@p_AniosExperiencia` | `int` | Años de experiencia |
| `@p_TarifaPorHora` | `decimal(10,2)` | Tarifa por hora |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | El correo electrónico no existe | `000001` | El correo electrónico ya existe |
| 2 | El asesor tiene al menos 1 año de experiencia | `000002` | Un asesor debe tener al menos 1 año de experiencia |
| 3 | La tarifa por hora es mayor a cero | `000003` | La tarifa por hora debe ser mayor a cero |
| 4 | Todo correcto | `000000` | Asesor registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarAsesor` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Las validaciones son *guard clauses*: se evalúan **en el orden de la tabla** y, si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: el correo electrónico no existe → `000001` *El correo electrónico ya existe*.
- [ ] Valida: el asesor tiene al menos 1 año de experiencia → `000002` *Un asesor debe tener al menos 1 año de experiencia*.
- [ ] Valida: la tarifa por hora es mayor a cero → `000003` *La tarifa por hora debe ser mayor a cero*.
- [ ] Si todo es correcto, inserta el asesor **activo**.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Asesor registrado'`.

**Sugerencia** (no se califica): Para validar que no existe, guarda el dato en una variable con `SELECT ... FROM ... WHERE` y revísala con `IF @variable IS NOT NULL`.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden.

```sql
-- 000000: un asesor nuevo
EXEC usp_insertarAsesor @p_Nombre = 'Asesor de Prueba', @p_CorreoElectronico = 'asesor.prueba@asesorpro.mx', @p_Materia = 'Historia', @p_AniosExperiencia = 2, @p_TarifaPorHora = 250.00

-- 000001: 'laura.garza@asesorpro.mx' ya existe
EXEC usp_insertarAsesor @p_Nombre = 'Asesor de Prueba', @p_CorreoElectronico = 'laura.garza@asesorpro.mx', @p_Materia = 'Historia', @p_AniosExperiencia = 2, @p_TarifaPorHora = 250.00

-- 000002: AniosExperiencia = 0
EXEC usp_insertarAsesor @p_Nombre = 'Asesor de Prueba', @p_CorreoElectronico = 'asesor.prueba@asesorpro.mx 2', @p_Materia = 'Historia', @p_AniosExperiencia = 0, @p_TarifaPorHora = 250.00

-- 000003: precio 0
EXEC usp_insertarAsesor @p_Nombre = 'Asesor de Prueba', @p_CorreoElectronico = 'asesor.prueba@asesorpro.mx 2', @p_Materia = 'Historia', @p_AniosExperiencia = 2, @p_TarifaPorHora = 0
```

| Caso | ErrCodigo | ErrMensaje |
|---|---|---|
| Un asesor nuevo | `000000` | Asesor registrado |
| 'laura.garza@asesorpro.mx' ya existe | `000001` | El correo electrónico ya existe |
| AniosExperiencia = 0 | `000002` | Un asesor debe tener al menos 1 año de experiencia |
| Precio 0 | `000003` | La tarifa por hora debe ser mayor a cero |
