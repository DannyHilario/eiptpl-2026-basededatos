# DDL: Data Definition Language

## ¿Qué es DDL?

DDL (Data Definition Language) es el subconjunto de SQL que se usa para **definir la estructura** de una base de datos. No manipula datos, sino los contenedores donde esos datos vivirán.

Las instrucciones principales de DDL son:

| Instrucción | ¿Para qué sirve? |
|-------------|------------------|
| `CREATE` | Crear un objeto nuevo (tabla, base de datos, vista, etc.) |
| `ALTER` | Modificar la estructura de un objeto existente |
| `DROP` | Eliminar un objeto |

En este tema nos enfocaremos en `CREATE TABLE`.

---

## CREATE TABLE

`CREATE TABLE` define una nueva tabla indicando su nombre y las columnas que tendrá. Cada columna requiere un nombre y un tipo de dato.

### Sintaxis básica

```sql
CREATE TABLE NombreTabla (
    NombreColumna1 TipoDeDato,
    NombreColumna2 TipoDeDato,
    NombreColumna3 TipoDeDato
);
```

### Ejemplo

```sql
CREATE TABLE Alumno (
    idAlumno INT,
    PrimerApellido VARCHAR(50),
    SegundoApellido VARCHAR(50),
    Nombre VARCHAR(100),
    FechaNacimiento DATE,
    Edad INT,
    CorreoElectronico VARCHAR(100),
    Ciudad VARCHAR(50),
    Sexo CHAR(1)
);
```

---

## Tipos de datos comunes en T-SQL

| Tipo | ¿Qué almacena? | Ejemplo |
|------|----------------|---------|
| `INT` | Números enteros | `1`, `42`, `-10` |
| `DECIMAL(p, s)` | Números con decimales | `DECIMAL(10, 2)` → hasta 10 dígitos, 2 decimales |
| `VARCHAR(n)` | Texto de longitud variable | `VARCHAR(100)` → hasta 100 caracteres |
| `CHAR(n)` | Texto de longitud fija | `CHAR(10)` → siempre 10 caracteres |
| `DATE` | Solo fecha | `2026-03-07` |
| `DATETIME` | Fecha y hora | `2026-03-07 14:30:00` |
| `BIT` | Valor booleano (0 o 1) | `1` = verdadero, `0` = falso |

Para la lista completa y cómo elegir el tipo correcto de cada columna, ver [Tipos de datos en SQL Server](../Etapa-2/04-TiposDeDatos.md).

---

## Restricciones básicas

Las restricciones se agregan a las columnas para controlar qué valores son válidos.

### NOT NULL

Impide que una columna quede vacía. Si no se especifica, la columna acepta valores nulos por defecto.

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL,
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

En este ejemplo `SegundoApellido`, `Edad`, `CorreoElectronico` y `Ciudad` son opcionales; el resto son obligatorios.

### PRIMARY KEY

Identifica de forma única cada fila de la tabla. No puede repetirse ni estar vacía.

```sql
CREATE TABLE Alumno (
    idAlumno INT NOT NULL PRIMARY KEY,
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

### IDENTITY

Hace que SQL Server genere el valor automáticamente, incrementándolo con cada nuevo registro. Se usa junto con `INT` en columnas que son llave primaria.

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

`IDENTITY(1,1)` significa: empieza en 1, incrementa de 1 en 1.

---

## Buenas prácticas

- Define siempre una `PRIMARY KEY` en cada tabla
- Usa `NOT NULL` en todas las columnas que conceptualmente no pueden estar vacías
- Elige el tipo de dato más ajustado a lo que vas a guardar: no uses `VARCHAR(MAX)` para un nombre, ni `DATETIME` si solo necesitas la fecha
