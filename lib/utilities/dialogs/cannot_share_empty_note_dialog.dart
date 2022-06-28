import 'package:flutter/cupertino.dart';
import 'generic_dialogs.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "UNABLE TO SHARE ",
    content: "You cannot share an EMPTY note!",
    optionBuilder: () => {
      "OK": null,
    },
  );
}
