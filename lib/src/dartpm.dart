import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dartpm/src/add.dart';
import 'package:dartpm/src/doctor.dart';
import 'package:dartpm/service/logging.dart';
import 'package:dartpm/src/login.dart';
import 'package:dartpm/src/logout.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';
import 'package:logging/logging.dart';

final log = Logger('dartpm');

Future<void> runMain(List<String> args) async {
  try {
    initLogging();

    final runner = CommandRunner(
        'dartpm', 'A command-line utility to manage dartpm packages')
      ..addCommand(LoginCommand())
      ..addCommand(LogoutCommand())
      ..addCommand(AddCommand())
      ..addCommand(DoctorCommand());

    await runner.run(args);
  } catch (e) {
    log.severe(kDoubleSeparator);
    log.severe(color('dartpm version: ${getVersion()}', AnsiColor.magenta));
    log.severe('dartpm failed with error:');
    log.severe(kSeparator);
    log.severe(e);
    log.severe('arguments: $args');
    log.severe(kDoubleSeparator);
    exit(1);
  }
}
