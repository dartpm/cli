import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/service/loginService.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/utils.dart';

final loginArgParser = ArgParser()
  ..addOption('token', help: 'Add personal access token, can be generated on $WEB_BASE_URL')
  ..addOption('desc', help: 'Add description ');

Future<void> handleLogin(List<String> arguments) async {
  final ArgResults argResults = loginArgParser.parse(arguments);
  final loginService = LoginService(SERVER_BASE_URL, WEB_BASE_URL);
  final token = argResults['token'] as String?;
  final desc = argResults['desc'] as String?;

  final loginResponse = await (token != null ? loginService.loginJwtEndpoint(token) : loginService.login(desc));

  for (int i = 0; i < loginResponse.orgs.length; i++) {
    await setToken('$SERVER_BASE_URL/registry/${loginResponse.orgs.elementAt(i).id}', loginResponse.token);
  }
  await setToken(SERVER_BASE_URL, loginResponse.token);

  saveToStorage(StorageData(loginResponse.orgs));
}
