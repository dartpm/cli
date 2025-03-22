import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/service/command.dart';
import 'package:dartpm/service/process.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';

class LogoutCommand extends CommandExtension {
  @override
  final name = 'logout';

  @override
  final description =
      color('Log out of dartpm CLI om this device.', AnsiColor.magenta);

  @override
  Future<void> run() async {
    try {
      final storageData = getFromStorage();
      if (storageData != null) {
        for (int i = 0; i < storageData.orgs.length; i++) {
          await _deleteOrgToken(
              '$SERVER_BASE_URL/registry/${storageData.orgs.elementAt(i).id}');
        }
      }
      await _deleteOrgToken(SERVER_BASE_URL);
      deleteStorage();
      print('Logged out successfully');
    } catch (e) {
      throw ('No login session found');
    }
  }

  Future<void> _deleteOrgToken(String route) async {
    var process = await CustomProcessHandler.start(
      'dart',
      ['pub', 'token', 'remove', route],
    );

    await process.waitForExit();
  }
}
