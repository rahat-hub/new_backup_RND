import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfCustomFonts {
  PdfCustomFonts._();

  static Future<Font> poppinsRegular() async => Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));

  static Future<Font> poppinsBold() async => Font.ttf(await rootBundle.load('assets/fonts/Poppins-Bold.ttf'));

  static Future<Font> poppinsItalic() async => Font.ttf(await rootBundle.load('assets/fonts/Poppins-Italic.ttf'));

  static Future<Font> poppinsBoldItalic() async => Font.ttf(await rootBundle.load('assets/fonts/Poppins-BoldItalic.ttf'));

  static Future<Font> materialIcons() async => Font.ttf(await rootBundle.load('assets/fonts/Material-Icons.ttf'));

  static Future<ThemeData> defaultPdfThemeData() async {
    final Font regular = await poppinsRegular();
    final Font bold = await poppinsBold();
    final Font italic = await poppinsItalic();
    final Font boldItalic = await poppinsBoldItalic();
    final Font icons = await materialIcons();

    return ThemeData.withFont(base: regular, bold: bold, italic: italic, boldItalic: boldItalic, icons: icons);
  }

  Future<TtfFont> getFont({required String fontName, AssetBundle? bundle, bool protect = false}) async {
    final String asset = 'assets/fonts/$fontName.ttf';
    //if (await AssetManifest.contains(asset)) {
    bundle ??= rootBundle;
    final ByteData data = await bundle.load(asset);
    return TtfFont(data, protect: protect);
    //}
  }
}

class PdfCustomColors {
  PdfCustomColors._();

  static PdfColor get primary => const PdfColor.fromInt(0xFF007DB8);

  static PdfColor get red => const PdfColor.fromInt(0xFFF44336);

  static PdfColor get redShade400 => const PdfColor.fromInt(0xFFEF5350);

  static PdfColor get grey => const PdfColor.fromInt(0xFF8C97A8);
}
