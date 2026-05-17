/// Base URL for the MediScan backend API.
///
/// | Where you run the app | Set API_BASE_URL to |
/// |-----------------------|--------------------------------------|
/// | Laptop / desktop      | http://localhost:5001                |
/// | Android emulator      | http://10.0.2.2:5001                 |
/// | Physical phone        | http://YOUR_LAPTOP_IP:5001           |
///
/// Example (phone on same Wi‑Fi as laptop):
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.42:5001
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5001',
  );
}
