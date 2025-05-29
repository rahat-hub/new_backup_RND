import 'dart:async';
import 'dart:io';

import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ViewPrintSavePdf extends StatelessWidget {
  const ViewPrintSavePdf({required this.pdfFile, required this.fileName, super.key, this.initialPageFormat});

  final String fileName;
  final FutureOr<Uint8List> Function(PdfPageFormat) pdfFile;
  final PdfPageFormat? initialPageFormat;

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (bool didPop, Object? result) => EasyLoading.dismiss(),
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(Get.context!).colorScheme.surface,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: InkWell(
            radius: 60,
            borderRadius: BorderRadius.circular(50),
            onTap: Get.back,
            child: DecoratedBox(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Icon(Icons.arrow_back, color: Theme.of(Get.context!).textTheme.bodyMedium!.color, size: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! + 5),
            ),
          ),
        ),
        title: Text(
          "View, Print or Save PDF",
          style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! + 3),
        ),
        centerTitle: true,
        elevation: 3,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: PdfPreview(
        build: pdfFile,
        initialPageFormat: initialPageFormat ?? PdfPageFormat.a4,
        pageFormats: const <String, PdfPageFormat>{"A4": PdfPageFormat.a4, "Letter": PdfPageFormat.letter, "Legal": PdfPageFormat.legal},
        pdfFileName: "$fileName.pdf",
        actions: <Widget>[
          PdfPreviewAction(
            icon: const Icon(Icons.save),
            onPressed: (BuildContext context, FutureOr<Uint8List> Function(PdfPageFormat) build, PdfPageFormat pageFormat) async {
              final Uint8List pdfPageData = await build(pageFormat);

              late String? path;
                  if (Platform.isAndroid) {
                    final List<Directory>? appDocumentPath = await getExternalStorageDirectories(type: StorageDirectory.documents);
                    path = appDocumentPath?.first.path;
                  } else if (Platform.isIOS || Platform.isMacOS || Platform.isWindows) {
                    final Directory appDocumentPath = await getApplicationDocumentsDirectory();
                    path = appDocumentPath.path;
                  } else {
                    throw PlatformException(code: "Unsupported Platform", message: "Platform is not supported!", details: Platform.operatingSystem);
                  }
                  final File pdfFile = File("$path/$fileName.pdf");
                  await pdfFile.writeAsBytes(pdfPageData);
                  await SnackBarHelper.openSnackBar(title: "PDF Saved", message: "PDF saved to ${path
                      ?.split("/")
                      .last} as $fileName.pdf");
                },
              ),
            ],
          ),
        ),
      );

  static Future<bool> printPdf({
    required FutureOr<Uint8List> Function(PdfPageFormat) pdfFile,
    required String fileName,
    PdfPageFormat initialPageFormat = PdfPageFormat.standard,
  }) => Printing.layoutPdf(onLayout: pdfFile, format: initialPageFormat, name: "$fileName.pdf");

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('fileName', fileName))
      ..add(ObjectFlagProperty<FutureOr<Uint8List> Function(PdfPageFormat p1)>.has('pdfFile', pdfFile))
      ..add(DiagnosticsProperty<PdfPageFormat?>('initialPageFormat', initialPageFormat));
  }
}
