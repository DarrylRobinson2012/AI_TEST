# Water Training Mobile App (Flutter)

A Flutter mobile app for customers to book swimming lessons, aqua therapy, and performance water training. Includes:
- Content feed for water safety and stroke mechanics
- Calendar booking page
- Messaging page
- Profile page
- Login/register flow (mocked locally for now)

## Tech
- Flutter (Material 3)
- Riverpod for state management
- GoRouter for navigation
- TableCalendar for calendar UI

## Getting Started
1. Install Flutter SDK: https://docs.flutter.dev/get-started/install
2. Fetch dependencies:
   ```bash
   cd flutter_app
   flutter pub get
   ```
3. Run:
   ```bash
   flutter run
   ```

## Structure
```
lib/
  main.dart
  models/
    booking.dart
    message.dart
    post.dart
    user.dart
  providers/
    auth_provider.dart
    bookings_provider.dart
    messages_provider.dart
    posts_provider.dart
    profile_provider.dart
  features/
    auth/login_screen.dart
    bookings/calendar_screen.dart
    messages/messages_screen.dart
    profile/profile_screen.dart
    content/feed_screen.dart
  widgets/
    bottom_nav.dart
```

## Notes
- Current data is in-memory (mock). Hook up to your backend later via `http` in providers.
- The login/register screens set a mock session; add API calls to your auth server when ready.
- Replace placeholder navigation/actions as needed.
