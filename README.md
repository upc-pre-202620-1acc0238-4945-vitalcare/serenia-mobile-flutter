# Serenia Mobile Flutter

Serenia Mobile Flutter is the multiplatform application for distant relatives of the Serenia platform. Built with Flutter on the foundations of Domain-Driven Design (DDD) and Clean Architecture, it lets relatives know how their older adult woke up without having to call every few hours: they see the daily check-in and its history, follow small wins and suggestions, attend and resolve alerts, organize care shifts and shared notes with the rest of the care circle, listen to the older adult's voice messages, and send them photos. The app runs on Android, iOS, and the web, consumes the Serenia Platform REST API, and is organized into the same bounded contexts as the backend.

## Tech Stack

- **Language:** Dart 3.14
- **UI:** Flutter 3.50 with Material 3 and the Serenia design system (Nunito)
- **Architecture:** DDD + Clean Architecture, view models as `Cubit`s (`flutter_bloc`) with immutable states
- **Dependency Injection:** `get_it` service locator
- **Networking:** `http` (JSON) + `http_parser` (multipart uploads)
- **Local Storage:** `flutter_secure_storage` (session)
- **Navigation:** Plain `Navigator` with one nested navigator per tab
- **Media:** `image_picker` (camera and gallery), `just_audio` (voice messages), `url_launcher` (phone dialer)
- **Formats:** `intl` with the `es` locale (`4:00 p. m.`, `Jueves 12 de noviembre`)
- **App Icons:** `flutter_launcher_icons`
- **Platforms:** Android (`minSdk` 24), iOS, and web

## Prerequisites

