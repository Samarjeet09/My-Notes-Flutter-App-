import 'package:flutter/cupertino.dart';
import 'package:notesapp/utilities/dialogs/generic_dialogs.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "LOG OUT",
      content: "Are you sure you want to LOG OUT",
      optionBuilder: () {
        return {
          "NO": false,
          "YES": true,
        };
      }).then(
    (value) => value ?? false,
  );
}
