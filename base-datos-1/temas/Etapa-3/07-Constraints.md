# Constraints

## ¿Qué son los constraints?

Los constraints (restricciones) son reglas que se definen sobre las columnas de una tabla para garantizar que los datos sean válidos y consistentes. SQL Server valida estas reglas automáticamente cada vez que se inserta o modifica un registro; si alguna regla se viola, la operación es rechazada con un error.

Ya hemos usado algunos (`NOT NULL`, `PRIMARY KEY`, `IDENTITY`). En este tema los formalizamos todos.

---

## PRIMARY KEY

Identifica de forma única cada fila de la tabla. No acepta valores nulos ni duplicados. Cada tabla debe tener exactamente una.

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);
```

---

## UNIQUE

Garantiza que no existan dos filas con el mismo valor en esa columna. A diferencia de `PRIMARY KEY`, una tabla puede tener múltiples columnas con `UNIQUE`, y sí acepta un valor nulo.

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100) UNIQUE
);
```

Si intentas insertar dos alumnos con el mismo correo, SQL Server rechazará el segundo registro.

---

## CHECK

Define una condición que el valor de la columna debe cumplir. Si el valor insertado no la cumple, la operación falla.

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Edad INT CHECK (Edad >= 15 AND Edad <= 100),
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F'))
);
```

En este ejemplo, intentar insertar `Edad = 5` o `Sexo = 'X'` generará un error.

---

## DEFAULT

Asigna un valor automático a una columna cuando el `INSERT` no proporciona uno explícitamente.

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(50) DEFAULT 'Monterrey',
    FechaRegistro DATE DEFAULT GETDATE()
);
```

Si insertas un alumno sin especificar `Ciudad`, SQL Server usará `'Monterrey'` automáticamente.

---

## FOREIGN KEY

Es el constraint más importante para el modelo relacional. Establece una relación entre dos tablas indicando que el valor de una columna **debe existir** como llave primaria en otra tabla.

### El problema que resuelve

Imagina que tienes alumnos y cada alumno pertenece a una carrera. Sin `FOREIGN KEY`, nada impide registrar un alumno con un `idCarrera` que no existe. Con `FOREIGN KEY`, SQL Server lo rechaza automáticamente.

### Sintaxis

```sql
CREATE TABLE Carrera (
    idCarrera INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    idCarrera INT NOT NULL,
    FOREIGN KEY (idCarrera) REFERENCES Carrera(idCarrera)
);
```

La línea `FOREIGN KEY (idCarrera) REFERENCES Carrera(idCarrera)` le dice a SQL Server:
> "El valor de `idCarrera` en `Alumno` debe existir en la columna `idCarrera` de la tabla `Carrera`."

### Regla de orden

La tabla referenciada (`Carrera`) debe crearse **antes** que la tabla que la referencia (`Alumno`). De lo contrario SQL Server devolverá un error porque no puede validar una referencia a una tabla que aún no existe.

### ¿Qué pasa cuando se viola?

```sql
-- Esto falla si no existe ninguna Carrera con idCarrera = 99
INSERT INTO Alumno (PrimerApellido, Nombre, idCarrera)
VALUES ('Méndez', 'Carlos', 99);
```

SQL Server devuelve un error de violación de llave foránea y el registro no se inserta.

---

## Resumen

| Constraint | ¿Qué garantiza? |
|------------|-----------------|
| `PRIMARY KEY` | Unicidad e identidad de cada fila |
| `UNIQUE` | No hay duplicados en esa columna |
| `NOT NULL` | La columna no puede estar vacía |
| `CHECK` | El valor cumple una condición lógica |
| `DEFAULT` | Valor automático si no se proporciona uno |
| `FOREIGN KEY` | El valor existe en otra tabla |
