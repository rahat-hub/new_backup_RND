import 'dart:async';
import 'dart:io';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../shared/constants/constant_colors.dart';

class FileViewLogic extends GetxController {
  late String sampleImageUrl;
  String? imageFilePath;

  late String samplePdfUrl;
  String? pdfFilePath;

  late String sampleTextUrl;
  String? textFilePath;

  late String sampleDocUrl;
  String? docFilePath;

  var isLoading = false.obs;

  final NumberPaginatorController paginationController = NumberPaginatorController();
  final Completer<PDFViewController> pdfController = Completer<PDFViewController>();
  RxInt pages = 0.obs;
  RxInt currentPage = 0.obs;
  RxBool isReady = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    await loadInitialViewData().catchError((e) async {
      Get.back();
      SnackBarHelper.openSnackBar(isError: true, title: "Error", message: "An error occurred while loading the file!");
      if (kDebugMode) {
        print("File Loading Error: $e");
      }
    });

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  ///This function is used to load the initial view data.
  loadInitialViewData() async {
    switch (Get.parameters["fileType"]) {
      case "image":
        sampleImageUrl = Get.parameters["filePath"] ?? "";

        if (sampleImageUrl.isNotEmpty) {
          await downloadAndSaveImage();
        } else {
          throw "Image URL is Empty!";
        }
        break;

      case "pdf":
        samplePdfUrl = Get.parameters["filePath"] ?? "";

        if (samplePdfUrl.isNotEmpty) {
          await downloadAndSavePdf();
        } else {
          throw "PDF URL is Empty!";
        }
        break;

      case "text":
        sampleTextUrl = Get.parameters["filePath"] ?? "";

        if (sampleTextUrl.isNotEmpty) {
          await downloadAndSaveText();
        } else {
          throw "Text URL is Empty!";
        }
        break;

      case "document":
      case "spreadsheet":
      case "presentation":
        sampleDocUrl = Get.parameters["filePath"] ?? "";

        if (sampleDocUrl.isNotEmpty) {
          await downloadAndSaveDoc();
        } else {
          throw "Document URL is Empty!";
        }
        break;
    }
  }

