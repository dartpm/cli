import 'package:args/args.dart';
import 'package:dartpm/utils/utils.dart';

enum AnsiColor {
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  reset; // for resetting the color

  // Convert the enum value to the corresponding ANSI escape code
  String get code {
    switch (this) {
      case AnsiColor.black:
        return '\x1B[30m';
      case AnsiColor.red:
        return '\x1B[31m';
      case AnsiColor.green:
        return '\x1B[32m';
      case AnsiColor.yellow:
        return '\x1B[33m';
      case AnsiColor.blue:
        return '\x1B[34m';
      case AnsiColor.magenta:
        return '\x1B[35m';
      case AnsiColor.cyan:
        return '\x1B[36m';
      case AnsiColor.white:
        return '\x1B[37m';
      case AnsiColor.reset:
        return '\x1B[0m';
    }
  }
}

String wrapText(String text, int width) {
  final buffer = StringBuffer();
  final words = text.split(' ');

  var line = '';

  for (var word in words) {
    if (line.length + word.length + 1 > width) {
      buffer.writeln(line);
      line = word;
    } else {
      if (line.isNotEmpty) {
        line += ' ';
      }
      line += word;
    }
  }

  if (line.isNotEmpty) {
    buffer.writeln(line);
  }

  return buffer.toString();
}

String color(String text, AnsiColor color) {
  return '${color.code}$text${AnsiColor.reset.code}';
}

void printCommandHelp(String commandName, String helpText, ArgParser parser,
    [String? details]) {
  print(color('dartpm version: ${getVersion()}', AnsiColor.magenta));
  print('');
  print(color(helpText, AnsiColor.blue));
  if (details != null) {
    print('');
    print(wrapText(details, 80));
  }
  print('Usage: dartpm $commandName <arguments|options>');
  print(parser.usage);
}
