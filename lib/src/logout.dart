import 'package:args/command_runner.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/utils.dart';

class LogoutCommand extends Command {
  @override
  final name = 'logout';

  @override
  final description = 'Log out of dartpm CLI om this device.';

  @override
  Future<void> run() async {
    final storageData = getFromStorage();
    if (storageData != null) {
      for (int i = 0; i < storageData.orgs.length; i++) {
        await deleteOrgToken(
            '$SERVER_BASE_URL/registry/${storageData.orgs.elementAt(i).id}');
      }
    }
    await deleteOrgToken(SERVER_BASE_URL);
    deleteStorage();
  }
}
