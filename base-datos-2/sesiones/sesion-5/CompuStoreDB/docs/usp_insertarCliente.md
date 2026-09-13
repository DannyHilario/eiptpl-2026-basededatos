# `usp_insertarCliente`

Script: [`instalacion/05-Cliente/03-usp-insertar.sql`](../instalacion/05-Cliente/03-usp-insertar.sql)

Alta de un cliente.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre del cliente |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido (opcional) |
| `@p_Sexo` | `char(1)` | `'M'` o `'F'` |
| `@p_Telefono` | `varchar(20)` | Teléfono (opcional, único por cliente) |
| `@p_Correo` | `varchar(100)` | Correo (único por cliente) |

## Validaciones (orden en que se evalúan)

1. `Sexo` debe ser `'M'` o `'F'`.
2. `Correo` no debe estar ya registrado por otro cliente.
3. Si `Telefono` no es `NULL`, no debe estar ya registrado por otro cliente.

## Códigos de salida

| ErrCodigo | ErrMensaje | Causa |
|-----------|------------|-------|
| `000001` | El sexo debe ser M o F | `Sexo` inválido |
| `000002` | El correo ya está registrado | `Correo` duplicado |
| `000003` | El teléfono ya está registrado | `Telefono` duplicado |
| `000000` | Inserción correcta | Éxito |

## Ejemplo de uso

```sql
EXEC usp_insertarCliente
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
EXEC usp_insertarCliente @p_Nombre = 'Test', @p_PrimerApellido = 'Uno', @p_SegundoApellido = NULL,
	@p_Sexo = 'M', @p_Telefono = '8199999901', @p_Correo = 'test.uno@correo.com'

-- Sexo inválido
EXEC usp_insertarCliente @p_Nombre = 'Test', @p_PrimerApellido = 'Dos', @p_SegundoApellido = NULL,
	@p_Sexo = 'X', @p_Telefono = '8199999902', @p_Correo = 'test.dos@correo.com'

-- Correo duplicado (usa un correo ya existente en Cliente)
EXEC usp_insertarCliente @p_Nombre = 'Test', @p_PrimerApellido = 'Tres', @p_SegundoApellido = NULL,
	@p_Sexo = 'F', @p_Telefono = '8199999903', @p_Correo = 'carlos.garcia@gmail.com'

-- Teléfono duplicado (usa un teléfono ya existente en Cliente)
EXEC usp_insertarCliente @p_Nombre = 'Test', @p_PrimerApellido = 'Cuatro', @p_SegundoApellido = NULL,
	@p_Sexo = 'F', @p_Telefono = '8100000001', @p_Correo = 'test.cuatro@correo.com'
```
