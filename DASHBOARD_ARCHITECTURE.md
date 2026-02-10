# Dashboard Architecture (Reference)

## Objetivo

Definir un sistema de dashboard modular, configurable y mantenible, donde cada widget encapsula su logica y la pantalla solo orquesta layout + filtros globales.

## Principios

- `Registry-first`: un registro central define widgets disponibles.
- `Configurable`: el usuario puede habilitar/deshabilitar y reordenar widgets.
- `Persistente`: la configuracion se guarda en `SharedPreferences`.
- `Decoupled`: UI de paneles separada del `registry`.
- `Minimal inputs`: cada panel recibe solo lo necesario (ej: `filters`).

## Estructura recomendada

```text
features/<module>/
  <module>_screen.dart
  dashboard/
    <module>_dashboard_registry.dart
    <module>_dashboard_config.dart
    <module>_dashboard_customize_sheet.dart
    <module>_filters.dart            # opcional
  widgets/
    <module>_dashboard_panels.dart   # implementacion de paneles
    ... widgets atomicos compartidos
```

## Componentes clave

### 1) Registry

Archivo: `dashboard/<module>_dashboard_registry.dart`

Responsabilidad:
- Declarar `WidgetDef` con:
  - `id`
  - `title(l10n)`
  - `builder(...)`
- Exponer lista ordenada de widgets disponibles.

Regla:
- Sin logica de negocio dentro del registry.

### 2) Config Store

Archivo: `dashboard/<module>_dashboard_config.dart`

Responsabilidad:
- Cargar/guardar:
  - `enabledWidgetIds`
  - `orderedWidgetIds`
- Sanitizar ids desconocidos/duplicados.

Persistencia:
- `SharedPreferences` con keys por modulo.

### 3) Customize Sheet

Archivo: `dashboard/<module>_dashboard_customize_sheet.dart`

Responsabilidad:
- Permitir:
  - `toggle` de widgets
  - `reorder` (drag/drop)
  - `reset`
  - presets opcionales (`Basico`, `Comercial`, `Analitico`)

Salida:
- Devuelve nuevo `DashboardConfig`.

### 4) Paneles de dashboard

Archivo: `widgets/<module>_dashboard_panels.dart`

Responsabilidad:
- Implementar cada widget/panel.
- Encapsular logica visual + calculos del panel.
- Recibir solo datos/filtros minimos.

Regla:
- Evitar que la pantalla crezca con logica interna de paneles.

### 5) Screen (orquestador)

Archivo: `<module>_screen.dart`

Responsabilidad:
- Cargar layout (`configStore.load(...)`).
- Construir widgets habilitados en el orden configurado.
- Abrir customize sheet y persistir cambios.
- Proveer filtros globales si aplica (ej: rango de fechas).

## Flujo de render

1. Screen carga `registry`.
2. Screen carga `config` persistida.
3. Screen mapea `ordered + enabled` -> `WidgetDef`.
4. Screen renderiza `def.builder(...)`.
5. Usuario personaliza en sheet.
6. Screen guarda config y refresca.

## Contratos recomendados

- IDs estables:
  - nunca reutilizar ids para otro widget.
- Builders tipados:
  - Home: `WidgetBuilder`
  - Reports: `Widget Function(ReportFilters filters)`
- Filtros inmutables:
  - usar clases `Filters` pequeñas y claras.

## Escalabilidad

- Agregar widget nuevo:
  1. Implementar panel en `widgets/..._panels.dart`
  2. Registrar `id/title/builder` en registry
  3. Agregar key i18n para title/textos
  4. (Opcional) incluir en presets

- Versionar layout:
  - mantener sanitizacion en config para soportar ids nuevos/eliminados sin romper UI.

## Buenas practicas aplicadas

- Tema visual via `Theme.of(context).colorScheme`.
- Nada hardcoded en textos: usar `l10n`.
- Widget self-contained + reusable.
- `Screen` como capa de composicion, no de implementacion de paneles.
