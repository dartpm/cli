import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/service/loginService.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

const loginHelp = 'Log in to dartpm.';
const loginHelpDetails =
    'login command will initiate the login process by opening the browser where user need to do login with current account, the token in the url will be used to authenticate the CLI';

final loginArgParser = ArgParser()
  ..addOption(
    'token',
    abbr: 't',
    help: 'Add personal access token, can be generated on $WEB_BASE_URL',
  )
  ..addOption(
    'desc',
    abbr: 'd',
    help: 'Add description to this login session',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Help for login command',
  );

Future<void> handleLogin(List<String> arguments) async {
  final ArgResults argResults = loginArgParser.parse(arguments);

  if (argResults['help']) {
    printCommandHelp('login', loginHelp, loginArgParser, loginHelpDetails);
    exit(0);
  }

  final loginService = LoginService(SERVER_BASE_URL, WEB_BASE_URL);
  final token = argResults['token'] as String?;
  final desc = argResults['desc'] as String?;

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
