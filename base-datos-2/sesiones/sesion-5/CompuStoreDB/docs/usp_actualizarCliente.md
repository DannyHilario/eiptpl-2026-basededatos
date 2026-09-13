# `usp_actualizarCliente`

Script: [`instalacion/05-Cliente/06-usp-actualizar.sql`](../instalacion/05-Cliente/06-usp-actualizar.sql)

Sobrescribe los datos principales de un cliente existente.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idCliente` | `int` | Id del cliente a actualizar |
| `@p_Nombre` | `varchar(50)` | Nombre nuevo |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido nuevo |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido nuevo (opcional) |
| `@p_Sexo` | `char(1)` | `'M'` o `'F'` |
| `@p_Telefono` | `varchar(20)` | Teléfono nuevo (opcional) |
| `@p_Correo` | `varchar(100)` | Correo nuevo |

## Validaciones (orden en que se evalúan)

1. El cliente debe existir.
2. `Sexo` debe ser `'M'` o `'F'`.
3. `Correo` no debe estar registrado por **otro** cliente (`idCliente <> @p_idCliente` — el cliente sí puede "actualizar" con el mismo correo que ya tenía).
4. Si `Telefono` no es `NULL`, no debe estar registrado por **otro** cliente.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El cliente no existe | `idCliente` inválido |
| `000002` | El sexo debe ser M o F | `Sexo` inválido |
| `000003` | El correo ya está registrado por otro cliente | `Correo` duplicado |
| `000004` | El teléfono ya está registrado por otro cliente | `Telefono` duplicado |
| `000000` | Actualización correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_actualizarCliente
	@p_idCliente = 1,
	@p_Nombre = 'Juan',
	@p_PrimerApellido = 'Pérez',
	@p_SegundoApellido = 'López',
	@p_Sexo = 'M',
	@p_Telefono = '8111234567',
	@p_Correo = 'juan.perez@correo.com'
```

## Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarCliente @p_idCliente = 1, @p_Nombre = 'Carlos', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López',
	@p_Sexo = 'M', @p_Telefono = '8100000001', @p_Correo = 'carlos.garcia@gmail.com'

-- Cliente no existe
EXEC usp_actualizarCliente @p_idCliente = 9999, @p_Nombre = 'X', @p_PrimerApellido = 'X', @p_SegundoApellido = NULL,
	@p_Sexo = 'M', @p_Telefono = NULL, @p_Correo = 'x@correo.com'

-- Sexo inválido
EXEC usp_actualizarCliente @p_idCliente = 1, @p_Nombre = 'Carlos', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López',
	@p_Sexo = 'X', @p_Telefono = '8100000001', @p_Correo = 'carlos.garcia@gmail.com'

-- Correo de otro cliente (usa el correo del idCliente = 2)
EXEC usp_actualizarCliente @p_idCliente = 1, @p_Nombre = 'Carlos', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López',
	@p_Sexo = 'M', @p_Telefono = '8100000001', @p_Correo = 'ana.hernandez@hotmail.com'
```
