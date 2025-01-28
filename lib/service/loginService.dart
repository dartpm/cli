import 'dart:convert';
import 'dart:io';
import '../utils/loginResponse.dart';
import '../utils/utils.dart' as utils;
import 'package:http/http.dart' as http;

class LoginService {
  final String serverBaseUri;
  final String webBaseUri;
  late final String? deviceName;
  late final String? os;

  LoginService(this.serverBaseUri, this.webBaseUri) {
    deviceName = Platform.localHostname;
    os = Platform.operatingSystem;
  }

  Future<LoginResponse> loginEndpoint(String token, String? desc) async {
    final uri = Uri.parse('$serverBaseUri/api/cli/login');
    final body = {
      'pairingToken': token,
      'deviceName': deviceName,
      'os': os,
      ...desc != null ? {'desc': desc} : {}
    };
    final response = await http.post(uri, body: body).timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}, ${response.body}');
    }
  }

  Future<LoginResponse> loginJwtEndpoint(String token) async {
    final uri = Uri.parse('$serverBaseUri/api/cli/loginJwt');
    final body = {'deviceName': deviceName, 'os': os};
    final response = await http.post(uri, headers: {'Authorixation': token}, body: body).timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}, ${response.body}');
    }
  }

  Future<LoginResponse> loginEndpointWithRetry(String token, String? desc) async {
    var retryCount = 0;
    while (retryCount < 5) {
      try {
        return await loginEndpoint(token, desc);
      } catch (e) {
        retryCount++;
      }
    }
    throw Exception('Fail to login');
  }

  Future<LoginResponse> login(String? desc) async {
    int byteLength = 16; // Length of the random bytes
    String base64String = utils.generateRandomBase64String(byteLength);
    utils.openUrl('$webBaseUri/login/$base64String');
    return await loginEndpointWithRetry(base64String, desc);
  }
}
