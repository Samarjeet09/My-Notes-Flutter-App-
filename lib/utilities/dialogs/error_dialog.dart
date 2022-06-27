import 'package:flutter/cupertino.dart';
import 'generic_dialogs.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog<void>(
    context: context,
    title: "ERROR",
    content: text,
    optionBuilder: () => {
      "OK": null,
    },
  );
}
