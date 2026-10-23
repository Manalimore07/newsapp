# 📰 PulseNews - Clean Architecture Flutter News Application

[![Flutter](https://img.shields.io/badge/Flutter-3.47.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.0-0175C2.svg)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success.svg)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%2FCubit-red.svg)](https://bloclibrary.dev)
[![Storage](https://img.shields.io/badge/Offline%20Cache-Hive-yellow.svg)](https://docs.hivedb.dev)
[![Tests](https://img.shields.io/badge/Tests-Passing%20(3%2F3)-brightgreen.svg)]()

A modern, high-performance Flutter news application built using **Clean Architecture**, **BLoC (Cubit)** state management, and **Hive** offline caching. Designed with **Material 3**, supporting dynamic Light/Dark theme switching, pull-to-refresh, real-time in-app search, and external browser article launching.

Developed by **[Manali More](https://github.com/Manalimore07)**.

---

## 🌟 Key Features

- **Clean Architecture**: Strict separation of concerns across Domain, Data, and Presentation layers for maximum testability and maintainability.
- **State Management**: Reactive and predictable UI state handling with `flutter_bloc` (`Cubit`).
- **Offline Caching**: Built-in persistence using `hive` and `hive_flutter`. Articles are cached locally upon fetching, ensuring the app works seamlessly even without an active internet connection.
- **Material 3 Design**: Modern typography, adaptive cards, and responsive layouts.
- **Theme Switching (Bonus)**: Persistent Light / Dark theme mode toggle stored in Hive.
- **Search Functionality**: Real-time filtering by article title, description, content, and author.
- **Pull-to-Refresh (Bonus)**: Smooth `RefreshIndicator` gesture to reload headlines with realistic network simulation.
- **External URL Launching**: Opens the original publisher link in external browser via `url_launcher`.
- **Unit Testing (Bonus)**: Comprehensive test suite for model serialization, null safety, and business logic (`flutter test`).

---

## 🏗️ Architecture Overview

The application strictly follows Uncle Bob's **Clean Architecture** principles:

```
lib/
├── core/                                # Shared utilities, theme & constants
│   ├── constants/app_constants.dart     # Box names, asset paths, title
│   ├── error/failures.dart              # Failure & exception models
│   └── theme/app_theme.dart             # Light & Dark Material 3 theme data
│
├── features/
│   └── news/
│       ├── domain/                      # 1. CORE BUSINESS LOGIC (Zero external dependencies)
│       │   ├── entities/article_entity.dart
│       │   ├── repositories/news_repository.dart
│       │   └── usecases/
│       │       ├── get_articles_usecase.dart
│       │       └── search_articles_usecase.dart
│       │
│       ├── data/                        # 2. DATA LAYER (Fetching & Caching)
│       │   ├── datasources/
│       │   │   ├── news_mock_data_source.dart   # Loads & parses mock JSON with simulated latency
│       │   │   └── news_local_data_source.dart  # Caches & retrieves articles via Hive
│       │   ├── models/article_model.dart        # ArticleModel with fromJson/toJson & null safety
│       │   └── repositories/news_repository_impl.dart
│       │
│       └── presentation/                # 3. UI & STATE MANAGEMENT
│           ├── cubit/                   # NewsCubit, NewsState, ThemeCubit
│           ├── screens/                 # HomeScreen, ArticleDetailScreen, SearchScreen
│           └── widgets/                 # ArticleCard, custom UI components
│
├── injection_container.dart             # Dependency Injection setup with get_it
└── main.dart                            # Application entry point & Hive initialization
```

### Why Clean Architecture?
- **Domain Layer** has zero dependencies on Flutter widgets, Hive, or HTTP libraries.
- Switching from mock JSON to a live NewsAPI endpoint requires modifying only the Data source—Domain and Presentation remain 100% untouched.
- Makes writing unit and widget tests clean, isolated, and straightforward.

---

## 🚀 Setup & Run Instructions

### Prerequisites
- **Flutter SDK**: `^3.13.0` or higher (Tested on `Flutter 3.47.0 • Dart 3.13.0`)
- **Git** installed on your system
- Any IDE (VS Code / Android Studio) or Terminal

### 1. Clone the repository
```bash
git clone https://github.com/Manalimore07/newsapp.git
cd newsapp
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run the application
```bash
# To run on Chrome (Web)
flutter run -d chrome

# To run on connected Android/iOS device or emulator
flutter run
```

### 4. Run automated tests
```bash
flutter test
```

### 5. Check code quality / static analysis
```bash
flutter analyze
```

---

## ⚖️ Assumptions & Trade-Offs

1. **Mock Data Source vs. Live NewsAPI**:
   - *Decision*: A bundled mock dataset (`assets/data/news_mock.json`) conforming strictly to the official NewsAPI response schema is used by default.
   - *Rationale*: Free-tier NewsAPI keys are capped at 100 requests per day and fail frequently on mobile IP ranges (CORS on Web / 426 Upgrade Required). Providing a guaranteed mock dataset with realistic network latency ensures the reviewer has a 100% crash-free, reliable experience.
   - *Extensibility*: The `NewsRemoteDataSource` interface allows swapping in a `DioNewsRemoteDataSource` with just a single line in `injection_container.dart`.

2. **Cubit instead of Bloc**:
   - *Decision*: Used `Cubit` from `flutter_bloc`.
   - *Rationale*: For this scope, `Cubit` provides the same reactive state management benefits without the boilerplate of separate event classes, making the code cleaner and easier to read.

3. **Hive Key-Value JSON Storage**:
   - *Decision*: Cached articles as serialized JSON maps inside Hive.
   - *Rationale*: Eliminates the need for code generation (`build_runner` / TypeAdapters) while retaining near-instant synchronous reads and offline reliability.

---

## 👩‍💻 Author
- **GitHub**: [@Manalimore07](https://github.com/Manalimore07)
- **Repository**: [https://github.com/Manalimore07/newsapp](https://github.com/Manalimore07/newsapp)
