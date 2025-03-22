import 'dart:io';
import 'dart:convert';
import 'package:dartpm/src/dartpm.dart';
import 'package:dartpm/utils/utils.dart';

class CustomProcessHandler {
  final Process _process;
  final String _id;

  CustomProcessHandler._(this._process, this._id);

  // Factory constructor to start a new process
  static Future<CustomProcessHandler> start(
    String executable,
    List<String> arguments,
  ) async {
    // Start the process
    final String id = generateRandomBase64String(10);
    log.info(
        'Running process id: $id, command: $executable ${arguments.join(' ')}');
    final process = await Process.start(
      executable,
      arguments,
      runInShell: true,
      mode: ProcessStartMode.normal,
      workingDirectory: ".",
    );
    return CustomProcessHandler._(process, id)
      ..listenToStderr()
      ..listenToStdout();
  }

  // Listen to stdout and print the data
  void listenToStdout() {
    _process.stdout.listen((data) {
      log.info('process id : $_id, output: ${utf8.decode(data)}');
    });
  }

  // Listen to stderr and print the error data
  void listenToStderr() {
    _process.stderr.listen((data) {
      log.info('process id : $_id, error: ${utf8.decode(data)}');
    });
  }

  // Write data to the process's stdin
  void writeToStdin(String input) {
    _process.stdin.writeln(input);
  }

  // Close stdin when done
  Future<void> closeStdin() async {
    log.info('process id : $_id, close process');
    await _process.stdin.close();
  }

  // Wait for the process to exit and return the exit code
  Future<int> waitForExit() async {
    final exitCode = await _process.exitCode;
    if (exitCode != 0) throw 'process id : $_id failed with $exitCode';
    return await _process.exitCode;
  }

  // Terminate the process
  void terminate([ProcessSignal signal = ProcessSignal.sigterm]) {
    _process.kill(signal);
  }

  // Dispose the process (kill and clean up resources)
  void dispose() {
    terminate();
  }
}
