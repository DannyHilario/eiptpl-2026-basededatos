# Examen de Medio Término — Ejercicio 3 de 3: `usp_insertarCliente`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Procedimiento almacenado `usp_insertarCliente`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** ejecutivo de atención a clientes, **quiero** dar de alta a un cliente nuevo en una sucursal, **para** que pueda empezar a contratar productos del banco, sin duplicar a nadie.

## Contexto

Dar de alta un cliente es insertar un renglón en `Cliente`. Antes, el banco revisa que:

- La sucursal donde se da de alta exista y esté activa.
- No haya otro cliente con la misma **CURP**, el mismo **RFC**, el mismo **teléfono** o el mismo **correo electrónico** (los cuatro son únicos en la tabla).

Validar los duplicados en el procedimiento permite regresar un mensaje claro en lugar del error del motor por la restricción `UNIQUE`.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarCliente` que valide las reglas de arriba y, si todo es correcto, inserte al cliente.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idSucursal` | `int` | Id de la sucursal |
| `@p_Nombre` | `varchar(100)` | Nombre(s) |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido |
| `@p_FechaNacimiento` | `date` | Fecha de nacimiento |
| `@p_Sexo` | `char(1)` | `'M'` o `'F'` |
| `@p_CURP` | `char(18)` | CURP |
| `@p_RFC` | `char(13)` | RFC |
| `@p_Telefono` | `varchar(15)` | Teléfono |
| `@p_CorreoElectronico` | `varchar(100)` | Correo electrónico |
| `@p_Direccion` | `varchar(200)` | Dirección completa |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La sucursal existe | `000001` | La sucursal no existe |
| 2 | La sucursal está activa (`Activo = 1`) | `000002` | La sucursal está dada de baja |
| 3 | No existe otro cliente con esa CURP | `000003` | Ya existe un cliente con esa CURP |
| 4 | No existe otro cliente con ese RFC | `000004` | Ya existe un cliente con ese RFC |
| 5 | No existe otro cliente con ese teléfono | `000005` | Ya existe un cliente con ese teléfono |
| 6 | No existe otro cliente con ese correo | `000006` | Ya existe un cliente con ese correo electrónico |
| 7 | Todo correcto | `000000` | Cliente registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarCliente` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: la sucursal existe → `000001` *La sucursal no existe*.
- [ ] Valida: la sucursal está activa (`Activo = 1`) → `000002` *La sucursal está dada de baja*.
- [ ] Valida: no existe otro cliente con esa CURP → `000003` *Ya existe un cliente con esa CURP*.
- [ ] Valida: no existe otro cliente con ese RFC → `000004` *Ya existe un cliente con ese RFC*.
- [ ] Valida: no existe otro cliente con ese teléfono → `000005` *Ya existe un cliente con ese teléfono*.
- [ ] Valida: no existe otro cliente con ese correo → `000006` *Ya existe un cliente con ese correo electrónico*.
- [ ] Se puede reutilizar una misma variable (por ejemplo `@idClienteExistente`) para las cuatro búsquedas de duplicados.
- [ ] Si todo es correcto, inserta el cliente en `Cliente` con los 11 datos recibidos. `Activo`, `FechaCreacion` y `FechaUltimaModificacion` toman su valor por defecto.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Cliente registrado'`.

## Ejemplo de salida esperada

`EXEC usp_insertarCliente @p_idSucursal = 1, @p_Nombre = 'Laura', @p_PrimerApellido = 'Treviño', @p_SegundoApellido = 'Garza', @p_FechaNacimiento = '1990-05-14', @p_Sexo = 'F', @p_CURP = 'TEGL900514MNLRRR05', @p_RFC = 'TEGL900514AB1', @p_Telefono = '8112340031', @p_CorreoElectronico = 'laura.trevino@correo.mx', @p_Direccion = 'Av. Juárez 1200, Col. Centro, Monterrey, N.L.'`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Cliente registrado |

