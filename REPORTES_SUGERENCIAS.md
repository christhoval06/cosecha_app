# Sugerencias Para Reportes

## Estado de implementacion

- [x] Comparativos de periodo
  Implementado para ventas, transacciones y ticket promedio (rango actual vs anterior).
- [x] Top y bottom productos
  Implementado en widgets separados para mejor/menor desempeno.
- [x] Desglose por canal
  Implementado como `mix por canal` con participacion y monto por canal.
- [x] Estacionalidad (base)
  Implementado con `heatmap diario` y `ventas mensuales (ultimos 6 meses)`.
- [ ] Margen bruto estimado
  Pendiente (requiere costo por producto).
- [ ] Cohorte de productos nuevos
  Pendiente.
- [x] Filtros avanzados (base)
  Implementado con `canal`, `producto`, `monto minimo/maximo` y `cantidad minima`, aplicados a todo el dashboard.
- [x] Presets de visualizacion
  Implementado en personalizacion de dashboard (`Basico`, `Comercial`, `Analitico`).
- [ ] Exportes utiles (CSV/PDF + metadata)
  Pendiente.
- [ ] Deteccion de anomalias
  Pendiente.
- [ ] Proyeccion simple
  Pendiente.

## Ideas de producto

1. Comparativos de periodo
- Actual vs anterior (semana/mes) para ventas, ticket y transacciones.
- Reusar base de `changePercent` para todas las metricas.

2. Margen bruto estimado
- Si se agrega costo por producto, mostrar margen y no solo ingresos.
- KPI mas util para decisiones de precio.

3. Top y bottom productos
- Incluir productos con mejor y peor desempeno.
- Agregar sugerencias de accion automatica.

4. Desglose por canal
- Participacion y tendencia Minorista/Mayorista.
- Permite detectar cambios de mix y dependencia.

5. Estacionalidad
- Heatmap mensual + barras por dia de semana/hora.
- Util para plan de inventario y operacion.

6. Cohorte de productos nuevos
- Rendimiento de productos agregados en ultimos 30/60 dias.
- Mide efectividad de catalogo nuevo.

7. Filtros avanzados
- Canal, producto, rango monto, cantidad y estado.
- Guardar presets para consultas frecuentes.

8. Exportes utiles
- XLSX + CSV + PDF ejecutivo.
- Incluir metadata de filtros aplicados.

9. Deteccion de anomalias
- Alertas por caidas fuertes, picos atipicos o periodos sin ventas.
- Resaltar automaticamente en el panel.

10. Proyeccion simple
- Forecast corto (7/30 dias) con promedio movil.
- Soporte para decisiones de compra.

## Prioridad recomendada (impacto vs esfuerzo)

1. Comparativos de periodo por metrica
2. Desglose por canal
3. Top y bottom productos
4. Exportes con filtros incluidos
