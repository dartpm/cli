import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/dartpm.dart';

void main(List<String> arguments) {
  final parser = getMainParser();
  final ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (error) {
    /// Trigger this error using `dart run bin/dartpm.dart -v`
    /// OR
    /// Trigger this error using `dart run bin/dartpm.dart login -t`
    /// If any invalid flag/options is passed, the parser.parse will throw error
    print('Invalid command: $error');
    exit(1);
  }

  validateArgResult(argResults, arguments, parser);

  handleCommand(argResults);
}

ArgParser getMainParser() {
  final parser = ArgParser();

  parser.addCommand('login', loginArgParser);
  parser.addCommand('logout', logoutArgParser);
  parser.addCommand('publish', publishArgParser);
  parser.addCommand('add', addPackageArgParser);
  parser.addCommand('doctor', doctorArgParser);
  parser.addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Show help information.',
  );
  parser.addFlag(
    'version',
    abbr: 'v',
    negatable: false,
    help: 'Current version of dartpm',
  );

  return parser;
}

void validateArgResult(
  ArgResults argResults,
  List<String> arguments,
  ArgParser parser,
) {
  /// If no command is found or help flag is used
  /// To trigger this run `dart run bin/dartpm.dart`
  /// OR
  /// run `dart run bin/dartpm.dart -h`
  /// OR
  /// run `dart run bin/dartpm.dart --help`
  if (argResults['help'] as bool || arguments.isEmpty) {
    printHelp(parser);
  }

  /// If wrong command is passed
  /// To trigger this run `dart run bin/dartpm.dart somecommand`
  if (argResults.command == null) {
    print('Error: No command provided');
    print('Use "dartpm --help" for more information.');
    exit(1);
  }
}

void handleCommand(ArgResults argResults) {
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

void printHelp(ArgParser parser) {
  const commandsPadding = 16;

  print('\x1B[35mdartpm version: ${getVersion()}\x1B[0m\n');
  print('\x1B[35mdartpm CLI tool.\x1B[0m');
  print('A command-line utility to manage dart packages\n');
  print('Usage: dartpm <command> [arguments]\n');

  print('Global options:');
  print(parser.usage);

  print('');

  print('Available commands:');
  for (var command in parser.commands.keys) {
    print('${command.padRight(commandsPadding)}${printCommandHelp(command)}');
  }

  print('');
  print('Visit ($WEB_BASE_URL/package/dartpm) to see usage');
  exit(0);
}

String printCommandHelp(String command) {
  switch (command) {
    case 'login':
      return loginHelp;
    case 'logout':
      return logoutHelp;
    case 'publish':
      return publishHelp;
    case 'add':
      return addHelp;
    case 'doctor':
      return doctorHelp;
    default:
      exit(1);
  }
}
