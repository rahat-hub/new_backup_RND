import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../../helper/loader_helper.dart';
import '../../forms_index_logic.dart';

class FormsIndexData {
  Obx viewFormsIndexData(FormsIndexLogic controller) {
    Get.find<FormsIndexLogic>();
    return Obx(() {
      return controller.isLoadingData.isFalse
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (controller.viewFormsJson["show_forms_queue"] ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        color: ColorConstants.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Forms Queue",
                            style: TextStyle(color: ColorConstants.white, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 2, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (Get.width > 980 && controller.viewFormsJson["forms_queue"]["rows"].length != 0)
                        Material(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          color: ColorConstants.primary.withValues(alpha: 0.8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    controller.viewFormsJson["forms_queue"]["headers"][0]["name"],
                                    style: TextStyle(
                                      fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                      fontWeight: FontWeight.w800,
                                      color: ColorConstants.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  controller.viewFormsJson["forms_queue"]["headers"][1]["name"],
                                  style: TextStyle(
                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                    fontWeight: FontWeight.w800,
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  controller.viewFormsJson["forms_queue"]["headers"][2]["name"],
                                  style: TextStyle(
                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                    fontWeight: FontWeight.w800,
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  controller.viewFormsJson["forms_queue"]["headers"][3]["name"],
                                  style: TextStyle(
                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                    fontWeight: FontWeight.w800,
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  controller.viewFormsJson["forms_queue"]["headers"][4]["name"],
                                  style: TextStyle(
                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                    fontWeight: FontWeight.w800,
                                    color: ColorConstants.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      controller.viewFormsJson["forms_queue"]["rows"].length == 0
                          ? Material(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: ColorConstants.primary.withValues(alpha: 0.5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                "None",
                                style: TextStyle(
                                  color: ColorConstants.white,
                                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.viewFormsJson["forms_queue"]["rows"].length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder:
                                (context, j) =>
                                    Get.width > 480
                                        ? Get.width > 980
                                            ? InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes.viewUserForm,
                                                  arguments: "fromIndex",
                                                  parameters: {"formId": controller.viewFormsJson["forms_queue"]["rows"][j]["forms_queue_id"].toString(), "masterFormId": "0"},
                                                );
                                              },
                                              child: Material(
                                                borderRadius:
                                                    j + 1 == controller.viewFormsJson["forms_queue"]["rows"].length
                                                        ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                                        : null,
                                                color: j % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Text(
                                                          controller.viewFormsJson["forms_queue"]["rows"][j]["form_name_type"],
                                                          style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller.viewFormsJson["forms_queue"]["rows"][j]["routing_level"].toString(),
                                                        style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        controller.viewFormsJson["forms_queue"]["rows"][j]["creating_user"],
                                                        style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        controller.viewFormsJson["forms_queue"]["rows"][j]["date_created"],
                                                        style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check,
                                                            color: Theme.of(Get.context!).colorScheme.primary,
                                                            size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                                                          ),
                                                          Text(
                                                            " ${controller.viewFormsJson["forms_queue"]["rows"][j]["completed"]}",
                                                            style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            : Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes.viewUserForm,
                                                    arguments: "fromIndex",
                                                    parameters: {"formId": controller.viewFormsJson["forms_queue"]["rows"][j]["forms_queue_id"].toString(), "masterFormId": "0"},
                                                  );
                                                },
                                                child: Material(
                                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                  color: ColorConstants.primary.withValues(alpha: 0.5),
                                                  child: Wrap(
                                                    alignment: WrapAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                Material(
                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
                                                                  color: ColorConstants.primary.withValues(alpha: 0.5),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                    child: Text(
                                                                      controller.viewFormsJson["forms_queue"]["headers"][0]["name"],
                                                                      style: TextStyle(
                                                                        fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                        fontWeight: FontWeight.w800,
                                                                        color: ColorConstants.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  child: Text(
                                                                    controller.viewFormsJson["forms_queue"]["rows"][j]["form_name_type"],
                                                                    style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                Material(
                                                                  color: ColorConstants.primary.withValues(alpha: 0.5),
                                                                  child: Text(
                                                                    controller.viewFormsJson["forms_queue"]["headers"][1]["name"],
                                                                    style: TextStyle(
                                                                      fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                      fontWeight: FontWeight.w800,
                                                                      color: ColorConstants.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  controller.viewFormsJson["forms_queue"]["rows"][j]["routing_level"].toString(),
                                                                  style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                Material(
                                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                                                                  color: ColorConstants.primary.withValues(alpha: 0.5),
                                                                  child: Text(
                                                                    controller.viewFormsJson["forms_queue"]["headers"][2]["name"],
                                                                    style: TextStyle(
                                                                      fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                      fontWeight: FontWeight.w800,
                                                                      color: ColorConstants.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  controller.viewFormsJson["forms_queue"]["rows"][j]["creating_user"],
                                                                  style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                Material(
                                                                  color: ColorConstants.primary.withValues(alpha: 0.5),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 5.0),
                                                                    child: Text(
                                                                      controller.viewFormsJson["forms_queue"]["headers"][3]["name"],
                                                                      style: TextStyle(
                                                                        fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                        fontWeight: FontWeight.w800,
                                                                        color: ColorConstants.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  child: Text(
                                                                    controller.viewFormsJson["forms_queue"]["rows"][j]["date_created"],
                                                                    style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                Material(
                                                                  color: ColorConstants.primary.withValues(alpha: 0.5),
                                                                  child: Text(
                                                                    controller.viewFormsJson["forms_queue"]["headers"][4]["name"],
                                                                    style: TextStyle(
                                                                      fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                      fontWeight: FontWeight.w800,
                                                                      color: ColorConstants.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons.check,
                                                                      color: Theme.of(Get.context!).colorScheme.primary,
                                                                      size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                                                                    ),
                                                                    Text(
                                                                      " ${controller.viewFormsJson["forms_queue"]["rows"][j]["completed"]}",
                                                                      style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                        : Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: InkWell(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.viewUserForm,
                                                arguments: "fromIndex",
                                                parameters: {"formId": controller.viewFormsJson["forms_queue"]["rows"][j]["forms_queue_id"].toString(), "masterFormId": "0"},
                                              );
                                            },
                                            child: Material(
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              color: ColorConstants.primary.withValues(alpha: 0.5),
                                              child: Wrap(
                                                alignment: WrapAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Material(
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                        color: ColorConstants.primary.withValues(alpha: 0.5),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 5.0),
                                                          child: Text(
                                                            controller.viewFormsJson["forms_queue"]["headers"][0]["name"],
                                                            style: TextStyle(
                                                              fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                              fontWeight: FontWeight.w800,
                                                              color: ColorConstants.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Text(
                                                          controller.viewFormsJson["forms_queue"]["rows"][j]["form_name_type"],
                                                          style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Material(
                                                              color: ColorConstants.primary.withValues(alpha: 0.5),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5.0),
                                                                child: Text(
                                                                  controller.viewFormsJson["forms_queue"]["headers"][1]["name"],
                                                                  style: TextStyle(
                                                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                    fontWeight: FontWeight.w800,
                                                                    color: ColorConstants.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              child: Text(
                                                                controller.viewFormsJson["forms_queue"]["rows"][j]["routing_level"].toString(),
                                                                style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Material(
                                                              color: ColorConstants.primary.withValues(alpha: 0.5),
                                                              child: Text(
                                                                controller.viewFormsJson["forms_queue"]["headers"][2]["name"],
                                                                style: TextStyle(
                                                                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                  fontWeight: FontWeight.w800,
                                                                  color: ColorConstants.white,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              controller.viewFormsJson["forms_queue"]["rows"][j]["creating_user"],
                                                              style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Material(
                                                              color: ColorConstants.primary.withValues(alpha: 0.5),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5.0),
                                                                child: Text(
                                                                  controller.viewFormsJson["forms_queue"]["headers"][3]["name"],
                                                                  style: TextStyle(
                                                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                    fontWeight: FontWeight.w800,
                                                                    color: ColorConstants.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              child: Text(
                                                                controller.viewFormsJson["forms_queue"]["rows"][j]["date_created"],
                                                                style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Material(
                                                              color: ColorConstants.primary.withValues(alpha: 0.5),
                                                              child: Text(
                                                                controller.viewFormsJson["forms_queue"]["headers"][4]["name"],
                                                                style: TextStyle(
                                                                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                                                                  fontWeight: FontWeight.w800,
                                                                  color: ColorConstants.white,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 3.0),
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    color: Theme.of(Get.context!).colorScheme.primary,
                                                                    size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    " ${controller.viewFormsJson["forms_queue"]["rows"][j]["completed"]}",
                                                                    style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                          ),
                    ],
                  ),
                ),
              controller.viewFormsJson["forms_view"] != null && controller.viewFormsJson["forms_view"].isNotEmpty
                  ? ListView.builder(
                    itemCount: controller.viewFormsJson["forms_view"] != null ? controller.viewFormsJson["forms_view"].length : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) => createItemsList(i, controller),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: ColorConstants.primary,
                      child: Text(
                        "No Master Forms Found . . .",
                        style: TextStyle(color: ColorConstants.white, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            ],
          )
          : const SizedBox();
    });
  }

  Padding createItemsList(i, FormsIndexLogic controller) {
    controller.itemList.add(controller.viewFormsJson["forms_view"][i]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: ColorConstants.primary,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 3.0, right: 5.0),
                  child: Text(
                    "${controller.viewFormsJson["forms_view"]![i]["form_sl_no"].toString()}.) ${controller.viewFormsJson["forms_view"][i]["master_form_name"]} ${controller.viewFormsJson["forms_view"][i]["inActive"] ? "- Inactive" : ""}",
                    style: TextStyle(color: ColorConstants.white, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 2, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  alignment: Get.width < 520 ? Alignment.centerRight : null,
                  margin: const EdgeInsets.only(right: 5.0, top: 2.0, bottom: 3.0),
                  child:
                      !(controller.viewFormsJson["forms_view"][i]["inActive"])
                          ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.button,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.add, color: ColorConstants.white, size: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! + 3),
                                Text(
                                  " Fill Out Form",
                                  style: TextStyle(
                                    color: ColorConstants.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 2,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              LoaderHelper.loaderWithGif();
                              await controller.getNewFillOutFormId(masterFormId: controller.viewFormsJson["forms_view"]![i]["master_form_id"].toString());
                              await EasyLoading.dismiss();

                              var reload = Get.toNamed(
                                Routes.fillOutForm,
                                arguments: "fromIndex",
                                parameters: {
                                  "masterFormId": controller.viewFormsJson["forms_view"]![i]["master_form_id"].toString(),
                                  "formId": controller.newFillOutFormData["form_id"].toString(),
                                  "formName": controller.newFillOutFormData["form_name"].toString(),
                                  "userMessage": controller.userMessage.value,
                                },
                              );

                              reload?.then((value) async {
                                if (value != null && value == true) {
                                  await controller.loadViewFormAllData();
                                }
                              });
                            },
                          )
                          : Text(
                            "In-Active Form",
                            style: TextStyle(
                              color: ColorConstants.white, //fontWeight: FontWeight.w800,
                              fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 2,
                            ),
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          controller.itemList[i]["rows"].length == 0
              ? Material(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: ColorConstants.primary.withValues(alpha: 0.8),
                child: Text(
                  "No Forms Found . . .",
                  style: TextStyle(color: ColorConstants.white, fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(defaultColumnWidth: const IntrinsicColumnWidth(), children: tableWidgets(i: i, controller: controller)[0]),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Get.width > 1200 && controller.itemList[i]["headers"].length <= 8 ? Axis.vertical : Axis.horizontal,
                      child: Table(defaultColumnWidth: const IntrinsicColumnWidth(), children: tableWidgets(i: i, controller: controller)[1]),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  List<List<TableRow>> tableWidgets({i, controller}) {
    List<TableRow> tableWidgets1 = <TableRow>[];
    List<TableRow> tableWidgets2 = <TableRow>[];
    tableWidgets1.add(
      TableRow(
        decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)), color: ColorConstants.primary.withValues(alpha: 0.8)),
        children: tableRowWidgets(i: i, controller: controller, header: true)[0],
      ),
    );
    tableWidgets2.add(
      TableRow(
        decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10)), color: ColorConstants.primary.withValues(alpha: 0.8)),
        children: tableRowWidgets(i: i, controller: controller, header: true)[1],
      ),
    );
    for (var j = 0; j < controller.itemList[i]["rows"].length; j++) {
      tableWidgets1.add(
        TableRow(
          decoration: BoxDecoration(
            borderRadius: j + 1 == controller.itemList[i]["rows"].length ? const BorderRadius.only(bottomLeft: Radius.circular(10)) : BorderRadius.zero,
            color: j % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.5),
          ),
          children: tableRowWidgets(i: i, j: j, controller: controller, header: false)[0],
        ),
      );
      tableWidgets2.add(
        TableRow(
          decoration: BoxDecoration(
            borderRadius: j + 1 == controller.itemList[i]["rows"].length ? const BorderRadius.only(bottomRight: Radius.circular(10)) : BorderRadius.zero,
            color: j % 2 == 0 ? ColorConstants.primary.withValues(alpha: 0.3) : ColorConstants.primary.withValues(alpha: 0.5),
          ),
          children: tableRowWidgets(i: i, j: j, controller: controller, header: false)[1],
        ),
      );
    }
    return [tableWidgets1, tableWidgets2];
  }

  List<List<Widget>> tableRowWidgets({i, j, controller, header}) {
    List<Widget> rowWidgets1 = <Widget>[];
    List<Widget> rowWidgets2 = <Widget>[];
    if (header) {
      rowWidgets1.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              "#",
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                fontWeight: FontWeight.w800,
                color: ColorConstants.white,
              ),
            ),
          ),
        ),
      );
      for (var k = 0; k < controller.itemList[i]["headers"].length; k++) {
        rowWidgets1.addIf(
          k == 1,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              controller.itemList[i]["headers"][k]["name"],
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                fontWeight: FontWeight.w800,
                color: ColorConstants.white,
              ),
            ),
          ),
        );
        rowWidgets2.addIf(
          k > 1,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              controller.itemList[i]["headers"][k]["name"],
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 4,
                fontWeight: FontWeight.w800,
                color: ColorConstants.white,
              ),
            ),
          ),
        );
      }
    } else {
      rowWidgets1.add(
        InkWell(
          onTap: () {
            Get.toNamed(
              Routes.viewUserForm,
              arguments: "fromIndex",
              parameters: {"formId": controller.itemList[i]["rows"][j]["f0"].toString(), "masterFormId": controller.viewFormsJson["forms_view"]![i]["master_form_id"].toString()},
            );
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text("${j + 1}", style: TextStyle(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3)),
            ),
          ),
        ),
      );
      for (var k = 0; k < controller.itemList[i]["headers"].length; k++) {
        rowWidgets1.addIf(
          k == 1,
          InkWell(
            onTap: () {
              Get.toNamed(
                Routes.viewUserForm,
                arguments: "fromIndex",
                parameters: {"formId": controller.itemList[i]["rows"][j]["f0"].toString(), "masterFormId": controller.viewFormsJson["forms_view"]![i]["master_form_id"].toString()},
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                controller.itemList[i]["rows"][j]["f$k"],
                style: TextStyle(
                  color:
                      k == 3
                          ? controller.itemList[i]["rows"][j]["f3"] ==
                                  "Approved" //greenText
                              ? ColorConstants.button
                              : controller.itemList[i]["rows"][j]["f3"] ==
                                  "Un-Approved" //blueText
                              ? ColorConstants.blue
                              : controller.itemList[i]["rows"][j]["f3"] ==
                                  "Denied" //redText
                              ? ColorConstants.red
                              : ColorConstants
                                  .orange //Pending + Unknown : orangeText
                          : null,
                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                ),
              ),
            ),
          ),
        );
        rowWidgets2.addIf(
          k > 1,
          InkWell(
            onTap: () {
              Get.toNamed(
                Routes.viewUserForm,
                arguments: "fromIndex",
                parameters: {"formId": controller.itemList[i]["rows"][j]["f0"].toString(), "masterFormId": controller.viewFormsJson["forms_view"]![i]["master_form_id"].toString()},
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                controller.itemList[i]["rows"][j]["f$k"],
                style: TextStyle(
                  color:
                      k == 3
                          ? controller.itemList[i]["rows"][j]["f3"] ==
                                  "Approved" //greenText
                              ? ColorConstants.button
                              : controller.itemList[i]["rows"][j]["f3"] ==
                                  "Un-Approved" //blueText
                              ? ColorConstants.blue
                              : controller.itemList[i]["rows"][j]["f3"] ==
                                  "Denied" //redText
                              ? ColorConstants.red
                              : ColorConstants
                                  .orange //Pending + Unknown : orangeText
                          : null,
                  fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3,
                ),
              ),
            ),
          ),
        );
      }
    }

    return [rowWidgets1, rowWidgets2];
  }
}
