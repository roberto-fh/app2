# CLAUDE.md — Guía de desarrollo para app2

## Contexto del proyecto

App del desafío **1 month 1 app** — mes 2. El objetivo es lanzar una app funcional tanto en **Android** como en **iOS** al final del mes. Priorizamos velocidad de entrega sin sacrificar calidad esencial.

---

## Principios de Vibe Coding

1. **Describe el qué, no el cómo.** Explica la intención, Claude decide la implementación.
2. **Itera en pequeños pasos.** Una feature a la vez.
3. **Revisa antes de seguir.** Lee y entiende el código generado antes de pedir lo siguiente.
4. **No acumules deuda técnica a ciegas.** Si algo se hace rápido y sucio, documentarlo.
5. **El contexto importa.** Proporciona siempre el archivo relevante antes de pedir cambios.

---

## Stack tecnológico

- **Plataforma:** iOS + Android (cross-platform)
- **Framework:** Flutter
- **Lenguaje:** Dart
- **UI:** Flutter Widgets + Material 3
- **Arquitectura:** MVVM con Riverpod
- **Backend:** Supabase (supabase_flutter)
- **HTTP:** Dio
- **Navegación:** go_router
- **Persistencia local:** shared_preferences
- **Mínimo SDK Android:** API 21 (Android 5.0)
- **Mínimo iOS:** 13.0

---

## Dependencias principales (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x
  go_router: ^14.x
  dio: ^5.x
  supabase_flutter: ^2.x
  shared_preferences: ^2.x

dev_dependencies:
  riverpod_generator: ^2.x
  build_runner: ^2.x
```

---

## Estructura de paquetes

```
lib/
  main.dart
  app.dart
  core/
    theme/
    constants/
    router/
  data/
    remote/
    local/
    repository/
  domain/
    model/
    usecase/
  presentation/
    screens/
    widgets/
  providers/          ← Riverpod providers (equivalente a ViewModels)
```

---

## Convenciones de código

### Nombrado
- Clases: `PascalCase`
- Funciones, variables, parámetros: `camelCase`
- Constantes: `kConstantName` (convención Flutter)
- Archivos: `snake_case.dart`
- Widgets: `PascalCase`, un widget principal por archivo

### Widgets
- Siempre recibir estado como parámetro, nunca leer providers dentro de widgets hoja
- Separar lógica de presentación: Screen (con ConsumerWidget) vs widgets reutilizables (sin providers)

```dart
// Bien
class SearchScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProvider);
    return SearchContent(state: state, onSearch: ref.read(searchProvider.notifier).search);
  }
}

class SearchContent extends StatelessWidget {
  const SearchContent({required this.state, required this.onSearch});
  // solo presentación
}
```

### Providers (Riverpod)
- Un `AsyncValue<T>` o `StateNotifier` por screen
- Usar `@riverpod` con code generation siempre que sea posible
- No referenciar `BuildContext` dentro de providers

### Repositorios
- Devolver `AsyncValue<T>` o `Either<Failure, T>` para manejo de errores
- Las llamadas de red siempre en providers asíncronos

---

## Reglas de calidad (no negociables)

1. **Sin crashes en el happy path.**
2. **Sin strings hardcodeados en la UI.** Usar constantes o `l10n`.
3. **Sin lógica en widgets.** Solo presentación.
4. **Manejo explícito de estados de carga y error.** Toda operación async tiene loading, success, error.
5. **No comentar código muerto.** Borrar, no comentar.

---

## Flujo de desarrollo

1. **Feature branch** por cada funcionalidad: `feature/<nombre>`
2. Commit atómico por cada cambio funcional
3. Mensaje de commit en español, imperativo: `Agrega pantalla de login`
4. Merge a `main` cuando la feature esté lista

---

## Seguridad de API keys

Siempre en variables de entorno o archivo no commiteado (ej. `.env` + `flutter_dotenv`), nunca hardcodeadas.

---

## Publicación

### Android (Play Store)
- Generar AAB: `flutter build appbundle --release`
- Firma configurada en `android/key.properties` (no en git)

### iOS (App Store)
- Requiere Mac con Xcode para firma y subida
- Generar IPA: `flutter build ipa`
- Subir con Xcode o Transporter

---

## Lo que Claude debe evitar

- No agregar dependencias innecesarias sin justificar
- No sobre-abstraer para un solo uso
- No reescribir código que no fue pedido
- No añadir comentarios obvios
- No usar `var` si el tipo es inferible y claro

## Lo que Claude debe hacer siempre

- Preguntar si hay duda sobre el alcance antes de escribir código
- Proponer la solución más simple que resuelva el problema
- Indicar si una decisión puede generar deuda técnica
- Mantener consistencia con el estilo existente
