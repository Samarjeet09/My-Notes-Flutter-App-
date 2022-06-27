//a generic way to extract a argument from the build context

import 'package:flutter/cupertino.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
