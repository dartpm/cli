import 'dart:io';

// export DART_ENV=development
String? environment = Platform.environment['DART_ENV'];
bool isDev = environment != null && environment == 'development';

final SERVER_BASE_URL = isDev ? 'http://localhost:8080' : 'https://dartpm.com';
final WEB_BASE_URL = isDev ? 'http://localhost:3000' : 'https://dartpm.com';
