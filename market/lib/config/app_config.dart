class AppConfig {
  static const String _baseUrl = 'http://13.219.156.170:8000';
  
  // URLs de autenticación
  static const String registerUrl = '$_baseUrl/register';
  static const String loginUrl = '$_baseUrl/token';
  
  // URLs de empresa
  static const String createCompanyUrl = '$_baseUrl/company';
  static const String getAllCompaniesUrl = '$_baseUrl/compnay/all';
  
  // URLs de productos
  static String getCompanyProductsUrl(String companyId) => '$_baseUrl/company/products/$companyId';
  static String uploadProductUrl(String companyId) => '$_baseUrl/product/$companyId';
  
  // URL para imágenes de productos
  static String getProductImageUrl() => '$_baseUrl/ProductImg';

  // Configuraciones adicionales
  static const int timeoutSeconds = 10;
  
  // Función para debug
  static void printConfig() {
    print('Base URL: $_baseUrl');
  }
}