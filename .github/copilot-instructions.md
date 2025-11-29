## Purpose
Short, actionable guidance for AI coding agents working on this Flutter app.

## Project overview
- **Type:** Flutter multi-platform app (Android, iOS, macOS, Windows, Linux, Web).
- **Top-level layout:** `lib/` contains the app UI; `android/`, `ios/`, `windows/`, `macos/`, `linux/` contain platform projects.
- **Single-screen example:** `lib/main.dart` implements `TiltGame` (a `StatefulWidget`) and uses `sensors_plus` to read accelerometer events.

## Key files to inspect
- `lib/main.dart` — main app + examples of lifecycle and stream handling (`initState`, `dispose`).
- `pubspec.yaml` — dependencies (e.g. `sensors_plus`), SDK constraint, and flutter settings.
- `analysis_options.yaml` — lint rules used by the project (follow these when editing).
- `test/widget_test.dart` — existing test scaffold; run `flutter test` to execute.

## Build / run / test commands
- Install deps: `flutter pub get`
- Run app: `flutter run -d <deviceId>` (common: `-d windows`, `-d chrome`, or an Android/iOS device)
- Build release APK: `flutter build apk`
- Build iOS (macOS + Xcode required): `flutter build ios`
- Run tests: `flutter test`
- Static analysis: `flutter analyze`
- Format code: `dart format .`

Notes: after changing native plugins or `pubspec.yaml`, stop the running app and run `flutter pub get` then restart (hot reload won't register native plugin changes).

## Project-specific conventions & patterns
- Null-safety is used (Dart SDK constraint in `pubspec.yaml`); follow null-safe patterns.
- Streams and device sensors: keep subscriptions in `State` objects and cancel in `dispose()` to avoid leaks. Example pattern in `lib/main.dart`:
  - subscribe in `initState()` with `accelerometerEventStream().listen(...)`
  - store `StreamSubscription? subscription;` on the state
  - cancel with `subscription?.cancel();` in `dispose()`
- UI: prefer small widgets under `lib/`. If adding features, create `lib/widgets/` or `lib/src/` and keep `main.dart` minimal.
- Keep rebuilds minimal: avoid calling `setState()` for high-frequency sensor updates unless necessary; consider `StreamBuilder` or a `ValueNotifier` for localized updates.

## Integration points & native considerations
- `sensors_plus` is a plugin that touches platform code — edits to `android/` or `ios/` may require platform tooling (Android SDK, Xcode, Visual Studio on Windows).
- Android uses Gradle Kotlin scripts (`android/app/build.gradle.kts`); use the provided Gradle wrapper (`android/gradlew`) for reproducible builds.
- iOS has `ios/Runner/Info.plist` and generated registrant files; Xcode may be required for some changes.

## Testing & debugging tips
- Device logs: `flutter logs` or use platform-specific loggers (adb, Xcode Console).
- To reproduce sensor-related behavior, use a physical device or an emulator with sensor injection if supported.
- Run `flutter test test/widget_test.dart` for widget-level tests.

## When editing this repo
- Always run `dart format .` and `flutter analyze` before pushing changes.
- If you change dependencies, run `flutter pub get` and restart any running app instances.
- For native changes, document platform-specific steps in the PR description (e.g., "Requires Android SDK 31+").

## Where to look for more context
- `README.md` (repo root) — start here for project intent.
- `android/`, `ios/`, `windows/` — platform-specific build files and native hooks.

If anything here is unclear or you want additional examples (e.g., preferred widget folder structure or CI commands), ask and I'll iterate.
