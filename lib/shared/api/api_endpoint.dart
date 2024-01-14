class ApiEndpoint {
  ///Base URL
  static const String baseUrl = 'https://api.order-online.digitafact.com';
  static const String imageUrlPath = '$baseUrl/storage/settings';

  ///Auth
  static const String signIn = '/api/auth/login';
  static const String signup = '/api/auth/register';
  static const String socialLogin = '/api/auth/social-login';
  static const String forgetPassword = '/api/auth/password/email';
  static const String logout = '/api/auth/logout';

  ///Home
  static const String settings = '/api/setting';
}
