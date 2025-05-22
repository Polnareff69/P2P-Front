class AppConstants {
  // 🔐 Claves para SharedPreferences
  static const String tokenKey = 'auth_token';
  static const String userRoleKey = 'user_role';
  static const String userEmailKey = 'user_email';
  static const String usernameKey = 'username';
  static const String companyIdKey = 'company_id';

  // 👥 Roles de usuario
  static const String sellerRole = 'seller';
  static const String userRole = 'user';

  // 🎯 Status codes HTTP comunes
  static const int httpSuccess = 200;
  static const int httpCreated = 201;
  static const int httpBadRequest = 400;
  static const int httpUnauthorized = 401;
  static const int httpNotFound = 404;
  static const int httpInternalError = 500;

  // ⏱️ Timeouts
  static const Duration defaultTimeout = Duration(
    seconds: 30,
  );
  static const Duration shortTimeout = Duration(
    seconds: 10,
  );

  // 📱 Mensajes de usuario
  static const String loginSuccess =
      'Inicio de sesión exitoso';
  static const String loginError =
      'Error en el inicio de sesión';
  static const String registerSuccess = 'Registro exitoso';
  static const String registerError =
      'Error en el registro';
  static const String logoutSuccess = 'Sesión cerrada';
  static const String networkError = 'Error de conexión';
  static const String tokenExpired =
      'Sesión expirada, inicia sesión nuevamente';

  // 🔄 Estados de la aplicación
  static const String stateLoading = 'loading';
  static const String stateSuccess = 'success';
  static const String stateError = 'error';
  static const String stateEmpty = 'empty';
}
