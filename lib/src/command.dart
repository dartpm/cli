import 'package:args/command_runner.dart';
import 'package:dartpm/service/logging.dart';

abstract class CommandExtension<T> extends Command {
  CommandExtension() {
    argParser.addFlag(
      "verbose",
      abbr: "v",
      defaultsTo: false,
      help: "Enable verbose logging",
    );
  }

  @override
  Future<T> run() async {
    final verbose = argResults!['verbose'] as bool;
    if (verbose) {
      enableVerboseLogging();
    }
    return await main();
  }

  Future<T> main() async {
    throw UnimplementedError('Leaf command $this must implement main().');
  }
}
