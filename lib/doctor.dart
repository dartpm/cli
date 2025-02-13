import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/textColorUtils.dart';

const doctorHelp = 'See details of current dartpm CLI session.';
const doctorHelpDetails =
    'doctor command will show the users orgs. If the org is missing, you can log out and log in again.';

final doctorArgParser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Help for doctor command',
  );

Future<void> handleDoctor(List<String> arguments) async {
  final ArgResults argResults = doctorArgParser.parse(arguments);

  if (argResults['help'] as bool) {
    printCommandHelp('doctor', doctorHelp, doctorArgParser);
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
