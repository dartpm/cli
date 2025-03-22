import 'dart:io';
import 'dart:math';
import 'package:dartpm/utils/constants.dart';

String generateRandomBase64String(int length) {
  // Generate random bytes
  final random = Random.secure();
  String s = '';
  for (int i = 0; i < length; i++) {
    s += ascii[random.nextInt(64)];
  }

  // Encode bytes to Base64
  return s;
}

void openUrl(String url) {
  if (Platform.isWindows) {
    Process.run('start', [url]);
  } else if (Platform.isMacOS) {
    Process.run('open', [url]);
  } else if (Platform.isLinux) {
    Process.run('xdg-open', [url]);
  } else {
    print('Unsupported platform');
  }
}

// Not used
Future<void> getOrgs() async {
  var process = await Process.start(
    'dart',
    ['pub', 'token', 'list'],
  );

  // Handle the process output (if necessary)
  process.stdout.listen((data) {
    stdout.add(data); // Print process output to the console
  });
  process.stderr.listen((data) {
    stderr.add(data); // Print process errors to the console
  });

  print('response : ${'qwerty\n'.toString()}');

  // process.stdin.writeln(token);
  await process.stdin.close();

  print('response1.2 ');
  final exitCode = await process.exitCode;

  exit(exitCode);
}

String getVersion() {
  return '0.0.8';
}
