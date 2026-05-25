import 'dart:io';

void main() {
  var file = File('lib/presentation/screens/config_screen.dart');
  var configScreenContent = file.readAsStringSync();

  var classConfigItemStart = configScreenContent.indexOf(
    'class ConfigItem extends StatelessWidget {',
  );
  if (classConfigItemStart == -1) return;

  // Split into three parts
  var screenPart = configScreenContent.substring(0, classConfigItemStart);
  var configItemEnd = configScreenContent.indexOf(
    'class ConfigExpansionItem extends StatelessWidget {',
  );
  var configItemPart = configScreenContent.substring(
    classConfigItemStart,
    configItemEnd,
  );
  var configExpansionPart = configScreenContent.substring(configItemEnd);

  // Write config_item.dart
  var configItemFile =
      "import 'package:flutter/material.dart';\n\n" + configItemPart;
  File(
    'lib/presentation/widgets/config_item.dart',
  ).writeAsStringSync(configItemFile);

  // Write config_expansion_item.dart
  var configExpansionFile =
      "import 'package:flutter/material.dart';\n\n" + configExpansionPart;
  File(
    'lib/presentation/widgets/config_expansion_item.dart',
  ).writeAsStringSync(configExpansionFile);

  // Update config_screen.dart with imports
  var newImports =
      "import '../widgets/config_item.dart';\nimport '../widgets/config_expansion_item.dart';\n";
  var lastImport = screenPart.lastIndexOf('import ');
  var nextNewline = screenPart.indexOf('\n', lastImport);
  var newScreenPart =
      screenPart.substring(0, nextNewline + 1) +
      newImports +
      screenPart.substring(nextNewline + 1);

  file.writeAsStringSync(newScreenPart);

  print('Widget refactoring done!');
}
