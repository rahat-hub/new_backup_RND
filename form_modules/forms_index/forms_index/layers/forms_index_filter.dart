import 'package:aviation_rnd/helper/date_time_helper.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../widgets/form_widgets.dart';
import '../../../../../widgets/widgets.dart';
import '../../forms_index_logic.dart';

class FormsIndexFilter {
  Padding filter(FormsIndexLogic controller, BuildContext context) {
    Get.find<FormsIndexLogic>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: ColorConstants.primary.withValues(alpha: 0.5)),
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        child:
            Get.width > 980
                ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "form_type",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Form Type",
                                        dropDownData: controller.formTypeList,
                                        hintText: controller.selectedFormType.isNotEmpty ? controller.selectedFormType["name"] : controller.formTypeList[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedFormType.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Obx(() {
                            return DynamicTextField(
                              title: "Start Date",
                              titleTextStyle: TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3),
                              dataType: "filter",
                              inputTextSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                              isDense: false,
                              controller: controller.startDateController,
                              readOnly: controller.disableKeyboard.value,
                              showCursor: !controller.disableKeyboard.value,
                              textInputType: controller.disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                              textInputAction: TextInputAction.search,
                              hintText: "mm/dd/yyyy",
                              hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                              onTap: () {
                                if (controller.disableKeyboard.isTrue) {
                                  DatePicker.showDatePicker(
                                    context,
                                    maxDateTime: DateTimeHelper.now.add(const Duration(days: 1)),
                                    onConfirm: (date, list) async {
                                      controller.disableKeyboard.value = true;
                                      controller.startDateController.text = DateTimeHelper.dateFormatDefault.format(date);
                                      controller.selectedStartDate.value = DateTimeHelper.dateFormatDefault.format(date);
                                      await controller.loadViewFormAllData();
                                      await controller.saveFilterSelectedValues();
                                    },
                                    onCancel: () {
                                      controller.disableKeyboard.value = false;
                                    },
                                    initialDateTime: DateTimeHelper.now.subtract(const Duration(days: 15)),
                                    locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                  );
                                }
                              },
                              onChanged: (date) {
                                controller.selectedStartDate.value = date;
                              },
                              onEditingComplete: () async {
                                if (DateTimeHelper.isValidDate(date: controller.startDateController.text.toString())) {
                                  await controller.loadViewFormAllData();
                                  await controller.saveFilterSelectedValues();
                                  controller.disableKeyboard.value = true;
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "aircraft",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Aircraft",
                                        dropDownData: controller.aircraftTypeList,
                                        hintText:
                                            controller.selectedAircraftType.isNotEmpty
                                                ? controller.selectedAircraftType["name"]
                                                : controller.aircraftTypeList.isNotEmpty
                                                ? controller.aircraftTypeList[0]["name"]
                                                : "All Aircraft",
                                        onChanged: (val) async {
                                          controller.selectedAircraftType.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "records_to_display",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Records No",
                                        dropDownData: controller.recordNumbers,
                                        hintText: controller.selectedRecordsNo.isNotEmpty ? controller.selectedRecordsNo["name"] : controller.recordNumbers[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedRecordsNo.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "personnel_name",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "User Name",
                                        tooltip: "Creating Or Referenced",
                                        dropDownData: controller.userNameList,
                                        hintText:
                                            controller.selectedUserName.isNotEmpty
                                                ? controller.selectedUserName["name"]
                                                : controller.selectCurrentUser
                                                ? controller.userNameList[0]["name"]
                                                : controller.userNameList[1]["name"],
                                        onChanged: (val) async {
                                          controller.selectedUserName.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: Obx(() {
                            return DynamicTextField(
                              title: "End Date",
                              titleTextStyle: TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3),
                              dataType: "filter",
                              inputTextSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                              isDense: false,
                              controller: controller.endDateController,
                              readOnly: controller.disableKeyboard.value,
                              showCursor: !controller.disableKeyboard.value,
                              textInputType: controller.disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                              textInputAction: TextInputAction.search,
                              hintText: "mm/dd/yyyy",
                              hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                              onTap: () {
                                if (controller.disableKeyboard.isTrue) {
                                  DatePicker.showDatePicker(
                                    context,
                                    maxDateTime: DateTimeHelper.now.add(const Duration(days: 1)),
                                    onConfirm: (date, list) async {
                                      controller.disableKeyboard.value = true;
                                      controller.endDateController.text = DateTimeHelper.dateFormatDefault.format(date);
                                      controller.selectedEndDate.value = DateTimeHelper.dateFormatDefault.format(date);
                                      await controller.loadViewFormAllData();
                                      await controller.saveFilterSelectedValues();
                                    },
                                    onCancel: () {
                                      controller.disableKeyboard.value = false;
                                    },
                                    initialDateTime: DateTimeHelper.now,
                                    locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                  );
                                }
                              },
                              onChanged: (date) {
                                controller.selectedEndDate.value = date;
                              },
                              onEditingComplete: () async {
                                if (DateTimeHelper.isValidDate(date: controller.endDateController.text.toString())) {
                                  await controller.loadViewFormAllData();
                                  await controller.saveFilterSelectedValues();
                                  controller.disableKeyboard.value = true;
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "open_completed",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Open/Completed",
                                        dropDownData: controller.formStatus,
                                        hintText: controller.selectedFormStatus.isNotEmpty ? controller.selectedFormStatus["name"] : controller.formStatus[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedFormStatus.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "routing_decision",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Routing Decision",
                                        dropDownData: controller.routingDecisions,
                                        hintText:
                                            controller.selectedRoutingDecision.isNotEmpty ? controller.selectedRoutingDecision["name"] : controller.routingDecisions[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedRoutingDecision.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "form_type",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Form Type",
                                        dropDownData: controller.formTypeList,
                                        hintText:
                                            controller.selectedFormType.isNotEmpty
                                                ? controller.selectedFormType["name"]
                                                : controller.formTypeList.isNotEmpty
                                                ? controller.formTypeList[0]["name"]
                                                : "",
                                        onChanged: (val) async {
                                          controller.selectedFormType.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "records_to_display",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Records No",
                                        dropDownData: controller.recordNumbers,
                                        hintText: controller.selectedRecordsNo.isNotEmpty ? controller.selectedRecordsNo["name"] : controller.recordNumbers[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedRecordsNo.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return DynamicTextField(
                              title: "Start Date",
                              titleTextStyle: TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3),
                              dataType: "filter",
                              inputTextSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                              isDense: false,
                              controller: controller.startDateController,
                              readOnly: controller.disableKeyboard.value,
                              showCursor: !controller.disableKeyboard.value,
                              textInputType: controller.disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                              textInputAction: TextInputAction.search,
                              hintText: "mm/dd/yyyy",
                              hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                              onTap: () {
                                if (controller.disableKeyboard.isTrue) {
                                  DatePicker.showDatePicker(
                                    context,
                                    maxDateTime: DateTimeHelper.now.add(const Duration(days: 1)),
                                    onConfirm: (date, list) async {
                                      controller.disableKeyboard.value = true;
                                      controller.startDateController.text = DateTimeHelper.dateFormatDefault.format(date);
                                      controller.selectedStartDate.value = DateTimeHelper.dateFormatDefault.format(date);
                                      await controller.loadViewFormAllData();
                                      await controller.saveFilterSelectedValues();
                                    },
                                    onCancel: () {
                                      controller.disableKeyboard.value = false;
                                    },
                                    initialDateTime: DateTimeHelper.now.subtract(const Duration(days: 15)),
                                    locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                  );
                                }
                              },
                              onChanged: (date) {
                                controller.selectedStartDate.value = date;
                              },
                              onEditingComplete: () async {
                                if (DateTimeHelper.isValidDate(date: controller.startDateController.text.toString())) {
                                  await controller.loadViewFormAllData();
                                  await controller.saveFilterSelectedValues();
                                  controller.disableKeyboard.value = true;
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() {
                            return DynamicTextField(
                              title: "End Date",
                              titleTextStyle: TextStyle(fontSize: Theme.of(context).textTheme.displayMedium!.fontSize! - 3),
                              dataType: "filter",
                              inputTextSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                              isDense: false,
                              controller: controller.endDateController,
                              readOnly: controller.disableKeyboard.value,
                              showCursor: !controller.disableKeyboard.value,
                              textInputType: controller.disableKeyboard.value ? TextInputType.none : TextInputType.datetime,
                              textInputAction: TextInputAction.search,
                              hintText: "mm/dd/yyyy",
                              hintStyle: TextStyle(color: ColorConstants.grey, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 5),
                              onTap: () {
                                if (controller.disableKeyboard.isTrue) {
                                  DatePicker.showDatePicker(
                                    context,
                                    maxDateTime: DateTimeHelper.now.add(const Duration(days: 1)),
                                    onConfirm: (date, list) async {
                                      controller.disableKeyboard.value = true;
                                      controller.endDateController.text = DateTimeHelper.dateFormatDefault.format(date);
                                      controller.selectedEndDate.value = DateTimeHelper.dateFormatDefault.format(date);
                                      await controller.loadViewFormAllData();
                                      await controller.saveFilterSelectedValues();
                                    },
                                    onCancel: () {
                                      controller.disableKeyboard.value = false;
                                    },
                                    initialDateTime: DateTimeHelper.now,
                                    locale: DATETIME_PICKER_LOCALE_DEFAULT,
                                  );
                                }
                              },
                              onChanged: (date) {
                                controller.selectedEndDate.value = date;
                              },
                              onEditingComplete: () async {
                                if (DateTimeHelper.isValidDate(date: controller.endDateController.text.toString())) {
                                  await controller.loadViewFormAllData();
                                  await controller.saveFilterSelectedValues();
                                  controller.disableKeyboard.value = true;
                                }
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "personnel_name",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "User Name",
                                        tooltip: "Creating Or Referenced",
                                        dropDownData: controller.userNameList,
                                        hintText:
                                            controller.selectedUserName.isNotEmpty
                                                ? controller.selectedUserName["name"]
                                                : controller.selectCurrentUser
                                                ? controller.userNameList[0]["name"]
                                                : controller.userNameList[1]["name"],
                                        onChanged: (val) async {
                                          controller.selectedUserName.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "aircraft",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Aircraft",
                                        dropDownData: controller.aircraftTypeList,
                                        hintText:
                                            controller.selectedAircraftType.isNotEmpty
                                                ? controller.selectedAircraftType["name"]
                                                : controller.aircraftTypeList.isNotEmpty
                                                ? controller.aircraftTypeList[0]["name"]
                                                : "All Aircraft",
                                        onChanged: (val) async {
                                          controller.selectedAircraftType.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "open_completed",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Open/Completed",
                                        dropDownData: controller.formStatus,
                                        hintText: controller.selectedFormStatus.isNotEmpty ? controller.selectedFormStatus["name"] : controller.formStatus[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedFormStatus.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ResponsiveBuilder(
                            builder:
                                (context, sizingInformation) => FormBuilderField(
                                  name: "routing_decision",
                                  builder: (FormFieldState<dynamic> field) {
                                    return Obx(() {
                                      return WidgetConstant.customDropDownWidgetNew(
                                        dropDownKey: "name",
                                        context: context,
                                        showTitle: true,
                                        title: "Routing Decision",
                                        dropDownData: controller.routingDecisions,
                                        hintText:
                                            controller.selectedRoutingDecision.isNotEmpty ? controller.selectedRoutingDecision["name"] : controller.routingDecisions[0]["name"],
                                        onChanged: (val) async {
                                          controller.selectedRoutingDecision.value = val;
                                          await controller.loadViewFormAllData();
                                          await controller.saveFilterSelectedValues();
                                        },
                                      );
                                    });
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
