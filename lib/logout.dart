import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

const logoutHelp = 'Log out of dartpm CLI om this device.';

final logoutArgParser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Help for logout command',
  );

Future<void> handleLogout(List<String> arguments) async {
  final ArgResults argResults = logoutArgParser.parse(arguments);

  if (argResults['help'] as bool) {
    printCommandHelp('logout', logoutHelp, logoutArgParser);
    exit(0);
  }

  final storageData = getFromStorage();
  if (storageData != null) {
    for (int i = 0; i < storageData.orgs.length; i++) {
      await deleteOrgToken(
          '$SERVER_BASE_URL/registry/${storageData.orgs.elementAt(i).id}');
    }
  }
  await deleteOrgToken(SERVER_BASE_URL);
  deleteStorage();
}
