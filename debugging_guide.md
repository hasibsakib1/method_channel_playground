# MethodChannel Debugging Guide 🐞

A cheat sheet for common errors when working with Flutter MethodChannels.

## 1. MissingPluginException
**Error:** `MissingPluginException(No implementation found for method ...)`
**Cause:**
*   You called a method name in Dart (e.g., `'getBattery'`) that doesn't exist in the Native `MethodCallHandler`.
*   You forgot to register the handler in `MainActivity`.
*   You added a **new** Native file/class but didn't do a full restart (Hot Restart is not enough for Native code changes!).

**Fix:**
*   Check spelling! `'getBattery'` vs `'getBatteryLevel'`.
*   **Stop & Run** the app completely.

## 2. PlatformException
**Error:** `PlatformException(error_code, message, details)`
**Cause:**
*   The Native code explicitly called `result.error(...)`.
*   An unhandled exception occurred in Native code (e.g., NullPointerException).

**Fix:**
*   Wrap your Dart code in `try-catch`:
    ```dart
    try {
      await platform.invokeMethod('...');
    } on PlatformException catch (e) {
      print("Native Error: ${e.message}");
    }
    ```
*   Check the **Android Logcat** for the actual Native stack trace.

## 3. UI Thread Issues
**Error:** `Methods marked with @UiThread must be executed on the main thread.`
**Cause:**
*   You tried to send data (`result.success` or `eventSink.success`) from a background thread (like a Timer or Network Callback).

**Fix:**
*   Wrap the sending logic in `runOnUiThread`:
    ```kotlin
    Handler(Looper.getMainLooper()).post {
        result.success(...)
    }
    ```

## 4. ANR (Application Not Responding)
**Cause:**
*   You did heavy work (Thread.sleep, large DB query) directly on the Main Thread in Native code.

**Fix:**
*   Move heavy work to a background thread (`Thread { ... }.start()`).
*   Remember to switch back to the Main Thread to send the result!

## 5. Permissions
**Error:** `SecurityException` or "Permission Denial"
**Cause:**
*   You declared a permission in `AndroidManifest.xml` but didn't restart the app.
*   You forgot to declare the permission entirely.

**Fix:**
*   Add `<uses-permission ... />` to `src/main/AndroidManifest.xml`.
*   **Stop & Run** the app.

## 6. EventChannel Not Streaming
**Cause:**
*   You defined `EventChannel` in Dart but didn't set the `StreamHandler` in Native.
*   Stream names don't match.

**Fix:**
*   Ensure `EventChannel('name')` matches `EventChannel(..., "name")`.
*   Ensure `setStreamHandler(...)` is called in `configureFlutterEngine`.