- Flutter SDK 3.50 (stable channel) with Dart 3.14
- Android Studio with Android SDK 36+ and an emulator or device running Android 7.0 (API 24) or newer
- Xcode (macOS only) to run the iOS app
- Google Chrome to run the web app
- Optionally, the [Serenia Platform](https://github.com/upc-pre-202620-1acc0238-4945-vitalcare/serenia-platform) backend running locally (see Getting Started)

## Project Structure

The project is organized into bounded contexts following DDD principles:

```text
lib/
├── core/
│   ├── widgets/              # Serenia design system components (buttons, fields, cards, chips, snackbar...)
│   ├── theme.dart            # Material theme built from the Serenia tokens
│   ├── serenia_*.dart        # Design tokens: colors, typography, spacing, radii, shadows, touch targets
│   ├── api_*.dart            # Base URL, shared headers, and API errors
│   ├── session*.dart         # Session storage (secure storage)
│   ├── authorized_image.dart # Images loaded with the session token
│   └── service_locator.dart  # get_it registrations
├── features/
│   ├── iam/                  # Welcome, role selection, sign in, sign up, profile data, profile photo, password
│   ├── carecircle/           # Relationship, invitation code, "Círculo", care shifts, shared notes, unlink
│   ├── dailycheckin/         # Today's check-in, history, and day detail
│   ├── wellbeingmonitoring/  # Small wins and wellbeing suggestions
│   ├── alertsandsafety/      # "Alertas" tab, alert detail, acknowledge, resolve, and call
│   ├── socialcompanionship/  # "Mensajes" tab: audio messages, family photos, and day reminders
│   ├── home/                 # "Inicio" tab, composes the sections of other contexts
│   ├── account/              # "Cuenta" tab, composes IAM and the family link
│   └── main/                 # MainPage, nested navigators, and the bottom navigation bar
└── main.dart                 # Entry point: opens Welcome, Relationship, or MainPage based on the session
```

Each bounded context follows the same layered layout: `domain` (entities, value objects, domain exceptions, and repository contracts, pure Dart), `application` (use cases), `infrastructure` (remote APIs, DTOs, repository implementations, and device services), and `presentation` (pages, view models, states, and feature widgets). `home` and `account` are presentation-only: they compose the pages of other bounded contexts.

## Configuration

The app reads its configuration from compile-time variables and the platform folders:

- `API_BASE_URL` (`--dart-define`): Host of the Serenia Platform API, read by `lib/core/api_constants.dart` (the app appends `/api/v1`). Defaults to the deployed backend, `https://serenia-platform.azurewebsites.net`.
- `android/app/src/main/AndroidManifest.xml`: Declares the `INTERNET` permission and the `tel:` dial intent query used by "Llamar". Release builds block cleartext (HTTP) traffic.
- `android/app/src/debug/res/xml/network_security_config.xml`: Allows cleartext traffic only to `10.0.2.2` and `localhost`, so debug builds can reach the local backend.
- `ios/Runner/Info.plist`: Camera and photo library usage descriptions (profile photo and photos for the older adult) and the `tel` URL scheme.
- `flutter_launcher_icons.yaml`: Source images and colors of the Android adaptive icon, the iOS icon, and the web icons.

## Getting Started

### 1) Install Dependencies

```bash
flutter pub get
```

### 2) Choose the Backend

By default the app talks to the deployed backend (`https://serenia-platform.azurewebsites.net`), so there is nothing to start.

To use a local backend instead, start [Serenia Platform](https://github.com/upc-pre-202620-1acc0238-4945-vitalcare/serenia-platform) with its default `dev` profile so it listens on `http://localhost:8080`, and pass its host with `--dart-define`:

- Android emulator: `--dart-define=API_BASE_URL=http://10.0.2.2:8080` (`10.0.2.2` is the host machine as seen from the emulator).
- iOS simulator and web: `--dart-define=API_BASE_URL=http://localhost:8080`.

### 3) Run the Application

#### Using Android Studio or VS Code

1. Open the project folder and run `flutter pub get` (or accept the IDE prompt).
2. Select a device (Android emulator, iOS simulator, or Chrome) and run `lib/main.dart`. Add `--dart-define` in the run configuration's additional arguments to use a local backend.

#### Using the Flutter CLI

```bash
# List the available devices
flutter devices

# Run on a device against the deployed backend
flutter run -d <device-id>

# Run on the Android emulator against a local backend
flutter run -d <device-id> --dart-define=API_BASE_URL=http://10.0.2.2:8080

# Run on Chrome
flutter run -d chrome
```

### 4) Using a Physical Device

With the deployed backend a physical device only needs internet access. `10.0.2.2` only exists inside the Android emulator, so to use a local backend on a physical Android device, either forward the port with `adb reverse tcp:8080 tcp:8080` and run with `--dart-define=API_BASE_URL=http://localhost:8080`, or point `API_BASE_URL` to the backend's LAN address and add that address to the debug network security config.

### 5) Test Data

A relative needs an older adult to accompany:

1. Create an older adult account in the [Serenia Mobile Android](https://github.com/upc-pre-202620-1acc0238-4945-vitalcare/serenia-mobile-android) app (or with `POST /api/v1/users` in the backend Swagger UI) and copy the invitation code from "Familia › Mi círculo".
2. In this app, choose "Crear mi cuenta" › "Soy familiar", create the account, choose the relationship, and enter the code.
3. To see check-ins, alerts, audio messages, and reminders, use the older adult app at the same time: answer the daily question, hold "Pedir ayuda", record "Cuéntame algo", or create reminders.

## Scripts and Commands

- `flutter pub get`: Install the dependencies.
- `flutter analyze`: Run the static analysis (`flutter_lints`).
- `flutter test`: Run the unit and widget tests.
- `flutter run -d <device-id>`: Run the app on a device, emulator, simulator, or browser.
- `flutter build apk --debug`: Build the debug APK.
- `flutter build apk --release`: Build the release APK.
- `flutter build ios`: Build the iOS app (macOS only).
- `flutter build web`: Build the web app into `build/web`.
- `dart run flutter_launcher_icons`: Regenerate the app icons after changing `assets/icons/` (then restore `ios/Runner.xcodeproj/project.pbxproj`, which the generator rewrites).

Every `run` and `build` command accepts `--dart-define=API_BASE_URL=<host>` to change the backend.

## Continuous Delivery

The workflow in `.github/workflows/flutter.yml` builds the app with GitHub Actions:

- **Pull requests to `develop` or `main`:** run `flutter analyze`, `flutter test`, and build the debug APK and the web app to check that the project still compiles. Nothing is published.
- **Push to `main`:** build the release APK and send it to Firebase App Distribution, so the testers get the new version. `develop` is only for integration and does not publish.
- **Every run:** keeps the APK as a downloadable artifact of the run, and uses `100 + run number` as the build number so each upload is newer than the last.

The Firebase step runs only when these repository secrets exist (Settings, Secrets and variables, Actions); without them it is skipped and the build still passes:

- `FIREBASE_APP_ID`: App ID of the Android app registered in the Firebase project (Project settings, General).
- `FIREBASE_SERVICE_ACCOUNT`: Full JSON key of a service account with the Firebase App Distribution Admin role.

Testers receive the builds through the App Distribution group named `testers`. Never commit `google-services.json`, keystores or the service account key.

## Features

### IAM (Identity and Access Management)

- Welcome, role selection ("¿Quién eres?"), and sign in at the older adult app's larger scale, shared with the Android app.
- Sign up (step 1 of 3) with name, email, optional phone number, and password; only relative accounts can sign in here.
- Session restore on launch and automatic sign out when the session expires (401).
- "Mis datos": edit name and phone number, and change the profile photo from the camera or the gallery.
- Change password ("Esa no es tu contraseña actual" on a wrong current password) and sign out with in-card confirmation.

### Care Circle

- Relationship (step 2 of 3): "Hija o hijo", "Nieta o nieto", "Sobrina o sobrino", "Hermana o hermano", "Nuera o yerno", or "Otro".
- Invitation code (step 3 of 3): one 8-character field shown in two groups, "Pegar código", and a single error for invalid, used, or expired codes; then "Conectados".
- "Círculo" tab: the older adult's relatives with their relationship, and shortcuts to care shifts and shared notes.
- Care shifts: week view with free and taken days, sign up for a free day up to 4 weeks ahead, a notice when someone else took the day first, and "Pasarle el turno" for your own shifts.
- Shared notes: newest first, write a new note, and edit your own notes inside the card.
- "Quitar mi vínculo" with in-card confirmation; your future shifts become free.

### Daily Check-in

- "Inicio" tab panel: today's answer ("Muy bien", "Más o menos", "No tan bien") with its time and question of the day, colored by the answer.
- Pending ("Aún no responde"), paused ("Hoy prefirió no responder"), and no answer states.
- "Ver historial": the last 3 months grouped by week, with filters by answer, and an empty state.
- Day detail: the answer of that day, the older adult's reminders ("Lo hizo", "Lo pasó a las…", "Sin marcar"), and that week's dots.

### Wellbeing Monitoring

- Small wins: good days this week, seven dots from Monday to Sunday (with icons, not only color), and the line "Lunes, martes y hoy amaneció muy bien".
- Suggestion after several "No tan bien" days in a row, with "Llamar a Rosa" and "Descartar".

### Alerts and Safety

- Emergency ("Pidió ayuda", coral) and inactivity ("Sin responder", amber) notices at the top of "Inicio".
- "Alertas" tab: "Pendientes" and "Anteriores", type and status chips (Pendiente, Atendiendo, Resuelta), who is handling each alert, and a "Todo en calma" empty state.
- Pending alerts count on the "Alertas" tab of the navigation bar.
- Alert detail with a timeline, "Llamar a Rosa" (opens the phone dialer; hidden when the older adult has no phone), and "Yo me encargo", which tells the other relatives.
- "Ya está bien: marcar como resuelta" with a "Deshacer" snackbar (about 6 seconds).

### Social Companionship

- "Mensajes" tab: the older adult's audio messages, played in the same list (one at a time) with progress and a "Nuevo" badge per relative.
- Photos sent by the circle, with who sent them and when, and "Ver todos" for the full lists.
- "Enviarle una foto": pick a photo from the gallery, review it ("¿Le envías esta foto?"), and send it to the older adult.

### Account

- "Mi cuenta": profile card, "Tu vínculo" ("Acompañas a Rosa · Eres su hija o hijo") with a link to "Círculo", password, and sign out.

## Security Model

- **Authentication:** The JWT, session id, and user id returned by the backend are stored with `flutter_secure_storage` (Keychain on iOS, encrypted storage on Android) and sent as `Authorization: Bearer <token>` on every authenticated request.
- **Role Check:** Only `DISTANT_RELATIVE` accounts can sign in; an older adult account is signed out right away and gets a sign-in error.
- **Session Expiration:** A `401` response clears the session and sends the user back to the welcome screen.
- **Sign Out:** Closes the session in the backend (`DELETE /sessions/{sessionId}`) and clears the local session.
- **Protected Media:** Audio messages, photos, and profile photos are served by protected endpoints; images and audio are loaded with the session token.
- **Transport:** Cleartext HTTP is allowed only for the local backend in debug builds.
- **Language:** Requests send `Accept-Language: es-PE`, so backend error messages arrive in Spanish.

## Development Conventions

- **DDD + Clean Architecture:** `domain` and `application` are pure Dart (no Flutter, `http`, or storage); DTOs never leave `infrastructure`.
- **Use Cases:** Each operation is a use case class with an `execute(...)` method; failures are domain exceptions.
- **View Models:** `Cubit`s registered with `registerFactory` and provided per page with `BlocProvider`; pages render their state with `BlocBuilder`/`BlocConsumer`.
- **Design System:** Colors, typography (Nunito, "familiar" and "mayor" scales), spacing, radii, and touch targets come from `lib/core`; shared widgets live in `lib/core/widgets` and feature-only widgets in each feature's `presentation` folder. Minimum touch target is 48 and primary actions use 52–56.
- **Accessibility:** Icons always come with text or a semantic label, state is never shown only by color, destructive actions are confirmed inside the card, errors use a field border plus a message, and text respects the system font size.
- **Navigation:** Each tab keeps its own navigator, so the bottom bar stays visible on subpages; tapping the active tab returns to its root page.
- **Commits:** Conventional Commits with the feature as scope (e.g. `feat(circle): ...`) and one `feature/*` branch per bounded context, merged into `develop` through pull requests.
