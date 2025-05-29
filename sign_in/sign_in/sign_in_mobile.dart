import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:aviation_rnd/widgets/text_fields.dart';
import 'package:aviation_rnd/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../sign_in_logic.dart';

class SignInMobilePortrait extends GetView<SignInLogic> {
  const SignInMobilePortrait({super.key});

  static final _loginFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Get.find<SignInLogic>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing, vertical: SizeConstants.contentSpacing),
                child: Obx(() => controller.themeSwitch()),
              ),
            ),
            Flexible(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: SizeConstants.contentSpacing),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          Get.width > 540
                              ? 510
                              : Get.width > 30
                              ? Get.width - 30
                              : double.infinity,
                    ),
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shadowColor: ColorConstants.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeConstants.contentSpacing),
                        side: const BorderSide(color: ColorConstants.primary, width: 2),
                      ),
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.only(left: SizeConstants.contentSpacing), child: Image.asset(AssetConstants.logo, gaplessPlayback: true)),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          const Text("Digital AirWare Service Log In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: SizeConstants.contentSpacing * 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing),
                            child: FormBuilder(
                              key: _loginFormKey,
                              child: AutofillGroup(
                                child: Column(
                                  children: [
                                    FormBuilderField(
                                      name: "username",
                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "User Name is Required!")]),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      builder: (FormFieldState<dynamic> field) {
                                        return TextFieldConstant.textField(
                                          controller: controller.saveUserName,
                                          field: field,
                                          hintText: "User Name (Login ID)",
                                          autofillHints: AutofillHints.username,
                                          textInputAction: TextInputAction.next,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: SizeConstants.contentSpacing * 2),
                                    FormBuilderField(
                                      name: "password",
                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "Password is Required!")]),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      builder: (FormFieldState<dynamic> field) {
                                        return Obx(() {
                                          return TextFieldConstant.textField(
                                            field: field,
                                            hintText: "Password",
                                            isPassword: true,
                                            obscureTextShow: controller.obscureText.value,
                                            obscureTextShowFunc: () => controller.obscureText.value = !controller.obscureText.value,
                                            autofillHints: AutofillHints.password,
                                            onEditingComplete: () async {
                                              _loginFormKey.currentState?.fields["username"]?.didChange(controller.saveUserName.text);
                                              if (controller.isLoadingLoggingIn.value != true) {
                                                if (_loginFormKey.currentState!.validate()) {
                                                  _loginFormKey.currentState!.save();
                                                  await controller.getToken(
                                                    key1: _loginFormKey.currentState!.value["username"],
                                                    key2: _loginFormKey.currentState!.value["password"],
                                                  );
                                                }
                                              }
                                            },
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          Row(
                            children: [
                              Obx(() {
                                return Checkbox(
                                  value: controller.checkbox.value,
                                  side: BorderSide(color: controller.isDark.value ? ColorConstants.white : ColorConstants.black, width: 2, style: BorderStyle.solid),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  onChanged: (value) => controller.checkbox.value = value!,
                                );
                              }),
                              Flexible(child: InkWell(onTap: () => controller.checkbox.value = !controller.checkbox.value, child: const Text("Remember User Name"))),
                            ],
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing),
                            child: Obx(() {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: ButtonConstant.buttonWidgetSingle(
                                      onTap: () async {
                                        _loginFormKey.currentState?.fields["username"]?.didChange(controller.saveUserName.text);
                                        if (controller.isLoadingLoggingIn.value != true) {
                                          if (_loginFormKey.currentState!.validate()) {
                                            _loginFormKey.currentState!.save();
                                            await controller.getToken(key1: _loginFormKey.currentState!.value["username"], key2: _loginFormKey.currentState!.value["password"]);
                                          }
                                        }
                                      },
                                      title: "L O G I N",
                                      isLoadingLoggingIn: controller.isLoadingLoggingIn.value,
                                    ),
                                  ),
                                  const SizedBox(width: SizeConstants.contentSpacing),
                                  Obx(() {
                                    return Expanded(
                                      child: ButtonConstant.buttonWidgetSingleWithIcon(
                                        onTap: () async {
                                          StoragePrefs().lsRead(key: StorageConstants.biometricSignatureSupport) == true
                                              ? controller.biometricSignatureEnable.value == false
                                                  ? SnackBarHelper.openSnackBar(isError: true, message: "Biometric Verification is Not Enabled!")
                                                  : await controller.biometricAuth()
                                              : SnackBarHelper.openSnackBar(isError: true, message: "Device doesn't Support Biometric Verification or Not Configured!");
                                        },
                                        customImageIcon: true,
                                        iconImage: controller.isFaceID.isTrue ? AssetConstants.iosFaceId : AssetConstants.fingerPrintLogo,
                                        iconSize: Theme.of(Get.context!).textTheme.labelSmall!.fontSize! + 15,
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing),
                            child: TextWidget(
                              text: "Please Contact your Administrator for Password Reset",
                              color: ColorConstants.blue,
                              size: SizeConstants.extraMediumText,
                              weight: FontWeight.w700,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing * 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInMobileLandscape extends GetView<SignInLogic> {
  const SignInMobileLandscape({super.key});

  static final _loginFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Get.find<SignInLogic>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (Keyboard.isClose)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing, vertical: SizeConstants.contentSpacing),
                  child: Obx(() => controller.themeSwitch()),
                ),
              ),
            Flexible(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: SizeConstants.contentSpacing),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          Get.width > 540
                              ? 510
                              : Get.width > 30
                              ? Get.width - 30
                              : double.infinity,
                    ),
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shadowColor: ColorConstants.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeConstants.contentSpacing),
                        side: const BorderSide(color: ColorConstants.primary, width: 2),
                      ),
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.only(left: SizeConstants.contentSpacing), child: Image.asset(AssetConstants.logo, gaplessPlayback: true)),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          const Text("Digital AirWare Service Log In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: SizeConstants.contentSpacing * 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing),
                            child: FormBuilder(
                              key: _loginFormKey,
                              child: AutofillGroup(
                                child: Column(
                                  children: [
                                    FormBuilderField(
                                      name: "username",
                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "User Name is Required!")]),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      builder: (FormFieldState<dynamic> field) {
                                        return TextFieldConstant.textField(
                                          controller: controller.saveUserName,
                                          field: field,
                                          hintText: "User Name (Login ID)",
                                          autofillHints: AutofillHints.username,
                                          textInputAction: TextInputAction.next,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: SizeConstants.contentSpacing * 2),
                                    FormBuilderField(
                                      name: "password",
                                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "Password is Required!")]),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      builder: (FormFieldState<dynamic> field) {
                                        return Obx(() {
                                          return TextFieldConstant.textField(
                                            field: field,
                                            hintText: "Password",
                                            isPassword: true,
                                            obscureTextShow: controller.obscureText.value,
                                            obscureTextShowFunc: () => controller.obscureText.value = !controller.obscureText.value,
                                            autofillHints: AutofillHints.password,
                                            onEditingComplete: () async {
                                              _loginFormKey.currentState?.fields["username"]?.didChange(controller.saveUserName.text);
                                              if (controller.isLoadingLoggingIn.value != true) {
                                                if (_loginFormKey.currentState!.validate()) {
                                                  _loginFormKey.currentState!.save();
                                                  await controller.getToken(
                                                    key1: _loginFormKey.currentState!.value["username"],
                                                    key2: _loginFormKey.currentState!.value["password"],
                                                  );
                                                }
                                              }
                                            },
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          Row(
                            children: [
                              Obx(() {
                                return Checkbox(
                                  value: controller.checkbox.value,
                                  side: BorderSide(color: controller.isDark.value ? ColorConstants.white : ColorConstants.black, width: 2, style: BorderStyle.solid),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  onChanged: (value) => controller.checkbox.value = value!,
                                );
                              }),
                              Flexible(child: InkWell(onTap: () => controller.checkbox.value = !controller.checkbox.value, child: const Text("Remember User Name"))),
                            ],
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing),
                            child: Obx(() {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: ButtonConstant.buttonWidgetSingle(
                                      onTap: () async {
                                        _loginFormKey.currentState?.fields["username"]?.didChange(controller.saveUserName.text);
                                        if (controller.isLoadingLoggingIn.value != true) {
                                          if (_loginFormKey.currentState!.validate()) {
                                            _loginFormKey.currentState!.save();
                                            await controller.getToken(key1: _loginFormKey.currentState!.value["username"], key2: _loginFormKey.currentState!.value["password"]);
                                          }
                                        }
                                      },
                                      title: "L O G I N",
                                      isLoadingLoggingIn: controller.isLoadingLoggingIn.value,
                                    ),
                                  ),
                                  const SizedBox(width: SizeConstants.contentSpacing),
                                  Obx(() {
                                    return Expanded(
                                      child: ButtonConstant.buttonWidgetSingleWithIcon(
                                        onTap: () async {
                                          StoragePrefs().lsRead(key: StorageConstants.biometricSignatureSupport) == true
                                              ? controller.biometricSignatureEnable.value == false
                                                  ? SnackBarHelper.openSnackBar(isError: true, message: "Biometric Verification is Not Enabled!")
                                                  : await controller.biometricAuth()
                                              : SnackBarHelper.openSnackBar(isError: true, message: "Device doesn't Support Biometric Verification or Not Configured!");
                                        },
                                        customImageIcon: true,
                                        iconImage: controller.isFaceID.isTrue ? AssetConstants.iosFaceId : AssetConstants.fingerPrintLogo,
                                        iconSize: Theme.of(Get.context!).textTheme.labelSmall!.fontSize! + 15,
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: SizeConstants.contentSpacing),
                            child: TextWidget(
                              text: "Please Contact your Administrator for Password Reset",
                              color: ColorConstants.blue,
                              size: SizeConstants.extraMediumText,
                              weight: FontWeight.w700,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: SizeConstants.contentSpacing * 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
