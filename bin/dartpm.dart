import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/dartpm.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  parser.addCommand('login', loginArgParser);
  parser.addCommand('logout', logoutArgParser);
  parser.addCommand('publish', doctorArgParser);
  parser.addCommand('add', addPackageArgParser);
  parser.addCommand('doctor', doctorArgParser);
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help information.');
  parser.addFlag('verbose', help: 'verbose do not vwork in this version');

  final ArgResults argResults = parser.parse(arguments);

  if (argResults['help'] as bool || arguments.isEmpty) {
    print('Usage: dartpm <command> [options]');
    print('Visit ($WEB_BASE_URL/package/dartpm) to see usage');
    exit(0);
  }

  if (argResults.command == null) {
    print('Error: No command provided');
    print('Use "dartpm --help" for more information.');
    exit(1);
  }

  final command = argResults.command!.name;

  switch (command) {
    case 'login':
      handleLogin(argResults.command!.arguments);
      break;
    case 'logout':
      handleLogout(argResults.command!.arguments);
      break;
    case 'publish':
      handlePublish(argResults.command!.arguments);
      break;
    case 'add':
      handleAddPackage(argResults.command!.arguments);
      break;
    case 'doctor':
      handleDoctor(argResults.command!.arguments);
      break;
    default:
      print('Unknown command: $command');
      exit(1);
  }
}
