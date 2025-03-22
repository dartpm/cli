import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/service/command.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

class DoctorCommand extends CommandExtension {
  @override
  final name = 'doctor';

  @override
  final description =
      color('See details of current dartpm CLI session.', AnsiColor.magenta);

  @override
  Future<void> main() async {
    print(color('dartpm version: ${getVersion()}', AnsiColor.magenta));
    final storageData = getFromStorage();
    if (storageData != null) {
      print('Logged in following orgs');
      for (int i = 0; i < storageData.orgs.length; i++) {
        print('$SERVER_BASE_URL/registry/${storageData.orgs.elementAt(i).id}');
      }
      print(SERVER_BASE_URL);
    } else {
      print('Not logged in');
    }
  }
}
