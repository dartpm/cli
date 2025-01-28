import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/dartpm.dart';
import 'package:dartpm/service/storageService.dart';

final doctorArgParser = ArgParser()..addFlag('help', abbr: 'h', negatable: false);

Future<void> handleDoctor(List<String> arguments) async {
  final ArgResults argResults = logoutArgParser.parse(arguments);

  if (argResults['help'] as bool) {
    print('Usage: See information about current session');
    exit(0);
  }

  final storageData = getFromStorage();
  print('Logged in following orgs');
  if (storageData != null) {
    for (int i = 0; i < storageData.orgs.length; i++) {
      print(storageData.orgs.elementAt(i).id);
    }
  }
  print(SERVER_BASE_URL);
  deleteStorage();
}
