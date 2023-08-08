import 'package:flutter/material.dart';
import 'package:messenger/widgets/loading_widget.dart';

class Utilities {
  static bool isKeyboardShowing() {
    return WidgetsBinding.instance.window.viewInsets.bottom > 0;
  }

  static closeKeyboard(BuildContext context) {
    if (isKeyboardShowing()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }
}

void showWaitingDialog(BuildContext context, Function() function) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 48,
        height: 48,
        child: LoadingWidget(),
      ),
    ),
  );

  await function();

  Navigator.pop(context);
}
