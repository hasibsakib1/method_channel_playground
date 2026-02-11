# MethodChannel Playground

A complete Flutter application demonstrating how to communicate between Dart and Native Android (Kotlin).

> **Note:** This project is a **"Learn by Doing"** playground. Ideally, it's a bit messy! The goal was to experiment, break things, and learn different patterns (from simple spaghetti code to cleaner architecture). It reflects a learning journey rather than a production-ready template.

This project covers everything from basic calls to complex data streams and real-world connectivity monitoring.

## Features

### 1. Basic MethodCalls (Request/Response)
*   **Get Greeting:** Sends a String argument (`name`) -> Returns a String.
*   **Compute Sum:** Sends a Map (`a`, `b`) -> Returns an Int.
*   **Get Battery Level:** Calls Android `BatteryManager` -> Returns Int.
*   **Get Detailed Battery Info:** Returns a complex Map (`level`, `status`, `isCharging`).

### 2. Error Handling
*   **Force Error:** Native code throws an error -> Caught by Flutter `try-catch`.

### 3. Asynchronous Native Work
*   **Heavy Task:** Simulates a long-running background task (3s) using threads, returning results to the UI thread safely.

### 4. EventChannels (Streams)
*   **Timer Stream:** Native sends a "Tick: X" event every second.
*   **Random Stream:** Configurable stream (Arguments: `min`, `max`) that emits random numbers.
*   **Network Monitor:** Real-time connectivity status (Connected/Disconnected) using `ConnectivityManager`.

## Project Structure

We use a **Chain of Responsibility** pattern to keep `MainActivity.kt` clean.

*   **Flutter (Dart):** `lib/main.dart` - A dashboard UI invoking all methods.
*   **Native (Kotlin):** `android/app/src/main/kotlin/...`
    *   `MainActivity.kt`: The "Traffic Cop" that routes calls.
    *   `BatteryHandler.kt`: Handles battery logic.
    *   `UtilityHandler.kt`: Handles math, greetings, errors, and heavy tasks.
    *   `TimerStreamHandler.kt`: Handles the simple timer stream.
    *   `RandomStreamHandler.kt`: Handles the configurable random number stream.
    *   `NetworkHandler.kt`: Handles the real-world network monitor.

## Setup & Running

1.  **Open in Android Studio/VS Code.**
2.  **Run the App:** `flutter run`
3.  **Permissions:** The app uses `ACCESS_NETWORK_STATE` (already added to `AndroidManifest.xml`).

## Debugging
See `debugging_guide.md` for common errors like `MissingPluginException` or `PlatformException`.
