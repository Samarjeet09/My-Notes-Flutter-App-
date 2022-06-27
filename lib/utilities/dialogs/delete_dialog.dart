import 'package:flutter/cupertino.dart';
import 'package:notesapp/utilities/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "DELETE NOTE",
      content: "Are you sure you want to DELETE THIS ITEM",
      optionBuilder: () {
        return {"YES": true, "NO": false};
      }).then(
    (value) => value ?? false,
  );
}
