import 'package:dartpm/service/command.dart';
import 'package:dartpm/service/process.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';

class AddCommand extends CommandExtension {
  AddCommand() {
    argParser.addFlag(
      'global',
      abbr: 'g',
      defaultsTo: false,
      help: 'Add global package',
    );
  }

  @override
  final name = 'add';

  @override
  final description = color('Add package from dartpm.', AnsiColor.magenta);

  @override
  Future<void> main() async {
    final packages = argResults!.rest;

    for (int i = 0; i < packages.length; i++) {
      String packageName = packages[i];
      String? scope;
      String? version;

      if (packageName.contains('@')) {
        final packageData = packageName.split('@');
        if (packageData.length != 2) {
          throw 'Invalid package name';
        }
        version = packageData[1];
        packageName = packageData[0];
      }

      if (packageName.contains('/')) {
        final packageData = packageName.split('/');
        if (packageData.length != 2) {
          throw 'Invalid package name';
        }
        scope = packageData[0];
        packageName = packageData[1];
      }

      await _addPackageCommand(
        packageName: packageName,
        scope: scope,
        version: version,
      );
    }
  }

  List<String> _addPackageCommandConfig(String packageUrl, String? version) {
    List<String> config = [
      '"hosted":"$packageUrl"',
    ];
    if (version != null) {
      config.add('"version":"$version"');
    }

    return config;
  }

  _addPackageCommand({
    required String packageName,
    String? scope,
    String? version,
  }) async {
    final packageUrl =
        '$SERVER_BASE_URL${scope != null ? '/registry/$scope' : ''}';

    final config = _addPackageCommandConfig(packageUrl, version);

    var process = await ((argResults!['global'] as bool)
        ? CustomProcessHandler.start('dart', [
            'pub',
            'global',
            'activate',
            '--source',
            'hosted',
            '--hosted-url',
            packageUrl,
            packageName
          ])
        : CustomProcessHandler.start(
            'dart',
            ['pub', 'add', '$packageName:{${config.join(', ')}}'],
          ));

    await process.waitForExit();
  }
}
