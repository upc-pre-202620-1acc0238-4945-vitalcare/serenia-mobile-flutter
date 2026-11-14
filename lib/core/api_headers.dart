class ApiHeaders {
  static const String language = 'es-PE';

  static Map<String, String> json({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': language,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
