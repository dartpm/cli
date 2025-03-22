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
      // print('packages : ${packages[i].split('@')}');
      final packageData = packages[i].split('@');
      String packageName;
      String? scope;
      String? version;
      if (packageData.length == 1) {
        /// package_name
        packageName = packageData[0];
      } else if (packageData.length == 2) {
        if (packageData[0] == '') {
          /// @org_name/package_name
          final packageData1 = packageData[1].split('/');
          scope = packageData1[0];
          packageName = packageData1[1];
        } else {
          /// package_name@1.0.0
          packageName = packageData[0];
          version = packageData[1];
        }
      } else if (packageData.length == 3) {
        /// @org_name/package_name@1.0.0
        final packageData1 = packageData[1].split('/');
        scope = packageData1[0];
        packageName = packageData1[1];
        version = packageData[2];
      } else {
        throw 'invalid package name';
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
            '$packageName:{${config.join(', ')}}'
          ])
        : CustomProcessHandler.start(
            //'pwd', []
            'dart',
            ['pub', 'add', '$packageName:{${config.join(', ')}}'],
          ));

    await process.waitForExit();
  }
}
