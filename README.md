# JpStudy v2

Offline-first Japanese study app for Windows, Android, and iOS.

## Stack

- Flutter (single codebase for desktop + mobile)
- Riverpod (state management)
- SQLite + Drift (local database and ORM)

## MVP scope

- Flashcards with SRS scheduling
- Grammar quiz (N5/N4/N3)
- Mock exam (timer, score, review)
- Progress: streak + XP + basic stats

## Project structure

- lib/app: app shell, theme
- lib/data: Drift database, repositories
- lib/features: UI modules (vocab, grammar, exam, progress)

## Local setup

```bash
flutter pub get
dart run build_runner build
flutter run
```
