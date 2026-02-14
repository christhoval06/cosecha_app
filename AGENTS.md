# AGENTS.md

Guía de trabajo para agentes que colaboran en `cosecha_app`.

## 1) Objetivo

Mantener el proyecto **modular, legible y seguro para evolucionar** siguiendo la arquitectura actual (`core` / `data` / `features`) y el enfoque local-first con Hive.

## 2) Stack y contexto del proyecto

- Framework: Flutter + Material 3.
- Persistencia local: Hive.
- Configuración de usuario: SharedPreferences.
- i18n: `lib/l10n/*.arb` + `flutter gen-l10n`.
- Navegación: rutas centralizadas en `lib/core/router/app_router.dart`.

## 3) Reglas de arquitectura (obligatorias)

### 3.1 Capas

- `lib/core`: infraestructura transversal (router, theme, servicios, utilidades, widgets compartidos).
- `lib/data`: modelos, setup de Hive y repositorios.
- `lib/features`: casos de uso por módulo, con `screen` + `widgets` y `dashboard` cuando aplique.

### 3.2 Dependencias permitidas

- `core` **no** depende de `features`.
- `data` no depende de UI.
- una `feature` no debe depender directamente de otra `feature` (solo contratos mínimos o navegación por rutas).
- la lógica de agregación/consultas va en `repositories` o `services`, no en la `screen`.

### 3.3 Dashboards configurables (Home / Reports)

Cuando se agreguen widgets de dashboard, respetar este patrón:

1. `registry`: registra `id/title/builder`.
2. `config store`: persiste `enabledWidgetIds` y `orderedWidgetIds`.
3. `customize sheet`: toggles, orden, presets y reset.
4. `panel`: lógica encapsulada por widget.

## 4) Guía de código por tipo

### 4.1 Screens

- Responsabilidad: orquestar estado, filtros globales, navegación y composición.
- Evitar lógica pesada de negocio o agregación en el archivo de screen.
- Si la screen supera complejidad razonable, extraer secciones a `widgets/`.

### 4.2 Widgets

- Reutilizables globales en `lib/core/widgets`.
- Reutilizables de módulo en `lib/features/<feature>/widgets`.
- Evitar hardcode de colores/estilos; usar `Theme.of(context)` y tokens de tema.
- Mantener constructores explícitos y parámetros mínimos necesarios.

### 4.3 Services

- Ubicación: `lib/core/services`.
- Usarlos para lógica transversal (backup, export, sesión, notificaciones, imágenes, reset).
- No meter UI dentro de servicios.
- Diseñar métodos determinísticos, con manejo de errores y mensajes claros para capa UI.

### 4.4 Repositories

- Ubicación: `lib/data/repositories`.
- Son la puerta para consultas de datos y agregaciones (totales, tendencias, breakdowns).
- Deben devolver estructuras listas para consumir por widgets/pantallas.
- Evitar duplicar lógica de consulta entre features.

### 4.5 Models y Hive

- Modelos en `lib/data/models`.
- Configuración de cajas/adapters en `lib/data/hive`.
- Archivos `*.g.dart` son generados: no editar manualmente.
- Si cambian modelos/adapters, regenerar código con `build_runner`.

## 5) i18n, rutas y tema

### 5.1 Internacionalización

- No agregar textos hardcoded en UI.
- Toda etiqueta visible al usuario debe ir en `app_es.arb` / `app_en.arb`.
- Regenerar localizaciones después de cambios.

### 5.2 Navegación

- Centralizar rutas y lectura de argumentos en router.
- Validar tipos de argumentos y manejar casos inválidos con fallback seguro.

### 5.3 Tema y diseño

- Usar tema central en `lib/core/theme/app_theme.dart`.
- Evitar `Colors.*` directo en pantallas (salvo casos justificados y consistentes).
- Conservar consistencia visual (tipografías, radios, spacing, componentes).

## 6) Flujo recomendado para cambios

1. Identificar capa correcta (core/data/feature) antes de editar.
2. Implementar mínimo cambio funcional (sin mezclar refactors grandes no solicitados).
3. Extraer lógica reutilizable si aparece en 2 o más lugares.
4. Verificar que no se rompa el patrón de dashboard/configuración.
5. Ejecutar validaciones técnicas.

## 7) Validaciones técnicas (antes de cerrar)

Ejecutar, según aplique:

```bash
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Si no se ejecuta alguna validación, documentar explícitamente qué faltó y por qué.

## 8) Criterios de aceptación para agentes

Un cambio se considera listo solo si:

- respeta arquitectura por capas y reglas de dependencia;
- no introduce textos hardcoded (si UI cambió);
- no duplica lógica de negocio en widgets/screens;
- mantiene rutas, argumentos y fallbacks seguros;
- pasa análisis/tests o queda documentada la brecha.

## 9) Anti-patrones a evitar

- lógica de reportes compleja dentro de widgets de UI;
- acceso directo a Hive desde screens cuando ya existe repository;
- copiar/pegar widgets similares en vez de extraer componentes;
- romper contratos de configuración de dashboard (ids sin sanear, orden inconsistente);
- mezclar cambios de arquitectura no pedidos en una tarea puntual.

## 10) Convención de respuesta de agentes

Al entregar trabajo, reportar siempre:

1. qué se cambió;
2. en qué archivos;
3. cómo se validó (`analyze`, `test`, etc.);
4. riesgos o pendientes.

