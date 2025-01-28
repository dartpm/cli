import 'dart:io';

import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/utils.dart';

final logoutArgParser = ArgParser()..addFlag('help', abbr: 'h', negatable: false);

Future<void> handleLogout(List<String> arguments) async {
  final ArgResults argResults = logoutArgParser.parse(arguments);

  if (argResults['help'] as bool) {
    print('Usage: Logout from currently logged in orgs, to see list of org run dartpm doctor');
    exit(0);
  }

  final storageData = getFromStorage();
  if (storageData != null) {
    for (int i = 0; i < storageData.orgs.length; i++) {
      await deleteOrgToken('$SERVER_BASE_URL/registry/${storageData.orgs.elementAt(i).id}');
    }
  }
  await deleteOrgToken(SERVER_BASE_URL);
  deleteStorage();
}
