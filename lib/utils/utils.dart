import 'dart:io';
import 'dart:math';

const smallCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
const capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const digits = '1234567890';
const specialCharacters = '-_';

String generateRandomBase64String(int length) {
  // Generate random bytes
  const ascii = smallCaseLetters + capitalLetters + digits + specialCharacters; // 26 + 26 + 10 + 2
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

Future<void> setToken(String route, String token) async {
  var process = await Process.start(
    'dart',
    ['pub', 'token', 'add', route],
  );

  process.stdin.writeln(token);

  await process.stdin.close();

  final exitCode = await process.exitCode;

  if (exitCode != 0) throw 'Something got wrong';
}

Future<void> deleteOrgToken(String route) async {
  var process = await Process.start(
    'dart',
    ['pub', 'token', 'remove', route],
  );

  await process.stdin.close();

  final exitCode = await process.exitCode;
  if (exitCode != 0) throw 'Something got wrong';
}

addPackage({
  required String serverBaseUrl,
  required String packageName,
  String? org,
  String? version,
}) async {
  final packageUrl = '$serverBaseUrl${org != null ? '/registry/$org' : ''}';
  List<String> config = [
    '"hosted":"$packageUrl"',
  ];

  if (version != null) {
    config.add('"version":"$version"');
  }

  print('add command ${'\'$packageName:{${config.join(', ')}}\''}');

  var process = await Process.start(
    'dart',
    ['pub', 'add', '\'$packageName:{${config.join(', ')}}\''],
  );

  await process.stdin.close();

  final exitCode = await process.exitCode;
  if (exitCode != 0) throw 'Something got wrong';
}

Future<void> publishPackage() async {
  var process = await Process.start(
    'dart',
    ['pub', 'publish'],
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