  Future<void> downloadAndSaveImage() async {
    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/sample.${Get.parameters["fileName"]}');

    await file.exists().then((value) async {
      if (value) await file.delete();
    });

    final response = await http.get(Uri.parse(sampleImageUrl));

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      imageFilePath = file.path;
    } else {
      throw "Image Loading Error ${response.statusCode}";
    }
  }

  Future<void> downloadAndSavePdf() async {
    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/sample.${Get.parameters["fileName"]}');

    await file.exists().then((value) async {
      if (value) await file.delete();
    });

    final response = await http.get(Uri.parse(samplePdfUrl));

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      pdfFilePath = file.path;
    } else {
      throw "Pdf Loading Error ${response.statusCode}";
    }
  }

  Future<void> downloadAndSaveText() async {
    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/sample.${Get.parameters["fileName"]}');

    await file.exists().then((value) async {
      if (value) await file.delete();
    });

    final response = await http.get(Uri.parse(sampleTextUrl));

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      textFilePath = file.path;
    } else {
      throw "Text Loading Error ${response.statusCode}";
    }
  }

  Future<void> downloadAndSaveDoc() async {
    late String? dir;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
      dir = directory?.first.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      dir = directory.path;
    } else {
      throw "Platform is not supported!";
    }
    final file = File("$dir/${Get.parameters["fileName"]}.${Get.parameters["filePath"]?.split(".").last}");

    await file.exists().then((value) async {
      if (value) await file.delete();
    });

    final response = await http.get(Uri.parse(sampleDocUrl));

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes, flush: true);
      docFilePath = file.path;

      if (!Platform.isAndroid || await Permission.manageExternalStorage.isGranted) {
        await OpenFile.open(docFilePath, isIOSAppOpen: Platform.isIOS).then((value) {
          if (value.type.name == "noAppToOpen") {
            SnackBarHelper.openSnackBar(isError: true, message: "No application found to open this file");
          }
        });
      } else {
        PermissionHelper.storagePermissionAccess();
      }
    } else {
      throw "Document Loading Error ${response.statusCode}";
    }
  }

  viewFile() {
    switch (Get.parameters["fileType"]) {
      case "image":
        return loadIMAGEView();

      case "pdf":
        return pdfFilePath != null ? loadNewPDFView(pdfFilePath!) : const Text("PDF is not Loaded!");

      case "text":
        return textFilePath != null ? loadTextView(textFilePath!) : const Text("Text is not Loaded!");

      case "document":
      case "spreadsheet":
      case "presentation":
        return docFilePath != null ? loadDocumentsView(Get.parameters["fileType"]) : const Text("Document is not Loaded!");

      default:
        return loadDefaultView(Get.parameters["fileType"]);
    }
  }

  ///IMAGE_VIEWER
  loadIMAGEView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: SizeConstants.contentSpacing + 10),
        imageFilePath != null
            ? Expanded(
              child: InteractiveViewer(
                child: Center(
                  child: Image.file(
                    File(imageFilePath!),
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => frame != null ? child : const CircularProgressIndicator(),
                  ),
                ),
              ),
            )
            : const Center(child: Text("Image is not Loaded!", style: TextStyle(fontSize: 20.0))),
        const SizedBox(height: SizeConstants.contentSpacing + 10),
      ],
    );
  }

  ///PDF_VIEWER
  loadNewPDFView(String pdfFilePath) {
    return Obx(() {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 50.0),
            child: PDFView(
              filePath: pdfFilePath,
              defaultPage: currentPage.value,
              fitPolicy: FitPolicy.BOTH,
              backgroundColor: Theme.of(Get.context!).colorScheme.surface,
              onRender: (page) {
                pages.value = page ?? 0;
                isReady.value = true;
              },
              onError: (error) {
                errorMessage.value = error.toString();
              },
              onPageError: (page, error) {
                errorMessage.value = '$page: ${error.toString()}';
              },
              onViewCreated: (PDFViewController pdfViewController) {
                if (!pdfController.isCompleted) {
                  pdfController.complete(pdfViewController);
                }
              },
              onPageChanged: (int? page, int? total) {
                currentPage.value = page ?? 0;
                paginationController.currentPage = page ?? 0;
              },
            ),
          ),
          errorMessage.isEmpty
              ? !isReady.value
                  ? const Center(child: CircularProgressIndicator())
                  : Container()
              : Center(child: Text(errorMessage.value)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 280,
              decoration: BoxDecoration(color: ColorConstants.yellow, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 5), child: Text("Page : ", textAlign: TextAlign.center)),
                  Obx(() {
                    return pages.value > 1
                        ? Flexible(
                          child: NumberPaginator(
                            controller: paginationController,
                            numberPages: pages.value,
                            child: const SizedBox(height: 48, child: Row(children: [PrevButton(), Flexible(child: DropDownContent()), NextButton()])),
                            onPageChange: (index) async {
                              if (index != currentPage.value) {
                                pdfController.future.then((value) => value.setPage(index));
                              }
                            },
                          ),
                        )
                        : const Text("1   of   1  ", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0));
                  }),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  /*FutureBuilder<PDFDocument> loadOldPDFView(String pdfFilePath) {
    return FutureBuilder(
      future: PDFDocument.fromFile(File(pdfFilePath)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("Error Loading PDF: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return PDFViewer(document: snapshot.requireData);
          }
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Center(child: Text("PDF is not Loaded!"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }*/

  ///TEXT_VIEWER
  loadTextView(String textFilePath) {
    return FutureBuilder(
      future: File(textFilePath).readAsString(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("Error Loading Text: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(10.0), child: Text(snapshot.data.toString())))],
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Center(child: Text("Text is not Loaded!"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  ///DOCUMENT_VIEWER
  loadDocumentsView(String? fileType) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text("Choose or install an office application to open the $fileType:"));
  }

  ///DEFAULT_VIEWER
  loadDefaultView(String? fileType) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text("${fileType?.capitalizeFirst ?? "Current"} File Viewer is not implemented yet!"));
  }
}
