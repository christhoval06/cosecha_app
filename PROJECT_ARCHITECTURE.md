# Project Architecture Reference

## Objetivo

Documentar la arquitectura aplicada en este proyecto para reutilizarla en futuros desarrollos Flutter: modular, mantenible, escalable y con responsabilidades claras por capa.

## Estructura general

```text
lib/
  core/
    constants/
    router/
    services/
    theme/
    utils/
    widgets/
  data/
    hive/
    models/
    repositories/
  features/
    <feature>/
      dashboard/        # registry/config/sheets (si aplica)
      widgets/          # widgets UI y paneles con logica encapsulada
      <feature>_screen.dart
  l10n/
  main.dart
```

## Capa `core`

Responsabilidad: infraestructura compartida de toda la app.

- `constants`: rutas, canales, llaves de prefs, etc.
- `router`: definición centralizada de rutas y navegación.
- `services`: lógica transversal (reset app, backup, export excel, sesión).
- `services/notifications`: programación, payloads y resolución de destinos de notificaciones.
- `theme`: tokens y configuración visual global.
- `utils`: formateadores, fechas, helpers utilitarios.
- `widgets`: componentes reutilizables de múltiples features.

Regla: `core` no depende de `features`.

## Capa `data`

Responsabilidad: acceso y transformación de datos.

- `models`: entidades persistidas (Hive types).
- `hive`: cajas y setup de almacenamiento.
- `repositories`: consultas/agregaciones para UI y reglas de negocio.
- ejemplo nuevo: `ReminderItem` + `ReminderRepository` para recordatorios tipados en Hive.

Patrón aplicado:
- Los `repositories` exponen operaciones listas para consumo (totales, series, top/bottom, breakdowns).
- La UI evita hacer lógica de agregación compleja directamente.

## Capa `features`

Responsabilidad: casos de uso por módulo (home, reports, settings, transactions, etc).

Cada feature contiene:
- `screen`: orquestación de estado y composición.
- `widgets`: bloques de UI reutilizables dentro de la feature.
- `dashboard` (opcional): para pantallas configurables por usuario.

### Patrón de dashboards

Se aplicó en `home` y `reports`.

Partes:
1. `registry`
- Define widgets disponibles (`id`, `title`, `builder`).
- Sin lógica pesada de UI/datos.

2. `config store`
- Persiste `enabledWidgetIds` + `orderedWidgetIds`.
- Sanitiza ids desconocidos/duplicados.

3. `customize sheet`
- Toggle/reorder/reset/presets.
- Devuelve nueva config.

4. `panels`
- Cada widget gestiona su lógica y render.
- Recibe el mínimo contexto/filtros necesario.

Beneficio:
- Mantenimiento simple: agregar widget no rompe la screen.
- Reutilización alta y menor acoplamiento.

## Principios de separación usados

1. Screen como orquestador, no como “todo-en-uno”.
2. Widgets autosuficientes para su lógica visual/funcional.
3. Servicios/repositories compartidos para evitar duplicación.
4. Configuración persistida para preferencias de usuario.
5. i18n obligatoria para textos (`arb` + `gen-l10n`).
6. Navegación con rutas constantes centralizadas.
7. Destinos de notificación centralizados en un registry (`ReminderDestinations`) para evitar rutas hardcodeadas en UI/servicios.

## Ejemplo de flujo (Reports)

1. `ReportsScreen` arma filtros globales.
2. Lee layout desde config store.
3. Recorre `registry` y renderiza widgets habilitados.
4. Cada panel consume repositorio con filtros.
5. Personalización se guarda y reaplica automáticamente.

## Exportación Excel (patrón reutilizable)

Implementación actual:
- Servicio central: `core/services/excel_export_service.dart`
- UI compartida: `core/widgets/excel_export_config_sheet.dart`
- Reuso en:
  - `features/reports`
  - `features/settings`

Modelo:
- Config global de export (modelos/campos).
- Default: exportar todo.
- Persistencia con `SharedPreferences`.

## Convenciones recomendadas para futuros proyectos

1. Agregar feature nueva:
- Crear carpeta en `features/<feature>/`.
- Mantener `screen + widgets` desde el inicio.

2. Si una pantalla crece:
- Extraer paneles/secciones a `widgets/`.
- Mantener en screen solo estado, navegación y composición.

3. Si hay preferencia de usuario:
- Crear `config store` en la feature.
- Persistir en `SharedPreferences`.

4. Si una lógica se reutiliza en 2+ módulos:
- Moverla a `core/services` o `data/repositories`.

5. Evitar acoplamiento:
- `features` no deberían depender entre sí directamente salvo navegación/contratos mínimos.

## Checklist rápido de calidad

- [ ] Textos en i18n (no hardcoded).
- [ ] Colores desde tema (no direct `Colors.*` en UI).
- [ ] Lógica de datos en repository/service.
- [ ] Widgets grandes extraídos a archivos dedicados.
- [ ] `flutter analyze` limpio antes de cerrar cambios.
