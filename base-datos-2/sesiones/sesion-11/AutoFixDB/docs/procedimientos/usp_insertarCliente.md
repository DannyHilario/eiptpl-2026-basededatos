# `usp_insertarCliente`

Script: [`instalacion/01-Cliente/03-usp-insertar.sql`](../../instalacion/01-Cliente/03-usp-insertar.sql)

Da de alta un cliente, pero antes revisa que su **correo** y su **teléfono** no estén registrados. La tabla `Cliente` no tiene `UNIQUE` en esas columnas (es la misma de Base de Datos I), así que esta validación es la que evita los duplicados.

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido |
| `@p_Nombre` | `varchar(100)` | Nombre(s) |
| `@p_Telefono` | `varchar(15)` | Teléfono; no debe estar registrado |
| `@p_Correo` | `varchar(100)` | Correo electrónico; no debe estar registrado |

## Validaciones y códigos de salida

| Orden | Validación | ErrCodigo | ErrMensaje |
|-------|------------|-----------|------------|
| 1 | Ningún cliente tiene ese correo | `000001` | El correo ya está registrado |
| 2 | Ningún cliente tiene ese teléfono | `000002` | El teléfono ya está registrado |
| — | Todo correcto: inserta el cliente | `000000` | Inserción correcta |

## Relación con los triggers

El `INSERT` que hace el procedimiento **dispara los triggers** de `Cliente` exactamente igual que un `INSERT` escrito a mano: el trigger no distingue quién hizo la inserción. Por eso, al ejecutar el SP con éxito, aparece en Mensajes `Registros correctamente insertados: 1` y la auditoría recibe un renglón `I`.

Cuando una validación falla, el procedimiento termina con `RETURN` **antes** del `INSERT`: no se inserta nada y los triggers no se disparan.

## Ejemplos

```sql
-- Éxito: 000000
EXEC usp_insertarCliente 'Martínez', 'Garza', 'Valeria', '8100000220', 'valeria.martinez@gmail.com';

-- Correo repetido: 000001
EXEC usp_insertarCliente 'Martínez', 'Garza', 'Valeria', '8100000221', 'valeria.martinez@gmail.com';

-- Teléfono repetido: 000002
EXEC usp_insertarCliente 'Martínez', 'Garza', 'Valeria', '8100000220', 'otro.correo@gmail.com';
```

Los parámetros se pasan **por posición**, en el orden de la tabla de arriba.
