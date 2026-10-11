# DML: Data Manipulation Language

## ¿Qué es DML?

DML (Data Manipulation Language) es el subconjunto de SQL que se usa para **trabajar con los datos** dentro de las tablas. A diferencia de DDL que define estructuras, DML inserta, consulta, modifica y elimina registros.

Las cuatro instrucciones principales son:

| Instrucción | ¿Para qué sirve? |
|-------------|------------------|
| `INSERT` | Agregar nuevos registros |
| `SELECT` | Consultar registros existentes |
| `UPDATE` | Modificar registros existentes |
| `DELETE` | Eliminar registros |

Para los ejemplos de este tema usaremos la siguiente tabla:

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Edad INT,
    CorreoElectronico VARCHAR(100),
    Ciudad VARCHAR(50),
    Sexo CHAR(1) NOT NULL
);
```

---

## INSERT

Agrega uno o más registros a una tabla.

```sql
INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Méndez', 'García', 'Carlos', '2003-07-15', 22,
        'carlos.mendez@cursodb.com', 'Monterrey', 'M');
```

Para insertar varios registros en una sola instrucción:

```sql
INSERT INTO Alumno (PrimerApellido, SegundoApellido, Nombre, FechaNacimiento, Edad,
                    CorreoElectronico, Ciudad, Sexo)
VALUES ('Torres', 'López', 'Ana', '2005-04-22', 20,
        'ana.torres@cursodb.com', 'Guadalajara', 'F'),
       ('Ramos', 'Vázquez', 'Luis', '2002-11-08', 23,
        'luis.ramos@cursodb.com', 'Monterrey', 'M'),
       ('Pérez', 'Sánchez', 'María', '2004-09-30', 21,
        'maria.perez@cursodb.com', 'Ciudad de México', 'F');
```

Puntos importantes:
- Siempre especifica las columnas explícitamente
- El orden de los valores debe coincidir con el orden de las columnas declaradas
- `idAlumno` no se incluye porque es `IDENTITY`: SQL Server lo genera automáticamente

---

## SELECT

Consulta registros de una tabla.

### Todos los registros y columnas

```sql
SELECT *
FROM Alumno;
```

### Columnas específicas

```sql
SELECT PrimerApellido, Nombre, Ciudad
FROM Alumno;
```

### Filtrar con WHERE

`WHERE` limita los resultados a los registros que cumplen una condición.

```sql
SELECT PrimerApellido, Nombre, Edad
FROM Alumno
WHERE Ciudad = 'Monterrey';
```

### Operadores en WHERE

| Operador | Significado | Ejemplo |
|----------|-------------|---------|
| `=` | Igual | `Ciudad = 'Monterrey'` |
| `<>` o `!=` | Diferente | `Ciudad <> 'Monterrey'` |
| `>` | Mayor que | `Edad > 20` |
| `<` | Menor que | `Edad < 25` |
| `>=` | Mayor o igual | `Edad >= 18` |
| `<=` | Menor o igual | `Edad <= 22` |

### Múltiples condiciones

```sql
SELECT PrimerApellido, Nombre, Edad
FROM Alumno
WHERE Ciudad = 'Monterrey' AND Edad >= 21;
```

```sql
SELECT PrimerApellido, Nombre, Ciudad
FROM Alumno
WHERE Ciudad = 'Monterrey' OR Ciudad = 'Guadalajara';
```

### Ordenar resultados con ORDER BY

```sql
SELECT PrimerApellido, Nombre, Edad
FROM Alumno
ORDER BY Edad DESC;
```

`ASC` ordena de menor a mayor (predeterminado), `DESC` de mayor a menor.

---

## UPDATE

Modifica registros existentes.

```sql
UPDATE Alumno
SET Ciudad = 'San Pedro'
WHERE idAlumno = 1;
```

Se pueden modificar varias columnas a la vez:

```sql
UPDATE Alumno
SET Ciudad = 'San Pedro', Edad = 23
WHERE idAlumno = 1;
```

> **Importante:** Siempre usa `WHERE` en un `UPDATE`. Sin él, la instrucción modificará **todos** los registros de la tabla.

---

## DELETE

Elimina registros de una tabla.

```sql
DELETE FROM Alumno
WHERE idAlumno = 3;
```

> **Importante:** Igual que con `UPDATE`, siempre usa `WHERE` en un `DELETE`. Sin él, se eliminarán **todos** los registros de la tabla.

---

## Resumen

| Instrucción | Afecta | ¿Requiere WHERE? |
|-------------|--------|------------------|
| `INSERT` | Agrega filas nuevas | No aplica |
| `SELECT` | Lee filas | Opcional |
| `UPDATE` | Modifica filas existentes | Siempre |
| `DELETE` | Elimina filas existentes | Siempre |
