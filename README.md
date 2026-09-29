# TaskFlow: Sample App for the Flutter 6-Day Course

TaskFlow is the to-do app that learners build step by step during the course. This repository contains the **finished app** on `main`, plus a **start and end branch for every day**, so any learner who falls behind can jump to the right point.

Verified with Flutter 3.44 (stable) / Dart 3.12: `flutter analyze` clean, `flutter test` passing, `flutter build web` and `flutter build apk --release` succeed.

## Features

- Add, edit, complete, and swipe-to-delete tasks (with a confirm dialog on Day 3)
- Form validation
- Filters: All / Active / Done
- State management with Provider
- Tasks saved on the device (`shared_preferences`)
- "Import sample tasks" from a REST API (`jsonplaceholder.typicode.com`), with loading and error states
- Material 3 theme with automatic dark mode, custom app icon
- Unit tests and a widget test, GitHub Actions CI

## Run it

```bash
flutter pub get
flutter run            # pick an emulator, a phone, or Chrome
flutter test           # run all tests
flutter analyze        # static analysis
dart run practice/day1_dart_basics.dart   # Day 1 Dart practice file
```

## Day branches

| Branch | What's in it |
|---|---|
| `day-02-start` | Fresh `flutter create` project |
| `day-02-end` / `day-03-start` | Day 1 Dart practice file, `Task` model, static task list UI |
| `day-03-end` / `day-04-start` | Stateful home, Add/Edit form with validation, navigation, swipe to delete |
| `day-04-end` / `day-05-start` | Provider, JSON, `shared_preferences` persistence, filters |
| `day-05-end` / `day-06-start` | REST API import, error handling, dark mode, empty state, app icon |
| `day-06-end` / `main` | Tests, CI workflow, release signing setup |

Switch with, for example:

```bash
git checkout day-04-start
flutter pub get
```

## Project structure

```
lib/
├── main.dart
├── models/task.dart
├── providers/task_provider.dart
├── services/
│   ├── api_service.dart
│   └── task_storage.dart
├── screens/
│   ├── home_screen.dart
│   └── add_edit_task_screen.dart
└── widgets/task_tile.dart
test/
├── task_provider_test.dart
└── home_screen_test.dart
practice/
└── day1_dart_basics.dart
```

## Release signing (Day 6)

`android/app/build.gradle.kts` reads `android/key.properties` if it exists. Without it, release builds are signed with the debug key, so a fresh clone still builds. To sign for the Play Store:

1. Create a keystore:
   `keytool -genkey -v -keystore %userprofile%\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Create `android/key.properties`:
   ```properties
   storePassword=<your-store-password>
   keyPassword=<your-key-password>
   keyAlias=upload
   storeFile=<full-path-to>/upload-keystore.jks
   ```
3. `flutter build appbundle`

`key.properties`, `*.jks`, and `*.keystore` are in `.gitignore`. **Never commit them.**

Before publishing, change `com.yourcompany.taskflow` to your own application ID.
