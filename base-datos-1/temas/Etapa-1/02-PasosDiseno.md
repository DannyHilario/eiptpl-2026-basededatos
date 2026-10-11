# Pasos para diseñar una base de datos

## Por qué diseñar antes de crear

Usar SQL Server no garantiza una buena base de datos. Una tabla mal pensada repite información, permite datos contradictorios o no deja responder las preguntas del negocio. Por eso, antes de escribir un solo `CREATE TABLE`, se **diseña**.

El diseño pasa por cuatro fases:

```
  Problema real        Análisis          Diseño           Diseño           Diseño
  (el negocio)   ──►  (¿qué se    ──►   conceptual  ──►  lógico     ──►   físico
                      necesita?)        (entidades y     (tablas,         (CREATE TABLE
                                        relaciones)      llaves,          en SQL Server)
                                                         normalización)
```

---

## 1. Análisis

Se averigua **para qué** sirve la base de datos y **qué información** debe guardar.

- Se platica con quienes usarán el sistema: el dueño, los empleados.
- Se identifican las **preguntas** que la base de datos debe responder: *"¿qué clientes nunca han regresado?"*, *"¿cuánto se cobró en marzo?"*.
- Se anotan las **reglas del negocio**: *"un cliente se registra en una sola sucursal"*, *"no puede haber dos clientes con el mismo teléfono"*.

El resultado es una descripción clara del negocio. En la Evidencia Integral, **esta fase ya viene hecha**: es tu caso.

---

## 2. Diseño conceptual

Se identifican las **entidades** (las "cosas" del negocio sobre las que se guarda información), sus **atributos** y cómo se **relacionan**. Se representa con un diagrama Entidad-Relación (ver [Modelo Entidad-Relación](05-ModeloEntidadRelacion.md)).

Recomendaciones del manual para elegir los campos:

- **Cada campo describe directamente el tema de su tabla.** Si un campo describe otra cosa, pertenece a otra tabla: la dirección de la sucursal no va en la tabla de clientes.
- **Incluye toda la información necesaria.** Revisa que cada pregunta del negocio se pueda responder con lo que guardas.
- **Guarda la información en sus partes más pequeñas.** Es más útil `Nombre` y `PrimerApellido` por separado que un solo campo con todo junto.

---

## 3. Diseño lógico

El diseño conceptual se convierte en **tablas**: cada tabla con sus columnas, su llave primaria y sus llaves foráneas. Aquí se aplica la **normalización** (ver [Normalización](04-Normalizacion.md)) para eliminar la información repetida.

El resultado es el **modelo relacional**: el diagrama de tablas que en la Evidencia Integral haces en dbdiagram.io (ver [Guía rápida de dbdiagram.io](08-dbdiagram.md)).

---

## 4. Diseño físico

El modelo relacional se implementa en un SGBD concreto: se eligen los **tipos de datos** de SQL Server (ver [Tipos de datos](../Etapa-2/04-TiposDeDatos.md)) y las **restricciones**, y se escriben los scripts `CREATE TABLE`.

---

## Cualidades de un buen diseño

Según el manual, un buen diseño:

- Refleja la estructura del problema en el mundo real.
- Puede representar todos los datos esperados, **incluso con el paso del tiempo**.
- Evita guardar información redundante.
- Mantiene la integridad de los datos a lo largo del tiempo.
- Revisa con detalle los tipos de datos.
- Es claro, coherente y fácil de entender.

> "Incluso con el paso del tiempo" es literal: si un precio cambia, la base de datos debe seguir sabiendo cuánto se cobró antes del cambio. Ver *Datos que cambian con el tiempo* en [Del negocio al modelo](07-DelNegocioAlModelo.md).

---

## Resumen

| Fase | Pregunta que responde | Resultado |
|------|-----------------------|-----------|
| Análisis | ¿Qué necesita el negocio? | Descripción, reglas y preguntas |
| Conceptual | ¿Qué "cosas" hay y cómo se relacionan? | Diagrama Entidad-Relación |
| Lógico | ¿Qué tablas, columnas y llaves? | Modelo relacional normalizado |
| Físico | ¿Cómo se crea en SQL Server? | Scripts `CREATE TABLE` |
