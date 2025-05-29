import 'dart:ui';

import 'package:aviation_rnd/helper/helper.dart';
import 'package:aviation_rnd/provider/discrepancy_api_provider.dart';
import 'package:aviation_rnd/shared/constants/constant_sizes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;

import '../../../shared/constants/constant_colors.dart';
import '../../../shared/services/keyboard.dart';
import '../../../shared/services/theme_color_mode.dart';
import '../../../shared/utils/logged_in_data.dart';
import '../../../widgets/buttons.dart';

class DiscrepancyDetailsNewLogic extends GetxController {
  RxBool isLoading = false.obs;

  RxMap<String, dynamic> discrepancyDetailsNewApiData = <String, dynamic>{}.obs;

  String discrepancyId = "";

  Map<String, TextEditingController> discrepancyDetailsTextController = <String, TextEditingController>{};

  RxBool obscureText = true.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    LoaderHelper.loaderWithGif();

    discrepancyId = Get.parameters['discrepancyId'].toString();

    await loadInitialData();

    isLoading.value = false;
    await EasyLoading.dismiss();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  loadInitialData() async {
    discrepancyDetailsNewApiData.clear();

    Response? data = await DiscrepancyNewApiProvider().discrepancyViewData(discrepancyId: discrepancyId);

    if (data?.statusCode == 200) {
      discrepancyDetailsNewApiData.addAll(data?.data["data"]["viewDiscrepancy"]);
    }
  }

  attachmentRemoveDialogView({required String attachmentId}) async {
    return showDialog(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Center(child: Text("Confirm Delete Discrepancies Documents", style: Theme.of(Get.context!).textTheme.headlineLarge)),
                content: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      children: [
                        const Icon(Icons.delete, size: 30, color: Colors.red),
                        Text("Are You Sure, Want To Delete?",
                            style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ]),
                ),
                actionsOverflowAlignment: OverflowBarAlignment.end,
                actionsOverflowButtonSpacing: 10.0,
                actions: [
                  ButtonConstant.dialogButton(
                      title: "Cancel",
                      borderColor: ColorConstants.black,
                      iconData: Icons.cancel_outlined,
                      enableIcon: true,
                      iconColor: Colors.white,
                      onTapMethod: () {
                        Get.back();
                      }),
                  ButtonConstant.dialogButton(
                      title: "Confirm Delete",
                      borderColor: ColorConstants.green,
                      enableIcon: true,
                      iconData: Icons.delete,
                      btnColor: ColorConstants.red,
                      onTapMethod: () async {
                        LoaderHelper.loaderWithGifAndText('Deleting...');
                        await attachmentRemoveApiCall(attachmentId: attachmentId);
                        update();
                      })
                ]),
          );
        });
      },
    );
  }

  electronicSignatureReformedDialogView() async {
    RxBool obscureTextShow = true.obs;
    TextEditingController textController = TextEditingController();
    GlobalKey<FormFieldState<dynamic>> validationKey = GlobalKey<FormFieldState>();

    return showDialog(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                  side: ThemeColorMode.isLight ? const BorderSide(color: ColorConstants.primary, width: 2) : const BorderSide(color: ColorConstants.primary),
                ),
                title: Center(child: Text("Electronic Signature", style: Theme.of(Get.context!).textTheme.headlineLarge)),
                content: SingleChildScrollView(
                  child: Column(children: [
                    const Text("By Clicking Below, You Are Certifying The Form Is Accurate & Complete."),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Expanded(child: Text("Name : ")),
                      Expanded(
                        flex: 2,
                        child: Text(UserSessionInfo.userFullName,
                            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontWeight: FontWeight.w600)),
                      )
                    ]),
                    const SizedBox(height: SizeConstants.contentSpacing * 2),
                    Row(
                      children: [
                        const Expanded(child: Text("Password :")),
                        Expanded(
                          flex: 2,
                          child: FormBuilderField(
                            name: "password",
                            key: validationKey,
                            validator: FormBuilderValidators.required(errorText: "Password is Required!"),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder: (FormFieldState<dynamic> field) {
                              return Obx(() {
                                return TextField(
                                  controller: textController,
                                  cursorColor: Colors.black,
                                  style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontWeight: FontWeight.normal),
                                  onChanged: (String? value) {
                                    if (value != "") {
                                      field.didChange(value);
                                    } else {
                                      field.reset();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 6),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorConstants.black.withValues(alpha: 0.1)),
                                        borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: ColorConstants.red), borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius)),
                                    errorText: field.errorText,
                                    suffixIcon: IconButton(
                                        splashRadius: 5,
                                        onPressed: () => obscureTextShow.value = !obscureTextShow.value,
                                        icon: Icon(
                                          size: 18,
                                          obscureTextShow.value ? Feather.eye : Feather.eye_off,
                                          color: ColorConstants.black.withValues(alpha: 0.5),
                                        )),
                                  ),
                                  obscureText: obscureTextShow.value,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
                actionsOverflowAlignment: OverflowBarAlignment.end,
                actionsOverflowButtonSpacing: 10.0,
                actions: [
                  ButtonConstant.dialogButton(
                      title: "Cancel",
                      borderColor: ColorConstants.red,
                      onTapMethod: () {
                        Get.back();
                      }),
                  ButtonConstant.dialogButton(
                      title: "Confirm",
                      borderColor: ColorConstants.green,
                      onTapMethod: () async {
                        Keyboard.close();
                        if (validationKey.currentState?.validate() ?? false) {
                          LoaderHelper.loaderWithGifAndText('Loading...');
                          await electronicSignatureApiCall(userPassword: textController.text);
                          update();
                        }
                      })
                ]),
          );
        });
      },
    );
  }

  electronicSignatureApiCall({required String userPassword}) async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyDetailsForAirPerformSignatureApiCall(discrepancyId: discrepancyId, userPassword: userPassword);
    if (data?.statusCode == 200) {
      discrepancyDetailsNewApiData.clear();
      await loadInitialData();
      Get.back(closeOverlays: true);
      update();
      await EasyLoading.dismiss();
      await SnackBarHelper.openSnackBar(isError: false, message: 'Electronic Signature Recorded For AIR Performed (ID: ${data?.data['data']['discrepancyId']})');
    }
  }

  attachmentRemoveApiCall({required String attachmentId}) async {
    Response? data = await DiscrepancyNewApiProvider().discrepancyViewAttachmentDeleteApiCall(attachmentId: attachmentId);
    if (data!.statusCode == 200) {
      await loadInitialData();
      Get.back(closeOverlays: true);
      update();
      await EasyLoading.dismiss();
    }
  }

