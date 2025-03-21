import 'package:dartpm/service/loginService.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/src/command.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

class LoginCommand extends CommandExtension {
  LoginCommand() {
    argParser
      ..addOption(
        'token',
        abbr: 't',
        help: 'Add personal access token, can be generated on $WEB_BASE_URL',
      )
      ..addOption(
        'desc',
        abbr: 'd',
        help: 'Add description to this login session',
      );
  }

  @override
  final name = 'login';

  @override
  final description = color('Log in to dartpm.', AnsiColor.magenta);

  @override
  Future<void> main() async {
    final loginService = LoginService(SERVER_BASE_URL, WEB_BASE_URL);
    final token = argResults!['token'] as String?;
    final desc = argResults!['desc'] as String?;

    final loginResponse = await (token != null
        ? loginService.loginJwtEndpoint(token)
        : loginService.login(desc));

    for (int i = 0; i < loginResponse.orgs.length; i++) {
      await setToken(
          '$SERVER_BASE_URL/registry/${loginResponse.orgs.elementAt(i).id}',
          loginResponse.token);
    }
    await setToken(SERVER_BASE_URL, loginResponse.token);

    saveToStorage(StorageData(loginResponse.orgs));
  }
}
