# Modificar y eliminar estructuras: ALTER, TRUNCATE y DROP

En [DDL](01-DDL.md) vimos cómo **crear** tablas. Este tema cubre las otras sentencias del manual para trabajar con la estructura: **modificar** una tabla que ya existe (`ALTER TABLE`), **vaciarla** (`TRUNCATE TABLE`) y **eliminarla** (`DROP TABLE`, `DROP DATABASE`).

## Tablas de ejemplo

Todos los ejemplos se ejecutaron en SQL Server sobre estas dos tablas:

```sql
CREATE TABLE Categoria (
    idCategoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL
);

CREATE TABLE Articulo (
    idArticulo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCategoria INT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    CONSTRAINT fk_Articulo_Categoria FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);

INSERT INTO Categoria (Nombre)
VALUES ('Accesorios'),
       ('Monitores');

INSERT INTO Articulo (idCategoria, Nombre)
VALUES (1, 'Mouse'),
       (2, 'Monitor');
```

---

## ALTER TABLE: modificar una tabla

Sirve para corregir o ampliar una tabla **sin borrarla** y sin perder sus datos.

### Agregar una columna

```sql
ALTER TABLE Articulo ADD Precio DECIMAL(10,2) NULL;
```

Los registros que ya existían quedan con `NULL` en la columna nueva: la tabla ya tenía datos y SQL Server no sabe qué precio ponerles.

Si la columna nueva debe ser `NOT NULL`, necesita un `DEFAULT` para llenar los registros existentes:

```sql
ALTER TABLE Articulo ADD Activo BIT NOT NULL DEFAULT 1;
```

```sql
SELECT idArticulo, Nombre, Precio, Activo
FROM Articulo;
```

| idArticulo | Nombre | Precio | Activo |
|------------|--------|--------|--------|
| 1 | Mouse | NULL | 1 |
| 2 | Monitor | NULL | 1 |

### Cambiar el tipo de una columna

```sql
ALTER TABLE Articulo ALTER COLUMN Nombre VARCHAR(100) NOT NULL;
```

Ampliar un `VARCHAR` siempre funciona. Hacerlo **más chico**, o cambiar a un tipo incompatible, falla si algún dato existente no cabe en el tipo nuevo.

### Agregar una restricción

```sql
ALTER TABLE Articulo ADD CONSTRAINT chk_Articulo_Precio CHECK (Precio > 0);
```

Darle **nombre** a la restricción (`chk_Articulo_Precio`) permite después quitarla por su nombre.

### Eliminar una columna

```sql
ALTER TABLE Articulo DROP COLUMN Precio;
```

Este intento **falla**:

```
The object 'chk_Articulo_Precio' is dependent on column 'Precio'.
ALTER TABLE DROP COLUMN Precio failed because one or more objects access this column.
```

La restricción `CHECK` depende de la columna. Primero se quita la restricción y después la columna:

```sql
ALTER TABLE Articulo DROP CONSTRAINT chk_Articulo_Precio;
ALTER TABLE Articulo DROP COLUMN Precio;
```

| Necesito… | Sentencia |
|-----------|-----------|
| Agregar una columna | `ALTER TABLE T ADD Columna TIPO …` |
| Cambiar el tipo de una columna | `ALTER TABLE T ALTER COLUMN Columna TIPO …` |
| Agregar una restricción | `ALTER TABLE T ADD CONSTRAINT nombre …` |
| Quitar una restricción | `ALTER TABLE T DROP CONSTRAINT nombre` |
| Quitar una columna | `ALTER TABLE T DROP COLUMN Columna` |

---

## TRUNCATE TABLE: vaciar una tabla

`TRUNCATE TABLE` borra **todos** los registros de una tabla de golpe. La tabla sigue existiendo, vacía.

```sql
TRUNCATE TABLE Articulo;
```

### TRUNCATE frente a DELETE

Las dos vacían la tabla, pero no son iguales. La diferencia se ve en el `IDENTITY`:

```sql
DELETE FROM Articulo;
INSERT INTO Articulo (idCategoria, Nombre) VALUES (1, 'Teclado');
```

| idArticulo | Nombre |
|------------|--------|
| 3 | Teclado |

```sql
TRUNCATE TABLE Articulo;
INSERT INTO Articulo (idCategoria, Nombre) VALUES (1, 'Teclado');
```

| idArticulo | Nombre |
|------------|--------|
| 1 | Teclado |

| | `DELETE FROM T` | `TRUNCATE TABLE T` |
|---|---|---|
| Grupo | DML | DDL |
| ¿Acepta `WHERE`? | Sí: puede borrar solo algunos registros | No: siempre borra todo |
| Numeración `IDENTITY` | **Continúa** donde iba | **Reinicia** en 1 |
| Tabla referenciada por una llave foránea | Funciona si ningún registro está en uso | **Falla siempre** |

```sql
TRUNCATE TABLE Categoria;
```

```
Cannot truncate table 'Categoria' because it is being referenced by a FOREIGN KEY constraint.
```

---

## DROP TABLE: eliminar una tabla

`DROP TABLE` elimina la tabla **completa**: su estructura y todos sus datos. No se puede deshacer.

### El orden importa

Una tabla **no se puede eliminar mientras otra tabla la referencie** con una llave foránea:

```sql
DROP TABLE Categoria;
```

```
Could not drop object 'Categoria' because it is referenced by a FOREIGN KEY constraint.
```

Hay que eliminar primero la tabla que **tiene** la llave foránea (la "hija") y después la que es referenciada (la "padre"). Es el **orden inverso** al de creación:

| Crear | Eliminar |
|-------|----------|
| 1. `Categoria` (padre) | 1. `Articulo` (hija) |
| 2. `Articulo` (hija) | 2. `Categoria` (padre) |

```sql
DROP TABLE IF EXISTS Articulo;
DROP TABLE IF EXISTS Categoria;
```

`IF EXISTS` evita el error si la tabla ya no existe, así que el script se puede ejecutar más de una vez.

> **Cómo saber el orden:** primero se elimina la tabla de la que **nadie depende**. En un modelo típico, primero la tabla de hechos (ventas, citas, pedidos), que tiene llaves foráneas hacia todas las demás; al final, los catálogos.

---

## DROP DATABASE: eliminar la base de datos

```sql
DROP DATABASE IF EXISTS TecnoShopDB;
```

Elimina la base de datos completa, con todas sus tablas.

**No se puede eliminar la base de datos a la que estás conectado.** Antes de ejecutarlo, selecciona **otra** base de datos en el menú desplegable de SSMS (por ejemplo, `master`).

---

## Resumen

| Sentencia | Qué hace | ¿Quedan los datos? | ¿Queda la tabla? |
|-----------|----------|-------------------|------------------|
| `ALTER TABLE` | Modifica la estructura | Sí | Sí |
| `DELETE FROM` | Borra registros (todos o algunos con `WHERE`) | Los que no se borraron | Sí |
| `TRUNCATE TABLE` | Borra **todos** los registros y reinicia el `IDENTITY` | No | Sí |
| `DROP TABLE` | Elimina la tabla | No | No |
| `DROP DATABASE` | Elimina la base de datos completa | No | No |
