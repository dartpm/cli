import 'dart:convert';
import 'dart:io';
import 'package:dartpm/service/encrypt.dart';
import 'package:dartpm/utils/textColorUtils.dart';

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

  Future<LoginResponse> loginEndpoint(
      String token, String secret, String? desc) async {
    final uri = Uri.parse('$serverBaseUri/api/cli/login');
    final body = {
      'pairingToken': token,
      'secret': secret,
      'deviceName': deviceName,
      'os': os,
      ...desc != null ? {'desc': desc} : {}
    };
    final response =
        await http.post(uri, body: body).timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load data: ${response.statusCode}, ${response.body}');
    }
  }

  Future<LoginResponse> loginJwtEndpoint(String token) async {
    final uri = Uri.parse('$serverBaseUri/api/cli/loginJwt');
    final body = {'deviceName': deviceName, 'os': os};
    final response = await http
        .post(uri, headers: {'Authorization': token}, body: body)
        .timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load data: ${response.statusCode}, ${response.body}');
    }
  }

  Future<LoginResponse> loginEndpointWithRetry(
      String token, String secret, String? desc) async {
    var retryCount = 0;
    while (retryCount < 5) {
      try {
        return await loginEndpoint(token, secret, desc);
      } catch (e) {
        retryCount++;
      }
    }
    throw Exception('Fail to login');
  }

  Future<LoginResponse> login(String? desc) async {
    int randomLength = 32; // Length of the random bytes
    String pairingToken = utils.generateRandomBase64String(randomLength);
    String secret = utils.generateRandomBase64String(randomLength);
    String webToken = encrypt(pairingToken, secret);

    utils.openUrl('$webBaseUri/login/$webToken');
    print(
        'open url in browser ${color('$webBaseUri/login/$webToken', AnsiColor.magenta)}');
    return await loginEndpointWithRetry(pairingToken, secret, desc);
  }
}
