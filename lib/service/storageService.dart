import 'dart:convert';
import 'dart:io';

import 'package:dartpm/utils/loginResponse.dart';

class StorageData {
  late Iterable<UserOrgs> orgs;

  StorageData(this.orgs);

  @override
  String toString() {
    return '{ "userOrgs": [ ${orgs.map((e) => e.toString()).join(',')} ] }';
  }

  StorageData.fromJson(Map<String, dynamic> json) {
    orgs = (json['userOrgs'] as List<dynamic>).map((e) => UserOrgs.fromJson(e));
  }
}

// Get the directory of the Dart script
Directory getDirectory() {
  final scriptUri = Platform.script.toFilePath();
  final scriptDirectory = Directory(scriptUri).parent;
  return scriptDirectory;
}

void saveToStorage(StorageData content) {
  final directory = getDirectory();
  final filename = 'metadata.txt';
  final file = File('${directory.path}/$filename');
  file.writeAsStringSync(content.toString());
}

StorageData? getFromStorage() {
  final directory = getDirectory();
  final filename = 'metadata.txt';
  final file = File('${directory.path}/$filename');
  if (file.existsSync()) {
    final content = file.readAsStringSync();
    return StorageData.fromJson(jsonDecode(content));
  }
  return null;
}

void deleteStorage() {
  final directory = getDirectory();
  final filename = 'metadata.txt';
  final file = File('${directory.path}/$filename');
  if (file.existsSync()) {
    file.deleteSync(recursive: true);
  }
}
