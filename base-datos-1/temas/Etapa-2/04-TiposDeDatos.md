# Tipos de datos en SQL Server

## ¿Qué es un tipo de dato?

El **tipo de dato** de una columna define **qué valores** puede guardar, **qué operaciones** se pueden hacer con ella y **cuánto espacio** ocupa. Elegirlo bien evita errores: si `Precio` es un número, SQL Server rechaza que alguien escriba `'cien pesos'`.

Los tipos se agrupan en cinco familias: numéricos, de caracteres, de fecha y hora, lógicos y binarios.

---

## Numéricos

### Enteros (sin decimales)

| Tipo | Rango | Espacio | Úsalo para |
|------|-------|---------|------------|
| `TINYINT` | 0 a 255 | 1 byte | Valores pequeños y nunca negativos: número de piso |
| `SMALLINT` | -32,768 a 32,767 | 2 bytes | Cantidades medianas: año, cupo |
| `INT` | ±2,147 millones | 4 bytes | **Llaves primarias y foráneas**, cantidades en general |
| `BIGINT` | ±9 trillones | 8 bytes | Números enormes (rara vez en este curso) |

### Con decimales exactos

| Tipo | Ejemplo | Úsalo para |
|------|---------|------------|
| `DECIMAL(p, s)` | `DECIMAL(10,2)` → hasta 10 dígitos, 2 de ellos decimales: `99999999.99` | **Dinero**, kilos, medidas: todo lo que deba ser exacto |
| `NUMERIC(p, s)` | Igual que `DECIMAL` | Es exactamente el mismo tipo |
| `MONEY` | `MONEY` | Dinero, con 4 decimales fijos |

- `p` (**precisión**) es el total de dígitos, y `s` (**escala**) cuántos de ellos van después del punto.
- `DECIMAL(5,2)` acepta hasta `999.99`; un valor de `1000.00` no cabe y SQL Server marca error.

### Con decimales aproximados

| Tipo | Úsalo para |
|------|------------|
| `FLOAT`, `REAL` | Cálculos científicos donde un error mínimo no importa |

> **Para dinero, nunca `FLOAT`.** `FLOAT` guarda una **aproximación**: `0.1 + 0.2` puede dar `0.30000000000000004`. En una tienda, esos centavos de más o de menos se acumulan. Usa `DECIMAL(10,2)`.

---

## De caracteres (texto)

| Tipo | Cómo guarda | Úsalo para |
|------|-------------|------------|
| `CHAR(n)` | **Siempre** `n` caracteres; si el texto es más corto, rellena con espacios | Textos de **largo fijo**: CURP (18), RFC (13), clave de 3 letras |
| `VARCHAR(n)` | Solo los caracteres que tiene el texto, hasta `n` | **Casi todo el texto**: nombres, direcciones, correos |
| `VARCHAR(MAX)` | Texto muy largo (hasta 2 GB) | Comentarios o descripciones largas |

- Los textos se escriben entre **comillas simples**: `'Marcela Rivas'`.
- El manual menciona `TEXT`. Es un tipo antiguo; hoy se usa `VARCHAR(MAX)` en su lugar.

> **¿Teléfono como número?** No. Un teléfono **no se suma ni se multiplica**, puede empezar con `0` (que un número borraría) y puede llevar lada o `+52`. Todo lo que es un **código** y no una **cantidad** va como texto: teléfono, código postal, número de serie, matrícula.

---

## De fecha y hora

| Tipo | Guarda | Ejemplo | Úsalo para |
|------|--------|---------|------------|
| `DATE` | Solo la fecha | `'2026-03-14'` | Fecha de nacimiento, fecha de registro, fecha de un pedido |
| `DATETIME` | Fecha y hora | `'2026-03-14 16:45:00'` | Cuando importa la hora exacta: entrada a un estacionamiento |
| `SMALLDATETIME` | Fecha y hora, sin segundos y con menor rango (1900-2079) | `'2026-03-14 16:45'` | Igual que `DATETIME`, ocupando menos espacio |

- Escribe las fechas como `'AAAA-MM-DD'` (`'2026-03-14'`): SQL Server las entiende igual sin importar el idioma de la computadora. Un formato como `'03/04/26'` es ambiguo: ¿3 de abril o 4 de marzo?
- El manual dice que SQL Server no tiene un tipo solo para fechas. Eso era cierto en versiones antiguas: **desde SQL Server 2008 existe `DATE`**, y es el que se usa cuando la hora no importa.

---

## Lógico

| Tipo | Valores | Úsalo para |
|------|---------|------------|
| `BIT` | `0` o `1` | Sí/no: `Activo`, `Pagado`, `EsCargo` |

`1` significa verdadero y `0` falso. Un `BIT` no lleva comillas: `Activo = 1`.

---

## Binarios

El manual menciona `IMAGE` para guardar imágenes y archivos. En la práctica, las imágenes se guardan como archivos fuera de la base de datos, y la tabla guarda solo su ruta en un `VARCHAR`. En este curso no se usan.

---

## Cómo elegir: guía rápida

| El dato es… | Tipo | Ejemplo |
|-------------|------|---------|
| Llave primaria o foránea | `INT` | `idCliente INT` |
| Nombre, dirección, correo | `VARCHAR(n)` | `Nombre VARCHAR(100)` |
| Código de largo fijo | `CHAR(n)` | `CURP CHAR(18)` |
| Teléfono, código postal, número de serie | `VARCHAR(n)` | `Telefono VARCHAR(15)` |
| Dinero | `DECIMAL(10,2)` | `Precio DECIMAL(10,2)` |
| Cantidad con decimales (kilos, litros) | `DECIMAL(p,s)` | `Kilos DECIMAL(5,2)` |
| Cantidad entera (piezas, horas, cupo) | `INT` | `Cantidad INT` |
| Fecha sin hora | `DATE` | `FechaRegistro DATE` |
| Fecha con hora | `DATETIME` | `FechaEntrada DATETIME` |
| Sí / no | `BIT` | `Activo BIT` |

> Elige el largo de los `VARCHAR` pensando en el dato real: `VARCHAR(100)` para un nombre completo, `VARCHAR(15)` para un teléfono. Un `VARCHAR(10)` para un correo electrónico se quedará corto.
