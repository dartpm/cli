import 'package:args/command_runner.dart';
import 'package:dartpm/service/storageService.dart';
import 'package:dartpm/utils/constants.dart';

class DoctorCommand extends Command {
  @override
  final name = 'doctor';

  @override
  final description = 'See details of current dartpm CLI session.';

  @override
  void run() {
    final storageData = getFromStorage();
    print('Logged in following orgs');
    if (storageData != null) {
      for (int i = 0; i < storageData.orgs.length; i++) {
        print(storageData.orgs.elementAt(i).id);
      }
    }
    print(SERVER_BASE_URL);
    deleteStorage();
  }
}
