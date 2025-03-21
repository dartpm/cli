import 'package:dartpm/src/command.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

class AddCommand extends CommandExtension {
  AddCommand() {
    argParser.addFlag(
      'gobal',
      abbr: 'g',
      defaultsTo: false,
      negatable: false,
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
      String? orgName;
      String? version;
      if (packageData.length == 1) {
        /// package_name
        packageName = packageData[0];
      } else if (packageData.length == 2) {
        if (packageData[0] == '') {
          /// @org_name/package_name
          final packageData1 = packageData[1].split('/');
          orgName = packageData1[0];
          packageName = packageData1[1];
        } else {
          /// package_name@1.0.0
          packageName = packageData[0];
          version = packageData[1];
        }
      } else if (packageData.length == 3) {
        /// @org_name/package_name@1.0.0
        final packageData1 = packageData[1].split('/');
        orgName = packageData1[0];
        packageName = packageData1[1];
        version = packageData[2];
      } else {
        throw 'invalid package name';
      }

      await addPackage(
          serverBaseUrl: SERVER_BASE_URL,
          packageName: packageName,
          org: orgName,
          version: version,
          isGlobal: argResults!['global'] as bool);
    }
  }
}
