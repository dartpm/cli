import 'dart:io';

// export DARTPM_ENV=development
String? environment = Platform.environment['DARTPM_ENV'];
bool isDev = environment != null && environment == 'development';

final SERVER_BASE_URL = isDev ? 'http://localhost:8080' : 'https://dartpm.com';
final WEB_BASE_URL = isDev ? 'http://localhost:3000' : 'https://dartpm.com';

const smallCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
const capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const digits = '1234567890';
const specialCharacters = '-_';
const ascii = smallCaseLetters +
    capitalLetters +
    digits +
    specialCharacters; // 26 + 26 + 10 + 2
