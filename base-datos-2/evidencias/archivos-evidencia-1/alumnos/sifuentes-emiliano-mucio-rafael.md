# Ejercicio de Evidencia 1: `vw_BitacoraRecetaDetalle`

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)
**Objeto a crear:** Vista `vw_BitacoraRecetaDetalle`

## Contexto

`BitacoraEstatusReceta` guarda el historial de transiciones de una receta, pero solo con el id del estatus (`idEstatusReceta`), no su nombre. Para leer ese historial en un lenguaje humano ("la receta 8 pasó a 'Surtida' el día tal"), hay que cruzarlo contra `EstatusReceta`. Tu vista deja ese cruce ya resuelto.

> Nota: la tabla `BitacoraEstatusReceta` se instala **vacía** — la va llenando [`usp_cambiarEstatusReceta`](../../../sesiones/sesion-7/HospitalDB/docs/procedimientos/usp_cambiarEstatusReceta.md) cada vez que alguien cambia el estatus de una receta. Para ver tu vista con datos, primero tendrás que ejecutar ese SP un par de veces (ver los casos de prueba).

## Tu tarea

Crea una vista llamada exactamente `vw_BitacoraRecetaDetalle` que una `BitacoraEstatusReceta` con `EstatusReceta`, mostrando el nombre del estatus en lugar de su id.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_BitacoraRecetaDetalle`.
- [ ] Muestra `idBitacoraEstatusReceta` e `idReceta` (de `BitacoraEstatusReceta`, tal cual).
- [ ] Muestra `NombreEstatus`: el valor de `EstatusReceta.Nombre` correspondiente a esa transición (no el id).
- [ ] Muestra `Fecha`: el valor de `BitacoraEstatusReceta.Fecha` (cuándo ocurrió esa transición).
- [ ] Une `BitacoraEstatusReceta` con `EstatusReceta` por `idEstatusReceta`.
- [ ] Muestra **una fila por cada transición registrada**, sin filtrar por receta ni por estatus.

## Ejemplo de salida esperada

La tabla nace vacía, así que este es un ejemplo de cómo se vería **después** de correr un par de transiciones de prueba (ver abajo) sobre la receta 1, que empieza en estatus `1 Creada`:

| idBitacoraEstatusReceta | idReceta | NombreEstatus | Fecha |
|---|---|---|---|
| 1 | 1 | En atención | *(la fecha/hora en que ejecutaste la prueba)* |
| 2 | 1 | Surtida | *(la fecha/hora en que ejecutaste la prueba)* |

## Casos de prueba sugeridos

```sql
-- Genera un par de transiciones de prueba sobre la receta 1 (empieza en estatus 1 Creada)
EXEC usp_cambiarEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 2  -- pasa a "En atención"
EXEC usp_cambiarEstatusReceta @p_idReceta = 1, @p_idEstatusNuevo = 3  -- pasa a "Surtida"

-- Ahora sí, consulta tu vista
SELECT * FROM vw_BitacoraRecetaDetalle WHERE idReceta = 1
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_SifuentesEmilianoMucioRafael_2212513.txt
```
