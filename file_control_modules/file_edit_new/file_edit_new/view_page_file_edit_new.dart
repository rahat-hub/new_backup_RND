import 'dart:ui';

import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/shared/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../helper/loader_helper.dart';
import '../../../../shared/constants/constant_colors.dart';
import '../../../../shared/constants/constant_sizes.dart';
import '../../../../shared/services/device_orientation.dart';
import '../../../../shared/services/theme_color_mode.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/file_edit_new_widgets.dart';
import '../../../../widgets/text_widgets.dart';
import '../file_edit_new_logic.dart';

class FileEditNewPageViewCode extends StatelessWidget {
  final FileEditNewLogic controller;

  const FileEditNewPageViewCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 5.0,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10.0,
          runSpacing: 5.0,
          children: [
            SizedBox(
              width: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 70
                      : (Get.width / 2) - 70
                  : Get.width,
              child: Row(
                spacing: 10.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: DeviceType.isTablet
                        ? DeviceOrientation.isLandscape
                            ? (Get.width / 4) - 100
                            : (Get.width / 3) - 50
                        : Get.width / 2,
                    child: FileEditNewDateTime(
                      fieldName: "Document Date",
                      isDense: true,
                      disableKeyboard: controller.disableKeyboard,
                      dateTimeController: controller.fileEditNewTextEditingController.putIfAbsent('givenDate', () => TextEditingController()),
                      dateType: "date",
                      onConfirm: (dateTime) {
                        controller.documentsEditUpdateApiData["GivenDate"] = dateTime;
                        controller.fileEditNewTextEditingController['givenDate']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 5.0),
                    child: FileEditNewTextButton(
                      fieldName: '[ Today ]',
                      onPressed: () {
                        DateTime date = DateTimeHelper.now;
                        String formatDate = date.toString().split(' ').first;
                        String finalDate = '${formatDate}T00:00:00';
                        controller.documentsEditUpdateApiData['GivenDate'] = finalDate;
                        controller.fileEditNewTextEditingController['givenDate']!.text = DateFormat("MM/dd/yyyy").format(date);
                      },
                    ),
                  ),
                ],
              ),
            ),
            FileEditNewDropDown(
              expands: true,
              textFieldWidth: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 80
                      : (Get.width / 2) - 80
                  : Get.width,
              dropDownController: controller.fileEditNewTextEditingController.putIfAbsent('documentType', () => TextEditingController()),
              dropDownKey: 'name',
              req: true,
              dropDownData: controller.documentTypeDropdownData,
              hintText: controller.selectedDocumentTypeDropdown.isNotEmpty
                  ? controller.selectedDocumentTypeDropdown['name']
                  : controller.documentTypeDropdownData.isNotEmpty
                      ? controller.documentTypeDropdownData[0]['name']
                      : "Top Level",
              fieldName: "Document Type",
              onChanged: (value) async {
                controller.selectedDocumentTypeDropdown.value = value;
                controller.documentsEditUpdateApiData['DocumentCategoryId'] = int.parse(controller.selectedDocumentTypeDropdown['id'].toString());
              },
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10.0,
          runSpacing: 5.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.0,
              children: [
                FileEditNewDropDown(
                  expands: true,
                  textFieldWidth: DeviceType.isTablet
                      ? DeviceOrientation.isLandscape
                          ? (Get.width / 3) - 80
                          : (Get.width / 2) - 80
                      : Get.width,
                  dropDownController: controller.fileEditNewTextEditingController.putIfAbsent('required', () => TextEditingController()),
                  dropDownKey: 'name',
                  dropDownData: controller.requiredForStaffDropdownData,
                  hintText: controller.selectedRequiredForStaffDropdown.isNotEmpty
                      ? controller.selectedRequiredForStaffDropdown['name']
                      : controller.requiredForStaffDropdownData.isNotEmpty
                          ? controller.requiredForStaffDropdownData[0]['name']
                          : "No",
                  fieldName: "Required For Staff",
                  onChanged: (value) async {
                    controller.selectedRequiredForStaffDropdown.value = value;
                    controller.documentsEditUpdateApiData['Required'] = int.parse(controller.selectedRequiredForStaffDropdown['id'].toString());
                  },
                ),
                Text(
                  '* (Users Will Be Forced To View The Document Before Completing New Forms)',
                  style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            FileEditNewTextField(
                textFieldController: controller.fileEditNewTextEditingController.putIfAbsent('description', () => TextEditingController()),
                dataType: 'text',
                textFieldWidth: DeviceType.isTablet
                    ? DeviceOrientation.isLandscape
                        ? (Get.width / 3) - 80
                        : (Get.width / 2) - 80
                    : Get.width,
                maxCharacterLength: 500,
                fieldName: 'Description',
                onChanged: (value) {
                  controller.documentsEditUpdateApiData['Description'] = value;
                }),
          ],
        ),
        Obx(() {
          return controller.selectedRequiredForStaffDropdown['id'].toString() == '1' ? staffRequiredViewReturn() : const SizedBox();
        }),
        Obx(() {
          return (controller.selectedUserDataList.isEmpty && controller.selectedRequiredForStaffDropdown['id'].toString() != '0')
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Click Change To Select', style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize!, fontWeight: FontWeight.w400)),
                    ],
                  ),
                )
              : const SizedBox();
        }),
        Obx(() {
          return (controller.selectedUserDataList.isNotEmpty && controller.selectedRequiredForStaffDropdown['id'].toString() == '1')
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstants.primary),
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorConstants.grey.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: List.generate(controller.selectedUserDataList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                          child: Card(
                              elevation: 8, // Controls shadow depth
                              shadowColor: Colors.grey, // Custom shadow color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  controller.selectedUserDataList[index]['name'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                        );
                      }),
                    ),
                  ),
                )
              : const SizedBox();
        }),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.0,
            children: [
              SizedBox(
                height: SizeConstants.contentSpacing * 4,
                width: Get.width,
                child: Material(
                  color: ColorConstants.primary,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: TextScroll(
                        'Document History',
                        velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                        delayBefore: const Duration(milliseconds: 2000),
                        numberOfReps: 5,
                        intervalSpaces: 20,
                        style: TextStyle(
                            color: Colors.white, fontSize: Theme.of(Get.context!).textTheme.titleLarge!.fontSize! + 3, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                      ),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: 'Created: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                          text: DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(controller.fileEditNewApiData['flightOps']['createdAt'])),
                          style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                      TextSpan(text: '\tBy\t', style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black)),
                      TextSpan(
                          text: controller.fileEditNewApiData['flightOps']['createdByName'],
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    ]),
              ),
              RichText(
                text: TextSpan(
                    text: 'Last Edit: ',
                    style: TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w400, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize),
                    children: <TextSpan>[
                      TextSpan(
                          text: DateFormat("MM/dd/yyyy hh:mm:ss a").format(DateTime.parse(controller.fileEditNewApiData['flightOps']['lastEditAt'])),
                          style: TextStyle(
                              color: ThemeColorMode.isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                      TextSpan(text: '\tBy\t', style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black)),
                      TextSpan(
                          text: controller.fileEditNewApiData['flightOps']['lastEditByName'],
                          style:
                              TextStyle(color: ColorConstants.primary, fontWeight: FontWeight.w600, fontSize: Theme.of(Get.context!).textTheme.headlineMedium?.fontSize)),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  staffRequiredViewReturn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 5.0,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10.0,
          runSpacing: 5.0,
          children: [
            FileEditNewDropDown(
              expands: true,
              textFieldWidth: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 80
                      : (Get.width / 2) - 80
                  : Get.width,
              dropDownController: controller.fileEditNewTextEditingController.putIfAbsent('RequiredType', () => TextEditingController()),
              dropDownKey: 'name',
              dropDownData: controller.requiredForTypeDropdownData,
              hintText: controller.selectedRequiredForTypeDropdown.isNotEmpty
                  ? controller.selectedRequiredForTypeDropdown['name']
                  : controller.requiredForTypeDropdownData[0]['name'],
              fieldName: "Required For Type",
              onChanged: (value) async {
                controller.selectedRequiredForTypeDropdown.value = value;
                controller.documentsEditUpdateApiData['RequiredType'] = int.parse(controller.selectedRequiredForTypeDropdown['id'].toString());
                controller.availableUserRolesDataJson.clear();
                controller.checkBoxStatus.clear();
                controller.selectedUserDataList.clear();
              },
            ),
            SizedBox(
              width: DeviceType.isTablet
                  ? DeviceOrientation.isLandscape
                      ? (Get.width / 3) - 70
                      : (Get.width / 2) - 70
                  : Get.width,
              child: FileEditNewDateTime(
                fieldName: "Required Reading By",
                isDense: true,
                disableKeyboard: controller.disableKeyboard,
                dateTimeController: controller.fileEditNewTextEditingController.putIfAbsent('requiredByDate', () => TextEditingController()),
                dateType: "date",
                onConfirm: (dateTime) {
                  String formatDate = dateTime.toString().split(' ').first;
                  String finalDate = '${formatDate}T00:00:00';
                  controller.documentsEditUpdateApiData["RequiredByDate"] = finalDate;
                  controller.fileEditNewTextEditingController['requiredByDate']!.text = DateFormat("MM/dd/yyyy").format(dateTime);
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Required For', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              Align(
                alignment: Alignment.topLeft,
                child: FileEditNewMaterialButton(
                  icon: MaterialCommunityIcons.folder_edit,
                  borderColor: ColorConstants.primary,
                  buttonText: 'Change',
                  onPressed: () async {
                    LoaderHelper.loaderWithGif();
                    controller.availableUserRolesDataJson.clear();
                    controller.checkBoxStatus.clear();
                    controller.selectedUserDataList.clear();
                    await controller.apiCallForLoadSelectedMany();
                    await controller.changeButtonPopUpUpdate();
                    await userRoleSelectorPopupView();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  userRoleSelectorPopupView() {
    return showDialog(
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius), side: const BorderSide(color: ColorConstants.primary, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Center(child: TextWidget(text: "Available User Role Options", size: SizeConstants.largeText - 2)),
                const SizedBox(height: 10),
                Row(children: [
                  const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                  Obx(() {
                    return IconButton(
                      icon: Icon(!controller.selectAllCheckBox.value ? Icons.select_all : Icons.deselect, size: SizeConstants.iconSizes(type: SizeConstants.largeIcon)),
                      color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                      onPressed: () {
                        controller.selectAllCheckBox.value = !controller.selectAllCheckBox.value;
                        controller.checkBoxStatus.clear();
                        controller.selectedUserDataList.clear();
                        for (int i = 0; i < controller.availableUserRolesDataJson.length; i++) {
                          controller.checkBoxStatus.add(controller.selectAllCheckBox.value);
                          if (controller.selectAllCheckBox.value == true) {
                            controller.selectedUserDataList.add(controller.availableUserRolesDataJson[i]);
                          } else {
                            controller.selectedUserDataList.clear();
                          }
                        }
                      },
                    );
                  }),
                ]),
                Expanded(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.availableUserRolesDataJson.length,
                        itemBuilder: (context, i) {
                          return Obx(() {
                            return CheckboxListTile(
                              activeColor: ColorConstants.primary,
                              side: const BorderSide(color: ColorConstants.grey, width: 2),
                              value: controller.checkBoxStatus[i],
                              dense: true,
                              title: Text(controller.availableUserRolesDataJson[i]["name"].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          controller.selectAllCheckBox.value == true || controller.checkBoxStatus[i] == true ? ColorConstants.black : ColorConstants.grey,
                                      letterSpacing: 0.5)),
                              selected: controller.checkBoxStatus[i],
                              onChanged: (val) async {
                                controller.checkBoxStatus[i] = val!;
                                controller.selectAllUserCheck();
                                if (val == true) {
                                  controller.selectedUserDataList.add(controller.availableUserRolesDataJson[i]);
                                } else {
                                  controller.selectedUserDataList.removeWhere((item) {
                                    return item == controller.availableUserRolesDataJson[i];
                                  });
                                  controller.selectAllCheckBox.value = false;
                                }
                              },
                            );
                          });
                        },
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: SizeConstants.rootContainerSpacing),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ButtonConstant.dialogButton(
                      title: "Cancel",
                      borderColor: ColorConstants.red,
                      onTapMethod: () async {
                        // controller.staffId.value = controller.fileEditNewApiData['flightOps']['requiredUserRoles'];
                        await controller.changeButtonPopUpUpdate();
                        Get.back();
                      }),
                  const SizedBox(width: SizeConstants.contentSpacing),
                  ButtonConstant.dialogButton(
                    title: "Save & Close",
                    btnColor: ColorConstants.primary,
                    onTapMethod: () {
                      controller.staffId.value = '';
                      for (int i = 0; i < controller.selectedUserDataList.length; i++) {
                        controller.staffId.value += '${controller.selectedUserDataList[i]['id']},';
                      }
                      controller.documentsEditUpdateApiData['RequiredUserRoles'] = controller.staffId.value;
                      Get.back();
                    },
                  )
                ])
              ]),
            ),
          ),
        );
      },
    );
  }
}