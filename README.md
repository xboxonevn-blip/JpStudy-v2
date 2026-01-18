# JpStudy-v2

A modern Japanese language learning application built with Flutter.

## Features

- 📚 **Vocabulary Learning** with Spaced Repetition System (SRS)
- 📖 **Custom Lessons** (N5-N1 JLPT levels)  
- 🎮 **Gamification** (XP, Levels, Achievements, Streaks)
- 🎯 **Mini-Games** (Match Game, Kanji Dash)
- 🌍 **Multi-language** (English, Vietnamese, Japanese)
- 🌙 **Dark Mode** support
- 📊 **Progress Tracking** with detailed statistics

## Built With

- **Flutter 3.x** - Cross-platform framework
- **Riverpod** - State management
- **Drift** - SQLite database ORM
- **GoRouter** - Navigation
- **just_audio** - Audio playback

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Windows/macOS/Linux development environment

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/JpStudy-v2.git

# Navigate to project directory
cd JpStudy-v2

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure

```
lib/
├── app/              # App configuration & theming
├── core/             # Shared utilities & widgets
│   ├── gamification/ # XP system, achievements
│   ├── services/     # TTS, audio services
│   └── widgets/      # Reusable UI components
├── data/             # Data layer
│   ├── db/           # Database schemas
│   ├── models/       # Data models
│   └── repositories/ # Data access
└── features/         # Feature modules
    ├── home/         # Dashboard
    ├── lesson/       # Lesson management
    ├── vocab/        # Vocabulary browser
    └── games/        # Mini-games
```

## Features in Detail

### Vocabulary System
- **Minna No Nihongo** integration (Lessons 1-5, 119 terms)
- 4-field structure: Term, Reading, Kanji Meaning, Translation
- Language-aware display (Vietnamese/English)
- Tag-based filtering

### Gamification
- **XP Formula**: Activity-based rewards
- **Level System**: Exponential progression
- **Achievements**: 8 unlockable badges
- **Streaks**: Daily learning tracking

### Study Modes
- **Flashcards**: Interactive term review
- **Practice**: Question-based learning
- **Match Game**: Time-based matching
- **Kanji Dash**: Speed translation game

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

## Acknowledgments

- Minna No Nihongo curriculum
- Flutter community
- Open-source contributors

## Roadmap

See [roadmap.md](.gemini/antigravity/brain/roadmap.md) for planned features.

---

**Status**: Active Development  
**Version**: 2.0.0-beta  
**Last Updated**: 2026-01-19
