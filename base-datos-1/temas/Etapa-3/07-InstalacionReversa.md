# Paquete de instalación y paquete de reversa

## ¿Qué son?

Una base de datos no se entrega como "la hice en mi computadora". Se entrega como un conjunto de **scripts** que cualquier persona puede ejecutar, en orden, para construirla desde cero en otro servidor.

| Paquete | Qué hace |
|---------|----------|
| **Instalación** | Crea la base de datos, sus tablas y sus datos iniciales |
| **Reversa** | Elimina **todo** lo que creó la instalación, y deja el servidor como estaba |

Juntos permiten instalar, probar, desinstalar y volver a instalar cuantas veces haga falta.

---

## Paquete de instalación

### Un script por paso, numerado

Cada script hace **una sola cosa**, y su nombre empieza con un número que dice en qué orden se ejecuta:

```
instalacion/
├── 01-create-database.sql
├── 02-create-table-cliente.sql
├── 03-create-table-producto.sql
├── 04-create-table-venta.sql
├── 05-insert-cliente.sql
├── 06-insert-producto.sql
└── 07-insert-venta.sql
```

### El orden: primero los padres

| Paso | Regla | Por qué |
|------|-------|---------|
| 1 | Crear la base de datos | Todo lo demás vive dentro de ella |
| 2 | Crear las tablas **padre** antes que las **hijas** | Una llave foránea no puede apuntar a una tabla que todavía no existe |
| 3 | Insertar en las tablas **padre** antes que en las **hijas** | Una venta del cliente 3 no puede registrarse si el cliente 3 todavía no existe |

> **Tabla padre:** la que es referenciada (`Cliente`). **Tabla hija:** la que tiene la llave foránea (`Venta`, con `idCliente`). Los catálogos y las tablas sin llaves foráneas van primero; la tabla de la operación, que apunta a todas, va al final.

### Cómo se ve cada script

```sql
-- Tema:        TecnoShop
-- Descripción: Crear tabla Venta
-- Autor:       Rosa Leal

USE TecnoShopDB;

CREATE TABLE Venta (
    idVenta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idProducto INT NOT NULL,
    FechaVenta DATE NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Venta_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_Venta_Producto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    CONSTRAINT chk_Venta_Cantidad CHECK (Cantidad > 0)
);
```

- **Cabecera** con tema, descripción y autor.
- **`USE TecnoShopDB;`** al inicio, para que el script se ejecute sobre la base correcta sin depender del menú desplegable de SSMS. Lo llevan todos, excepto el que crea la base de datos (todavía no existe) y el que la elimina.
- Los `INSERT` **siempre** mencionan las columnas: `INSERT INTO Cliente (Nombre, Ciudad) VALUES (…)`.

---

## Paquete de reversa

Deshace la instalación **en orden inverso**:

```
reversa/
├── 01-drop-tables.sql
└── 02-drop-database.sql
```

### 01-drop-tables.sql

Elimina las tablas empezando por las **hijas**, porque una tabla padre no se puede eliminar mientras una hija la referencie (ver [Modificar y eliminar estructuras](05-ModificarEstructura.md)):

```sql
-- Tema:        TecnoShop - Reversa
-- Descripción: Eliminar tablas en orden inverso a las llaves foráneas
-- Autor:       Rosa Leal

USE TecnoShopDB;

-- Paso 1: Venta primero — depende de Cliente y de Producto
DROP TABLE IF EXISTS Venta;

-- Paso 2: Producto — ya no tiene dependientes tras eliminar Venta
DROP TABLE IF EXISTS Producto;

-- Paso 3: Cliente — ya no tiene dependientes tras eliminar Venta
DROP TABLE IF EXISTS Cliente;
```

### 02-drop-database.sql

```sql
-- Tema:        TecnoShop - Reversa
-- Descripción: Eliminar la base de datos TecnoShopDB
-- Autor:       Rosa Leal

DROP DATABASE IF EXISTS TecnoShopDB;
```

> Antes de ejecutar este script, selecciona **otra** base de datos en el menú desplegable de SSMS (por ejemplo, `master`): no se puede eliminar la base de datos a la que estás conectado.

---

## El plan de instalación y el plan de reversa

El **plan** es una tabla que documenta cada script: en qué orden va y qué hace. Sirve para que otra persona pueda instalar sin adivinar.

| Orden | Script | Descripción |
|-------|--------|-------------|
| 1 | `01-create-database.sql` | Crea la base de datos `TecnoShopDB` |
| 2 | `02-create-table-cliente.sql` | Crea la tabla `Cliente` |
| 3 | `03-create-table-producto.sql` | Crea la tabla `Producto` |
| 4 | `04-create-table-venta.sql` | Crea la tabla `Venta`, con llaves foráneas a `Cliente` y a `Producto` |
| … | … | … |

---

## Cómo probar tu paquete

Un paquete funciona cuando **otra persona** puede ejecutarlo sin ayuda. Pruébalo así, en este orden:

1. Ejecuta **toda la instalación**, script por script, en orden. Ninguno debe marcar error.
2. Ejecuta tus consultas y revisa que regresen lo esperado.
3. Ejecuta **toda la reversa**. La base de datos debe desaparecer.
4. Ejecuta **otra vez toda la instalación**. Debe funcionar igual que la primera vez.

Si el paso 4 falla, la reversa dejó algo sin borrar.

---

## Errores comunes

| Error | Por qué pasa | Solución |
|-------|--------------|----------|
| `Foreign key '…' references invalid table '…'` | Se creó una tabla hija antes que su padre | Renumera los scripts: padres primero |
| `The INSERT statement conflicted with the FOREIGN KEY constraint` | Se insertó en una tabla hija antes que en su padre, o con un id que no existe | Inserta primero en los padres y revisa los id |
| `Could not drop object … referenced by a FOREIGN KEY constraint` | En la reversa, se eliminó un padre antes que su hija | Elimina primero las hijas |
| `Cannot drop database … because it is currently in use` | Estás conectado a la base que quieres eliminar | Selecciona `master` antes del script |
| `There is already an object named … in the database` | Se ejecutó la instalación dos veces sin la reversa | Ejecuta la reversa y vuelve a instalar |
| El script crea la tabla en `master` | Faltó `USE` y estaba seleccionada otra base | Agrega `USE TuBaseDB;` al inicio |
