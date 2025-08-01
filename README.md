# 🎮 Game Arcade

A comprehensive Flutter-based gaming platform featuring multiple arcade-style games with Firebase integration for user authentication, leaderboards, and score tracking.

## 📱 Overview

Game Arcade is a mobile gaming application built with Flutter that provides an immersive gaming experience with three classic arcade games. The app features user authentication, real-time leaderboards, and a modern, responsive UI with gradient themes.

## 🎯 Features

### 🎮 Games
- **Dino Run**: A classic endless runner game featuring a dinosaur character dodging enemies
- **Flappy Bird**: Navigate a bird through pipes in this challenging arcade game
- **Tetris**: The classic block-stacking puzzle game with modern controls

### 🔐 User Management
- Firebase Authentication integration
- User registration and login system
- Profile management with image upload capability
- Admin panel for user management

### 🏆 Leaderboard System
- Real-time score tracking using Firestore
- Global leaderboards for each game
- Score persistence across sessions

### 📱 Modern UI/UX
- Gradient-themed interface with orange accent colors
- Responsive design for various screen sizes
- Custom fonts (Jersey10, Audiowide)
- Smooth animations and transitions

## 🏗️ Technical Architecture

### Frontend
- **Framework**: Flutter (Dart)
- **Game Engine**: Flame (for game development)
- **State Management**: Provider pattern
- **UI**: Material Design with custom theming

### Backend
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage (for profile images)
- **Real-time Updates**: Firestore streams for leaderboards

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📁 Project Structure

```
lib/
├── controllers/          # Business logic and state management
│   ├── auth_controller.dart
│   ├── game_service.dart
│   ├── leaderboard_controller.dart
│   └── score_controller.dart
├── games/               # Game implementations
│   ├── game1/          # Dino Run game
│   ├── game2/          # Flappy Bird game
│   └── game3/          # Tetris game
├── models/             # Data models
│   ├── gameModel.dart
│   ├── score_model.dart
│   └── signup_model.dart
├── screens/            # App screens and UI
│   ├── home_screen.dart
│   ├── login.dart
│   ├── leaderboard_screen.dart
│   └── [other screens...]
├── services/           # External service integrations
└── widgets/           # Reusable UI components
```

## 🔧 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter: sdk
  flame: ^1.22.0           # Game development framework
  firebase_core: ^3.12.1   # Firebase core functionality
  firebase_auth: ^5.5.1    # Authentication
  cloud_firestore: ^5.6.5  # Database
  firebase_storage: ^12.4.4 # File storage
  provider: ^6.1.3         # State management
  image_picker: ^1.0.7     # Image selection
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 2.17.0)
- Dart SDK
- Firebase project setup
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd game_arcade
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Configure Firebase Authentication and Firestore
   - Update `firebase_options.dart` with your configuration

4. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Configuration

1. **Authentication**: Enable Email/Password authentication in Firebase Console
2. **Firestore**: Create collections for:
   - `users` - User profiles
   - `scores` - Game scores
   - `games` - Game metadata
3. **Storage**: Configure for profile image uploads

## 🎮 Game Details

### Dino Run
- **Type**: Endless runner
- **Controls**: Tap to jump
- **Features**: Enemy spawning system, parallax scrolling background
- **Scoring**: Time-based with enemy dodging bonuses

### Flappy Bird
- **Type**: Obstacle avoidance
- **Controls**: Tap to flap wings
- **Features**: Pipe collision detection, gravity physics
- **Scoring**: Pipes successfully passed

### Tetris
- **Type**: Puzzle
- **Controls**: Touch controls for movement and rotation
- **Features**: Line clearing, increasing difficulty
- **Scoring**: Lines cleared and level progression

## 🎨 Assets

The project includes custom assets:
- **Audio**: Background music and sound effects
- **Images**: Game sprites, backgrounds, and UI elements
- **Fonts**: Custom typography (Jersey10, Audiowide)

## 🔐 Authentication Flow

1. **Splash Screen**: App initialization
2. **Login/Signup**: Firebase Auth integration
3. **Home Screen**: Game selection and navigation
4. **Profile Management**: User data and preferences

## 📊 Leaderboard System

- Real-time score updates using Firestore streams
- Separate leaderboards for each game
- Score validation and persistence
- User ranking system

## 🛠️ Development

### Build Commands
```bash
# Debug build
flutter run

# Release build (Android)
flutter build apk --release

# Release build (iOS)
flutter build ios --release

# Web build
flutter build web
```

### Testing
```bash
# Run tests
flutter test

# Widget tests
flutter test test/widget_test.dart
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team

## 🔮 Roadmap

- [ ] Additional game implementations
- [ ] Multiplayer functionality
- [ ] In-app purchases
- [ ] Push notifications
- [ ] Social features and friend systems
- [ ] Achievement system

---

**Built with ❤️ using Flutter and Firebase**
