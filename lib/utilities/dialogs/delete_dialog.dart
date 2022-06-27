import 'package:flutter/cupertino.dart';
import 'package:notesapp/utilities/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "DELETE NOTE",
      content: "Are you sure you want to DELETE THIS ITEM",
      optionBuilder: () {
        return {
          "NO": false,
          "YES": true,
        };
      }).then(
    (value) => value ?? false,
  );
}
