class ApiConstants {
  static const String host = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://serenia-platform.azurewebsites.net',
  );
  static const String baseUrl = '$host/api/v1';
}
