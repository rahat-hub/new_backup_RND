import 'dart:async';
import 'dart:ui';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/provider/flight_operation_and_documents_api_provider.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:url_launcher/url_launcher.dart';

class FileControl {
  /// This is a private constructor.
  FileControl._();

  /// This function is used to get the file path from the API.
  /// It takes three required parameters:
  /// - fileId: The file ID as a string.
  /// - fileType: The file type as a string.
  /// - fileName: The file name as a string.
  /// It makes an API call to get the file path.
  /// If the API call is successful, it will navigate to the file view page.
  /// If the API call is unsuccessful, it will show a snack bar with an error message.
  /// It returns nothing.
  /// The file view page is a WebView page that displays the file.
  /// The file view page is defined in the routes file.
  /// The file view page takes three parameters:
  /// - fileType: The file type as a string.
  /// - fileName: The file name as a string.
  /// - filePath: The URL link as a string.
  /// The file format can be one of the following:
  /// - image
  /// - file
  /// - doc
  /// - map
  /// - unknown
  /// The path name is the file name.
  /// The URL link is the URL of the file.
  /// The URL link is constructed using the current API URL and the file path from the API.
  /// The file path from the API is stored in the data field of the API response.
  /// The file path from the API is stored in the urlOfFile field of the data field of the API response.
  /// The file path from the API is stored as a string.
  /// The file path from the API is stored as a relative path.
  /// The relative path is relative to the Downloaded_Files folder on the server.
  static Future<void> getPathAndViewFile({String? fileId, String? fileName, String fileParentFolder = "Downloaded_Files", String? fileLocation, String? calledFrom}) async {
    await LoaderHelper.loaderWithGif();
    assert(fileId != null || fileLocation != null, "Either fileId or fileLocation is Required");

    if (fileId != null) {
      final Response<dynamic> response = await FlightOperationAndDocumentsApiProvider().serveFileLocation(fileId: fileId);
      await EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final Map<String, dynamic> fileInformation = (response.data as Map<String, dynamic>)["data"];
        final String externalUrl = fileInformation["externalUrl"] ?? "";
        final String fileParentFolder = fileInformation["downloadFolder"] ?? "";
        final String fileLocation = fileInformation["urlOfFile"] ?? "";

        if (externalUrl.isNotEmpty) {
          final Uri url = Uri.parse(externalUrl);
          final bool urlLaunchAble = await canLaunchUrl(url);

          if (urlLaunchAble) {
            await DialogHelper.openCommonDialogBox(
              centerTitle: true,
              title: "External Link",
              message: "Do you want to open the external link: $externalUrl?",
              enableWidget: true,
              children: <Widget>[Text("Do you want to open the external link: $externalUrl?")],
              widgetButtonTitle: "Open Link",
              onTap: () async {
                Get.back();
                await launchUrl(url);
              },
            );
          } else {
            await SnackBarHelper.openSnackBar(isError: true, message: "Unable to Open Link: $externalUrl");
          }
        } else if (fileLocation.isNotEmpty) {
          viewFile(fileId: fileId, fileName: fileName, fileParentFolder: fileParentFolder, fileLocation: fileLocation, calledFrom: calledFrom);
        } else {
          await fileLoadingErrorDialog(errorMessage: "Error: File Location is Empty!", requestedFileId: fileId, fileName: fileName, filePath: "$fileParentFolder/$fileLocation");
        }
      } else if (response.statusCode == 400) {
        await fileLoadingErrorDialog(errorMessage: "Error: File ID is Invalid!", requestedFileId: fileId, fileName: fileName, filePath: "$fileParentFolder/$fileLocation");
      }
    } else if (fileLocation != null) {
      viewFile(fileId: fileId, fileName: fileName, fileParentFolder: fileParentFolder, fileLocation: fileLocation, calledFrom: calledFrom);
    } else {
      await fileLoadingErrorDialog(
        errorMessage: "Error: File ID or File Location Not Found.\nFile ID or File Location is Required!",
        requestedFileId: fileId,
        fileName: fileName,
        filePath: "$fileParentFolder/$fileLocation",
      );
    }
  }

  ///[fileName] or [fileId] is required
  static String viewFile({required String fileLocation, String? fileId, String? fileName, String fileParentFolder = "Downloaded_Files", String? calledFrom}) {
    assert(fileName != null || fileId != null, "Either fileName or fileId is Required");

    String newFileName = (DataUtils.isNullOrEmptyString(fileName) ? fileLocation.split("/").last : fileName!).replaceAll(RegExp('[^a-zA-Z0-9.]'), '');
    newFileName = DataUtils.isNullOrEmptyString(newFileName) ? fileId! : newFileName;
    final String currentFileType = fileType(fileName: fileLocation.split("/").last);
    final String filePath = "${UrlConstants.currentApiURL.replaceAll("dawapi", "mvc")}/$fileParentFolder/$fileLocation";

    unawaited(Get.toNamed(Routes.fileView, arguments: calledFrom, parameters: <String, String>{"fileName": newFileName, "fileType": currentFileType, "filePath": filePath}));

    return filePath;
  }

  /// This function is used to get the file type based on the file extension.
  /// It takes two optional parameters:
  /// - extension: The file extension as a string.
  /// - fileName: The file name as a string.
  /// If the extension is not provided, it will try to extract the extension from the file name.
  /// If the extension is not provided and the file name is not provided, it will return "unknown".
  /// It returns the file type as a string in lowercase.
  /// The file type can be one of the following:
  /// - image
  /// - pdf
  /// - text
  /// - document
  /// - spreadsheet
  /// - presentation
  /// - doc
  /// - map
  /// - unknown
  static String fileType({String? extension, String? fileName}) {
    final String? extensionType = extension?.replaceAll(".", "").trim() ?? fileName?.split(".").last.trim();
    switch (extensionType?.toUpperCase()) {
      case "JPG":
      case "JPEG":
      case "PNG":
      case "GIF":
      case "BMP":
        return "image";

      case "PDF":
        return "pdf";

      case "TXT":
      case "TEXT":
        return "text";

      case "DOC":
      case "DOCX":
      case "ODT":
        return "document";

      case "XLS":
      case "XLSX":
      case "ODS":
      case "CSV":
        return "spreadsheet";

      case "PPT":
      case "PPTX":
      case "ODP":
        return "presentation";

      case "POT":
      case "POTX":
        return "doc";

      case "KML":
      case "KMZ":
        return "map";

      default:
        return "unknown";
    }
  }

  static Future<void> fileLoadingErrorDialog({String? errorMessage, String? fileName, String? requestedFileId, String? filePath}) => showDialog<void>(
    useRootNavigator: false,
    context: Get.context!,
    builder: (BuildContext context) => Padding(
      padding: DeviceType.isTablet
          ? DeviceOrientation.isLandscape
                ? const EdgeInsets.fromLTRB(200, 100, 200, 100)
                : const EdgeInsets.all(50)
          : const EdgeInsets.all(5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
            side: const BorderSide(color: ColorConstants.primary, width: 2),
          ),
          title: const Text("File Loading Error!", textAlign: TextAlign.center),
          titleTextStyle: TextStyle(
            color: ThemeColorMode.isLight ? ColorConstants.black : null,
            fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 5,
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                textScaler: TextScaler.linear(Get.textScaleFactor),
                text: TextSpan(
                  text: "File Info: $fileName ($requestedFileId)\n",
                  style: TextStyle(
                    color: ThemeColorMode.isLight ? Colors.black : Colors.white,
                    fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "The resource you are looking for has been removed, renamed, or is temporarily unavailable.",
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize! + 3, fontWeight: FontWeight.normal, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SizeConstants.contentSpacing + 10),
              if (kDebugMode)
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                    text: "Requested URL: ",
                    style: TextStyle(
                      color: ThemeColorMode.isLight ? Colors.black : Colors.white,
                      fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 2,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "${UrlConstants.currentApiURL.replaceAll("dawapi", "mvc")}/$filePath",
                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize, fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: " ($errorMessage)",
                        style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.bodyMedium!.fontSize, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            ButtonConstant.dialogButton(
              title: "Close",
              borderColor: ColorConstants.grey,
              onTapMethod: () {
                Get.back(closeOverlays: true);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
