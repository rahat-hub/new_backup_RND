import 'package:aviation_rnd/helper/helper.dart';
import 'package:flutter/services.dart';

class CopyIntoClipboard {
  CopyIntoClipboard._();

  /// Copy the given text into the clipboard
  static Future<void> copyText({required String text, String? message}) async {
    await Clipboard.setData(ClipboardData(text: text)).then((_) {
      SnackBarHelper.scaffoldSnackBar(message: "Copied $message into your clipboard!");
    });
  }
}
