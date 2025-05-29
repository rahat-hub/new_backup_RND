import 'package:flutter/widgets.dart';

class FocusWidget {
  /// Private constructor to hide the constructor.
  FocusWidget._();

  /// Primary focus node
  static FocusNode primaryFocus = FocusNode();

  ///Remove focus from current widget
  static void unFocus(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  ///Request focus to primary widget
  static void requestFocus(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.requestFocus();
    }
  }

  ///Request focus to specific widget
  static void reFocus({BuildContext? context, FocusNode? focusNode}) {
    context != null ? FocusScope.of(context).requestFocus(focusNode ?? primaryFocus) : FocusManager.instance.primaryFocus?.requestFocus(focusNode ?? primaryFocus);
  }
}
