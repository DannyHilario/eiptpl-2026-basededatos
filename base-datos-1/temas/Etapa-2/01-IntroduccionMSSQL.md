# Introducción a Microsoft SQL Server

## ¿Qué es SQL Server?

Microsoft SQL Server es un sistema de gestión de bases de datos relacionales (RDBMS) desarrollado por Microsoft. Permite almacenar, organizar y recuperar datos estructurados mediante el lenguaje **T-SQL** (Transact-SQL), que es la implementación de SQL de Microsoft.

Es ampliamente utilizado en entornos empresariales para aplicaciones que requieren persistencia de datos, desde sistemas de ventas hasta plataformas de análisis.

---

## Conceptos Clave

### Base de Datos
Colección organizada de datos relacionados. En SQL Server, cada base de datos es un contenedor independiente con sus propias tablas, vistas, procedimientos y usuarios.

### Tabla
Estructura que organiza los datos en filas (registros) y columnas (atributos). Es la unidad básica de almacenamiento.

### T-SQL (Transact-SQL)
Extensión de SQL desarrollada por Microsoft. Añade sobre el estándar SQL características como variables, estructuras de control de flujo (`IF`, `WHILE`) y manejo de errores (`TRY...CATCH`).

---

## Ediciones de SQL Server

| Edición | Uso típico |
|---------|------------|
| **Express** | Aprendizaje y aplicaciones pequeñas. Gratuita, límite de 10 GB por base de datos |
| **Developer** | Desarrollo y pruebas. Gratuita, todas las características de Enterprise |
| **Standard** | Empresas medianas |
| **Enterprise** | Grandes empresas, máximo rendimiento y disponibilidad |

> Para este curso usaremos **SQL Server Express** o **Developer**.

---

## Herramientas

### SQL Server Management Studio (SSMS)
Es la herramienta oficial de Microsoft para trabajar con SQL Server. Desde aquí escribirás y ejecutarás tus consultas, crearás tablas y administrarás tus bases de datos. Es la herramienta que usaremos durante todo el curso.

---

## Primera Conexión

Al abrir SSMS por primera vez, aparecerá una ventana pidiendo conectarse a un servidor. Para conectarte a tu instalación local:

- **Server name**: escribe el nombre de tu computadora. Si no lo sabes, puedes consultarlo en *Panel de Control → Sistema*. En una instalación default del SQL Server, ya estará escrito inicialmente.
- **Authentication**: selecciona **Windows Authentication**. Esta opción usa tu sesión de Windows actual para identificarte, sin necesidad de usuario ni contraseña adicionales.

Haz clic en **Connect** y estarás dentro.

---

## Ejercicio

Conéctate a tu instancia local de SQL Server y ejecuta:

```sql
SELECT @@VERSION;
```

Esto devuelve la versión instalada de SQL Server. Anota qué edición y versión tienes.