Después, `SELECT * FROM Cliente WHERE idCliente = 31` muestra a Laura Treviño Garza, activa, en la Sucursal Centro.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito
EXEC usp_insertarCliente @p_idSucursal = 1, @p_Nombre = 'Laura', @p_PrimerApellido = 'Treviño', @p_SegundoApellido = 'Garza', @p_FechaNacimiento = '1990-05-14', @p_Sexo = 'F', @p_CURP = 'TEGL900514MNLRRR05', @p_RFC = 'TEGL900514AB1', @p_Telefono = '8112340031', @p_CorreoElectronico = 'laura.trevino@correo.mx', @p_Direccion = 'Av. Juárez 1200, Col. Centro, Monterrey, N.L.'
SELECT idCliente, idSucursal, Nombre, PrimerApellido, CURP
FROM Cliente
WHERE idCliente = 31

-- 000001: la sucursal no existe
EXEC usp_insertarCliente @p_idSucursal = 9999, @p_Nombre = 'Laura', @p_PrimerApellido = 'Treviño', @p_SegundoApellido = 'Garza', @p_FechaNacimiento = '1990-05-14', @p_Sexo = 'F', @p_CURP = 'TEGL900514MNLRRR06', @p_RFC = 'TEGL900514AB2', @p_Telefono = '8112340032', @p_CorreoElectronico = 'laura2@correo.mx', @p_Direccion = 'Calle 1'

-- 000002: sucursal dada de baja (en los datos iniciales todas están activas; primero da de baja la 5)
UPDATE Sucursal SET Activo = 0 WHERE idSucursal = 5
EXEC usp_insertarCliente @p_idSucursal = 5, @p_Nombre = 'Laura', @p_PrimerApellido = 'Treviño', @p_SegundoApellido = 'Garza', @p_FechaNacimiento = '1990-05-14', @p_Sexo = 'F', @p_CURP = 'TEGL900514MNLRRR06', @p_RFC = 'TEGL900514AB2', @p_Telefono = '8112340032', @p_CorreoElectronico = 'laura2@correo.mx', @p_Direccion = 'Calle 1'

-- 000003: la CURP GALC880315HNLRPR01 ya es del cliente 1
EXEC usp_insertarCliente @p_idSucursal = 1, @p_Nombre = 'Otro', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López', @p_FechaNacimiento = '1988-03-15', @p_Sexo = 'M', @p_CURP = 'GALC880315HNLRPR01', @p_RFC = 'XXXX880315AA1', @p_Telefono = '8112349999', @p_CorreoElectronico = 'otro@correo.mx', @p_Direccion = 'Calle 1'

-- 000004: el RFC GALC880315AA6 ya es del cliente 1
EXEC usp_insertarCliente @p_idSucursal = 1, @p_Nombre = 'Otro', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López', @p_FechaNacimiento = '1988-03-15', @p_Sexo = 'M', @p_CURP = 'XXXX880315HNLRPR01', @p_RFC = 'GALC880315AA6', @p_Telefono = '8112349999', @p_CorreoElectronico = 'otro@correo.mx', @p_Direccion = 'Calle 1'

-- 000005: el teléfono 8112340001 ya es del cliente 1
EXEC usp_insertarCliente @p_idSucursal = 1, @p_Nombre = 'Otro', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López', @p_FechaNacimiento = '1988-03-15', @p_Sexo = 'M', @p_CURP = 'XXXX880315HNLRPR01', @p_RFC = 'XXXX880315AA1', @p_Telefono = '8112340001', @p_CorreoElectronico = 'otro@correo.mx', @p_Direccion = 'Calle 1'

-- 000006: el correo carlos.garcia@correo.mx ya es del cliente 1
EXEC usp_insertarCliente @p_idSucursal = 1, @p_Nombre = 'Otro', @p_PrimerApellido = 'García', @p_SegundoApellido = 'López', @p_FechaNacimiento = '1988-03-15', @p_Sexo = 'M', @p_CURP = 'XXXX880315HNLRPR01', @p_RFC = 'XXXX880315AA1', @p_Telefono = '8112349999', @p_CorreoElectronico = 'carlos.garcia@correo.mx', @p_Direccion = 'Calle 1'
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio se entrega en su propio archivo, `EMT_AguilarHernandezMarcosFernando_2254024_Ejercicio3.txt`, en la tarea de Microsoft Teams *Examen de Medio Término | Ejercicio 3 | Procedimientos Almacenados*. Ver [Entregable](../../descripcion-examen.md#entregable) y [Forma de entrega](../../descripcion-examen.md#forma-de-entrega) en la descripción del examen.
