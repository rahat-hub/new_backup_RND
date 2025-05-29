import 'dart:math';

import 'package:aviation_rnd/helper/loader_helper.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../helper/pdf_helper.dart';
import '../../../../helper/snack_bar_helper.dart';
import '../../../../provider/forms_api_provider.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/form_widgets.dart';
import '../view_user_form_logic.dart';

class ViewUserFormTopBottomLayers {
  Widget topLayerCard(ViewUserFormLogic controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: Colors.blue[300],
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  textScaler: TextScaler.linear(Get.textScaleFactor),
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                    ),
                    children: [
                      const TextSpan(text: "Created By: "),
                      TextSpan(text: controller.formsViewDetails["userNameCreated"], style: const TextStyle(fontWeight: FontWeight.w500)),
                      const TextSpan(text: " At "),
                      TextSpan(text: controller.formsViewDetails["createdAt"], style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                controller.formsViewDetails["completedBy"] == 0
                    ? Wrap(
                      children: [
                        Text("Status: ", style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3)),
                        Material(
                          color: ColorConstants.primary,
                          borderRadius: BorderRadius.circular(5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "In Progress",
                              style: TextStyle(color: ColorConstants.white, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                            ),
                          ),
                        ),
                      ],
                    )
                    : RichText(
                      textScaler: TextScaler.linear(Get.textScaleFactor),
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3,
                          color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                        ),
                        children: [
                          const TextSpan(text: "Completed By: "),
                          TextSpan(text: controller.formsViewDetails["userNameCompleted"], style: const TextStyle(fontWeight: FontWeight.w500)),
                          const TextSpan(text: " At "),
                          TextSpan(text: controller.formsViewDetails["completedAt"], style: const TextStyle(fontWeight: FontWeight.w500)),
                          controller.formsViewDetails["completedIpAddress"] != ""
                              ? TextSpan(text: " [IP Address: ${controller.formsViewDetails["completedIpAddress"]}]")
                              : const TextSpan(),
                        ],
                      ),
                    ),
                if (controller.formsViewDetails["denialReason"] != "")
                  RichText(
                    textScaler: TextScaler.linear(Get.textScaleFactor),
                    text: TextSpan(
                      style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.black),
                      children: [
                        const TextSpan(text: "Denial Reason: "),
                        TextSpan(text: controller.formsViewDetails["denialReason"], style: const TextStyle(color: ColorConstants.red, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ) /*: const SizedBox.shrink(),*/,
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: InkWell(
            onTap: () async {},
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              color: Colors.blue[400],
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.formsViewDetails["formHasRouting"] == 1 || controller.formsViewDetails["canAdvance"] == 1 || controller.formsViewDetails["canDemote"] == 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (controller.formsViewDetails["formHasRouting"] == 1)
                                GeneralMaterialButton(
                                  buttonText:
                                      "View Routing ( ${controller.formsViewDetails["routingComplete"] == 1 ? "Completed" : " ${controller.formsViewDetails["routingLevelCurrent"]} of ${controller.formsViewDetails["routingLevelMax"]} "} )",
                                  icon: Icons.library_books_outlined,
                                  lrPadding: 5.0,
                                  onPressed: () async {
                                    LoaderHelper.loaderWithGif();
                                    await controller.viewRouting(strFormId: Get.parameters["formId"] ?? controller.lastViewedFormId);
                                    EasyLoading.dismiss();
                                  },
                                ),
                              if (controller.formsViewDetails["canAdvance"] == 1 || controller.formsViewDetails["canDemote"] == 1)
                                GeneralMaterialButton(
                                  buttonText: "Approve / Demote Routing",
                                  icon: Icons.arrow_forward_outlined,
                                  lrPadding: 5.0,
                                  onPressed: () async {
                                    controller.viewUserFormInputControllers[controller.viewUserFormAllData["formId"].toString()]?.clear();
                                    controller.viewUserFormInputControllers["routingNote"]?.clear();
                                    LoaderHelper.loaderWithGif();
                                    await controller.advanceRouting(
                                      strFormId: Get.parameters["formId"] ?? controller.lastViewedFormId,
                                      controller: controller.viewUserFormInputControllers.putIfAbsent(
                                        controller.viewUserFormAllData["formId"].toString(),
                                        () => TextEditingController(),
                                      ),
                                      notesController: controller.viewUserFormInputControllers.putIfAbsent("routingNote", () => TextEditingController()),
                                      userName: UserSessionInfo.userFullName,
                                      userDropDownData: controller.userDropDownData,
                                      selectedUserData: controller.selectedUserData,
                                      onDialogPopUp: () async {
                                        controller.userDropDownData.clear();
                                        controller.selectedUserData.clear();
                                        Response response = await controller.formsApiProvider.generalAPICall(
                                          apiCallType: "POST",
                                          url: "/forms/getElectronicSignFormData",
                                          postData: {
                                            "systemId": UserSessionInfo.systemId.toString(),
                                            "userId": UserSessionInfo.userId.toString(),
                                            "formId": Get.parameters["formId"].toString(),
                                            "fieldId": "",
                                          },
                                        );
                                        if (response.statusCode == 200 /*&& response.data["data"].isNotEmpty*/ ) {
                                          controller.userDropDownData.addAll(response.data["data"]["electronicSignatureFormData"]["objPersonnelList"]);
                                        }
                                      },
                                      onChangedUser: (value) {
                                        controller.selectedUserData.value = value;
                                      },
                                      onTapSignForm: () async {
                                        Keyboard.close(context: context);
                                        LoaderHelper.loaderWithGif();
                                        await controller
                                            .performSignatureValidation(
                                              userID: controller.selectedUserData["id"],
                                              password: controller.viewUserFormInputControllers[controller.viewUserFormAllData["formId"].toString()]?.text,
                                            )
                                            .then((value) async {
                                              if (value) {
                                                Get.back();
                                                Get.back();
                                                EasyLoading.dismiss();
                                                controller.getInitialViewUserFormData(reload: true);
                                              }
                                            });
                                        EasyLoading.dismiss();
                                        controller.viewUserFormInputControllers[controller.viewUserFormAllData["formId"].toString()]?.clear();
                                        controller.viewUserFormInputControllers["routingNote"]?.clear();
                                      },
                                    );
                                    EasyLoading.dismiss();
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (postProcessingReports(controller, context).isNotEmpty)
                      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: postProcessingReports(controller, context))),
                    if (controller.formsViewDetails["allowAttachments"] ?? false)
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Obx(() {
                            return Text(
                              "Attachments: (${controller.formAttachmentFiles.length})",
                              style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3, color: ColorConstants.white),
                            );
                          }),
                          GeneralMaterialButton(
                            buttonText: "Add Attachment",
                            buttonColor: ColorConstants.button,
                            borderColor: ColorConstants.primary,
                            icon: Icons.file_present,
                            //lrPadding: 5.0,
                            onPressed: () {
                              var reload = Get.toNamed(Routes.fileUpload, arguments: "addAttachment", parameters: Get.parameters as Map<String, String>);

                              reload?.then((value) async {
                                if (value != null && value == true) {
                                  await controller.getInitialViewUserFormData(reload: true);
                                }
                              });
                            },
                          ),
                          if (DeviceType.isMobile && controller.formAttachmentFiles.isNotEmpty)
                            Obx(() {
                              return InkWell(
                                onTap: () {
                                  controller.showMore.value = !controller.showMore.value;
                                },
                                child:
                                    controller.showMore.value
                                        ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Hide Attachments",
                                              style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                                            ),
                                            Icon(Icons.arrow_upward, color: ColorConstants.white, size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3),
                                          ],
                                        )
                                        : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Show Attachments",
                                              style: TextStyle(color: ColorConstants.white, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                                            ),
                                            Icon(Icons.arrow_downward, color: ColorConstants.white, size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3),
                                          ],
                                        ),
                              );
                            }),
                        ],
                      ),
                    if (controller.formsViewDetails["allowAttachments"] ?? false)
                      Obx(() {
                        return controller.showMore.value || DeviceType.isTablet || DeviceType.isDesktop
                            ? GridView.builder(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              shrinkWrap: true,
                              itemCount: controller.formAttachmentFiles.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    Get.width > 480
                                        ? Get.width > 980
                                            ? 6
                                            : 4
                                        : 2,
                                mainAxisExtent: 30.0,
                                mainAxisSpacing: 5.0,
                                crossAxisSpacing: 5.0,
                              ),
                              itemBuilder:
                                  (context, index) => GeneralMaterialButton(
                                    buttonText: "Attachment ${index + 1}",
                                    icon:
                                        FileControl.fileType(fileName: controller.formAttachmentFiles[index]["fileName"]) == "image"
                                            ? Icons.image
                                            : FileControl.fileType(fileName: controller.formAttachmentFiles[index]["fileName"]) == "pdf"
                                            ? Icons.picture_as_pdf
                                            : FileControl.fileType(fileName: controller.formAttachmentFiles[index]["fileName"]) == "doc"
                                            ? Icons.text_snippet
                                            : Icons.file_present,
                                    onPressed: () async {
                                      await FileControl.getPathAndViewFile(
                                        fileId: controller.formAttachmentFiles[index]["id"].toString(),
                                        fileName: controller.formAttachmentFiles[index]["id"].toString(),
                                      );
                                    },
                                  ),
                            )
                            : const SizedBox();
                      }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> postProcessingReports(ViewUserFormLogic controller, BuildContext context) {
    List<String> hirReportFields = ["327409", "328043", "328109", "328177", "328243", "328311", "328377", "328445", "328511", "328579", "328645", "328713"];

    List<Widget> postProcessingReportButtons = <Widget>[
      if (((controller.viewUserFormData["completed"] ?? false) &&
              (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) > 0 &&
              (controller.formsViewDetails["emailToListWhenCompleted"] ?? "") != "") ||
          Get.parameters["masterFormId"] == "408") ...{
        if (Get.parameters["masterFormId"] == "408")
          GeneralMaterialButton(
            buttonText: "Send Pre-Completion Notification",
            icon: Icons.send_rounded,
            lrPadding: 5.0,
            onPressed: () async {
              LoaderHelper.loaderWithGif();
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "NCHPManualSend",
              );
              if (response.statusCode == 200 && response.data["userMessage"] != "") {
                SnackBarHelper.openSnackBar(isError: false, title: "Send Pre-Completion Notification", message: response.data["userMessage"]);
              }
              EasyLoading.dismiss();
            },
          ),
        if ((controller.viewUserFormData["completed"] ?? false) &&
            (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) > 0 &&
            (controller.formsViewDetails["emailToListWhenCompleted"] ?? "") != "")
          GeneralMaterialButton(
            buttonText: "Re-Send Report Email To Subscribed Users",
            icon: Icons.mail_outline,
            lrPadding: 5.0,
            onPressed: () async {
              LoaderHelper.loaderWithGif();
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "EmailFormToUsersSubscribedToForm",
              );
              if (response.statusCode == 200 && response.data["userMessage"] != "") {
                SnackBarHelper.openSnackBar(isError: false, title: "Re-Send Report Email To Subscribed Users", message: response.data["userMessage"]);
              }
              EasyLoading.dismiss();
            },
          ),
      },
      //Check For Laser Strike URL
      if ((controller.viewUserFormData["faaLaserStrikeURL"] ?? "") != "")
        GeneralMaterialButton(
          buttonText: "Re-Submit FAA Laser Report",
          icon: Icons.play_arrow,
          lrPadding: 5.0,
          onPressed: () async {
            Uri url = Uri.parse(controller.viewUserFormData["faaLaserStrikeURL"] ?? "");
            var urlLaunchAble = await canLaunchUrl(url);
            if (urlLaunchAble) {
              await launchUrl(url);
            } else {
              SnackBarHelper.openSnackBar(isError: true, message: "FAA Laser Strike URL can't be Launched.");
            }
          },
        ),
      if ((controller.formsViewDetails["completedAt"] != "1/1/1900 00:00") && (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) > 0) ...{
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 18 &&
            (controller.viewUserFormData["titleReGenerateLink"] ?? "") != "") //--Maricopa County Sheriffs Office ( Mcso Dfl )
          GeneralMaterialButton(
            buttonText: "Re-Generate ${controller.viewUserFormData["titleReGenerateLink"]}",
            icon: Icons.analytics_outlined,
            lrPadding: 5.0,
            onPressed: () async {
              await LoaderHelper.loaderWithGif();
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "EmailFormSarAndShiftSummaries",
              );
              if (response.statusCode == 200) {
                Map reportsData = response.data["data"] ?? {};
                List<String> userMessage = response.data["userMessage"].toString().split("||");

                String formId = (reportsData["formId"] ?? controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString();
                String? systemDateTime = reportsData["systemDateTime"];
                int tableFontSize = reportsData["tableFontSize"] ?? 12;

                List<Map<String, dynamic>> maricopaGenerateShiftSummaryForPDF = reportsData["objMaricopaGenerateShiftSummaryForPDFList"]?.cast<Map<String, dynamic>>() ?? [];
                List<Map<String, dynamic>> maricopaGenerateSARReportForPDFData = reportsData["objMaricopaGenerateSARReportForPDF"]?.cast<Map<String, dynamic>>() ?? [];

                int count = 1;

                ///Shift Summary Report
                for (int i = 0; i < maricopaGenerateShiftSummaryForPDF.length; i++) {
                  await LoaderHelper.loaderWithGifAndText("Sending Shift Summary Report #${count++}");
                  String title = maricopaGenerateShiftSummaryForPDF[i]["emailSubject"];
                  String emailTo = maricopaGenerateShiftSummaryForPDF[i]["emailToList"];
                  String emailBody = maricopaGenerateShiftSummaryForPDF[i]["emailBody"];
                  String emailBodyParse = maricopaGenerateShiftSummaryForPDF[i]["emailBodyParse"];

                  Response pdfResponse = await FormsApiProvider().postPdfProcessingReport(
                    formId: formId,
                    createdAt: systemDateTime,
                    tableFontSize: tableFontSize.toString(),
                    title: title,
                    emailRecipient: emailTo,
                    contentMessage: emailBody,
                    contentData: emailBodyParse,
                  );

                  if (pdfResponse.statusCode == 200) {
                    Map pdfResponseData = pdfResponse.data["data"];

                    await FormsApiProvider().postEmailProcessingReport(
                      formId: formId,
                      fileName: pdfResponseData["fileName"],
                      subject: pdfResponseData["subject"],
                      address: pdfResponseData["address"],
                    );
                  }

                  await EasyLoading.dismiss();
                }

                ///SAR Report
                for (int i = 0; i < maricopaGenerateSARReportForPDFData.length; i++) {
                  await LoaderHelper.loaderWithGifAndText("Sending SAR Report #${count++}");
                  String title = "SAR Report Generated";
                  String emailTo = maricopaGenerateSARReportForPDFData[i]["emailRecipient"];
                  String emailBody = maricopaGenerateSARReportForPDFData[i]["emailBody"];
                  String emailBodyParse = maricopaGenerateSARReportForPDFData[i]["emailBodyParse"];

                  Response pdfResponse = await FormsApiProvider().postPdfProcessingReport(
                    formId: formId,
                    createdAt: systemDateTime,
                    tableFontSize: tableFontSize.toString(),
                    title: title,
                    emailRecipient: emailTo,
                    contentMessage: emailBody,
                    contentData: emailBodyParse,
                  );

                  if (pdfResponse.statusCode == 200) {
                    Map pdfResponseData = pdfResponse.data["data"];

                    await FormsApiProvider().postEmailProcessingReport(
                      formId: formId,
                      fileName: pdfResponseData["fileName"],
                      subject: pdfResponseData["subject"],
                      address: pdfResponseData["address"],
                    );
                  }

                  await EasyLoading.dismiss();
                }

                await SnackBarHelper.openSnackBar(isError: !userMessage[2].contains("success"), title: userMessage[1].trim(), message: userMessage.first.trim());
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 28 &&
            (controller.viewUserFormData["formFieldIdTEXASDPS"] ?? 0) != 0) //--TEXAS DPS ( Flight Entry Form )
          GeneralMaterialButton(
            buttonText: "Re-Generate SAR Report",
            icon: Icons.analytics_outlined,
            lrPadding: 5.0,
            onPressed: () async {
              await LoaderHelper.loaderWithGifAndText("Generating SAR Report....");
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "EmailFormSarAndShiftSummaries",
              );
              if (response.statusCode == 200) {
                Map reportsData = response.data["data"] ?? {};
                List<String> userMessage = response.data["userMessage"].toString().split("||");

                String formId = (reportsData["formId"] ?? controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString();
                String? systemDateTime = reportsData["systemDateTime"];
                int? tableFontSize = reportsData["tableFontSize"];
                String? title = reportsData["reportTitle"];
                String? emailToList = reportsData["emailList"];
                String? emailNameList = reportsData["emailNameList"];
                String? message = reportsData["contentMessageList"].isNotEmpty ? reportsData["contentMessageList"][0] : null;
                String? body = reportsData["body"];

                await LoaderHelper.loaderWithGifAndText("Sending To: $emailNameList");

                ///SAR Report
                await Future.delayed(const Duration(seconds: 2), () async {
                  Response pdfResponse = await FormsApiProvider().postPdfProcessingReport(
                    formId: formId,
                    createdAt: systemDateTime,
                    tableFontSize: tableFontSize?.toString(),
                    title: title,
                    emailRecipient: emailToList,
                    contentMessage: message,
                    contentData: body,
                  );

                  if (pdfResponse.statusCode == 200) {
                    Map pdfResponseData = pdfResponse.data["data"];

                    await FormsApiProvider().postEmailProcessingReport(
                      formId: formId,
                      fileName: pdfResponseData["fileName"],
                      subject: pdfResponseData["subject"],
                      address: pdfResponseData["address"],
                    );
                  }
                });

                await EasyLoading.dismiss();

                await SnackBarHelper.openSnackBar(isError: !userMessage[2].contains("success"), title: userMessage[1].trim(), message: userMessage.first.trim());
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 66) //--NYPD Aviation Unit ( All Forms - NYPD AVIATION - AU2 )
          GeneralMaterialButton(
            buttonText: "Generate Flight Data Sheet",
            icon: Icons.search,
            lrPadding: 5.0,
            onPressed: () async {
              //EasyLoading.show(status: "Generating Flight Data Sheet....");
              LoaderHelper.loaderWithGifAndText("Generating Flight Data Sheet....");
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "EmailNypdFlightDataSheet",
              );
              if (response.statusCode == 200) {
                Map<String, dynamic>? postProcessingAllData = response.data["data"] as Map<String, dynamic>?;
                Map<String, dynamic>? nypdFlightDataSheetReportData = postProcessingAllData?["objNYPDFlightDataSheetReportVW"] as Map<String, dynamic>?;
                String fileTitle = "Flight Data Sheet (${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]})";
                String outputFileName = "${fileTitle}_${DateFormat('MM-dd-yyyy_HH-mm-ss').format(DateTimeHelper.now)}_${Random().nextInt(100000000)}".replaceAll(" ", "_");

                await EasyLoading.dismiss();
                if (response.data["userMessage"] != "") {
                  SnackBarHelper.openSnackBar(isError: false, title: "Generate Flight Data Sheet", message: response.data["userMessage"]);
                }
                if (nypdFlightDataSheetReportData?["formId"] != 0) {
                  Get.to(
                    () => ViewPrintSavePdf(
                      pdfFile:
                          (pageFormat) => postFormProcessingEmailReport394(
                            pageFormat: pageFormat,
                            strTitle: fileTitle,
                            formIDForAttachments: "${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]}",
                            createdAt: DateTimeHelper.dateTimeFormatDefault.format(DateTimeHelper.now).toString(),
                            createdBy: UserSessionInfo.userFullName,
                            dataPost: nypdFlightDataSheetReportData,
                            dataFlights: nypdFlightDataSheetReportData?["objNYPDFlightDataSheetDetailsVWList"] as List<dynamic>?,
                          ),
                      initialPageFormat: PdfPageFormat.a4.landscape,
                      fileName: outputFileName,
                    ),
                  );
                }
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 79 &&
            (controller.viewUserFormData["formFieldIdBSO"] ?? 0) != 0) //--Broward Sheriffs Office ( Daily Mission Report )
          GeneralMaterialButton(
            buttonText: "Email Significant Report",
            icon: Icons.analytics_outlined,
            lrPadding: 5.0,
            onPressed: () async {
              await LoaderHelper.loaderWithGif();
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "BrowardSignificantReport",
              );
              await EasyLoading.dismiss();
              if (response.statusCode == 200 && (response.data["userMessage"] ?? "").isNotEmpty) {
                List<String> userMessage = response.data["userMessage"].split("||");
                await SnackBarHelper.openSnackBar(isError: !userMessage[2].contains("success"), title: userMessage[1].trim(), message: userMessage.first.trim());
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 81 &&
            (controller.viewUserFormData["formFieldIdTEXASDPSUAS"] ?? 0) != 0 &&
            (controller.viewUserFormData["titleReGenerateLinkTXDPSUAS"] ?? "") != "") //--TXDPS UAS
          GeneralMaterialButton(
            buttonText: "Re-Generate ${controller.viewUserFormData["titleReGenerateLinkTXDPSUAS"]}",
            icon: Icons.analytics_outlined,
            lrPadding: 5.0,
            onPressed: () async {
              LoaderHelper.loaderWithGif();
              Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                saveAndComplete: "0",
                alreadyCompleted: "1",
                optionalAction: "EmailFormSarAndShiftSummaries",
              );
              if (response.statusCode == 200) {
                LoaderHelper.loaderWithGifAndText("Sending ${controller.viewUserFormData["titleReGenerateLinkTXDPSUAS"]} #${response.data["data"]["count"]}");
                await Future.delayed(const Duration(seconds: 3), () {
                  EasyLoading.dismiss();
                  if (response.data["userMessage"] != "") {
                    SnackBarHelper.openSnackBar(
                      isError: false,
                      title: "Re-Generate ${controller.viewUserFormData["titleReGenerateLinkTXDPSUAS"]}",
                      message: response.data["userMessage"],
                    );
                  }
                });
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) ==
            106) /*&&(controller.viewUserFormData["formType"] ?? Get.parameters["masterFormId"]) == 788*/ //--Tennessee Highway Patrol ( All Forms -INCIDENT REPORT )
          GeneralMaterialButton(
            buttonText: "Regular Incident Report",
            icon: Icons.analytics_outlined,
            lrPadding: 5.0,
            onPressed: () async {
              RxList<dynamic>? selectCallListDropDownData = <dynamic>[].obs;
              RxList<dynamic>? crewMembersDropDownData = <dynamic>[].obs;
              RxList<dynamic>? supplementsDropDownData = <dynamic>[].obs;

              String? selectedCall = "0";
              String? selectedCrewMembers = "0";
              String? selectedSupplements = "0";

              Response response = await FormsApiProvider().thpIncidentReport(fillOutFormId: controller.viewUserFormData["formId"] ?? Get.parameters["formId"]);
              if (response.statusCode == 200) {
                var thpIncidentReportAllData = response.data["data"];
                selectCallListDropDownData.addAll(thpIncidentReportAllData["thpIrCallList"]);
                selectCallListDropDownData.sort((a, b) => a["id"].compareTo(b["id"]));
                crewMembersDropDownData.addAll(thpIncidentReportAllData["thpIrTrnCrewList"]);
                supplementsDropDownData.addAll(thpIncidentReportAllData["thpIrSupplementList"]);

                controller.viewUserFormInputControllers["selectCall"]?.text = "-- Select Call --";
                controller.viewUserFormInputControllers["includeTrainingCrewMembers"]?.text = "No";
                controller.viewUserFormInputControllers["includeSupplements"]?.text = "No";

                FormWidgets.formDialogBox(
                  dialogTitle: "Regular Incident Report",
                  titleColor: ColorConstants.black,
                  actionButtonTitle: "Generate Call Report",
                  actionButtonIcon: Icons.analytics_outlined,
                  actionButtonColor: ColorConstants.white,
                  actionButtonTitleColor: ColorConstants.black,
                  onActionButton: () async {
                    String outputFileName =
                        "Regular_Incident_Report_(${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]})_${DateFormat('MM-dd-yyyy_HH-mm-ss').format(DateTimeHelper.now)}_${Random().nextInt(100000000)}";

                    controller.viewUserFormValidator["selectCall"]?.currentState?.save();
                    if (controller.viewUserFormValidator["selectCall"]?.currentState?.validate() ?? false) {
                      Get.back();

                      Response response = await FormsApiProvider().thpIncidentReport(
                        fillOutFormId: "${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]}",
                        leg: selectedCall,
                        trnCrew: selectedCrewMembers,
                        supp: selectedSupplements,
                      );
                      if (response.statusCode == 200) {
                        var thpIncidentReportData = response.data["data"]["formThpIncidentReport"];
                        Get.to(
                          () => ViewPrintSavePdf(
                            pdfFile:
                                (pageFormat) => tennesseeHighwayPatrolIncidentReport(
                                  pageFormat: pageFormat,
                                  formID: "${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]}",
                                  leg: selectedCall,
                                  trnCrew: selectedCrewMembers,
                                  supp: selectedSupplements,
                                  incidentReportData: thpIncidentReportData,
                                ),
                            initialPageFormat: PdfPageFormat.a4.landscape,
                            fileName: outputFileName,
                          ),
                        );
                      }
                    }
                  },
                  children: [
                    FormWidgets.formDynamicDropDown(
                      title: "Select Call",
                      dropDownController: controller.viewUserFormInputControllers.putIfAbsent("selectCall", () => TextEditingController(text: "-- Select Call --")),
                      req: true,
                      dropDownValidationKey: controller.viewUserFormValidator.putIfAbsent("selectCall", () => GlobalKey<FormFieldState>()),
                      expands: true,
                      dropDownData: selectCallListDropDownData,
                      dropDownKey: "name",
                      onSelected: (value) {
                        selectedCall = value["id"].toString();
                      },
                    ),
                    FormWidgets.formDynamicDropDown(
                      title: "Include Training Crew Members",
                      dropDownController: controller.viewUserFormInputControllers.putIfAbsent("includeTrainingCrewMembers", () => TextEditingController(text: "No")),
                      expands: true,
                      dropDownData: crewMembersDropDownData,
                      dropDownKey: "name",
                      onSelected: (value) {
                        selectedCrewMembers = value["id"].toString();
                      },
                    ),
                    FormWidgets.formDynamicDropDown(
                      title: "Include Supplements",
                      dropDownController: controller.viewUserFormInputControllers.putIfAbsent("includeSupplements", () => TextEditingController(text: "No")),
                      expands: true,
                      dropDownData: supplementsDropDownData,
                      dropDownKey: "name",
                      onSelected: (value) {
                        selectedSupplements = value["id"].toString();
                      },
                    ),
                  ],
                );
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 98 &&
            (controller.viewUserFormData["completed"] ?? false) &&
            (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) > 0 &&
            (controller.viewUserFormData["formType"] ?? Get.parameters["masterFormId"]) == 893) //--COLUMBUS POLICE DEPARTMENT ( PATROL LOG )
          GeneralMaterialButton(
            buttonText: "Incident Report",
            icon: Icons.analytics_outlined,
            lrPadding: 5.0,
            onPressed: () async {
              RxList<dynamic>? selectCallListDropDownData = <dynamic>[].obs;
              String selectedCall = "1";

              Response response = await FormsApiProvider().cpIncidentReport(
                fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                leg: selectedCall,
              );
              if (response.statusCode == 200) {
                var thpIncidentReportAllData = response.data["data"];
                selectCallListDropDownData.addAll(thpIncidentReportAllData["callNumList"]);
                selectCallListDropDownData.sort((a, b) => int.parse(a["id"].toString()).compareTo(int.parse(b["id"].toString())));

                controller.viewUserFormInputControllers["selectCall"]?.text = "Call #1";

                FormWidgets.formDialogBox(
                  dialogTitle: "Generate Incident Report",
                  titleColor: ColorConstants.black,
                  actionButtonTitle: "Generate Incident Report",
                  actionButtonIcon: Icons.analytics_outlined,
                  actionButtonColor: ColorConstants.white,
                  actionButtonTitleColor: ColorConstants.black,
                  onActionButton: () async {
                    String outputFileName =
                        "Incident_Report_(${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]})_${DateFormat('MM-dd-yyyy_HH-mm-ss').format(DateTimeHelper.now)}_${Random().nextInt(100000000)}";

                    Get.back();
                    Response response = await FormsApiProvider().cpIncidentReport(
                      fillOutFormId: "${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]}",
                      leg: selectedCall,
                    );
                    if (response.statusCode == 200) {
                      var cpIncidentReportData = response.data["data"]["columbousPoliceIncidentReport"];
                      Get.to(
                        () => ViewPrintSavePdf(
                          pdfFile:
                              (pageFormat) => columbusPoliceIncidentReport(
                                pageFormat: pageFormat,
                                id: "${controller.viewUserFormData["formId"] ?? Get.parameters["formId"]}",
                                leg: selectedCall,
                                incidentReportData: cpIncidentReportData,
                              ),
                          initialPageFormat: PdfPageFormat.a4.landscape,
                          fileName: outputFileName,
                        ),
                      );
                    }
                  },
                  children: [
                    FormWidgets.formDynamicDropDown(
                      title: "Select Call",
                      dropDownController: controller.viewUserFormInputControllers.putIfAbsent("selectCall", () => TextEditingController(text: "Call #1")),
                      expands: true,
                      dropDownData: selectCallListDropDownData,
                      dropDownKey: "name",
                      onSelected: (value) {
                        selectedCall = value["id"].toString();
                      },
                    ),
                  ],
                );
              }
            },
          ),
        if ((controller.viewUserFormData["systemId"] ?? UserSessionInfo.systemId) == 120 &&
            (controller.viewUserFormData["completed"] ?? false) &&
            (controller.viewUserFormData["formType"] ?? Get.parameters["masterFormId"]) == 853 &&
            (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) > 0) //--PRINCE GEORGES AVIATION ( AVIATION DAILY )
          if (hirReportFields.any((element) => controller.formFieldValues[element] == "on"))
            GeneralMaterialButton(
              buttonText: "Re-Generate HIR Report",
              icon: Icons.analytics_outlined,
              lrPadding: 5.0,
              onPressed: () async {
                await LoaderHelper.loaderWithGif();
                Response response = await FormsApiProvider().formDesignerPostProcessingReports(
                  fillOutFormId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                  saveAndComplete: "0",
                  alreadyCompleted: "1",
                  optionalAction: "",
                );
                if (response.statusCode == 200) {
                  await LoaderHelper.loaderWithGifAndText("Sending HIR #${response.data["data"]["count"]}");
                  Response emailResponse = await FormsApiProvider().postEmailProcessingPrinceGeorgeReport(
                    formId: (controller.viewUserFormData["formId"] ?? Get.parameters["formId"]).toString(),
                    fileName: response.data["data"]["fileName"],
                    subAction: "PgcSendHirPdfs",
                  );
                  await EasyLoading.dismiss();
                  if (emailResponse.data["userMessage"] != "") {
                    SnackBarHelper.openSnackBar(isError: false, title: "Re-Generate HIR Report", message: emailResponse.data["userMessage"]);
                  }
                }
              },
            ),
      },
    ];

    return postProcessingReportButtons;
  }

  Future<Uint8List> postFormProcessingEmailReport394({
    PdfPageFormat? pageFormat,
    String? strTitle,
    String? formIDForAttachments,
    String? createdAt,
    String? createdBy,
    Map<String, dynamic>? dataPost,
    List<dynamic>? dataFlights,
  }) async {
    final List<dynamic> flights = dataFlights ?? [];
    final pdf.Document doc = pdf.Document();

    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    final pdf.ImageProvider nypdLogo1 = await networkImage("${UrlConstants.systemLogoURL}/Downloaded_Files/2016-3/66-2016-3-29__09-07_32.png");
    final pdf.ImageProvider nypdLogo2 = await networkImage("${UrlConstants.systemLogoURL}/Downloaded_Files/2016-3/66-2016-3-29__09-05_10.jpg");

    doc.addPage(
      pdf.MultiPage(
        theme: themeData,
        maxPages: 700,
        margin: const pdf.EdgeInsets.all(30.0),
        pageFormat: pageFormat,
        crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
        header:
            (context) =>
                context.pageNumber == 1
                    ? pdf.Padding(
                      padding: const pdf.EdgeInsets.only(bottom: 8.0),
                      child: pdf.Row(
                        children: [
                          pdf.Expanded(child: pdf.Image(nypdLogo1)),
                          pdf.Expanded(
                            flex: 6,
                            child: pdf.Text("NYPD AVIATION UNIT FLIGHT DATA", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.bold), textAlign: pdf.TextAlign.center),
                          ),
                          pdf.Expanded(child: pdf.Image(nypdLogo2)),
                        ],
                      ),
                    )
                    : pdf.SizedBox(),
        footer:
            (context) => pdf.Column(
              children: [
                pdf.Divider(height: 6.0),
                pdf.Row(
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    pdf.Expanded(flex: 2, child: pdf.Text("Printed At: $createdAt", style: pdf.TextStyle(fontSize: 15, fontStyle: pdf.FontStyle.italic))),
                    pdf.Expanded(flex: 2, child: pdf.Text("Printed By: $createdBy", style: pdf.TextStyle(fontSize: 15, fontStyle: pdf.FontStyle.italic))),
                    pdf.Expanded(
                      child: pdf.Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: pdf.TextStyle(fontSize: 15, fontStyle: pdf.FontStyle.italic),
                        textAlign: pdf.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        build: (context) {
          return [
            //Line 1
            titleWithBoxedValue(value: "AU2#: ${dataPost?["aU2"] ?? ""}", fillColor: PdfColor.fromHex("#FFFF7F")),
            pdf.Container(
              width: double.maxFinite,
              padding: const pdf.EdgeInsets.symmetric(horizontal: 10.0),
              child: pdf.Column(
                crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
                children: [
                  //Line 2
                  pdf.Wrap(
                    alignment: pdf.WrapAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "Date", value: dataPost?["date"] ?? ""),
                      titleWithBoxedValue(title: "Platoon", value: dataPost?["platoon"] ?? ""),
                      titleWithBoxedValue(title: "Aircraft #", value: dataPost?["aircraft"] ?? ""),
                      titleWithBoxedValue(title: "Time Departed FBF", value: dataPost?["timeDepartedFBF"] ?? ""),
                    ],
                  ),
                  //Line 3
                  pdf.Wrap(
                    alignment: pdf.WrapAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "PC", value: dataPost?["pc"] ?? ""),
                      titleWithBoxedValue(title: "Pilot FLT Time", value: dataPost?["pilotFLTTime1"] ?? ""),
                      titleWithBoxedValue(title: "Time Returned FBF", value: dataPost?["timeReturnedFBF"] ?? ""),
                    ],
                  ),
                  //Line 4
                  pdf.Wrap(
                    alignment: pdf.WrapAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "CP", value: dataPost?["cp"] ?? ""),
                      titleWithBoxedValue(title: "Pilot FLT Time", value: dataPost?["pilotFLTTime2"] ?? ""),
                      titleWithBoxedValue(title: "Flight Time", value: dataPost?["flightTime"] ?? ""),
                    ],
                  ),
                  //Line 5
                  pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "CC", value: dataPost?["cc"] ?? ""),
                      titleWithBoxedValue(title: "# Of Passengers", value: dataPost?["numberOfPassengers"] ?? ""),
                      titleWithBoxedValue(title: "Mission Time", value: dataPost?["missionTime"] ?? ""),
                    ],
                  ),
                  //Line 6
                  pdf.Wrap(
                    alignment: pdf.WrapAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "SC1", value: dataPost?["sC1"] ?? ""),
                      titleWithBoxedValue(title: "SC2", value: dataPost?["sC2"] ?? ""),
                      titleWithBoxedValue(title: "Run up/Shut Down", value: dataPost?["runUp_ShutDown"] ?? ""),
                    ],
                  ),
                  //Line 6
                  titleWithBoxedValue(title: "RS", value: dataPost?["rs"] ?? ""),
                  pdf.Divider(thickness: 2.0, height: 10.0),
                  pdf.Text("Fuel Used :", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold, fontStyle: pdf.FontStyle.italic)),
                  //Line 7
                  pdf.Wrap(
                    alignment: pdf.WrapAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "Fuel Used", value: dataPost?["fuelUsed"] ?? ""),
                      titleWithBoxedValue(title: "Credit Card", value: dataPost?["creditCard1"] ?? ""),
                    ],
                  ),
                  pdf.Wrap(
                    alignment: pdf.WrapAlignment.spaceBetween,
                    children: [
                      titleWithBoxedValue(title: "Credit Card", value: dataPost?["creditCard2"] ?? ""),
                      titleWithBoxedValue(title: "Credit Card", value: dataPost?["creditCard3"] ?? ""),
                    ],
                  ),
                  for (int index = 0; index < flights.length; index++)
                    pdf.Column(
                      crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
                      children: [
                        pdf.Divider(thickness: 2.0, height: 10.0),
                        pdf.Text("Job #${index + 1} :", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold, fontStyle: pdf.FontStyle.italic)),
                        pdf.Wrap(
                          alignment: pdf.WrapAlignment.spaceBetween,
                          children: [
                            titleWithBoxedValue(title: "Mission Time", value: flights[index]["missionTime"] ?? ""),
                            titleWithBoxedValue(title: "# Arrested", value: flights[index]["arrested"] ?? ""),
                            titleWithBoxedValue(title: "Camera/Video", value: flights[index]["camera_Video"] ?? ""),
                            titleWithBoxedValue(title: "ASR#", value: flights[index]["asr"] ?? ""),
                          ],
                        ),
                        pdf.Wrap(
                          alignment: pdf.WrapAlignment.spaceBetween,
                          children: [
                            titleWithBoxedValue(title: "Borough", value: flights[index]["borough"] ?? ""),
                            titleWithBoxedValue(title: "# Hoisted", value: flights[index]["hoisted"] ?? ""),
                            titleWithBoxedValue(title: "FLIR", value: flights[index]["flir"] ?? ""),
                            titleWithBoxedValue(title: "PCR#", value: flights[index]["pcr"] ?? ""),
                          ],
                        ),
                        pdf.Wrap(
                          alignment: pdf.WrapAlignment.spaceBetween,
                          children: [
                            titleWithBoxedValue(title: "Supported Unit", value: flights[index]["supportedUnit"] ?? ""),
                            titleWithBoxedValue(title: "Scuba", value: flights[index]["scuba"] ?? ""),
                            titleWithBoxedValue(title: "Nitesun", value: flights[index]["niteSun"] ?? ""),
                            titleWithBoxedValue(title: "Out/City#", value: flights[index]["out_City"] ?? ""),
                          ],
                        ),
                        pdf.Row(
                          mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                          children: [
                            titleWithBoxedValue(title: "Assignment", value: flights[index]["assignment"] ?? ""),
                            titleWithBoxedValue(title: "FDNY#", value: flights[index]["fdny"] ?? ""),
                          ],
                        ),
                        titleWithBoxedValue(boxExpands: true, title: "Job Location", value: flights[index]["jobLocation"] ?? ""),
                        titleWithBoxedValue(boxExpands: true, title: "Disposition", value: flights[index]["disposition"] ?? ""),
                        titleWithBoxedValue(boxExpands: true, title: "Comments", value: flights[index]["comments"] ?? ""),
                      ],
                    ),
                ],
              ),
            ),
          ];
        },
      ),
    );
    return await doc.save();
  }

  pdf.Widget titleWithBoxedValue({
    String? title,
    String? value,
    int flex = 0,
    bool boxExpands = false,
    pdf.MainAxisAlignment mainAxisAlignment = pdf.MainAxisAlignment.start,
    pdf.MainAxisSize mainAxisSize = pdf.MainAxisSize.min,
    PdfColor? fillColor,
  }) {
    return pdf.Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        if (title != null && title.isNotEmpty) pdf.Text("$title:", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
        pdf.Flexible(
          flex: 1,
          fit: boxExpands ? pdf.FlexFit.tight : pdf.FlexFit.loose,
          child: pdf.Container(
            constraints: const pdf.BoxConstraints(minHeight: 20.0, minWidth: 30.0),
            decoration: pdf.BoxDecoration(color: fillColor, border: pdf.Border.all(width: 1.5)),
            margin: const pdf.EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            padding: const pdf.EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
            child: pdf.Text("$value", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
          ),
        ),
      ],
    );
  }

  Future<Uint8List> tennesseeHighwayPatrolIncidentReport({
    PdfPageFormat? pageFormat,
    String? formID,
    String? leg,
    String? trnCrew,
    String? supp,
    required Map<String, dynamic>? incidentReportData,
  }) async {
    final pdf.Document doc = pdf.Document();
    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();
    final pdf.ImageProvider thpLogo = await networkImage("${UrlConstants.systemLogoURL}/graphics/TNHP-Wings.png");

    int strFormId = int.tryParse(formID.toString()) ?? 0;
    //int strLeg = int.tryParse(leg.toString()) ?? 0;
    int strIncludeTrainingCrew = int.tryParse(trnCrew.toString()) ?? 0;
    int strIncludeSupplements = int.tryParse(supp.toString()) ?? 0;

    String reportingOfficer = incidentReportData?["reportingOfficer"] ?? "";
    String code = incidentReportData?["code"] ?? "";
    String additionalAircraftUsed = incidentReportData?["additionalAircraftUsed"] ?? "";
    String callAddress = incidentReportData?["callAddress"] ?? "";
    String afterHours = incidentReportData?["afterHours"] ?? "";
    String agencyType = incidentReportData?["agencyType"] ?? "";
    String aircraft = incidentReportData?["aircraft"] ?? "";
    String arrests = incidentReportData?["arrests"] ?? "";
    String callNarrative = incidentReportData?["callNarrative"] ?? "";
    String eventNumber = incidentReportData?["eventNumber"] ?? "";
    String city1 = incidentReportData?["city1"] ?? "";
    String city2 = incidentReportData?["city2"] ?? "";
    String city3 = incidentReportData?["city3"] ?? "";
    String city4 = incidentReportData?["city4"] ?? "";
    String countyCode1 = incidentReportData?["countyCode1"] ?? "";
    String countyCode2 = incidentReportData?["countyCode2"] ?? "";
    String countyCode3 = incidentReportData?["countyCode3"] ?? "";
    String countyCode4 = incidentReportData?["countyCode4"] ?? "";
    String countyHrs1 = incidentReportData?["countyHrs1"] ?? "";
    String countyHrs2 = incidentReportData?["countyHrs2"] ?? "";
    String countyHrs3 = incidentReportData?["countyHrs3"] ?? "";
    String countyHrs4 = incidentReportData?["countyHrs4"] ?? "";
    String flightDate = incidentReportData?["flightDate"] ?? "";
    String ddDDDD = incidentReportData?["dDdddd"] ?? "";
    String disposition = incidentReportData?["disposition"] ?? "";
    String dispositionType = incidentReportData?["dispositionType"] ?? "";
    String district = incidentReportData?["district"] ?? "";
    String endTime = incidentReportData?["endTime"] ?? "";
    String equipmentUsed = incidentReportData?["equipmentUsed"] ?? "";
    String flightTime = incidentReportData?["flightTime"] ?? "";
    String flir = incidentReportData?["flir"] ?? "";
    String hoistEquipment = incidentReportData?["hoistEquipment"] ?? "";
    String latLong = incidentReportData?["latLong"] ?? "";
    String manHours = incidentReportData?["manHours"] ?? "";
    String missionSubType = incidentReportData?["missionSubType"] ?? "";
    String missionType = incidentReportData?["missionType"] ?? "";
    String other = incidentReportData?["other"] ?? "";
    String otherAgencyInvolved = incidentReportData?["otherAgencyInvolved"] ?? "";
    String otherOfficerInvolved = incidentReportData?["otherOfficerInvolved"] ?? "";
    String personsLocated = incidentReportData?["personsLocated"] ?? "";
    String personsMissing = incidentReportData?["personsMissing"] ?? "";
    String requestingLawEnforcementAgency = incidentReportData?["requestingLawEnforcementAgency"] ?? "";
    String requestingNonLawEnforcementAgency = incidentReportData?["requestingNonLawEnforcementAgency"] ?? "";
    String searches = incidentReportData?["searches"] ?? "";
    String selfInitiated = incidentReportData?["selfInitiated"] ?? "";
    String startTime = incidentReportData?["startTime"] ?? "";
    String stolenVehicleRecovered = incidentReportData?["stolenVehicleRecovered"] ?? "";
    String supplementReportRequired = incidentReportData?["supplementReportRequired"] ?? "";
    String suspects = incidentReportData?["suspects"] ?? "";
    String temaRequest = incidentReportData?["temaRequest"] ?? "";
    String vehiclesLocated = incidentReportData?["vehiclesLocated"] ?? "";
    String weather = incidentReportData?["weather"] ?? "";
    String incidentNumber = incidentReportData?["incidentNumber"] ?? "";

    String pic = incidentReportData?["pic"] ?? "";
    String coPilot = incidentReportData?["coPilot"] ?? "";
    String tfo1 = incidentReportData?["tfo1"] ?? "";
    String tfo2 = incidentReportData?["tfo2"] ?? "";
    String operator1 = incidentReportData?["operator1"] ?? "";
    String operator2 = incidentReportData?["operator2"] ?? "";
    String operator3 = incidentReportData?["operator3"] ?? "";
    String operator4 = incidentReportData?["operator4"] ?? "";
    String operator5 = incidentReportData?["operator5"] ?? "";
    String operator6 = incidentReportData?["operator6"] ?? "";
    String operator7 = incidentReportData?["operator7"] ?? "";
    String operator8 = incidentReportData?["operator8"] ?? "";
    String operator9 = incidentReportData?["operator9"] ?? "";
    String operator10 = incidentReportData?["operator10"] ?? "";
    String operatorSpecialist4 = incidentReportData?["operatorSpecialist4"] ?? "";
    String operatorSpecialist5 = incidentReportData?["operatorSpecialist5"] ?? "";
    String operatorSpecialist6 = incidentReportData?["operatorSpecialist6"] ?? "";
    String operatorSpecialist7 = incidentReportData?["operatorSpecialist7"] ?? "";
    String operatorSpecialist8 = incidentReportData?["operatorSpecialist8"] ?? "";
    String operatorSpecialist9 = incidentReportData?["operatorSpecialist9"] ?? "";
    String operatorSpecialist10 = incidentReportData?["operatorSpecialist10"] ?? "";

    String suppAircraft_1 = incidentReportData?["suppAircraft_1"] ?? "";
    String suppAircraft_2 = incidentReportData?["suppAircraft_2"] ?? "";
    String suppAircraft_3 = incidentReportData?["suppAircraft_3"] ?? "";
    String suppEndTime_1 = incidentReportData?["suppEndTime_1"] ?? "";
    String suppEndTime_2 = incidentReportData?["suppEndTime_2"] ?? "";
    String suppEndTime_3 = incidentReportData?["suppEndTime_3"] ?? "";
    String suppFlightTime_1 = incidentReportData?["suppFlightTime_1"] ?? "";
    String suppFlightTime_2 = incidentReportData?["suppFlightTime_2"] ?? "";
    String suppFlightTime_3 = incidentReportData?["suppFlightTime_3"] ?? "";
    String suppManHours_1 = incidentReportData?["suppManHours_1"] ?? "";
    String suppManHours_2 = incidentReportData?["suppManHours_2"] ?? "";
    String suppManHours_3 = incidentReportData?["suppManHours_3"] ?? "";
    String suppReportingOfficer_1 = "suppReportingOfficer_1"; //incidentReportData?["suppReportingOfficer_1"] ?? "";
    String suppReportingOfficer_2 = incidentReportData?["suppReportingOfficer_2"] ?? "";
    String suppReportingOfficer_3 = incidentReportData?["suppReportingOfficer_3"] ?? "";
    String suppStartTime_1 = incidentReportData?["suppStartTime_1"] ?? "";
    String suppStartTime_2 = incidentReportData?["suppStartTime_2"] ?? "";
    String suppStartTime_3 = incidentReportData?["suppStartTime_3"] ?? "";
    String suppSupplementNarrative_1 = incidentReportData?["suppSupplementNarrative_1"] ?? "";
    String suppSupplementNarrative_2 = incidentReportData?["suppSupplementNarrative_2"] ?? "";
    String suppSupplementNarrative_3 = incidentReportData?["suppSupplementNarrative_3"] ?? "";

    String passenger1 = incidentReportData?["passenger1"] ?? "";
    String passenger2 = incidentReportData?["passenger2"] ?? "";
    String passenger3 = incidentReportData?["passenger3"] ?? "";
    String passenger4 = incidentReportData?["passenger4"] ?? "";
    String passenger5 = incidentReportData?["passenger5"] ?? "";
    String passenger6 = incidentReportData?["passenger6"] ?? "";
    String passenger7 = incidentReportData?["passenger7"] ?? "";
    String passenger8 = incidentReportData?["passenger8"] ?? "";
    String passenger9 = incidentReportData?["passenger9"] ?? "";
    String passenger10 = incidentReportData?["passenger10"] ?? "";

    List<pdf.Widget> passengerList = <pdf.Widget>[];
    int n = 1;

    for (int i = 1; i <= 10; i++) {
      switch (i) {
        case 1:
          if (passenger1 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger1));
            n++;
          }
          break;
        case 2:
          if (passenger2 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger2));
            n++;
          }
          break;
        case 3:
          if (passenger3 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger3));
            n++;
          }
          break;
        case 4:
          if (passenger4 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger4));
            n++;
          }
          break;
        case 5:
          if (passenger5 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger5));
            n++;
          }
          break;
        case 6:
          if (passenger6 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger6));
            n++;
          }
          break;
        case 7:
          if (passenger7 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger7));
            n++;
          }
          break;
        case 8:
          if (passenger8 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger8));
            n++;
          }
          break;
        case 9:
          if (passenger9 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger9));
            n++;
          }
          break;
        case 10:
          if (passenger10 != "") {
            passengerList.add(thpTitleWithValue(title: "Passenger #$n", value: passenger10));
            n++;
          }
          break;
        default:
          break;
      }
    }

    doc.addPage(
      pdf.MultiPage(
        theme: themeData,
        maxPages: 700,
        margin: const pdf.EdgeInsets.all(30.0),
        pageFormat: pageFormat,
        crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
        header:
            (context) =>
                context.pageNumber == 1
                    ? pdf.Padding(
                      padding: const pdf.EdgeInsets.only(bottom: 8.0),
                      child: pdf.Row(
                        children: [
                          pdf.Expanded(child: pdf.Image(thpLogo)),
                          pdf.Expanded(
                            flex: 3,
                            child: pdf.Column(
                              children: [
                                pdf.Text("Incident Report", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.bold), textAlign: pdf.TextAlign.center),
                                pdf.Text("Incident: $incidentNumber", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal), textAlign: pdf.TextAlign.center),
                                pdf.Text("Form: $strFormId", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal), textAlign: pdf.TextAlign.center),
                              ],
                            ),
                          ),
                          pdf.Expanded(
                            flex: 2,
                            child: pdf.Column(
                              children: [
                                pdf.Text(
                                  "TENNESSEE HIGHWAY PATROL\nAviation Section",
                                  style: pdf.TextStyle(fontSize: 18, fontWeight: pdf.FontWeight.normal),
                                  textAlign: pdf.TextAlign.center,
                                ),
                                pdf.Text(UserSessionInfo.userFullName, style: pdf.TextStyle(fontSize: 18, fontWeight: pdf.FontWeight.normal), textAlign: pdf.TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    : pdf.SizedBox(),
        build: (context) {
          return [
            //Call Information
            pdf.Padding(
              padding: const pdf.EdgeInsets.symmetric(vertical: 3.0),
              child: pdf.Text("Call Information", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "Date", value: flightDate),
                thpTitleWithValue(title: "Aircraft", value: aircraft),
                thpTitleWithValue(title: "Reporting Officer", value: reportingOfficer),
              ],
            ),
            thpDataRow(
              children: [
                thpTitleWithValue(title: "Disposition", value: disposition),
                thpTitleWithValue(title: "Disposition Type", value: dispositionType),
                thpTitleWithValue(title: "Event #", value: eventNumber),
              ],
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "Mission Type", value: missionType),
                thpTitleWithValue(title: "Agency Type", value: agencyType),
                thpTitleWithValue(title: "Mission Sub-Type", value: missionSubType),
              ],
            ),
            if (other != "") thpDataRow(children: [thpTitleWithValue(title: "Other", value: other)]),
            thpDataRow(
              backgroundColor: other != "" ? PdfColors.grey200 : null,
              children: [
                thpTitleWithValue(title: "Self Initiated", value: selfInitiated),
                thpTitleWithValue(title: "Supplement Report Required", value: supplementReportRequired),
                thpTitleWithValue(title: "TEMA Request", value: temaRequest),
              ],
            ),
            thpDataRow(
              backgroundColor: other != "" ? PdfColors.grey200 : null,
              children: [
                thpTitleWithValue(title: "Additional Aircraft Used", value: additionalAircraftUsed),
                thpTitleWithValue(title: "Weather", value: weather),
                thpTitleWithValue(title: "10 Codes", value: code),
              ],
            ),
            thpDataRow(backgroundColor: other != "" ? null : PdfColors.grey200, children: [thpTitleWithValue(title: "Call Narrative", value: callNarrative)]),
            //Crew
            pdf.Padding(padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0), child: pdf.Text("Crew", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal))),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "PIC", value: pic),
                thpTitleWithValue(title: "Co-Pilot", value: coPilot),
                thpTitleWithValue(title: "TFO #1", value: tfo1),
                thpTitleWithValue(title: "TFO #2", value: tfo2),
              ],
            ),
            thpDataRow(
              children: [
                thpTitleWithValue(title: "RS/SO #1", value: operator1),
                thpTitleWithValue(title: "RS/SO #2", value: operator2),
                thpTitleWithValue(title: "RS/SO #3", value: operator3),
              ],
            ),
            if (strIncludeTrainingCrew == 1) ...{
              if (operator4 != "" || operator5 != "" || operator6 != "" || operator7 != "")
                thpDataRow(
                  backgroundColor: PdfColors.grey200,
                  children: [
                    thpTitleWithValue(title: "RS/SO #4", value: "$operator4 $operatorSpecialist4"),
                    thpTitleWithValue(title: "RS/SO #5", value: "$operator5 $operatorSpecialist5"),
                    thpTitleWithValue(title: "RS/SO #6", value: "$operator6 $operatorSpecialist6"),
                    thpTitleWithValue(title: "RS/SO #7", value: "$operator7 $operatorSpecialist7"),
                  ],
                ),
              if (operator8 != "" || operator9 != "" || operator10 != "")
                thpDataRow(
                  children: [
                    thpTitleWithValue(title: "RS/SO #8", value: "$operator8 $operatorSpecialist8"),
                    thpTitleWithValue(title: "RS/SO #9", value: "$operator9 $operatorSpecialist9"),
                    thpTitleWithValue(title: "RS/SO #10", value: "$operator10 $operatorSpecialist10"),
                  ],
                ),
            },
            //Passengers
            if (passengerList.isNotEmpty) ...{
              pdf.Padding(
                padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
                child: pdf.Text("Passengers", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
              ),
              thpDataRow(backgroundColor: PdfColors.grey200, children: passengerList.sublist(0, passengerList.length > 5 ? 5 : null)),
              if (passengerList.length > 4) thpDataRow(children: passengerList.sublist(5)),
            },
            //Times
            pdf.Padding(padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0), child: pdf.Text("Times", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal))),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "Start Time", value: startTime),
                thpTitleWithValue(title: "End Time", value: endTime),
                thpTitleWithValue(title: "Man Hours", value: manHours),
                thpTitleWithValue(title: "After Time", value: afterHours),
                thpTitleWithValue(title: "Flight Time", value: flightTime),
              ],
            ),
            //Location
            pdf.Padding(
              padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
              child: pdf.Text("Location", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
            ),
            thpDataRow(backgroundColor: PdfColors.grey200, children: [thpTitleWithValue(title: "District", value: district)]),
            thpDataRow(
              children: [
                thpTitleWithValue(title: "Requesting Law Enforcement Agency", value: requestingLawEnforcementAgency),
                thpTitleWithValue(title: "Requesting Non Law Enforcement Agency", value: requestingNonLawEnforcementAgency),
                thpTitleWithValue(title: "Agency Involved", value: otherAgencyInvolved),
              ],
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "County Code", value: countyCode1),
                thpTitleWithValue(title: "City", value: city1),
                thpTitleWithValue(title: "County Hrs", value: countyHrs1),
              ],
            ),
            thpDataRow(
              children: [
                thpTitleWithValue(title: "County Code", value: countyCode2),
                thpTitleWithValue(title: "City", value: city2),
                thpTitleWithValue(title: "County Hrs", value: countyHrs2),
              ],
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "County Code", value: countyCode3),
                thpTitleWithValue(title: "City", value: city3),
                thpTitleWithValue(title: "County Hrs", value: countyHrs3),
              ],
            ),
            thpDataRow(
              children: [
                thpTitleWithValue(title: "County Code", value: countyCode4),
                thpTitleWithValue(title: "City", value: city4),
                thpTitleWithValue(title: "County Hrs", value: countyHrs4),
              ],
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "Lat / Long", value: latLong),
                thpTitleWithValue(title: "DDdddd", value: ddDDDD),
                thpTitleWithValue(title: "Address", value: callAddress),
              ],
            ),
            thpDataRow(children: [thpTitleWithValue(title: "Other Officer Involved", value: otherOfficerInvolved)]),
            //Additional Call Information
            pdf.Padding(
              padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
              child: pdf.Text("Additional Call Information", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [
                thpTitleWithValue(title: "Person (s) Missing", value: personsMissing),
                thpTitleWithValue(title: "Person (s) Located", value: personsLocated),
                thpTitleWithValue(title: "Suspect (s)", value: suspects),
                thpTitleWithValue(title: "Arrest (s)", value: arrests),
              ],
            ),
            thpDataRow(
              children: [
                thpTitleWithValue(title: "Vehicles Located", value: vehiclesLocated),
                thpTitleWithValue(title: "Stolen Vehicle Recovered", value: stolenVehicleRecovered),
                thpTitleWithValue(title: "FLIR", value: flir),
                thpTitleWithValue(title: "Searches", value: searches),
              ],
            ),
            //Equipment Used
            pdf.Padding(
              padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
              child: pdf.Text("Equipment Used", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
            ),
            thpDataRow(
              backgroundColor: PdfColors.grey200,
              children: [thpTitleWithValue(title: "Equipment Used", value: equipmentUsed), thpTitleWithValue(title: "Hoist Equipment", value: hoistEquipment)],
            ),
            //Supplemental Reports
            if (strIncludeSupplements == 1) ...{
              if (suppReportingOfficer_1 != "" ||
                  suppAircraft_1 != "" ||
                  suppStartTime_1 != "" ||
                  suppEndTime_1 != "" ||
                  suppFlightTime_1 != "" ||
                  suppManHours_1 != "" ||
                  suppSupplementNarrative_1 != "") ...{
                pdf.Padding(
                  padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
                  child: pdf.Text("Supplement #1", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
                ),
                thpDataRow(
                  backgroundColor: PdfColors.grey200,
                  children: [
                    thpTitleWithValue(title: "Reporting Officer", value: suppReportingOfficer_1),
                    thpTitleWithValue(title: "Aircraft", value: suppAircraft_1),
                    thpTitleWithValue(title: "Times", value: "$suppStartTime_1-$suppEndTime_1"),
                    thpTitleWithValue(title: "Flight Time", value: suppFlightTime_1),
                    thpTitleWithValue(title: "Man Hours", value: suppManHours_1),
                  ],
                ),
                thpDataRow(children: [thpTitleWithValue(title: "Supplement Narrative", value: suppSupplementNarrative_1)]),
              },
              if (suppReportingOfficer_2 != "" ||
                  suppAircraft_2 != "" ||
                  suppStartTime_2 != "" ||
                  suppEndTime_2 != "" ||
                  suppFlightTime_2 != "" ||
                  suppManHours_2 != "" ||
                  suppSupplementNarrative_2 != "") ...{
                pdf.Padding(
                  padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
                  child: pdf.Text("Supplement #2", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
                ),
                thpDataRow(
                  backgroundColor: PdfColors.grey200,
                  children: [
                    thpTitleWithValue(title: "Reporting Officer", value: suppReportingOfficer_2),
                    thpTitleWithValue(title: "Aircraft", value: suppAircraft_2),
                    thpTitleWithValue(title: "Times", value: "$suppStartTime_2-$suppEndTime_2"),
                    thpTitleWithValue(title: "Flight Time", value: suppFlightTime_2),
                    thpTitleWithValue(title: "Man Hours", value: suppManHours_2),
                  ],
                ),
                thpDataRow(children: [thpTitleWithValue(title: "Supplement Narrative", value: suppSupplementNarrative_2)]),
              },
              if (suppReportingOfficer_3 != "" ||
                  suppAircraft_3 != "" ||
                  suppStartTime_3 != "" ||
                  suppEndTime_3 != "" ||
                  suppFlightTime_3 != "" ||
                  suppManHours_3 != "" ||
                  suppSupplementNarrative_3 != "") ...{
                pdf.Padding(
                  padding: const pdf.EdgeInsets.only(top: 6.0, bottom: 3.0),
                  child: pdf.Text("Supplement #3", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
                ),
                thpDataRow(
                  backgroundColor: PdfColors.grey200,
                  children: [
                    thpTitleWithValue(title: "Reporting Officer", value: suppReportingOfficer_3),
                    thpTitleWithValue(title: "Aircraft", value: suppAircraft_3),
                    thpTitleWithValue(title: "Times", value: "$suppStartTime_3-$suppEndTime_3"),
                    thpTitleWithValue(title: "Flight Time", value: suppFlightTime_3),
                    thpTitleWithValue(title: "Man Hours", value: suppManHours_2),
                  ],
                ),
                thpDataRow(children: [thpTitleWithValue(title: "Supplement Narrative", value: suppSupplementNarrative_3)]),
              },
            },
          ];
        },
      ),
    );
    return await doc.save();
  }

  pdf.Widget thpDataRow({List<pdf.Widget> children = const <pdf.Widget>[], PdfColor? backgroundColor}) {
    return pdf.Container(
      width: double.maxFinite,
      decoration: pdf.BoxDecoration(border: const pdf.Border.symmetric(horizontal: pdf.BorderSide(width: 1.5, color: PdfColors.grey)), color: backgroundColor),
      padding: const pdf.EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      child: pdf.Wrap(alignment: pdf.WrapAlignment.spaceBetween, spacing: 5.0, runSpacing: 3.0, children: children),
    );
  }

  pdf.Widget thpTitleWithValue({String? title, String? value}) {
    return pdf.Wrap(
      children: [
        pdf.Text("$title: ", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
        pdf.Text("$value", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold)),
      ],
    );
  }

  Future<Uint8List> columbusPoliceIncidentReport({PdfPageFormat? pageFormat, String? id, String? leg, required Map<String, dynamic>? incidentReportData}) async {
    final pdf.Document doc = pdf.Document();
    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();
    final pdf.ImageProvider cpLogo = await networkImage("${UrlConstants.systemLogoURL}/Downloaded_Files/2020-5/98-2020-5-18__09-22_17.jpg");

    Map<String, dynamic>? incidentReport = incidentReportData?["objCOLUMBUSPOLICEIncidentReport"];
    List<dynamic> incidentReportArrestList = incidentReportData?["objCOLUMBUSPOLICEIncidentReportArrestList"] ?? [];

    //int strFormId = int.tryParse(id.toString()) ?? 0;
    //int strLeg = int.tryParse(leg.toString()) ?? 0;

    String incidentNumber = incidentReport?["incidentNumber"] ?? "";
    String strPilot = incidentReport?["pilot"] ?? "";
    String strObserver = incidentReport?["observer"] ?? "";
    String strFlightDate = incidentReport?["flightDate"] ?? "";
    String strFlightStart = incidentReport?["flightStart"] ?? "";
    String strTime = incidentReport?["time"] ?? "";
    String strType = incidentReport?["type"] ?? "";
    String strLocation = incidentReport?["location"] ?? "";
    String strGroundUnits = incidentReport?["groundUnits"] ?? "";
    String strCADInc = incidentReport?["cadInc"] ?? "";
    String strNarrative = incidentReport?["narrative"] ?? "";

    doc.addPage(
      pdf.MultiPage(
        theme: themeData,
        maxPages: 700,
        margin: const pdf.EdgeInsets.all(30.0),
        pageFormat: pageFormat,
        crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
        header:
            (context) =>
                context.pageNumber == 1
                    ? pdf.Padding(
                      padding: const pdf.EdgeInsets.only(bottom: 8.0),
                      child: pdf.Row(
                        children: [
                          pdf.Expanded(child: pdf.Image(cpLogo)),
                          pdf.Expanded(
                            flex: 5,
                            child: pdf.Column(
                              children: [
                                pdf.Text("Columbus Division of Police", style: pdf.TextStyle(fontSize: 24, fontWeight: pdf.FontWeight.bold), textAlign: pdf.TextAlign.center),
                                pdf.SizedBox(height: 15.0),
                                pdf.Text("Helicopter Section", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal), textAlign: pdf.TextAlign.center),
                                pdf.Text("Incident Report", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.bold), textAlign: pdf.TextAlign.center),
                              ],
                            ),
                          ),
                          pdf.Expanded(child: pdf.Image(cpLogo)),
                        ],
                      ),
                    )
                    : pdf.SizedBox(),
        build: (context) {
          return [
            pdf.Divider(thickness: 1.0, color: PdfColors.grey),
            //Incident Information
            pdf.Padding(
              padding: const pdf.EdgeInsets.symmetric(horizontal: 40.0),
              child: pdf.Column(
                crossAxisAlignment: pdf.CrossAxisAlignment.start,
                children: [
                  cpTitleWithValue(title: "Incident Number", value: incidentNumber, boldValue: true, fontSize: 20.0),
                  pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                    children: [cpTitleWithValue(title: "Pilot", value: strPilot), cpTitleWithValue(title: "Observer", value: strObserver)],
                  ),
                  pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                    children: [cpTitleWithValue(title: "Flight Date", value: strFlightDate), cpTitleWithValue(title: "Flight Start", value: strFlightStart)],
                  ),
                ],
              ),
            ),
            pdf.Divider(thickness: 1.0, color: PdfColors.grey),
            //Incident Details
            pdf.Padding(
              padding: const pdf.EdgeInsets.symmetric(horizontal: 40.0),
              child: pdf.Column(
                crossAxisAlignment: pdf.CrossAxisAlignment.start,
                children: [
                  pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
                    children: [cpTitleWithValue(title: "Time", value: strTime), cpTitleWithValue(title: "Type", value: strType)],
                  ),
                  cpTitleWithValue(title: "Location", value: strLocation),
                  cpTitleWithValue(title: "Ground Units", value: strGroundUnits),
                  cpTitleWithValue(title: "CAD Incident", value: strCADInc),
                ],
              ),
            ),
            pdf.SizedBox(height: 5.0),
            cpTitleWithValue(title: "Narrative", value: strNarrative),
            //Arrests / Charges
            pdf.SizedBox(height: 20.0),
            pdf.Row(
              children: [
                pdf.Expanded(child: pdf.Text("Num", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
                pdf.SizedBox(width: 5.0),
                pdf.Expanded(flex: 2, child: pdf.Text("Last", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
                pdf.Expanded(flex: 2, child: pdf.Text("First", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
                pdf.Expanded(child: pdf.Text("Age", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
                pdf.Expanded(flex: 2, child: pdf.Text("Sex", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
                pdf.Expanded(flex: 2, child: pdf.Text("Race", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
                pdf.Expanded(flex: 4, child: pdf.Text("Charge Description", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold))),
              ],
            ),
            incidentReportArrestList.isNotEmpty
                ? pdf.ListView.builder(
                  itemCount: incidentReportArrestList.length,
                  itemBuilder:
                      (context, i) => pdf.Row(
                        crossAxisAlignment: pdf.CrossAxisAlignment.start,
                        children: [
                          pdf.Expanded(child: pdf.Text("   ${i + 1}", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal))),
                          pdf.SizedBox(width: 5.0),
                          pdf.Expanded(
                            flex: 2,
                            child: pdf.Text(incidentReportArrestList[i]["last_1"] ?? "", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
                          ),
                          pdf.Expanded(
                            flex: 2,
                            child: pdf.Text(incidentReportArrestList[i]["first_1"] ?? "", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
                          ),
                          pdf.Expanded(child: pdf.Text(" ${incidentReportArrestList[i]["age_1"]}", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal))),
                          pdf.Expanded(
                            flex: 2,
                            child: pdf.Text(incidentReportArrestList[i]["gender_1"] ?? "", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
                          ),
                          pdf.Expanded(
                            flex: 2,
                            child: pdf.Text(incidentReportArrestList[i]["race_1"] ?? "", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
                          ),
                          pdf.Expanded(
                            flex: 4,
                            child: pdf.Text(incidentReportArrestList[i]["offense_1"] ?? "", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
                          ),
                        ],
                      ),
                )
                : pdf.Text("None", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.normal)),
          ];
        },
      ),
    );
    return await doc.save();
  }

  pdf.Widget cpTitleWithValue({String? title, String? value, double? fontSize, bool boldValue = false}) {
    return pdf.Wrap(
      crossAxisAlignment: pdf.WrapCrossAlignment.center,
      children: [
        pdf.Text("$title:   ", style: pdf.TextStyle(fontSize: 16, fontWeight: pdf.FontWeight.bold)),
        pdf.Text("$value", style: pdf.TextStyle(fontSize: fontSize ?? 16, fontWeight: boldValue ? pdf.FontWeight.bold : pdf.FontWeight.normal)),
      ],
    );
  }

  List<Widget> bottomNavigationBarButtons(ViewUserFormLogic controller, BuildContext context) {
    Get.find<ViewUserFormLogic>;
    List<Widget> bottomNavigationBarWidgets = <Widget>[
      if ((controller.formsViewDetails["completedAt"] != "1/1/1900") &&
          (controller.formsViewDetails["completedAt"] != "1/1/1900 00:00") &&
          (controller.viewUserFormData["closeOutFormImport"] ?? false)) //Import Into Log Book
        GeneralMaterialButton(
          buttonText: "Import Into Pilot Log Book",
          icon: Icons.book_outlined,
          borderColor: ColorConstants.primary,
          lrPadding: 5.0,
          onPressed: () {
            controller.importCloseOut(formId: Get.parameters["formId"] ?? controller.lastViewedFormId);
          },
        ),
      if ((controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) != -1 &&
          (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) > 0) //View Form History
        GeneralMaterialButton(
          buttonText: "View Form History",
          icon: Icons.history,
          borderColor: ColorConstants.primary,
          lrPadding: 5.0,
          onPressed: () async {
            LoaderHelper.loaderWithGif();
            await controller.viewHistory(formId: Get.parameters["formId"] ?? controller.lastViewedFormId);
          },
        ),
      if ((controller.viewUserFormData["userAccess"]?["canEdit"] ?? false) && (controller.viewUserFormData["formId"] ?? int.parse(Get.parameters["formId"]!)) != -1) //Edit Form
        GeneralMaterialButton(
          buttonText: "Edit Form",
          icon: Icons.edit_outlined,
          borderColor: ColorConstants.primary,
          lrPadding: 5.0,
          onPressed: () {
            Get.toNamed(
              Routes.fillOutForm,
              arguments: "formEdit",
              parameters: {
                "formId": Get.parameters["formId"] ?? controller.lastViewedFormId,
                "formName": controller.formsViewDetails["formName"].toString(),
                "masterFormId": Get.parameters["masterFormId"].toString(),
              },
            );
          },
        ),
      //View Form
      GeneralMaterialButton(
        buttonText: "View Form",
        icon: Icons.picture_as_pdf_outlined,
        borderColor: ColorConstants.primary,
        lrPadding: 5.0,
        onPressed: () {
          //controller.viewFormPdf();
          Get.to(
            () => ViewPrintSavePdf(
              pdfFile: (pageFormat) => controller.viewFormPdf(pageFormat: pageFormat, mode: "ViewForm"),
              initialPageFormat: PdfPageFormat.a4.landscape,
              fileName:
                  "${UserSessionInfo.systemName.toString().replaceAll(" ", "_")}_${controller.formName.value.replaceAll(" ", "_")}_${controller.viewUserFormAllData["formId"].toString()}",
            ),
          );
        },
      ),
      //Download / Print
      GeneralMaterialButton(
        buttonText: "Download / Print",
        icon: Icons.print_outlined,
        borderColor: ColorConstants.primary,
        lrPadding: 5.0,
        onPressed: () {
          ViewPrintSavePdf.printPdf(
            pdfFile: (pageFormat) => controller.viewFormPdf(pageFormat: pageFormat, mode: "Print"),
            initialPageFormat: PdfPageFormat.a4.landscape,
            fileName:
                "${UserSessionInfo.systemName.toString().replaceAll(" ", "_")}_${controller.formName.value.replaceAll(" ", "_")}_${controller.viewUserFormAllData["formId"].toString()}",
          );
          //controller.createPDF(imageData); //From ForDesigner JS
        },
      ),
    ];
    return bottomNavigationBarWidgets;
  }

  Future<Uint8List> postFormProcessingEmailReport917({
    PdfPageFormat? pageFormat,
    Map<String, dynamic>? msg,
    String? strTitle,
    String? createdAt,
    String? emailTo,
    String? formIDForAttachments,
  }) async {
    final Map<String, dynamic> dailyFlightLogReportData = msg ?? {};
    final pdf.Document doc = pdf.Document();

    final pdf.ThemeData themeData = await PdfCustomFonts.defaultPdfThemeData();

    final pdf.ImageProvider cCSOLogo = await networkImage("${UrlConstants.systemLogoURL}/Downloaded_Files/2022-3/130-2022-3-2__09-16_6.jpg");

    String strCoPilot = dailyFlightLogReportData["coPilot"]?.toString().trim() ?? "";
    String strCoPilotLastName = dailyFlightLogReportData["coPilotLastName"]?.toString().trim() ?? "";
    String strCoPilotFirstName = dailyFlightLogReportData["coPilotFirstName"]?.toString().trim() ?? "";
    String strCoPilotBadgeID = dailyFlightLogReportData["coPilotBadgeId"]?.toString().trim() ?? "";
    String strCoPilotRankDesignation = dailyFlightLogReportData["coPilotRankDesignation"]?.toString().trim() ?? "";
    String strFlightDate = dailyFlightLogReportData["flightDate"]?.toString().trim().split(" ").first ?? "";
    String strPilot = dailyFlightLogReportData["pilot"]?.toString().trim() ?? "";
    String strPilotLastName = dailyFlightLogReportData["pilotLastName"]?.toString().trim() ?? "";
    String strPilotFirstName = dailyFlightLogReportData["pilotFirstName"]?.toString().trim() ?? "";
    String strPilotBadgeID = dailyFlightLogReportData["pilotBadgeID"]?.toString().trim() ?? "";
    String strPilotRankDesignation = dailyFlightLogReportData["pilotRankDesignation"]?.toString().trim() ?? "";
    String strTFO1 = dailyFlightLogReportData["tfO1"]?.toString().trim() ?? "";
    String strTFO1LastName = dailyFlightLogReportData["tfO1LastName"]?.toString().trim() ?? "";
    String strTFO1FirstName = dailyFlightLogReportData["tfO1FirstName"]?.toString().trim() ?? "";
    String strTFO1BadgeID = dailyFlightLogReportData["tfO1BadgeId"]?.toString().trim() ?? "";
    String strTFO1RankDesignation = dailyFlightLogReportData["tfO1RankDesignation"]?.toString().trim() ?? "";
    String strTFO2 = dailyFlightLogReportData["tfO2"]?.toString().trim() ?? "";
    String strTFO2LastName = dailyFlightLogReportData["tfO2LastName"]?.toString().trim() ?? "";
    String strTFO2FirstName = dailyFlightLogReportData["tfO2FirstName"]?.toString().trim() ?? "";
    String strTFO2BadgeID = dailyFlightLogReportData["tfO2BadgeId"]?.toString().trim() ?? "";
    String strTFO2RankDesignation = dailyFlightLogReportData["tfO2RankDesignation"]?.toString().trim() ?? "";
    String strFlightRecordNumber = dailyFlightLogReportData["flightRecordNumber"]?.toString().trim() ?? "0";
    String strFelony = int.parse(dailyFlightLogReportData["felony"]?.toString() ?? "0").toString();
    String strMisdemeanor = int.parse(dailyFlightLogReportData["misdemeanor"]?.toString() ?? "0").toString();
    String strTailNumber = dailyFlightLogReportData["tailNumber"]?.toString().trim() ?? "";
    String strTakeOffTime = dailyFlightLogReportData["takeOffTime"]?.toString().trim() ?? "";
    String strTotalFlightTime = num.parse(dailyFlightLogReportData["totalFlightTime"]?.toString() ?? "0.0").toStringAsFixed(1);
    String strCallNarrative = dailyFlightLogReportData["callNarrative"]?.toString().trim() ?? "";

    doc.addPage(
      pdf.MultiPage(
        theme: themeData,
        maxPages: 700,
        margin: const pdf.EdgeInsets.all(30.0),
        pageFormat: pageFormat,
        crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
        header:
            (context) =>
                context.pageNumber == 1
                    ? pdf.Padding(
                      padding: const pdf.EdgeInsets.only(bottom: 8.0),
                      child: pdf.Row(
                        children: [
                          pdf.Expanded(child: pdf.Image(cCSOLogo)),
                          pdf.Expanded(
                            flex: 3,
                            child: pdf.Column(
                              children: [
                                pdf.Text("CCSO AVIATION FLIGHT RECORD", style: pdf.TextStyle(fontSize: 24, fontWeight: pdf.FontWeight.bold)),
                                pdf.SizedBox(height: 10.0),
                                pdf.Text("(Abbreviated for E-mail purposes)", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    : pdf.SizedBox(),
        footer: (context) => pdf.Center(child: pdf.Text('Page ${context.pageNumber} / ${context.pagesCount}', style: const pdf.TextStyle(fontSize: 15))),
        build: (context) {
          return [
            pdf.Column(
              crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
              children: [
                pdf.Row(
                  mainAxisAlignment: pdf.MainAxisAlignment.end,
                  children: [
                    pdf.Text("FLIGHT RECORD #", style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.bold)),
                    pdf.Container(
                      decoration: pdf.BoxDecoration(border: pdf.Border.all(width: 1.5)),
                      margin: const pdf.EdgeInsets.only(left: 10.0, top: 3.0, bottom: 3.0),
                      padding: const pdf.EdgeInsets.only(left: 40.0, right: 8.0, top: 2.0, bottom: 2.0),
                      child: pdf.Text(strFlightRecordNumber, style: pdf.TextStyle(fontSize: 20, fontWeight: pdf.FontWeight.normal)),
                    ),
                  ],
                ),
                pdf.Divider(thickness: 3.0),
                pdf.Wrap(
                  alignment: pdf.WrapAlignment.spaceBetween,
                  runSpacing: 5.0,
                  children: [
                    textWithUnderline(title: "DATE", value: strFlightDate),
                    textWithUnderline(title: "PILOT ID", value: strPilotBadgeID),
                    textWithUnderline(title: "FLIGHT TIME", value: strTotalFlightTime),
                    textWithUnderline(title: "TAIL #", value: strTailNumber),
                  ],
                ),
                pdf.Column(
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    pdf.Padding(padding: const pdf.EdgeInsets.only(top: 20.0), child: textWithUnderline(title: "CREW", showUnderline: false)),
                    pdf.Container(
                      decoration: (strPilot != "" || strCoPilot != "" || strTFO1 != "" || strTFO2 != "") ? pdf.BoxDecoration(border: pdf.Border.all(width: 1.5)) : null,
                      margin: const pdf.EdgeInsets.only(bottom: 20.0),
                      child: pdf.Column(
                        children: [
                          if (strPilot != "")
                            pdf.Row(
                              children: [
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "LAST NAME", value: strPilotLastName, isPilot: true)),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "FIRST NAME", value: strPilotFirstName, isPilot: true)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "ID#", value: strPilotBadgeID, isPilot: true)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "AGENCY", value: "CCSO", isPilot: true)),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "DUTY SYMBOL", value: strPilotRankDesignation, isPilot: true)),
                              ],
                            ),
                          if (strCoPilot != "")
                            pdf.Row(
                              children: [
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "LAST NAME", value: strCoPilotLastName)),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "FIRST NAME", value: strCoPilotFirstName)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "ID#", value: strCoPilotBadgeID)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "AGENCY", value: "CCSO")),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "DUTY SYMBOL", value: strCoPilotRankDesignation)),
                              ],
                            ),
                          if (strTFO1 != "")
                            pdf.Row(
                              children: [
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "LAST NAME", value: strTFO1LastName)),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "FIRST NAME", value: strTFO1FirstName)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "ID#", value: strTFO1BadgeID)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "AGENCY", value: "CCSO")),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "DUTY SYMBOL", value: strTFO1RankDesignation)),
                              ],
                            ),
                          if (strTFO2 != "")
                            pdf.Row(
                              children: [
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "LAST NAME", value: strTFO2LastName)),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "FIRST NAME", value: strTFO2FirstName)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "ID#", value: strTFO2BadgeID)),
                                pdf.Expanded(flex: 3, child: textInTheBox(title: "AGENCY", value: "CCSO")),
                                pdf.Expanded(flex: 4, child: textInTheBox(title: "DUTY SYMBOL", value: strTFO2RankDesignation)),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                pdf.Wrap(
                  alignment: pdf.WrapAlignment.spaceBetween,
                  runSpacing: 5.0,
                  children: [
                    textWithUnderline(title: "FELONY ARRESTS", value: strFelony),
                    textWithUnderline(title: "MISDEMEANOR ARRESTS", value: strMisdemeanor),
                    textWithUnderline(title: "TAKE OFF TIME", value: strTakeOffTime),
                  ],
                ),
                pdf.SizedBox(height: 20.0),
                textWithUnderline(title: "NARRATIVE", value: "\n $strCallNarrative", showUnderline: false),
              ],
            ),
          ];
        },
      ),
    );
    return await doc.save();
  }

  pdf.Widget textInTheBox({required String title, String? value, bool isPilot = false}) {
    return pdf.Container(
      alignment: pdf.Alignment.center,
      constraints: const pdf.BoxConstraints(minHeight: 90.0),
      decoration: pdf.BoxDecoration(border: pdf.Border.all(width: 1.5)),
      padding: const pdf.EdgeInsets.symmetric(horizontal: 5.0),
      margin: pdf.EdgeInsets.only(left: title == "LAST NAME" ? 5.0 : 0.0, right: 5.0, top: isPilot ? 5.0 : 0.0, bottom: 5.0),
      child: pdf.Column(
        mainAxisSize: pdf.MainAxisSize.min,
        children: [
          pdf.Text(title, style: pdf.TextStyle(fontSize: 18.0, fontWeight: pdf.FontWeight.normal), textAlign: pdf.TextAlign.center),
          pdf.Text(value ?? "", style: pdf.TextStyle(fontSize: 18.0, fontWeight: pdf.FontWeight.bold), textAlign: pdf.TextAlign.center),
        ],
      ),
    );
  }

  pdf.Widget textWithUnderline({required String title, String? value, bool showUnderline = true}) {
    return pdf.Container(
      decoration: pdf.BoxDecoration(border: showUnderline ? const pdf.Border(bottom: pdf.BorderSide(width: 2.0)) : null),
      padding: pdf.EdgeInsets.only(left: 2.0, right: showUnderline ? 20.0 : 2.0, top: 3.0, bottom: 3.0),
      child: pdf.RichText(
        //textAlign: pw.TextAlign.justify,
        text: pdf.TextSpan(
          text: "$title: ",
          style: pdf.TextStyle(fontSize: 20.0, fontWeight: pdf.FontWeight.bold),
          children: [pdf.TextSpan(text: value, style: pdf.TextStyle(fontWeight: pdf.FontWeight.normal))],
        ),
      ),
    );
  }
}
