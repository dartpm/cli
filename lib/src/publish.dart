import 'dart:io';
import 'package:dartpm/src/command.dart';
import 'package:dartpm/utils/constants.dart';
import 'package:dartpm/utils/textColorUtils.dart';
import 'package:dartpm/utils/utils.dart';

class PublishCommand extends CommandExtension {
  @override
  final name = 'publish';

  @override
  final description = color(
      'Configure the pubspec.yaml for publishing on dartpm', AnsiColor.magenta);

  // Function to update the 'publish_to' field if it exists (even as a comment), ensuring no preceding spaces, tabs, or #.
  String _updatePublishTo(String content) {
    // Match a commented-out 'publish_to' or a line with extra spaces, and uncomment it
    return content.replaceFirst(
        RegExp(r'^\s*#?\s*publish_to:.*', multiLine: true),
        'publish_to: $SERVER_BASE_URL');
  }

  // Function to append 'publish_to' at the end of the file without leading spaces, tabs, or any other chars
  String _appendPublishTo(String content) {
    // Append 'publish_to' at the end of the file without any leading indentation or preceding chars
    return '${content.trim()}\npublish_to: $SERVER_BASE_URL\n';
  }

  @override
  Future<void> main() async {
    final pubspecFilePath = 'pubspec.yaml';
    File pubspecFile = File(pubspecFilePath);

    if (!pubspecFile.existsSync()) {
      print(
          "pubspec.yaml file not found. The command should be run in root where pubspec of the package is located");
      return;
    }

    String pubspecContent = await pubspecFile.readAsString();

    /// Check if the 'publish_to' key exists, even as a comment
    if (pubspecContent
        .contains(RegExp(r'^\s*#?\s*publish_to:', multiLine: true))) {
      /// If it exists (even as a comment), uncomment and update the field
      pubspecContent = _updatePublishTo(pubspecContent);
    } else {
      /// If it doesn't exist, append it at the end without leading spaces or any other chars
      pubspecContent = _appendPublishTo(pubspecContent);
    }

    // Write the updated content back to the file
    await pubspecFile.writeAsString(pubspecContent);

    print("Updated publish_to field in pubspec.yaml successfully.");

    await publishPackage();
  }
}
