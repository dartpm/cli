import 'dart:io';
import 'package:args/args.dart';
import 'package:dartpm/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

const addHelp = 'Add package from dartpm.';
const addHelpDetails =
    'This command makes easy to add packages directly from the dartpm. This is just an alias. Packages can be added using dart CLI tool as well.';

final addPackageArgParser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Help for add command',
  )
  ..addFlag(
    'gobal',
    abbr: 'g',
    negatable: false,
    help: 'Add global package',
  );

handleAddPackage(List<String> packages) async {
  final ArgResults argResults = addPackageArgParser.parse(packages);

  if (argResults['help'] as bool || packages.isEmpty) {
    printCommandHelp('add', addHelp, addPackageArgParser, addHelpDetails);
    exit(0);
  }

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
        isGlobal: argResults['global']);
  }
}