/*electronicSignatureDialogView() async {

    discrepancyDetailsTextController.putIfAbsent("electronic_sig_user_name", () => TextEditingController());
    discrepancyDetailsTextController['electronic_sig_user_name']!.text = UserSessionInfo.userFullName;
    discrepancyDetailsTextController.putIfAbsent("electronic_sig_user_password", () => TextEditingController());

    return showDialog(
        useSafeArea: true,
        useRootNavigator: false,
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Padding(
            padding: DeviceType.isTablet
                ? DeviceOrientation.isLandscape
                    ? const EdgeInsets.fromLTRB(200.0, 100.0, 200.0, 100.0)
                    : const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 50.0)
                : const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Dialog(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                    side: const BorderSide(color: ColorConstants.primary, width: 2),
                  ),
                  child: Material(
                    color: ColorConstants.primary.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Center(
                          child: Text(
                            "Electronic Signature",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        Text("By Clicking Below, You Are Certifying The Item Is Accurate & Complete.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.normal)),
                        FormBuilderField(
                          name: "electronic_signature_user_name",
                          builder: (FormFieldState<dynamic> field) {
                            return TextFieldConstant.discrepancyAdditionalTextFields(
                                controller: discrepancyDetailsTextController.putIfAbsent("electronic_sig_user_name", () => TextEditingController()),
                                field: field,
                                title: "User Name",
                                readOnly: true,
                                showSuffixIcon: false,
                                hintText: "user Name");
                          },
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        FormBuilderField(
                          name: "electronic_signature_user_password",
                          validator: discrepancyDetailsTextController.putIfAbsent("electronic_sig_user_password", () => TextEditingController()).text.isNotEmpty
                              ? null
                              : FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "Password is Required!")]),
                          builder: (FormFieldState<dynamic> field) {
                            return Obx(() {
                              return TextFieldConstant.discrepancyAdditionalTextFields(
                                  controller: discrepancyDetailsTextController.putIfAbsent("electronic_sig_user_password", () => TextEditingController()),
                                  field: field,
                                  title: "Password",
                                  showSuffixIcon: true,
                                  isPassword: true,
                                  obscureTextShow: obscureText.value,
                                  obscureTextShowFunc: () {
                                    obscureText.value ? obscureText.value = false : obscureText.value = true;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: "Password");
                            });
                          },
                        ),
                        const SizedBox(height: SizeConstants.contentSpacing + 10),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          ButtonConstant.dialogButton(
                            title: "Cancel",
                            btnColor: ColorConstants.red,
                            borderColor: ColorConstants.grey,
                            onTapMethod: () {
                              discrepancyDetailsTextController["electronic_sig_user_password"]!.text = "";
                              Get.back();
                            },
                          ),
                          const SizedBox(width: SizeConstants.contentSpacing),
                          ButtonConstant.dialogButton(
                            title: "Confirm",
                            btnColor: ColorConstants.primary,
                            borderColor: ColorConstants.grey,
                            onTapMethod: () async {
                              //LoaderHelper.loaderWithGif();
                              //await melEditElectronicSignature(password: melEditTextEditingFieldController["electronic_sig_user_password"]!.text);
                            },
                          ),
                        ])
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }*/
}
