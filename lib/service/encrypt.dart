import 'package:dartpm/utils/constants.dart';

String encrypt(String data, String key) {
  String encryptedData = "";
  for (var i = 0; i < data.length; i++) {
    encryptedData +=
        ascii[(ascii.indexOf(data[i]) + ascii.indexOf(key[i])) % 64];
  }

  return encryptedData;
}

// Only here for reference.
String descrypt(String encryptedData, String key) {
  String data = "";
  for (var i = 0; i < encryptedData.length; i++) {
    data += ascii[
        (ascii.indexOf(encryptedData[i]) - ascii.indexOf(key[i]) + 64) % 64];
  }
  return data;
}
