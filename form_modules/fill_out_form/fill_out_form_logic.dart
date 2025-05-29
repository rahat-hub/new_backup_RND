import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart' hide Response;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:signature/signature.dart';

import '../../../helper/date_time_helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../helper/snack_bar_helper.dart';
import '../../../provider/forms_api_provider.dart';
import '../../../shared/constants/constant_colors.dart';
import '../../../shared/constants/constant_sizes.dart';
import '../../../shared/services/keyboard.dart';
import '../../../shared/services/theme_color_mode.dart';
import '../../../shared/utils/logged_in_data.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/text_widgets.dart';
import '../form_designer_js.dart';

class FillOutFormLogic extends GetxController with GetTickerProviderStateMixin, FormDesignerJs {
  var fillOutFormAllData = {}.obs;
  var pageList = [].obs;
  var rowsData = [].obs;

  var tabScrollerControllerStop = false.obs;
  List<Tab> myTabs = <Tab>[].obs;
  late Rx<TabController> tabController;

  final formValidationKey = <GlobalKey<FormBuilderState>>[];
  final itemScrollController = <ItemScrollController>[];
  final scrollOffsetController = <ScrollOffsetController>[];
  final itemPositionsListener = <ItemPositionsListener>[];
  final scrollOffsetListener = <ScrollOffsetListener>[];

  List<Widget> widgetsForEachRow = <Widget>[].obs;
  List<Widget> widgetsForEachTab = <Widget>[].obs;

  RxMap<String, FocusNode> fillOutFocusNodes = <String, FocusNode>{}.obs;
  RxMap<String, TextEditingController> fillOutInputControllers = <String, TextEditingController>{}.obs;
  RxMap<String, TextEditingController> fillOutDropDownControllers = <String, TextEditingController>{}.obs;
  RxMap<String, TextEditingController> fillOutSignatureLookUpController = <String, TextEditingController>{}.obs;
  RxMap<String, SignatureController> signatureController = <String, SignatureController>{}.obs;

  var penSignatureClearButtonEnable = {}.obs;
  var penSignatureStoreButtonEnable = {}.obs;
  var penSignatureDateTime = {}.obs;
  var penSignatureDateTimeValue = {}.obs;

  var selectedDropDown = {}.obs;
  var formFieldPreValues = {};
  var dropDownFieldValues = {};
  var dateTimeDisableKeyboard = true.obs;

  var formName = "".obs;
  var isLoading = false.obs;
  var dataLoaded = false.obs;

  var formAttachmentFiles = [].obs;
  var formEditData = {};
  var fieldsPositions = <String, Map<String, int>>{};
  var createdFields = [];

  //late final AppLifecycleListener _listener;
  //final List<String> _states = <String>[];
  //late AppLifecycleState? _state;

  @override
  void onInit() async {
    super.onInit();
    /*_state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onResume: () {
        print("onResume");
        _states.add("onResume");
      },
      onDetach: () {
        print("onResume");
        _states.add("onResume");
      },
      onHide: () {
        print("onResume");
        _states.add("onResume");
      },
      onInactive: () {
        print("onResume");
        _states.add("onResume");
      },
      onPause: () {
        print("onResume");
        _states.add("onResume");
      },
      onRestart: () {
        print("onResume");
        _states.add("onResume");
      },
      onShow: () {
        print("onResume");
        _states.add("onResume");
      },
      onStateChange: (value) {
        _state = value;
        print(_state);
      },
    );*/

    dataLoaded.value = false;
    isLoading.value = true;
    LoaderHelper.loaderWithGif();
    await setInitialFillOutFormData();
    await getInitialFillOutFormData();
    await getAndSetTab();
    await tabView();

    /*scrollController.addListener(() {
      print(scrollController.position.isScrollingNotifier);
        if (scrollController.position.userScrollDirection == ScrollDirection.forward || scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          scrolling.value = true;
        }
        Future.delayed(const Duration(seconds: 3), (){
          scrolling.value = false;
        });
      });*/
  }

  @override
  void onClose() {
    intervalID?.cancel();
    //_listener.dispose();
    super.onClose();
  }

  Future<void> getInitialFillOutFormData() async {
    fillOutFormAllData.clear();
    pageList.clear();

    Response response = await FormsApiProvider().getInitialFillOutFormData(fillOutFormId: Get.parameters["formId"] ?? lastViewedFormId, needMobileViewData: true);
    if (response.statusCode == 200) {
      fillOutFormAllData.addAll(response.data["data"]);
      formName.value = fillOutFormAllData["formName"];
      pageList.addAll(fillOutFormAllData["formFilloutMobile"]["tabs"]);
      formEditData.addAll(fillOutFormAllData["formFilloutMobile"]["formEditData"]);

      for (int i = 0; i < fillOutFormAllData["usersPreviousChoicesList"].length; i++) {
        formFieldPreValues.addIf(
          true,
          fillOutFormAllData["usersPreviousChoicesList"][i]["formFieldId"].toString(),
          fillOutFormAllData["usersPreviousChoicesList"][i]["formFieldValue"].toString() == "1900-01-01"
              ? ""
              : fillOutFormAllData["usersPreviousChoicesList"][i]["formFieldValue"].toString(),
        );

        values.addIf(
          true,
          fillOutFormAllData["usersPreviousChoicesList"][i]["formFieldId"].toString(),
          fillOutFormAllData["usersPreviousChoicesList"][i]["formFieldValue"].toString() == "1900-01-01"
              ? ""
              : fillOutFormAllData["usersPreviousChoicesList"][i]["formFieldValue"].toString(),
        );
      }

      formAttachmentFiles.value = fillOutFormAllData["objFormUploadFiles"] ?? [];
    }
  }

  Future<void> getAndSetTab() async {
    for (int i = 0; i < pageList.length; i++) {
      myTabs.add(Tab(height: 42 * Get.textScaleFactor, child: Text(pageList[i]["tabName"])));
    }
    tabController = TabController(length: myTabs.length, vsync: this).obs;
  }

  Future<void> updateFieldValues() async {
    values.forEach((fieldId, value) async {
      if (!extendedFields.contains(fieldId)) {
        fillOutInputControllers.putIfAbsent(fieldId, () => TextEditingController());
        fillOutInputControllers[fieldId]?.text = value.toString();
      } else if (extendedTextFields.contains(fieldId) && updateExtendedTextField == fieldId) {
        LoaderHelper.loaderWithGif();
        await loadExtendedField(strFieldID: fieldId, strNarrativeID: value, strFieldTypeID: "28");
        fillOutInputControllers.putIfAbsent(fieldId, () => TextEditingController());
        fillOutInputControllers[fieldId]?.text = extendedFieldsValue[fieldId] ?? "";
        updateExtendedTextField = "";
        EasyLoading.dismiss();
      }
    });
  }

  Future<List<Widget>> tabView() async {
    widgetsForEachTab.clear();
    rowsData.clear();
    scrollOffsetListener.clear();
    itemPositionsListener.clear();
    scrollOffsetController.clear();
    itemScrollController.clear();
    formValidationKey.clear();

    for (int i = 0; i < pageList.length; i++) {
      formValidationKey.add(GlobalKey<FormBuilderState>());
      itemScrollController.add(ItemScrollController());
      scrollOffsetController.add(ScrollOffsetController());
      itemPositionsListener.add(ItemPositionsListener.create());
      scrollOffsetListener.add(ScrollOffsetListener.create());
      rowsData.add(pageList[i]["rows"]);

      for (int j = 0; j < pageList[i]["rows"].length; j++) {
        for (int k = 0; k < rowsData[i][j]["columns"].length; k++) {
          if (rowsData[i][j]["columns"][k]["cssClassName"] != null && rowsData[i][j]["columns"][k]["cssClassName"] != '') {
            var fieldClass = rowsData[i][j]["columns"][k]["cssClassName"].toString().split(" ");
            for (var key in fieldClass) {
              jsClass[key]?.addIf(jsClass[key]?.contains(rowsData[i][j]["columns"][k]["id"].toString()) == false, rowsData[i][j]["columns"][k]["id"].toString());
            }
          }

          if (rowsData[i][j]["columns"][k]["formFieldType"] == 144) {
            jsClass["raforms"]?.addIf(jsClass["raforms"]?.contains(rowsData[i][j]["columns"][k]["id"].toString()) == false, rowsData[i][j]["columns"][k]["id"]);
          }

          switch (rowsData[i][j]["columns"][k]["formFieldType"] as int) {
            case 3 || 4 || 6 || 25 || 27 || 31 || 32 || 66 || 67 || 70 || 71 || 72 || 73 || 74 || 75 || 91 || 144 || 250 || 1000: // DropDown
            case (>= 200 && < 250) || (>= 350 && < 450): // DropDown UR: User Roles (200-249) && Form Chooser (350-450)
              if (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                rowsData[i][j]["columns"][k]["elementData"].forEach((element) async {
                  if (element["id"] == (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
                    if (rowsData[i][j]["columns"][k]["formFieldType"] == 4) {
                      await loadACData(id: element["id"]);
                    }
                    dropDownFieldValues.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), element["name"]);
                  }
                });
              }
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 26: //GPS COORDINATES - DDD MM.MMM FORMAT
              if (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                var strThisCoordinates = formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()].toString().trim();
                strThisCoordinates = strThisCoordinates.replaceAll("°", "").replaceAll("N", "").replaceAll("W", "");
                var strThisCoordinatesSplit = strThisCoordinates.split(" ");

                values["${rowsData[i][j]["columns"][k]["id"]}gpsN0"] = int.parse(strThisCoordinatesSplit[0]).toString();
                values["${rowsData[i][j]["columns"][k]["id"]}gpsN1"] = double.parse(strThisCoordinatesSplit[1]).toStringAsFixed(3);
                values["${rowsData[i][j]["columns"][k]["id"]}gpsW0"] = int.parse(strThisCoordinatesSplit[2]).toString();
                values["${rowsData[i][j]["columns"][k]["id"]}gpsW1"] = double.parse(strThisCoordinatesSplit[3]).toStringAsFixed(3);
              }
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 28: //Extended Text Field
              if (Get.arguments == "formEdit") {
                await loadExtendedField(
                  strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                  strNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                );
              }
              if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController());
                fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()].toString();
              }
              extendedTextFields.add(rowsData[i][j]["columns"][k]["id"].toString());
              extendedFields.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 152: //Medication Selector
              if (Get.arguments == "formEdit") {
                await loadExtendedField(
                  strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                  strNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                );
              }
              if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                await saveSelectMultipleFinalVenom(
                  strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                  strFormFieldNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()].toString(),
                  strData: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()],
                );
              }
              extendedFields.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 35 || 199: //Flight Ops Selector (Multiple) || DropDown Via Service Table Value (Multiple)
              if (rowsData[i][j]["columns"][k]["formFieldStSelectMany"] && !rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"]) {
                if (int.tryParse(formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()].toString()) != null && Get.arguments == "formEdit") {
                  await loadExtendedField(
                    strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                    strNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                    strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                  );
                }
                extendedFields.add(rowsData[i][j]["columns"][k]["id"].toString());
              } else if (!rowsData[i][j]["columns"][k]["formFieldStSelectMany"] && !rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"]) {
                if (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                  rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
                    if (element["id"] == (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
                      dropDownFieldValues.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), element["name"]);
                    }
                  });
                }
                formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              } else {
                formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              }
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 10 || 11 || 50 || 51 || 52 || 53 || 54 || 92 || 127: // Spacer, New Line, Headers
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 55 || 56 || 57 || 58 || 98 || 111 || 59 || 60 || 108 || 120 || 77 || 80 || 83 || 86 || 89 || 102 || 105 || 114 || 117 || 22 || 95 || 23: //CloseOut Fields (To Add)
            case 132 || 135 || 138 || 141 || 146 || 149 || 45 || 48 || 158 || 164 || 167 || 170 || 173 || 176 || 179 || 182 || 185 || 188 || 191 || 194 || 197:
            case 252 || 255 || 258 || 261: //--- These fields don't have a traditional header / title
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j - 1});
              break;

            case 16 || 17 || 18 || 19 || 100 || 112 || 20 || 21 || 109 || 121 || 78 || 81 || 84 || 87 || 90 || 103 || 106 || 115 || 118 || 30 || 96 || 34: //CloseOut Fields (End)
            case 133 || 136 || 139 || 142 || 147 || 150 || 46 || 49 || 159 || 165 || 168 || 171 || 174 || 177 || 180 || 183 || 186 || 189 || 192 || 195 || 198:
            case 253 || 256 || 259 || 262: //--- These fields don't have a traditional header / title
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j - 2});
              break;

            case 160: //ACCESSORIES WITH CYCLES+HOBBS
              if (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                var fieldValues = formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()].split(",");
                values[rowsData[i][j]["columns"][k]["id"].toString()] = fieldValues[0].toString();
                rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
                  if (element["id"] == (fieldValues[0] ?? "0")) {
                    dropDownFieldValues.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), element["name"]);
                  }
                });
                values["accCStart_${rowsData[i][j]["columns"][k]["id"]}"] = int.parse(fieldValues[1]).toString();
                values["accCAdd_${rowsData[i][j]["columns"][k]["id"]}"] = int.parse(fieldValues[2]).toString();
                values["accCEnd_${rowsData[i][j]["columns"][k]["id"]}"] = int.parse(fieldValues[3]).toString();
                values["accHStart_${rowsData[i][j]["columns"][k]["id"]}"] = double.parse(fieldValues[4]).toStringAsFixed(1);
                values["accHAdd_${rowsData[i][j]["columns"][k]["id"]}"] = double.parse(fieldValues[5]).toStringAsFixed(1);
                values["accHEnd_${rowsData[i][j]["columns"][k]["id"]}"] = double.parse(fieldValues[6]).toStringAsFixed(1);
              }
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            case 61 || 62 || 63 || 64 || 65 || 68 || 69: //Pilot Profile Fields (PIC, SIC, NVG, DAY, NIGHT, INS ACT, INS SIM)
              values[rowsData[i][j]["columns"][k]["id"].toString()] = formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0.0";
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;

            default:
              if (rowsData[i][j]["columns"][k]["fieldName"] == "" && rowsData[i][j]["columns"][k]["elementType"] == "select") {
                if (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                  rowsData[i][j]["columns"][k]["elementData"].forEach((element) {
                    if (element["id"] == (formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()] ?? "0")) {
                      dropDownFieldValues.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), element["name"]);
                    }
                  });
                }
              }
              formFieldAllIds.add(rowsData[i][j]["columns"][k]["id"].toString());
              fieldsPositions.addIf(true, rowsData[i][j]["columns"][k]["id"].toString(), {"tab": i, "row": j});
              break;
          }
        }
      }
    }

    await initEditUserForm();

    await updateFieldValues();

    for (int i = 0; i < pageList.length; i++) {
      widgetsForEachTab.add(rowView(i));
    }

    isLoading.value = false;
    dataLoaded.value = true;
    await EasyLoading.dismiss();
    lastViewedFormId = Get.parameters["formId"] ?? fillOutFormAllData["formId"].toString();
    update(); // need to update if we use GetBuilder. When we will call update(), it will update the view when everything is ready to view
    if (Get.arguments == "fromIndex") {
      SnackBarHelper.openSnackBar(isError: false, message: Get.parameters["userMessage"]);
    }
    return widgetsForEachTab;
  }

  RefreshIndicator rowView(i) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration.zero, () async {
          await checkForm(doSave: false, fieldId: null);
          await updateFieldValues();
          update();
        });
      },
      child: FormBuilder(
        key: formValidationKey[i],
        child: ScrollablePositionedList.builder(
          itemCount: pageList[i]["rows"].length,
          shrinkWrap: true,
          itemScrollController: itemScrollController[i],
          scrollOffsetController: scrollOffsetController[i],
          itemPositionsListener: itemPositionsListener[i],
          /*..itemPositions.addListener(() {
                if (itemPositionsListener[i].itemPositions.value.any((element) => element.itemTrailingEdge == 1.00)) {
                  lastItem.value = true;
                } else {
                  lastItem.value = false;
                }
              }),*/
          scrollOffsetListener: scrollOffsetListener[i],
          /*..changes.listen((event) {
                scrolling.value = false;
                if (event.toInt() < 0) {
                  scrolling.value = true;
                }
                else if ( event.toInt() > 0 ) {
                scrolling.value = false;
              }
                else {
                  Future.delayed(const Duration(seconds: 2), () {
                    scrolling.value = false;
                  });
                }
              }),*/
          itemBuilder: (context, j) {
            return Padding(
              padding:
                  createdFields.contains(rowsData[i][j]["columns"].length > 1 ? rowsData[i][j]["columns"][1]["id"].toString() : rowsData[i][j]["columns"][0]["id"].toString()) &&
                          widgetsForEachRow.isEmpty
                      ? const EdgeInsets.symmetric(horizontal: 5.0)
                      : const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () async {
                  Keyboard.close(context: context);
                  dateTimeDisableKeyboard.value = true;
                  for (var element in addChoiceServiceTableData.keys) {
                    addChoiceServiceTableData[element] = [];
                  }
                  await checkForm(doSave: false, fieldId: null);
                  await updateFieldValues();
                  update();
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.blue,
                  color:
                      rowsData[i][j]["formRowBgColor"] != ""
                          ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                              ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                              : hexToColor(rowsData[i][j]["formRowBgColor"])
                          : ThemeColorMode.isDark
                          ? Colors.grey[900]
                          : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Wrap(
                      alignment: rowsData[i][j]["columns"][0]["formFieldType"] == 127 && rowsData[i][j]["columns"].length == 2 ? WrapAlignment.start : WrapAlignment.spaceBetween,
                      children: widgetView(i: i, j: j),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> widgetView({i, j}) {
    widgetsForEachRow.clear();
    for (int k = 0; k < rowsData[i][j]["columns"].length; k++) {
      switch (rowsData[i][j]["columns"][k]["formFieldType"] as int) {
        /*General Fields
        case "------ FIELDS FOR PILOT PROFILES -------":
        case "--------------GENERAL FIELDS---------------":
        case "---- FIELDS FOR SELECTED AIRCRAFT ----":
        case "--------- FORMATTING FIELDS ----------":
        case "---- FIELDS FOR PRATT WHITNEY --":
        case "--------- FUEL FARM FIELDS ----------":
        case "--------- FORM CHOOSER ----------":
        case "--------- SIGNATURE FIELDS ----------":
        case "---- FIELDS SHOWN IF NPNG AIRCRAFT ----------":
        case "---------------- APU FIELDS ------------------":
        case "--------- MISC AIRCRAFT FIELDS ----------":
        case "--------- AUTOMATION FIELDS ----------":
        case "--------- USER ROLES ----------":*/

        //Text Fields
        case 1: //"TEXT FIELD (STANDARD)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormTextField(
                  fieldType: "textFieldStandard",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  numberOnly: property[rowsData[i][j]["columns"][k]["id"].toString()]?["numberOnly"],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;
        case 28: //"TEXT FIELD (EXTENDED)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormTextField(
                  fieldType: "textFieldExtended",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()],
                  hintText: (rowsData[i][j]["columns"][k]["placeHolder"] ?? "") != "" ? rowsData[i][j]["columns"][k]["placeHolder"] : "Form Field Memo:",
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxLines: 5,
                  maxSize: "5000",
                  showCounter: true,
                  keyboardType: TextInputType.multiline,
                  onTap: () async {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) async {
                    await loadExtendedFieldSave(
                      strFieldId: rowsData[i][j]["columns"][k]["id"].toString(),
                      strNarrativeId: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                      strFieldTypeId: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                      strValue: val,
                    );
                  },
                  onEditingComplete: () async {
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;
        case 37: //"NUMBER - INTEGER/WHOLE NUMBER":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "numberIntegerWholeNumber",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?')),
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 38: //"NUMBER - DECIMAL 1 PLACE":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormTextField(
                  fieldType: "numberDecimal_1Place",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d?)?')),
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '' && val != '-') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = double.parse(val).toStringAsFixed(1);
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;
        case 39: //"NUMBER - DECIMAL 2 PLACES":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "numberDecimal_2Place",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d{0,2})?')),
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '' && val != '-') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = double.parse(val).toStringAsFixed(2);
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 40: //"NUMBER - DECIMAL 3 PLACES":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "numberDecimal_3Place",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d{0,3})?')),
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '' && val != '-') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = double.parse(val).toStringAsFixed(3);
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 41: //"NUMBER - DECIMAL 4 PLACES":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "numberDecimal_4Place",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d{0,4})?')),
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '' && val != '-') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = double.parse(val).toStringAsFixed(4);
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 42: //"ACCESSORIES SELECTOR - HOBBS AUGMENT":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "accessoriesSelectorHobbsAugment",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d?)?')),
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '' && val != '-') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 43: //"ACCESSORIES SELECTOR - CYCLES AUGMENT":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormTextField(
                  fieldType: "accessoriesSelectorCyclesAugment",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?')),
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;
        case 122: //"FAR PART 91 HOURS (TOTAL)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.farPart91HoursTotal(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 123: //"FAR PART 135 HOURS (TOTAL)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.farPart135HoursTotal(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 125: //UNKNOWN:
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "unknown",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              numberOnly: property[rowsData[i][j]["columns"][k]["id"].toString()]?["numberOnly"],
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 126: //"HIDDEN DATA FIELD":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormTextField(
              fieldType: "hiddenDataField",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;

        //Date & Time
        case 24: //"DATE (FLIGHT DATE)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormDateTime(
                  fieldType: "dateFlightDate",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name:
                      rowsData[i][j]["columns"][k]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                          ? "DATE"
                          : rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle:
                      rowsData[i][j]["columns"][k]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                          ? "DATE"
                          : rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  hintText: rowsData[i][j]["columns"][k]["placeHolder"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"] ?? false,
                  disableKeyboard: dateTimeDisableKeyboard.value,
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  dateType: rowsData[i][j]["columns"][k]["cssClassName"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onConfirm: (date) async {
                    dateTimeDisableKeyboard.value = true;
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = DateTimeHelper.dateFormatDefault.format(date);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = DateTimeHelper.dateFormatDefault.format(date);
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                  onCancel: () {
                    dateTimeDisableKeyboard.value = false;
                    update();
                  },
                  onEditingComplete: () async {
                    if (isDate(date: values[rowsData[i][j]["columns"][k]["id"].toString()].toString()) == false &&
                        values[rowsData[i][j]["columns"][k]["id"].toString()] != null &&
                        values[rowsData[i][j]["columns"][k]["id"].toString()].toString() != '') {
                      SnackBarHelper.openSnackBar(isError: true, message: "This Date Appears Invalid!\nPlease Check Your Date and Ensure It is in mm/dd/yyyy Format or Blank.");
                      await Future.delayed(const Duration(milliseconds: 10), () {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.requestFocus();
                      });
                    } else {
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      dateTimeDisableKeyboard.value = true;
                      update();
                      if (rowsData[i][j]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 1) {
                        fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    }
                  },
                );
              },
            ),
          );
          break;
        case 5: //"DATE (OTHER DATE)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormDateTime(
                  fieldType: "dateOtherDate",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  hintText: rowsData[i][j]["columns"][k]["placeHolder"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"] ?? false,
                  disableKeyboard: dateTimeDisableKeyboard.value,
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onConfirm: (date) async {
                    dateTimeDisableKeyboard.value = true;
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = DateTimeHelper.dateFormatDefault.format(date);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = DateTimeHelper.dateFormatDefault.format(date);
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                  onCancel: () {
                    dateTimeDisableKeyboard.value = false;
                    update();
                  },
                  onEditingComplete: () async {
                    if (isDate(date: values[rowsData[i][j]["columns"][k]["id"].toString()].toString()) == false &&
                        values[rowsData[i][j]["columns"][k]["id"].toString()] != null &&
                        values[rowsData[i][j]["columns"][k]["id"].toString()].toString() != '') {
                      SnackBarHelper.openSnackBar(isError: true, message: "This Date Appears Invalid!\nPlease Check Your Date and Ensure It is in mm/dd/yyyy Format or Blank.");
                      await Future.delayed(const Duration(milliseconds: 10), () {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.requestFocus();
                      });
                    } else {
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      dateTimeDisableKeyboard.value = true;
                      update();
                      if (rowsData[i][j]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 1) {
                        fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    }
                  },
                );
              },
            ),
          );
          break;
        case 7: //"TIME (HH:MM)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormDateTime(
                  fieldType: "timeHHMM",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  hintText: rowsData[i][j]["columns"][k]["placeHolder"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"] ?? false,
                  disableKeyboard: dateTimeDisableKeyboard.value,
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onConfirm: (time) async {
                    var onBlurEvents = rowsData[i][j]["columns"][k]["javaScript"]["events"]["onBlur"].toString().split(";");
                    var setValueID = "";
                    dateTimeDisableKeyboard.value = true;
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = DateTimeHelper.timeFormatDefault.format(time);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = DateTimeHelper.timeFormatDefault.format(time);
                    if (onBlurEvents.length > 2) {
                      if (onBlurEvents[1].endsWith(".val((this).val())")) {
                        setValueID = onBlurEvents[1].replaceAll(RegExp(r'\D+'), "");
                        if (setValueID.isNotEmpty) {
                          values[setValueID] = DateTimeHelper.timeFormatDefault.format(time);
                        }
                      }
                    }
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                  onCancel: () {
                    dateTimeDisableKeyboard.value = false;
                    update();
                  },
                  onEditingComplete: () async {
                    if (await formCheckTime(field: rowsData[i][j]["columns"][k]["id"].toString()) == false) {
                      await Future.delayed(const Duration(milliseconds: 10), () {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.requestFocus();
                      });
                    } else {
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      dateTimeDisableKeyboard.value = true;
                      update();
                      if (rowsData[i][j]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 1) {
                        fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    }
                  },
                );
              },
            ),
          );
          break;

        //Check Boxes
        case 2: //"CHECK BOX (YES/NO)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormCheckBox(
                  fieldType: "checkBoxYesNo",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  currentValue:
                      values[rowsData[i][j]["columns"][k]["id"].toString()] != null
                          ? (values[rowsData[i][j]["columns"][k]["id"].toString()] == "on" ? true : false)
                          : (rowsData[i][j]["columns"][k]["defaultValue"] == "Checked" ? true : false),
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"] ?? false,
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  multiple: rowsData[i][j]["columns"].length > 1 ? true : false,
                  onChanged: (val) async {
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = (val == true ? "off" : "on");
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await showHideText(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        //Drop Downs
        case 4: //"DROP DOWN - ACCESSIBLE AIRCRAFT":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownAccessibleAircraft(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    LoaderHelper.loaderWithGif();
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    jsClass["sn"]?.addIf(jsClass["sn"]?.contains(rowsData[i][j]["columns"][k]["id"].toString()) == false, rowsData[i][j]["columns"][k]["id"].toString());
                    await loadACData(id: val["id"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    EasyLoading.dismiss();
                  },
                );
              },
            ),
          );
          break;
        case 6: //"DROP DOWN - ALL USERS":
          if (fillOutFormAllData["systemId"] == 14 && rowsData[i][j]["columns"][k]["formFieldName"] == "Observer") {
            for (Map<dynamic, dynamic> element in rowsData[i][j]["columns"][k]["elementData"] ?? []) {
              if (element["id"] == fillOutFormAllData["userId"].toString()) {
                selectedDropDown.addIf(true, rowsData[i][j]["columns"][k]["id"], element["name"]);
                values[rowsData[i][j]["columns"][k]["id"].toString()] = element["id"];
              }
            }
          }
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownAllUsers(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 27: //"DROP DOWN - NUMBERS 0-50":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownNumbers0_50(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 31: //"DROP DOWN - NUMBERS 0-100":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownNumbers0_100(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 32: //"DROP DOWN - NUMBERS 0-150":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownNumbers0_150(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 25: //"DROP DOWN - CUSTOMERS":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownCustomers(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 250: //"ACCESSORIES SELECTOR":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.accessoriesSelector(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    if (rowsData[i][j]["columns"][k]["serviceTableName"] == "Fuel Farm") {
                      LoaderHelper.loaderWithGif();
                      await loadCurrentFuelFarmGallons(thisFuelFarmId: val["id"].toString());
                    }
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    EasyLoading.dismiss();
                  },
                );
              },
            ),
          );
          break;
        case 3: //"DROP DOWN - FOR TRIGGERED FIELDS ONLY":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormDropDown(
                  fieldType: "dropDownForTriggeredFieldsOnly",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: triggeredFieldsDropDownData[rowsData[i][j]["columns"][k]["id"].toString()] ?? rowsData[i][j]["columns"][k]["elementData"],
                  dropDownKey: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        //Hybrid or Combined
        case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dropDownViaServiceTableValues(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name:
                      rowsData[i][j]["columns"][k]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                          ? "COMPLETED"
                          : rowsData[i][j]["columns"][k]["formFieldName"],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  searchDataList: addChoiceServiceTableData,
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  specificDataType: rowsData[i][j]["columns"][k]["serviceTableName"],
                  addChoices: rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"],
                  selectMultiple: rowsData[i][j]["columns"][k]["formFieldStSelectMany"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle:
                      rowsData[i][j]["columns"][k]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                          ? "COMPLETED"
                          : rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue:
                      rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"]
                          ? formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()]
                          : rowsData[i][j]["columns"][k]["formFieldStSelectMany"]
                          ? extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                          : dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  selectedValue:
                      rowsData[i][j]["columns"][k]["formFieldStSelectMany"]
                          ? selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                          : selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  hintText: rowsData[i][j]["columns"][k]["placeHolder"] ?? "",
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) async {
                    if (rowsData[i][j]["columns"][k]["formFieldAbilityToAdd"]) {
                      if (val != '') {
                        LoaderHelper.loaderWithGif();
                        values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                        await searchFormFieldValues(
                          strFormFieldType: rowsData[i][j]["columns"][k]["serviceTableName"],
                          strValue: val,
                          liveSearchID: rowsData[i][j]["columns"][k]["id"].toString(),
                        );
                        update();
                        EasyLoading.dismiss();
                      } else {
                        values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                        addChoiceServiceTableData[rowsData[i][j]["columns"][k]["id"].toString()] = [];
                      }
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    } else {
                      selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                    }
                  },
                  onEditingComplete: () async {
                    LoaderHelper.loaderWithGif();
                    addChoiceServiceTableData[rowsData[i][j]["columns"][k]["id"].toString()] = [];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    EasyLoading.dismiss();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                  onSelect: (val, requestToAdd) async {
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = val;
                    Keyboard.close();
                    await setChoiceFromSearch(
                      strFieldId: rowsData[i][j]["columns"][k]["id"].toString(),
                      strValue: val,
                      requestToAdd: requestToAdd,
                      serviceTableToAddTo: rowsData[i][j]["columns"][k]["serviceTableName"],
                    );
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                  onDialogPopUp: () async {
                    LoaderHelper.loaderWithGif();
                    await loadExtendedField(
                      strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                      strNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                      strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                    );
                    EasyLoading.dismiss();

                    var selectedData = "".obs;
                    var selectedDataList = [].obs;
                    var selectAllCheckBox = false.obs;
                    var checkBoxStatus = [].obs;

                    if (loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                      for (int n = 0; n < loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                        if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                          if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]!.contains(
                            loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"],
                          )) {
                            selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                            checkBoxStatus.add(true);
                          } else {
                            checkBoxStatus.add(false);
                            selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                          }
                        } else {
                          checkBoxStatus.add(false);
                        }
                      }
                    }
                    update();
                    showDialog(
                      useSafeArea: true,
                      useRootNavigator: false,
                      barrierDismissible: true,
                      context: Get.context!,
                      builder: (BuildContext context) {
                        return ResponsiveBuilder(
                          builder: (context, sizingInformation) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Dialog(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                  side: const BorderSide(color: ColorConstants.primary, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          InkWell(
                                            child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                            onTap: () {
                                              selectAllCheckBox.value = !selectAllCheckBox.value;
                                              checkBoxStatus.clear();
                                              selectedDataList.clear();
                                              for (int n = 0; n < loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                checkBoxStatus.add(selectAllCheckBox.value);
                                                if (selectAllCheckBox.value == true) {
                                                  selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                                                } else {
                                                  selectedDataList.clear();
                                                }
                                              }
                                            },
                                          ),
                                          Obx(() {
                                            return IconButton(
                                              icon: Icon(
                                                !selectAllCheckBox.value ? Icons.select_all : Icons.deselect,
                                                size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                              ),
                                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                              onPressed: () {
                                                selectAllCheckBox.value = !selectAllCheckBox.value;
                                                checkBoxStatus.clear();
                                                selectedDataList.clear();
                                                for (int n = 0; n < loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                  checkBoxStatus.add(selectAllCheckBox.value);
                                                  if (selectAllCheckBox.value == true) {
                                                    selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                                                  } else {
                                                    selectedDataList.clear();
                                                  }
                                                }
                                              },
                                            );
                                          }),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length,
                                                itemBuilder: (context, l) {
                                                  return Obx(() {
                                                    return CheckboxListTile(
                                                      activeColor: ColorConstants.primary,
                                                      side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                      value: checkBoxStatus[l],
                                                      dense: true,
                                                      title: Text(
                                                        loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"],
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          color: selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                      selected: checkBoxStatus[l],
                                                      onChanged: (val) async {
                                                        checkBoxStatus[l] = val!;
                                                        if (val == true) {
                                                          selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"]);
                                                        } else {
                                                          selectedDataList.removeWhere((item) {
                                                            return item == loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"];
                                                          });
                                                          selectAllCheckBox.value = false;
                                                        }
                                                      },
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: SizeConstants.rootContainerSpacing),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ButtonConstant.dialogButton(
                                            title: "Cancel",
                                            borderColor: ColorConstants.red,
                                            onTapMethod: () {
                                              Get.back();
                                            },
                                          ),
                                          const SizedBox(width: SizeConstants.contentSpacing),
                                          ButtonConstant.dialogButton(
                                            title: "Save & Close",
                                            btnColor: ColorConstants.primary,
                                            onTapMethod: () async {
                                              LoaderHelper.loaderWithGif();
                                              selectedData.value = "";
                                              for (int n = 0; n < selectedDataList.length; n++) {
                                                if (n + 1 == selectedDataList.length) {
                                                  selectedData.value += "${selectedDataList[n]}";
                                                } else {
                                                  selectedData.value += "${selectedDataList[n]}^^^#";
                                                }
                                              }
                                              Get.back();
                                              selectedDropDown.addIf(true, rowsData[i][j]["columns"][k]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                              await saveSelectMultipleFinal(
                                                strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                                                strFormFieldNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                                                strData: selectedData.value,
                                              );
                                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                                              await updateFieldValues();
                                              update();
                                              EasyLoading.dismiss();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
          break;

        //CloseOut Form Fields
        case 160: //"ACCESSORIES WITH CYCLES+HOBBS":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.accessoriesWithCycleHobbs(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    if (val["id"] != "0") {
                      values[rowsData[i][j]["columns"][k]["elementList"][0]["id"]] = val["c"];
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"]] = "";
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"]] = val["c"];
                      values[rowsData[i][j]["columns"][k]["elementList"][3]["id"]] = double.parse(val["h"]).toStringAsFixed(1);
                      values[rowsData[i][j]["columns"][k]["elementList"][4]["id"]] = "";
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"]] = double.parse(val["h"]).toStringAsFixed(1);

                      fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][0]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][0]["id"]]!;
                      fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][1]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][1]["id"]]!;
                      fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][2]["id"]]!;
                      fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][3]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][3]["id"]]!;
                      fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][4]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][4]["id"]]!;
                      fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][5]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][5]["id"]]!;
                    }
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                  field1Id: rowsData[i][j]["columns"][k]["elementList"][0]["id"],
                  field1Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][0]["id"], () => TextEditingController()),
                  field1FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][0]["id"], () => FocusNode()),
                  field1OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]?.clear();
                    }
                  },
                  field1OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()] = val;
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] =
                          ((int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]!) ?? 0) +
                                  (int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]!) ?? 0))
                              .toString();
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()] = '0';
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] =
                          ((int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]!) ?? 0) +
                                  (int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]!) ?? 0))
                              .toString();
                    }
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]!;
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field1OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]?.requestFocus();
                  },
                  field2Id: rowsData[i][j]["columns"][k]["elementList"][1]["id"],
                  field2Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][1]["id"], () => TextEditingController()),
                  field2FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][1]["id"], () => FocusNode()),
                  field2OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]?.clear();
                    }
                  },
                  field2OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()] = val;
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] =
                          ((int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]!) ?? 0) +
                                  (int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]!) ?? 0))
                              .toString();
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()] = '0';
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] =
                          ((int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]!) ?? 0) +
                                  (int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]!) ?? 0))
                              .toString();
                    }
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]!;
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field2OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]?.requestFocus();
                  },
                  field3Id: rowsData[i][j]["columns"][k]["elementList"][2]["id"],
                  field3Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][2]["id"], () => TextEditingController()),
                  field3FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][2]["id"], () => FocusNode()),
                  field3OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]?.clear();
                    }
                  },
                  field3OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] = val;
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()] =
                          ((int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]!) ?? 0) -
                                  (int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]!) ?? 0))
                              .toString();
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] = '0';
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()] =
                          ((int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]!) ?? 0) -
                                  (int.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]!) ?? 0))
                              .toString();
                    }
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][1]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]!;
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field3OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]?.requestFocus();
                  },
                  field4Id: rowsData[i][j]["columns"][k]["elementList"][3]["id"],
                  field4Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][3]["id"], () => TextEditingController()),
                  field4FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][3]["id"], () => FocusNode()),
                  field4OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]?.clear();
                    }
                  },
                  field4OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()] = double.parse(val).toStringAsFixed(1);
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"]
                          .toString()] = ((double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]!) ?? 0.0) +
                              (double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]!) ?? 0.0))
                          .toStringAsFixed(1);
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()] = '0.0';
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"]
                          .toString()] = ((double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]!) ?? 0.0) +
                              (double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]!) ?? 0.0))
                          .toStringAsFixed(1);
                    }
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][5]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]!;
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field4OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]?.requestFocus();
                  },
                  field5Id: rowsData[i][j]["columns"][k]["elementList"][4]["id"],
                  field5Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][4]["id"], () => TextEditingController()),
                  field5FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][4]["id"], () => FocusNode()),
                  field5OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]?.clear();
                    }
                  },
                  field5OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()] = double.parse(val).toStringAsFixed(1);
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"]
                          .toString()] = ((double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]!) ?? 0.0) +
                              (double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]!) ?? 0.0))
                          .toStringAsFixed(1);
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()] = '0.0';
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"]
                          .toString()] = ((double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]!) ?? 0.0) +
                              (double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]!) ?? 0.0))
                          .toStringAsFixed(1);
                    }
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][5]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]!;
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field5OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]?.requestFocus();
                  },
                  field6Id: rowsData[i][j]["columns"][k]["elementList"][5]["id"],
                  field6Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][5]["id"], () => TextEditingController()),
                  field6FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][5]["id"], () => FocusNode()),
                  field6OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]?.clear();
                    }
                  },
                  field6OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()] = double.parse(val).toStringAsFixed(1);
                      values[rowsData[i][j]["columns"][k]["elementList"][4]["id"]
                          .toString()] = ((double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]!) ?? 0.0) -
                              (double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]!) ?? 0.0))
                          .toStringAsFixed(1);
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()] = '0.0';
                      values[rowsData[i][j]["columns"][k]["elementList"][4]["id"]
                          .toString()] = ((double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]!) ?? 0.0) -
                              (double.tryParse(values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]!) ?? 0.0))
                          .toStringAsFixed(1);
                    }
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][4]["id"]]?.text = values[rowsData[i][j]["columns"][k]["elementList"][4]["id"].toString()]!;
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field6OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][5]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;

        //Select Multiple
        case 35: //"FLIGHT OPS DOCUMENT SELECTOR":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.flightOpsDocumentSelector(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", "),
                  selectedValue:
                      extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ") ?? selectedDropDown[rowsData[i][j]["columns"][k]["id"]],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onDialogPopUp: () async {
                    LoaderHelper.loaderWithGif();
                    await loadExtendedField(
                      strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                      strNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                      strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                    );
                    EasyLoading.dismiss();

                    var selectedData = "".obs;
                    var selectedDataList = [].obs;
                    var selectAllCheckBox = false.obs;
                    var checkBoxStatus = [].obs;

                    if (loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                      for (int n = 0; n < loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                        if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                          if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]!.contains(
                            loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"],
                          )) {
                            selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                            checkBoxStatus.add(true);
                          } else {
                            checkBoxStatus.add(false);
                            selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                          }
                        } else {
                          checkBoxStatus.add(false);
                        }
                      }
                    }
                    update();
                    showDialog(
                      useSafeArea: true,
                      useRootNavigator: false,
                      barrierDismissible: true,
                      context: Get.context!,
                      builder: (BuildContext context) {
                        return ResponsiveBuilder(
                          builder: (context, sizingInformation) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Dialog(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                  side: const BorderSide(color: ColorConstants.primary, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          InkWell(
                                            child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                            onTap: () {
                                              selectAllCheckBox.value = !selectAllCheckBox.value;
                                              checkBoxStatus.clear();
                                              selectedDataList.clear();
                                              for (int n = 0; n < loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                checkBoxStatus.add(selectAllCheckBox.value);
                                                if (selectAllCheckBox.value == true) {
                                                  selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                                                } else {
                                                  selectedDataList.clear();
                                                }
                                              }
                                            },
                                          ),
                                          Obx(() {
                                            return IconButton(
                                              icon: Icon(
                                                !selectAllCheckBox.value ? Icons.select_all : Icons.deselect,
                                                size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                              ),
                                              color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                              onPressed: () {
                                                selectAllCheckBox.value = !selectAllCheckBox.value;
                                                checkBoxStatus.clear();
                                                selectedDataList.clear();
                                                for (int n = 0; n < loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                  checkBoxStatus.add(selectAllCheckBox.value);
                                                  if (selectAllCheckBox.value == true) {
                                                    selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"]);
                                                  } else {
                                                    selectedDataList.clear();
                                                  }
                                                }
                                              },
                                            );
                                          }),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length,
                                                itemBuilder: (context, l) {
                                                  return Obx(() {
                                                    return CheckboxListTile(
                                                      activeColor: ColorConstants.primary,
                                                      side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                      value: checkBoxStatus[l],
                                                      dense: true,
                                                      title: Text(
                                                        loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"],
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          color: selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                      selected: checkBoxStatus[l],
                                                      onChanged: (val) async {
                                                        checkBoxStatus[l] = val!;
                                                        if (val == true) {
                                                          selectedDataList.add(loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"]);
                                                        } else {
                                                          selectedDataList.removeWhere((item) {
                                                            return item == loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"];
                                                          });
                                                          selectAllCheckBox.value = false;
                                                        }
                                                      },
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: SizeConstants.rootContainerSpacing),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ButtonConstant.dialogButton(
                                            title: "Cancel",
                                            borderColor: ColorConstants.red,
                                            onTapMethod: () {
                                              Get.back();
                                            },
                                          ),
                                          const SizedBox(width: SizeConstants.contentSpacing),
                                          ButtonConstant.dialogButton(
                                            title: "Save & Close",
                                            btnColor: ColorConstants.primary,
                                            onTapMethod: () async {
                                              LoaderHelper.loaderWithGif();
                                              selectedData.value = "";
                                              for (int n = 0; n < selectedDataList.length; n++) {
                                                if (n + 1 == selectedDataList.length) {
                                                  selectedData.value += "${selectedDataList[n]}";
                                                } else {
                                                  selectedData.value += "${selectedDataList[n]}^^^#";
                                                }
                                              }
                                              Get.back();
                                              selectedDropDown.addIf(true, rowsData[i][j]["columns"][k]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                              await saveSelectMultipleFinal(
                                                strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                                                strFormFieldNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                                                strData: selectedData.value,
                                              );
                                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                                              await updateFieldValues();
                                              update();
                                              EasyLoading.dismiss();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
          break;

        case 152: //"MEDICATION SELECTOR":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.medicationSelector(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()],
                  selectedValue: extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] ?? selectedDropDown[rowsData[i][j]["columns"][k]["id"]],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onDialogPopUp: () async {
                    LoaderHelper.loaderWithGif();
                    await loadExtendedField(
                      strFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                      strNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                      strFieldTypeID: rowsData[i][j]["columns"][k]["formFieldType"].toString(),
                    );
                    update();
                    EasyLoading.dismiss();

                    var selectedName = "".obs;
                    var selectedId = "".obs;
                    var selectedDropDownData = "".obs;
                    var selectedDataList = [].obs;
                    var selectAllCheckBox = false.obs;
                    var checkBoxStatus = [].obs;

                    showDialog(
                      useSafeArea: true,
                      useRootNavigator: false,
                      barrierDismissible: true,
                      context: Get.context!,
                      builder: (BuildContext context) {
                        return ResponsiveBuilder(
                          builder: (context, sizingInformation) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Dialog(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                  side: const BorderSide(color: ColorConstants.primary, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Center(child: TextWidget(text: "Drug Types", size: SizeConstants.largeText - 2)),
                                      const SizedBox(height: 10),
                                      Obx(() {
                                        return DropdownMenu(
                                          menuHeight: Get.height - 200,
                                          textStyle: Theme.of(
                                            Get.context!,
                                          ).textTheme.bodyMedium!.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3, color: ColorConstants.black),
                                          trailingIcon: const Icon(Icons.keyboard_arrow_down, size: 30, color: ColorConstants.black),
                                          expandedInsets: EdgeInsets.zero,
                                          hintText:
                                              rowsData[i][j]["columns"][k]["readOnlyDisabled"]
                                                  ? selectedDropDownData.value = rowsData[i][j]["columns"][k]["defaultValue"]
                                                  : selectedDropDownData.isNotEmpty
                                                  ? selectedDropDownData.value
                                                  : loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![0]["name"],
                                          inputDecorationTheme: InputDecorationTheme(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintStyle: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.copyWith(color: ColorConstants.black, fontSize: Theme.of(Get.context!).textTheme.displayMedium!.fontSize! - 3),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: ColorConstants.black),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: ColorConstants.black),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: ColorConstants.black),
                                              borderRadius: BorderRadius.circular(SizeConstants.textBoxRadius),
                                            ),
                                          ),
                                          dropdownMenuEntries:
                                              loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()] == null
                                                  ? []
                                                  : loadExtendedFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.map((value) {
                                                    return DropdownMenuEntry<dynamic>(
                                                      value: value,
                                                      label: "${value["name"]}",
                                                      style: ButtonStyle(
                                                        textStyle: WidgetStatePropertyAll(
                                                          Theme.of(
                                                            Get.context!,
                                                          ).textTheme.bodyMedium?.copyWith(fontSize: (Theme.of(Get.context!).textTheme.displayMedium?.fontSize)! - 3),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                          onSelected: (val) async {
                                            if (rowsData[i][j]["columns"][k]["readOnlyDisabled"]) {
                                              selectedDropDownData.value = rowsData[i][j]["columns"][k]["defaultValue"];
                                            } else {
                                              LoaderHelper.loaderWithGif();
                                              selectedDropDownData.value = val["name"];
                                              await loadExtendedChildField(strFieldID: rowsData[i][j]["columns"][k]["id"].toString(), dropDownId: val["id"]);
                                              if (loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                                                for (int n = 0; n < loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                  if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                                                    if (extendedFieldsValue[rowsData[i][j]["columns"][k]["id"].toString()]!.contains(
                                                      loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["id"],
                                                    )) {
                                                      selectedDataList.add(loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]);
                                                      checkBoxStatus.add(true);
                                                    } else {
                                                      checkBoxStatus.add(false);
                                                      selectedDataList.removeWhere(
                                                        (item) => item["name"] == loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![n]["name"],
                                                      );
                                                    }
                                                  } else {
                                                    checkBoxStatus.add(false);
                                                  }
                                                }
                                              }
                                              update();
                                              EasyLoading.dismiss();
                                            }
                                          },
                                        );
                                      }),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Obx(() {
                                            return loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()] != null &&
                                                    loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.isNotEmpty
                                                ? const TextWidget(text: "Specific Items:", size: SizeConstants.largeText - 5)
                                                : const SizedBox();
                                          }),
                                          Obx(() {
                                            return loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()] != null &&
                                                    loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.isNotEmpty
                                                ? Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 11.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      InkWell(
                                                        child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                        onTap: () {
                                                          selectAllCheckBox.value = !selectAllCheckBox.value;
                                                          checkBoxStatus.clear();
                                                          selectedDataList.clear();
                                                          for (int n = 0; n < loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                            checkBoxStatus.add(selectAllCheckBox.value);
                                                            if (selectAllCheckBox.value == true) {
                                                              selectedDataList.add(loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]?[n]);
                                                            } else {
                                                              selectedDataList.clear();
                                                            }
                                                          }
                                                        },
                                                      ),
                                                      Obx(() {
                                                        return IconButton(
                                                          icon: Icon(
                                                            !selectAllCheckBox.value ? Icons.select_all : Icons.deselect,
                                                            size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                          ),
                                                          color: ThemeColorMode.isDark ? ColorConstants.white : ColorConstants.black,
                                                          onPressed: () {
                                                            selectAllCheckBox.value = !selectAllCheckBox.value;
                                                            checkBoxStatus.clear();
                                                            selectedDataList.clear();
                                                            for (int n = 0; n < loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]!.length; n++) {
                                                              checkBoxStatus.add(selectAllCheckBox.value);
                                                              if (selectAllCheckBox.value == true) {
                                                                selectedDataList.add(loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]?[n]);
                                                              } else {
                                                                selectedDataList.clear();
                                                              }
                                                            }
                                                          },
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                )
                                                : const SizedBox();
                                          }),
                                        ],
                                      ),
                                      Expanded(
                                        child: Obx(() {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()] != null
                                                    ? loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]?.length
                                                    : 0,
                                            itemBuilder: (context, l) {
                                              return Obx(() {
                                                return CheckboxListTile(
                                                  activeColor: ColorConstants.primary,
                                                  side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                  value: checkBoxStatus[l],
                                                  dense: true,
                                                  title: Text(
                                                    loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"]!,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w400,
                                                      color: selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  selected: checkBoxStatus[l],
                                                  onChanged: (val) async {
                                                    checkBoxStatus[l] = val!;
                                                    if (val == true) {
                                                      selectedDataList.add(loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]);
                                                    } else {
                                                      selectedDataList.removeWhere((item) {
                                                        return item["name"] == loadExtendedChildFieldData[rowsData[i][j]["columns"][k]["id"].toString()]![l]["name"];
                                                      });
                                                      selectAllCheckBox.value = false;
                                                    }
                                                  },
                                                );
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: SizeConstants.rootContainerSpacing),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ButtonConstant.dialogButton(
                                            title: "Cancel",
                                            borderColor: ColorConstants.red,
                                            onTapMethod: () {
                                              Get.back();
                                            },
                                          ),
                                          const SizedBox(width: SizeConstants.contentSpacing),
                                          ButtonConstant.dialogButton(
                                            title: "Save & Close",
                                            btnColor: ColorConstants.primary,
                                            onTapMethod: () async {
                                              LoaderHelper.loaderWithGif();
                                              selectedName.value = "";
                                              selectedId.value = "";
                                              for (int n = 0; n < selectedDataList.length; n++) {
                                                if (n + 1 == selectedDataList.length) {
                                                  selectedName.value += "${selectedDataList[n]["name"]}";
                                                  selectedId.value += "${selectedDataList[n]["id"]}";
                                                } else {
                                                  selectedName.value += "${selectedDataList[n]["name"]}, ";
                                                  selectedId.value += "${selectedDataList[n]["id"]},";
                                                }
                                              }
                                              Get.back();
                                              selectedDropDown.addIf(true, rowsData[i][j]["columns"][k]["id"], selectedName.value);
                                              await saveSelectMultipleFinalVenom(
                                                strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                                                strFormFieldNarrativeID: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                                                strData: selectedId.value,
                                              );
                                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                                              await updateFieldValues();
                                              update();
                                              EasyLoading.dismiss();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
          break;

        case 26: //"GPS COORDINATES - DDD MM.MMM FORMAT":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.gpsCoordinatesDDDMMMMM(
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  field1Id: rowsData[i][j]["columns"][k]["elementList"][0]["id"],
                  field1Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][0]["id"], () => TextEditingController()),
                  field1FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][0]["id"], () => FocusNode()),
                  field1OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()]?.clear();
                    }
                  },
                  field1OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()] = val;
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][0]["id"].toString()] = "0";
                    }
                    calcGpsCoordinatesDMS(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field1OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]?.requestFocus();
                  },
                  field2Id: rowsData[i][j]["columns"][k]["elementList"][1]["id"],
                  field2Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][1]["id"], () => TextEditingController()),
                  field2FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][1]["id"], () => FocusNode()),
                  field2OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()]?.clear();
                    }
                  },
                  field2OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()] = double.parse(val.toString()).toStringAsFixed(3);
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][1]["id"].toString()] = "0.000";
                    }
                    calcGpsCoordinatesDMS(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field2OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]?.requestFocus();
                  },
                  field3Id: rowsData[i][j]["columns"][k]["elementList"][2]["id"],
                  field3Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][2]["id"], () => TextEditingController()),
                  field3FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][2]["id"], () => FocusNode()),
                  field3OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()]?.clear();
                    }
                  },
                  field3OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] = val;
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][2]["id"].toString()] = "0";
                    }
                    calcGpsCoordinatesDMS(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field3OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]?.requestFocus();
                  },
                  field4Id: rowsData[i][j]["columns"][k]["elementList"][3]["id"],
                  field4Controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][3]["id"], () => TextEditingController()),
                  field4FocusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["elementList"][3]["id"], () => FocusNode()),
                  field4OnTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()]?.clear();
                    }
                  },
                  field4OnChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()] = double.parse(val.toString()).toStringAsFixed(3);
                    } else {
                      values[rowsData[i][j]["columns"][k]["elementList"][3]["id"].toString()] = "0.000";
                    }
                    calcGpsCoordinatesDMS(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  field4OnEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;

        //Field for Pilot Profiles
        //Text Fields
        case 61: //"PIC TIME":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.picTime(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 62: //"SIC TIME":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.sicTime(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 63: //"NVG TIME":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.nvgTime(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 64: //"DAY FLIGHT TIME":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.dayFlightTime(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 65: //"NIGHT FLIGHT TIME":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.nightFlightTime(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 68: //"INSTRUMENT TIME (ACTUAL)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.instrumentTimeActual(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;
        case 69: //"INSTRUMENT TIME (SIMULATED)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.instrumentTimeSimulated(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;

        //Dropdowns
        case 66: //"DAY LANDINGS":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.dayLandings(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 67: //"NIGHT LANDINGS":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.nightLandings(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 70: //"APPROACHES (ILS)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.approachesILS(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 71: //"APPROACHES (LOCALIZER)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.approachesLOCALIZER(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 72: //"APPROACHES (LPV)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.approachesLPV(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 73: //"APPROACHES (LNAV)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.approachesLNAV(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 74: //"APPROACHES (VOR)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.approachesVOR(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;
        case 75: //"OPERATIONS (HNVGO)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.operationsHNVGO(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        //Dropdowns
        case 91: //"AIRCRAFT REPOSITION TO BASE":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.aircraftRepositionToBase(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        //Fields for Selected Aircraft
        //Fields Shown IF NPNG Aircraft
        //Fields For Pratt Whitney
        //Apu Fields
        //Fuel Farm Fields
        //Fields Shown If Cycles IM/PT/CT
        //Fields For CAT/AVCS/MTOW Aircraft
        //CloseOut Form Fields
        case 8 || 9 || 12 || 14 || 97 || 110 || 13 || 15 || 107 || 119 || 76 || 79 || 82 || 85 || 88 || 101 || 104 || 113 || 116 || 29 || 94 || 33: //CloseOut Fields (Forward)
        case 131 || 134 || 137 || 140 || 145 || 148 || 44 || 47 || 151 || 163 || 166 || 169 || 172 || 175 || 178 || 181 || 184 || 187 || 190 || 193 || 196:
        case 251 || 254 || 257 || 260: //--- These fields don't have a traditional header / title
          /*case 8: //"AIRCRAFT FLT HOBBS (START)":
        case 9: //"AIRCRAFT BILL-MISC HOBBS (START)":
        case 145: //"AUX HOBBS (START)":
        case 151: //"AIRCRAFT TOTAL TIME (START)":
        case 29: //"LANDINGS (START)":
        case 94: //"LANDINGS - RUN ON (START)":
        case 33: //"TORQUE EVENTS (START)":
        case 44: //"HOIST CYCLES (START)":
        case 47: //"HOOK CYCLES (START)":
        case 12: //"E1: STARTS/N1/NG/CCY/CT/CT (START)":
        case 14: //"E2: STARTS/N1/NG/CCY/CT/CT (START)":
        case 97: //"E3: STARTS/N1/NG/CCY/CT/CT (START)":
        case 110: //"E4: STARTS/N1/NG/CCY/CT/CT (START)":
        case 85: //"E1: N2/PCY/PT1/PT1 (START)":
        case 88: //"E2: N2/PCY/PT1/PT1 (START)":
        case 101: //"E3: N2/PCY/PT1/PT1 (START)":
        case 113: //"E4: N2/PCY/PT1/PT1 (START)":
        case 76: //"E1: TOTAL TIME (START)":
        case 79: //"E2: TOTAL TIME (START)":
        case 104: //"E3: TOTAL TIME (START)":
        case 116: //"E4: TOTAL TIME (START)":
        case 13: //"E1: NPNF/ICY/IMP/IMP (START)":
        case 15: //"E2: NPNF/ICY/IMP/IMP (START)":
        case 107: //"E3: NPNF/ICY/IMP/IMP (START)":
        case 119: //"E4: NPNF/ICY/IMP/IMP (START)":
        case 131: //"E1: PRATT ENGINE CYCLES (START)":
        case 134: //"E2: PRATT ENGINE CYCLES (START)":
        case 137: //"E3: PRATT ENGINE CYCLES (START)":
        case 140: //"E4: PRATT ENGINE CYCLES (START)":
        case 82: //"APU: TOTAL TIME (START)":
        case 148: //"FUEL FARM FILLED BEGINNING AMOUNT":
        case 163: //"E1: CT COVER (START)":
        case 166: //"E2: CT COVER (START)":
        case 169: //"E1: CT CREEP (START)":
        case 172: //"E2: CT CREEP (START)":
        case 175: //"E1: HP COMPRESSOR (START)":
        case 178: //"E2: HP COMPRESSOR (START)":
        case 181: //"E1: PT 1 CREEP (START)":
        case 184: //"E2: PT 1 CREEP (START)":
        case 187: //"E1: PT 2 CREEP (START)":
        case 190: //"E2: PT 2 CREEP (START)":
        case 193: //"E1: PT 2 DISC (START)":
        case 196: //"E2: PT 2 DISC (START)":
        case 251: //"CAT.A Operations (Start)":
        case 254: //"AVCS INOP (Start)":
        case 257: //"MTOW FHS (Start)":
        case 260: //"MTOW LDS (Start)":*/
          var fieldName = rowsData[i][j]["columns"][k]["fieldName"].toUpperCase().replaceAll(" (START)", '').replaceAll(" BEGINNING AMOUNT", '');
          if (rowsData[i][j]["columns"].length > k + 1
              ? (rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}" ||
                  rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}")
              : false) {
            if (rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}") {
              if (rowsData[i][j]["columns"].length > k + 2) {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k + 1]["id"].toString()), rowsData[i][j]["columns"][k + 1]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k + 2]["id"].toString()), rowsData[i][j]["columns"][k + 2]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                            },
                          ),
                          FormWidgets.closeOutFieldsToAdd(
                            id: rowsData[i][j]["columns"][k + 1]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            req: rowsData[i][j]["columns"][k + 1]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k + 1]["defaultValue"],
                            disableUserEditing: rowsData[i][j]["columns"][k + 1]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k + 1]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k + 1]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.requestFocus();
                            },
                          ),
                          FormWidgets.closeOutFieldsEnd(
                            id: rowsData[i][j]["columns"][k + 2]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                            req: rowsData[i][j]["columns"][k + 2]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k + 2]["defaultValue"],
                            disableUserEditing: rowsData[i][j]["columns"][k + 2]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k + 2]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 2]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") -
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k + 2]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k + 2]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 2]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k + 2]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 2]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              if (rowsData[i][j]["columns"].length > k + 1) {
                                fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              } else if (rowsData[i].length > j + 1) {
                                fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k + 1]["id"].toString()), rowsData[i][j]["columns"][k + 1]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                            },
                          ),
                          FormWidgets.closeOutFieldsToAdd(
                            id: rowsData[i][j]["columns"][k + 1]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            req: rowsData[i][j]["columns"][k + 1]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k + 1]["defaultValue"],
                            disableUserEditing: rowsData[i][j]["columns"][k + 1]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k + 1]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k + 1]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.requestFocus();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            } else if (rowsData[i][j]["columns"][k + 1]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}") {
              if (rowsData[i][j]["columns"].length > k + 2) {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k + 1]["id"].toString()), rowsData[i][j]["columns"][k + 1]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k + 2]["id"].toString()), rowsData[i][j]["columns"][k + 2]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][k + 1]["columns"][k]["id"].toString()]?.requestFocus();
                            },
                          ),
                          FormWidgets.closeOutFieldsEnd(
                            id: rowsData[i][j]["columns"][k + 1]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            req: rowsData[i][j]["columns"][k + 1]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k + 1]["defaultValue"],
                            disableUserEditing: rowsData[i][j]["columns"][k + 1]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k + 1]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") -
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k + 1]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.requestFocus();
                            },
                          ),
                          FormWidgets.closeOutFieldsToAdd(
                            id: rowsData[i][j]["columns"][k + 2]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                            req: rowsData[i][j]["columns"][k + 2]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k + 2]["defaultValue"],
                            disableUserEditing: rowsData[i][j]["columns"][k + 2]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k + 2]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 2]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k + 2]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k + 2]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 2]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k + 2]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 2]["typeToCalculate"], strMode: 2);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              if (rowsData[i][j]["columns"].length > k + 1) {
                                fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              } else if (rowsData[i].length > j + 1) {
                                fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k + 1]["id"].toString()), rowsData[i][j]["columns"][k + 1]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j]["columns"][k + 2]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][k + 1]["columns"][k]["id"].toString()]?.requestFocus();
                            },
                          ),
                          FormWidgets.closeOutFieldsEnd(
                            id: rowsData[i][j]["columns"][k + 1]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            req: rowsData[i][j]["columns"][k + 1]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k + 1]["defaultValue"],
                            disableUserEditing: rowsData[i][j]["columns"][k + 1]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k + 1]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k + 1]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k + 1]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k + 1]["typeToCalculate"], strMode: 3);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              if (rowsData[i][j]["columns"].length > k + 1) {
                                fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            }
          } else if (rowsData[i].length > j + 1 && rowsData[i][j + 1]["columns"].length > k
              ? rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}" ||
                  rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}"
              : false) {
            if (rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "TO ADD" : "(TO ADD)"}") {
              if (rowsData[i].length > j + 2) {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j + 1]["columns"][k]["id"].toString()), rowsData[i][j + 1]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j + 2]["columns"][k]["id"].toString()), rowsData[i][j + 2]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.requestFocus();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  rowsData[i][j + 1]["formRowBgColor"] != ""
                                      ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              child: FormWidgets.closeOutFieldsToAdd(
                                id: rowsData[i][j + 1]["columns"][k]["id"],
                                rowColor: rowsData[i][j + 1]["formRowBgColor"],
                                name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                                fieldType: htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                req: rowsData[i][j + 1]["columns"][k]["formFieldRequired"],
                                showField: showField[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                                previousValue: formFieldPreValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => TextEditingController()),
                                focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => FocusNode()),
                                defaultValue: rowsData[i][j + 1]["columns"][k]["defaultValue"],
                                disableUserEditing: rowsData[i][j + 1]["columns"][k]["readOnlyDisabled"],
                                hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                                maxSize: rowsData[i][j + 1]["columns"][k]["formMaxLength"],
                                onTap: () {
                                  switch (fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.text) {
                                    case "0":
                                    case "0.0":
                                    case "0.00":
                                    case "0.000":
                                      fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.clear();
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text =
                                      (double.parse(val != "" ? val : "0.0") +
                                              double.parse(
                                                fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                    ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                    : "0.0",
                                              ))
                                          .toString();
                                  if (val != '') {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = val;
                                  } else {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = "0";
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onEditingComplete: () async {
                                  await checkForm(doSave: false, fieldId: rowsData[i][j + 1]["columns"][k]["id"].toString());
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }

                                  await updateFieldValues();
                                  update();
                                  fillOutFocusNodes[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.requestFocus();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  rowsData[i][j + 2]["formRowBgColor"] != ""
                                      ? rowsData[i][j + 2]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j + 2]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j + 2]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              child: FormWidgets.closeOutFieldsEnd(
                                id: rowsData[i][j + 2]["columns"][k]["id"],
                                rowColor: rowsData[i][j + 2]["formRowBgColor"],
                                name: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                                fieldType: htmlValues[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                                req: rowsData[i][j + 2]["columns"][k]["formFieldRequired"],
                                showField: showField[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                                acronymTitle: rowsData[i][j + 2]["columns"][k]["acronymTitle"],
                                previousValue: formFieldPreValues[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                                controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 2]["columns"][k]["id"].toString(), () => TextEditingController()),
                                focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 2]["columns"][k]["id"].toString(), () => FocusNode()),
                                defaultValue: rowsData[i][j + 2]["columns"][k]["defaultValue"],
                                disableUserEditing: rowsData[i][j + 2]["columns"][k]["readOnlyDisabled"],
                                hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                                maxSize: rowsData[i][j + 2]["columns"][k]["formMaxLength"],
                                onTap: () {
                                  switch (fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text) {
                                    case "0":
                                    case "0.0":
                                    case "0.00":
                                    case "0.000":
                                      fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.clear();
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 2]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.text =
                                      (double.parse(val != "" ? val : "0.0") -
                                              double.parse(
                                                fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                    ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                    : "0.0",
                                              ))
                                          .toString();
                                  if (val != '') {
                                    values[rowsData[i][j + 2]["columns"][k]["id"].toString()] = val;
                                  } else {
                                    values[rowsData[i][j + 2]["columns"][k]["id"].toString()] = "0";
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 2]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onEditingComplete: () async {
                                  await checkForm(doSave: false, fieldId: rowsData[i][j + 2]["columns"][k]["id"].toString());
                                  updateFlightCalculations(strType: rowsData[i][j + 2]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }

                                  await updateFieldValues();
                                  update();
                                  if (rowsData[i][j]["columns"].length > k + 1) {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                        ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                        : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  } else {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j + 1]["columns"][k]["id"].toString()), rowsData[i][j + 1]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.requestFocus();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  rowsData[i][j + 1]["formRowBgColor"] != ""
                                      ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              child: FormWidgets.closeOutFieldsToAdd(
                                id: rowsData[i][j + 1]["columns"][k]["id"],
                                rowColor: rowsData[i][j + 1]["formRowBgColor"],
                                name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                                fieldType: htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                req: rowsData[i][j + 1]["columns"][k]["formFieldRequired"],
                                showField: showField[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                                previousValue: formFieldPreValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => TextEditingController()),
                                focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => FocusNode()),
                                defaultValue: rowsData[i][j + 1]["columns"][k]["defaultValue"],
                                disableUserEditing: rowsData[i][j + 1]["columns"][k]["readOnlyDisabled"],
                                hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                                maxSize: rowsData[i][j + 1]["columns"][k]["formMaxLength"],
                                onTap: () {
                                  switch (fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.text) {
                                    case "0":
                                    case "0.0":
                                    case "0.00":
                                    case "0.000":
                                      fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.clear();
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  if (val != '') {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = val;
                                  } else {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = "0";
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onEditingComplete: () async {
                                  await checkForm(doSave: false, fieldId: rowsData[i][j + 1]["columns"][k]["id"].toString());
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }

                                  await updateFieldValues();
                                  update();
                                  if (rowsData[i][j]["columns"].length > k + 1) {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                        ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                        : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  } else {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            } else if (rowsData[i][j + 1]["columns"][k]["fieldName"].toUpperCase() == "$fieldName ${fieldName == "FUEL FARM FILLED" ? "ENDING AMOUNT" : "(END)"}") {
              if (rowsData[i].length > j + 2) {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j + 1]["columns"][k]["id"].toString()), rowsData[i][j + 1]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j + 2]["columns"][k]["id"].toString()), rowsData[i][j + 2]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.requestFocus();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  rowsData[i][j + 1]["formRowBgColor"] != ""
                                      ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              child: FormWidgets.closeOutFieldsEnd(
                                id: rowsData[i][j + 1]["columns"][k]["id"],
                                rowColor: rowsData[i][j + 1]["formRowBgColor"],
                                name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                                fieldType: htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                req: rowsData[i][j + 1]["columns"][k]["formFieldRequired"],
                                showField: showField[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                                previousValue: formFieldPreValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => TextEditingController()),
                                focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => FocusNode()),
                                defaultValue: rowsData[i][j + 1]["columns"][k]["defaultValue"],
                                disableUserEditing: rowsData[i][j + 1]["columns"][k]["readOnlyDisabled"],
                                hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                                maxSize: rowsData[i][j + 1]["columns"][k]["formMaxLength"],
                                onTap: () {
                                  switch (fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.text) {
                                    case "0":
                                    case "0.0":
                                    case "0.00":
                                    case "0.000":
                                      fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.clear();
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text =
                                      (double.parse(val != "" ? val : "0.0") -
                                              double.parse(
                                                fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                    ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                    : "0.0",
                                              ))
                                          .toString();
                                  if (val != '') {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = val;
                                  } else {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = "0";
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onEditingComplete: () async {
                                  await checkForm(doSave: false, fieldId: rowsData[i][j + 1]["columns"][k]["id"].toString());
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }

                                  await updateFieldValues();
                                  update();
                                  fillOutFocusNodes[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.requestFocus();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  rowsData[i][j + 2]["formRowBgColor"] != ""
                                      ? rowsData[i][j + 2]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j + 2]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j + 2]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              child: FormWidgets.closeOutFieldsToAdd(
                                id: rowsData[i][j + 2]["columns"][k]["id"],
                                rowColor: rowsData[i][j + 2]["formRowBgColor"],
                                name: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                                fieldType: htmlValues[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                                req: rowsData[i][j + 2]["columns"][k]["formFieldRequired"],
                                showField: showField[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                                acronymTitle: rowsData[i][j + 2]["columns"][k]["acronymTitle"],
                                previousValue: formFieldPreValues[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                                controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 2]["columns"][k]["id"].toString(), () => TextEditingController()),
                                focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 2]["columns"][k]["id"].toString(), () => FocusNode()),
                                defaultValue: rowsData[i][j + 2]["columns"][k]["defaultValue"],
                                disableUserEditing: rowsData[i][j + 2]["columns"][k]["readOnlyDisabled"],
                                hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                                maxSize: rowsData[i][j + 2]["columns"][k]["formMaxLength"],
                                onTap: () {
                                  switch (fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text) {
                                    case "0":
                                    case "0.0":
                                    case "0.00":
                                    case "0.000":
                                      fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.clear();
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 2]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.text =
                                      (double.parse(val != "" ? val : "0.0") +
                                              double.parse(
                                                fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text != ""
                                                    ? fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.text
                                                    : "0.0",
                                              ))
                                          .toString();
                                  if (val != '') {
                                    values[rowsData[i][j + 2]["columns"][k]["id"].toString()] = val;
                                  } else {
                                    values[rowsData[i][j + 2]["columns"][k]["id"].toString()] = "0";
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onEditingComplete: () async {
                                  await checkForm(doSave: false, fieldId: rowsData[i][j + 2]["columns"][k]["id"].toString());
                                  updateFlightCalculations(strType: rowsData[i][j + 2]["columns"][k]["typeToCalculate"], strMode: 2);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }

                                  await updateFieldValues();
                                  update();
                                  if (rowsData[i][j]["columns"].length > k + 1) {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                        ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                        : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  } else {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              } else {
                createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
                createdFields.addIf(!createdFields.contains(rowsData[i][j + 1]["columns"][k]["id"].toString()), rowsData[i][j + 1]["columns"][k]["id"].toString());
                widgetsForEachRow.add(
                  GetBuilder<FillOutFormLogic>(
                    init: FillOutFormLogic(),
                    builder: (controller) {
                      return Column(
                        children: [
                          FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][j]["columns"][k]["id"],
                            rowColor: rowsData[i][j]["formRowBgColor"],
                            name: rowsData[i][j]["columns"][k]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                            showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                            acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                            disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                            hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                            maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text =
                                  (double.parse(val != "" ? val : "0.0") +
                                          double.parse(
                                            fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text != ""
                                                ? fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]!.text
                                                : "0.0",
                                          ))
                                      .toString();
                              if (val != '') {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              update();
                              fillOutFocusNodes[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.requestFocus();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  rowsData[i][j + 1]["formRowBgColor"] != ""
                                      ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              child: FormWidgets.closeOutFieldsEnd(
                                id: rowsData[i][j + 1]["columns"][k]["id"],
                                rowColor: rowsData[i][j + 1]["formRowBgColor"],
                                name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                                fieldType: htmlValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                req: rowsData[i][j + 1]["columns"][k]["formFieldRequired"],
                                showField: showField[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                                previousValue: formFieldPreValues[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                                controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => TextEditingController()),
                                focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 1]["columns"][k]["id"].toString(), () => FocusNode()),
                                defaultValue: rowsData[i][j + 1]["columns"][k]["defaultValue"],
                                disableUserEditing: rowsData[i][j + 1]["columns"][k]["readOnlyDisabled"],
                                hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                                maxSize: rowsData[i][j + 1]["columns"][k]["formMaxLength"],
                                onTap: () {
                                  switch (fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.text) {
                                    case "0":
                                    case "0.0":
                                    case "0.00":
                                    case "0.000":
                                      fillOutInputControllers[rowsData[i][j + 1]["columns"][k]["id"].toString()]?.clear();
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  if (val != '') {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = val;
                                  } else {
                                    values[rowsData[i][j + 1]["columns"][k]["id"].toString()] = "0";
                                  }
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }
                                },
                                onEditingComplete: () async {
                                  await checkForm(doSave: false, fieldId: rowsData[i][j + 1]["columns"][k]["id"].toString());
                                  updateFlightCalculations(strType: rowsData[i][j + 1]["columns"][k]["typeToCalculate"], strMode: 3);
                                  if (fillOutFormAllData["systemId"] == 14) {
                                    switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                      case 8 || 16 || 55 || 9 || 17 || 56:
                                        changePICTime();
                                        break;
                                    }
                                  }

                                  await updateFieldValues();
                                  update();
                                  if (rowsData[i][j]["columns"].length > k + 1) {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                                        ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                                        : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  } else {
                                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            }
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              GetBuilder<FillOutFormLogic>(
                init: FillOutFormLogic(),
                builder: (controller) {
                  return FormWidgets.closeOutFieldsStart(
                    id: rowsData[i][j]["columns"][k]["id"],
                    rowColor: rowsData[i][j]["formRowBgColor"],
                    name: rowsData[i][j]["columns"][k]["formFieldName"],
                    fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                    req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                    defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                      }
                      updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                      if (fillOutFormAllData["systemId"] == 14) {
                        switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                          case 8 || 16 || 55 || 9 || 17 || 56:
                            changePICTime();
                            break;
                        }
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                      } else {
                        values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                      }
                      updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                      if (fillOutFormAllData["systemId"] == 14) {
                        switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                          case 8 || 16 || 55 || 9 || 17 || 56:
                            changePICTime();
                            break;
                        }
                      }
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 1);
                      if (fillOutFormAllData["systemId"] == 14) {
                        switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                          case 8 || 16 || 55 || 9 || 17 || 56:
                            changePICTime();
                            break;
                        }
                      }

                      await updateFieldValues();
                      if (rowsData[i][j]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 1) {
                        fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  );
                },
              ),
            );
          }
          break;

        case 55 || 56 || 57 || 58 || 98 || 111 || 59 || 60 || 108 || 120 || 77 || 80 || 83 || 86 || 89 || 102 || 105 || 114 || 117 || 22 || 95 || 23: //CloseOut Fields (To Add)
        case 132 || 135 || 138 || 141 || 146 || 149 || 45 || 48 || 158 || 164 || 167 || 170 || 173 || 176 || 179 || 182 || 185 || 188 || 191 || 194 || 197:
        case 252 || 255 || 258 || 261: //--- These fields don't have a traditional header / title
          /*case 55: //"AIRCRAFT FLT HOBBS (TO ADD)":
        case 56: //"AIRCRAFT BILL-MISC HOBBS (TO ADD)":
        case 146: //"AUX HOBBS (TO ADD)":
        case 158: //"AIRCRAFT TOTAL TIME (TO ADD)":
        case 22: //"LANDINGS (TO ADD)":
        case 95: //"LANDINGS - RUN ON (TO ADD)":
        case 23: //"TORQUE EVENTS (TO ADD)":
        case 45: //"HOIST CYCLES (TO ADD)":
        case 48: //"HOOK CYCLES (TO ADD)":
        case 57: //"E1: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 58: //"E2: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 98: //"E3: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 111: //"E4: TO ADDS/N1/NG/CCY/CT/CT (TO ADD)":
        case 86: //"E1: N2/PCY/PT1/PT1 (TO ADD)":
        case 89: //"E2: N2/PCY/PT1/PT1 (TO ADD)":
        case 102: //"E3: N2/PCY/PT1/PT1 (TO ADD)":
        case 114: //"E4: N2/PCY/PT1/PT1 (TO ADD)":
        case 77: //"E1: TOTAL TIME (TO ADD)":
        case 80: //"E2: TOTAL TIME (TO ADD)":
        case 105: //"E3: TOTAL TIME (TO ADD)":
        case 117: //"E4: TOTAL TIME (TO ADD)":
        case 59: //"E1: NPNF/ICY/IMP/IMP (TO ADD)":
        case 60: //"E2: NPNF/ICY/IMP/IMP (TO ADD)":
        case 108: //"E3: NPNF/ICY/IMP/IMP (TO ADD)":
        case 120: //"E4: NPNF/ICY/IMP/IMP (TO ADD)":
        case 132: //"E1: PRATT ENGINE CYCLES (TO ADD)":
        case 135: //"E2: PRATT ENGINE CYCLES (TO ADD)":
        case 138: //"E3: PRATT ENGINE CYCLES (TO ADD)":
        case 141: //"E4: PRATT ENGINE CYCLES (TO ADD)":
        case 83: //"APU: TOTAL TIME (TO ADD)":
        case 149: //"FUEL FARM FILLED TO ADD":
        case 164: //"E1: CT COVER (TO ADD)":
        case 167: //"E2: CT COVER (TO ADD)":
        case 170: //"E1: CT CREEP (TO ADD)":
        case 173: //"E2: CT CREEP (TO ADD)":
        case 176: //"E1: HP COMPRESSOR (TO ADD)":
        case 179: //"E2: HP COMPRESSOR (TO ADD)":
        case 182: //"E1: PT 1 CREEP (TO ADD)":
        case 185: //"E2: PT 1 CREEP (TO ADD)":
        case 188: //"E1: PT 2 CREEP (TO ADD)":
        case 191: //"E2: PT 2 CREEP (TO ADD)":
        case 194: //"E1: PT 2 DISC (TO ADD)":
        case 197: //"E2: PT 2 DISC (TO ADD)":
        case 252: //"CAT.A Operations (To Add)":
        case 255: //"AVCS INOP (To Add)":
        case 258: //"MTOW FHS (To Add)":
        case 261: //"MTOW LDS (To Add)":*/
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.closeOutFieldsToAdd(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                    updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 2);
                    if (fillOutFormAllData["systemId"] == 14) {
                      switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                        case 8 || 16 || 55 || 9 || 17 || 56:
                          changePICTime();
                          break;
                      }
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                    }
                    updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 2);
                    if (fillOutFormAllData["systemId"] == 14) {
                      switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                        case 8 || 16 || 55 || 9 || 17 || 56:
                          changePICTime();
                          break;
                      }
                    }
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 2);
                    if (fillOutFormAllData["systemId"] == 14) {
                      switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                        case 8 || 16 || 55 || 9 || 17 || 56:
                          changePICTime();
                          break;
                      }
                    }

                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                  },
                );
              },
            ),
          );
          break;

        case 16 || 17 || 18 || 19 || 100 || 112 || 20 || 21 || 109 || 121 || 78 || 81 || 84 || 87 || 90 || 103 || 106 || 115 || 118 || 30 || 96 || 34: //CloseOut Fields (End)
        case 133 || 136 || 139 || 142 || 147 || 150 || 46 || 49 || 159 || 165 || 168 || 171 || 174 || 177 || 180 || 183 || 186 || 189 || 192 || 195 || 198:
        case 253 || 256 || 259 || 262: //--- These fields don't have a traditional header / title
          /*case 16: //"AIRCRAFT FLT HOBBS (END)":
        case 17: //"AIRCRAFT BILL-MISC HOBBS (END)":
        case 147: //"AUX HOBBS (END)":
        case 159: //"AIRCRAFT TOTAL TIME (END)":
        case 30: //"LANDINGS (END)":
        case 96: //"LANDINGS - RUN ON (END)":
        case 34: //"TORQUE EVENTS (END)":
        case 46: //"HOIST CYCLES (END)":
        case 49: //"HOOK CYCLES (END)":
        case 18: //"E1: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 19: //"E2: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 100: //"E3: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 112: //"E4: TO ADDS/N1/NG/CCY/CT/CT (END)":
        case 87: //"E1: N2/PCY/PT1/PT1 (END)":
        case 90: //"E2: N2/PCY/PT1/PT1 (END)":
        case 103: //"E3: N2/PCY/PT1/PT1 (END)":
        case 115: //"E4: N2/PCY/PT1/PT1 (END)":
        case 78: //"E1: TOTAL TIME (END)":
        case 81: //"E2: TOTAL TIME (END)":
        case 106: //"E3: TOTAL TIME (END)":
        case 118: //"E4: TOTAL TIME (END)":
        case 20: //"E1: NPNF/ICY/IMP/IMP (END)":
        case 21: //"E2: NPNF/ICY/IMP/IMP (END)":
        case 109: //"E3: NPNF/ICY/IMP/IMP (END)":
        case 121: //"E4: NPNF/ICY/IMP/IMP (END)":
        case 133: //"E1: PRATT ENGINE CYCLES (END)":
        case 136: //"E2: PRATT ENGINE CYCLES (END)":
        case 139: //"E3: PRATT ENGINE CYCLES (END)":
        case 142: //"E4: PRATT ENGINE CYCLES (END)":
        case 84: //"APU: TOTAL TIME (END)":
        case 150: //"FUEL FARM FILLED ENDING AMOUNT":
        case 165: //"E1: CT COVER (END)":
        case 168: //"E2: CT COVER (END)":
        case 171: //"E1: CT CREEP (END)":
        case 174: //"E2: CT CREEP (END)":
        case 177: //"E1: HP COMPRESSOR (END)":
        case 180: //"E2: HP COMPRESSOR (END)":
        case 183: //"E1: PT 1 CREEP (END)":
        case 186: //"E2: PT 1 CREEP (END)":
        case 189: //"E1: PT 2 CREEP (END)":
        case 192: //"E2: PT 2 CREEP (END)":
        case 195: //"E1: PT 2 DISC (END)":
        case 198: //"E2: PT 2 DISC (END)":
        case 253: //"CAT.A Operations (END)":
        case 256: //"AVCS INOP (END)":
        case 259: //"MTOW FHS (END)":
        case 262: //"MTOW LDS (END)":*/
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.closeOutFieldsEnd(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                    updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 3);
                    if (fillOutFormAllData["systemId"] == 14) {
                      switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                        case 8 || 16 || 55 || 9 || 17 || 56:
                          changePICTime();
                          break;
                      }
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                    }
                    updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 3);
                    if (fillOutFormAllData["systemId"] == 14) {
                      switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                        case 8 || 16 || 55 || 9 || 17 || 56:
                          changePICTime();
                          break;
                      }
                    }
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    updateFlightCalculations(strType: rowsData[i][j]["columns"][k]["typeToCalculate"], strMode: 3);
                    if (fillOutFormAllData["systemId"] == 14) {
                      switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                        case 8 || 16 || 55 || 9 || 17 || 56:
                          changePICTime();
                          break;
                      }
                    }

                    await updateFieldValues();
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                  },
                );
              },
            ),
          );
          break;

        //Text Fields
        case 154: //"E1: CREEP DAMAGE PERCENT (END)":
        case 155: //"E2: CREEP DAMAGE PERCENT (END)":
        case 156: //"E3: CREEP DAMAGE PERCENT (END)":
        case 157: //"E4: CREEP DAMAGE PERCENT (END)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.creepDamagePercentEnd(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              fieldType: htmlValues[rowsData[i][j]["columns"][k]["id"].toString()],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                } else {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = "0";
                }
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
              },
            ),
          );
          break;

        //MISC Aircraft Fields
        //Text Fields
        case 36: //"UPDATE AC FUEL IN LBS":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.updateAcFuelInLbs(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              hintText: rowsData[i][j]["columns"][k]["placeHolder"],
              disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
              onTap: () {
                switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                  case "0":
                  case "0.0":
                  case "0.00":
                  case "0.000":
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                }
              },
              onChanged: (val) {
                if (val != '') {
                  values[rowsData[i][j]["columns"][k]["id"].toString()] = double.parse(val).toStringAsFixed(1);
                } else {
                  values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                }
                checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
              },
              onEditingComplete: () async {
                await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                await updateFieldValues();
                update();
                if (rowsData[i][j]["columns"].length > k + 1) {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else if (rowsData[i].length > j + 1) {
                  fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                      ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                      : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                } else {
                  fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                }
              },
            ),
          );
          break;

        //Formatting Fields
        //Field Formatters
        case 10: //"SPACER":
          if (rowsData[i][j]["columns"].length == 1) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.spacer(showField: showField[rowsData[i][j]["columns"][k]["id"].toString()], hidden: rowsData[i][j]["columns"][k]["columnHidden"]),
            );
          } else if (k == 0 && rowsData[i][j]["columns"].length > 8) {
            widgetsForEachRow.add(exceptionalFormTabularDesign(i, j, k)); //For Arizona DPS FW(55)_Z- Do not use-Employee Daily Summary - 160hr(503),
            // Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 40hr(517), Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 160hr(504),
            // Arizona DPS RW(46)_Z- Do not use-Employee Daily Summary - 160hr(493), Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 40hr(498),
            // Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 160hr(506), //NC HIGHWAY PATROL(68)_Mission Request or Flight Plan(408)
          }
          break;

        case 11: //"NEW LINE":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.newLine(showField: showField[rowsData[i][j]["columns"][k]["id"].toString()], hidden: rowsData[i][j]["columns"][k]["columnHidden"]),
          );
          exceptionalFormManualDesigns(i, j, k); //For Airtec Inc(90)_Daily Fuel Log(660), EXPLORAIR(100)_CONTROL COMBUSTIBLES AOG(700)
          break;

        //Headers
        case 50: //"HEADER CENTERED (BLUE)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredBlue(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            exceptionalFormManualDesigns(i, j, k); //For Hillsborough County Sheriffs Aviation(3)_Weekly Fuel Farm Inspection(90),
            // LEE County Sheriff(48)_Fuel Farm Inspection(297), MARTIN COUNTY SHERIFF(118)_Flight Activity Form(888),
            //Orange County Sheriffs Office(53)_TFO Trainee Daily Observation Report(412)
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredBlue(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredBlue(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: false,
              ),
            );
          }
          break;
        case 52: //"HEADER CENTERED (GREEN)":
          //For Las Vegas Metropolitan PD(59)_SAR 120 Training(710)
          if (Get.parameters["masterFormId"].toString() == "710") {
            for (var element in rowsData[i][j]["columns"]) {
              createdFields.add(element["id"].toString());
            }
            widgetsForEachRow.addIf(
              k == 0,
              FormWidgets.headerCenteredGreen(
                showField: showField[rowsData[i][j]["columns"][0]["id"].toString()],
                hidden: rowsData[i][j]["columns"][0]["columnHidden"],
                name: rowsData[i][j]["columns"][0]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][0]["acronymTitle"],
                multiple: false,
              ),
            );
          }

          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredGreen(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            exceptionalFormManualDesigns(
              i,
              j,
              k,
            ); //For Miami Dade Fire Rescue(5)_Daily Cmdr or Pilot(77), Miami Dade Fire Rescue(5)_OIC FM(79), HeliService USA(141)_AIRCRAFT DFL(1030)
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredGreen(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredGreen(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: false,
              ),
            );
          }
          break;
        case 54: //"HEADER CENTERED (ORANGE)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredOrange(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredOrange(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredOrange(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: false,
              ),
            );
          }
          break;
        case 53: //"HEADER CENTERED (RED)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredRed(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredRed(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredRed(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: false,
              ),
            );
          }
          break;
        case 51: //"HEADER CENTERED (WHITE)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredWhite(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredWhite(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredWhite(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: false,
              ),
            );
          }
          break;
        case 92: //"HEADER CENTERED (CUSTOM)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCenteredCustom(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"] != "" ? rowsData[i][j]["formRowBgColor"] : rowsData[i][j]["columns"][k]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredCustom(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"] != "" ? rowsData[i][j]["formRowBgColor"] : rowsData[i][j]["columns"][k]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              FormWidgets.headerCenteredCustom(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"] != "" ? rowsData[i][j]["formRowBgColor"] : rowsData[i][j]["columns"][k]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: false,
              ),
            );
          }
          break;
        case 127: //"HEADER (CUSTOM)":
          if (rowsData[i][j]["columns"].length > 2 &&
                  rowsData[i][j]["columns"][0]["formFieldType"] == rowsData[i][j]["columns"][1]["formFieldType"] &&
                  rowsData[i][j]["columns"][1]["formFieldType"] == rowsData[i][j]["columns"][2]["formFieldType"] &&
                  rowsData[i].length > j + 1
              ? rowsData[i][j + 1]["columns"][0]["elementType"] == 'text' || rowsData[i][j + 1]["columns"][0]["elementType"] == 'checkbox'
              : false) {
            createdFields.addIf(!createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()), rowsData[i][j]["columns"][k]["id"].toString());
            var finalWidgetsList = <Widget>[];
            finalWidgetsList.add(
              FormWidgets.headerCustom(
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                multiple: true,
              ),
            );
            finalWidgetsList.addAll(multiHeaderFields(i, j, k));
            widgetsForEachRow.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: finalWidgetsList));
          } else if (rowsData[i][j]["columns"].length > 1
              ? rowsData[i][j]["columns"][1]["cssClassName"] == "TableHeader"
                  ? true
                  : rowsData[i][j]["columns"][1]["formFieldType"] == 10
                  ? rowsData[i][j]["columns"].length > 2 && rowsData[i][j]["columns"][2]["cssClassName"] == "TableHeader"
                  : false
              : false) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              GetBuilder<FillOutFormLogic>(
                init: FillOutFormLogic(),
                builder: (controller) {
                  return FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j]["formRowBgColor"],
                    name: rowsData[i][j]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                    multiple: true,
                  );
                },
              ),
            );
          } else {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              GetBuilder<FillOutFormLogic>(
                init: FillOutFormLogic(),
                builder: (controller) {
                  return FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j]["formRowBgColor"],
                    name: rowsData[i][j]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                    multiple: false,
                  );
                },
              ),
            );
          }
          break;

        //Signature
        case 99: //"SIGNATURE - ELECTRONIC":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.signatureElectronic(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              fieldName: rowsData[i][j]["columns"][k]["formFieldName"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;
        case 124: //"SIGNATURE - PEN":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.signaturePEN(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  signatureController: signatureController.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () {
                    var startIndex = 0;
                    var penSignatureData = <String, List<List>>{"lines": []};
                    return SignatureController(
                      penStrokeWidth: 2,
                      penColor: ColorConstants.red,
                      exportBackgroundColor: Colors.blue,
                      onDrawStart: () {
                        tabScrollerControllerStop.value = true;
                      },
                      onDrawEnd: () {
                        if (signatureController[rowsData[i][j]["columns"][k]["id"].toString()] != null) {
                          var pointsList = [];
                          for (var points in signatureController[rowsData[i][j]["columns"][k]["id"].toString()]!.points) {
                            pointsList.add([points.offset.dx.toPrecision(2), points.offset.dy.toPrecision(2)]);
                          }
                          if (penSignatureDataList[rowsData[i][j]["columns"][k]["id"].toString()]?.isEmpty == true) {
                            startIndex = 0;
                            penSignatureData["lines"] = [];
                          }
                          penSignatureData["lines"]?.add(pointsList.sublist(startIndex));
                          startIndex = pointsList.length;
                        }
                        penSignatureDataList[rowsData[i][j]["columns"][k]["id"].toString()] = penSignatureData;
                        updateSignature(
                          strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                          signatureRecordID: rowsData[i][j]["columns"][k]["signatureTableId"].toString(),
                          savedOnFile: false,
                        );
                        tabScrollerControllerStop.value = false;
                        penSignatureClearButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = true;
                        update();
                      },
                    );
                  }),
                  signatureLookUpController: fillOutSignatureLookUpController.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  onCancelPopUpOnTap: () {
                    fillOutSignatureLookUpController[rowsData[i][j]["columns"][k]["id"].toString()]!.clear();
                    signaturePenAllData.clear();
                    signaturePenData.clear();
                    Get.back();
                  },
                  signatureClearButtonEnable: penSignatureClearButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] ?? false,
                  signatureClearButtonOnTap: () {
                    signatureController[rowsData[i][j]["columns"][k]["id"].toString()]?.points.clear();
                    penSignatureClearButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = false;
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]!.clear();
                    penSignatureDataList[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    updateSignature(
                      strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                      signatureRecordID: rowsData[i][j]["columns"][k]["signatureTableId"].toString(),
                      savedOnFile: false,
                    );
                    update();
                  },
                  signatureStoreButtonEnable: penSignatureStoreButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] ?? false,
                  signatureStoreButtonOnTap: () async {
                    LoaderHelper.loaderWithGif();
                    await updateSignature(
                      strFormFieldID: rowsData[i][j]["columns"][k]["id"].toString(),
                      signatureRecordID: rowsData[i][j]["columns"][k]["signatureTableId"].toString(),
                      savedOnFile: true,
                    );
                    penSignatureStoreButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = false;
                    update();
                    EasyLoading.dismiss();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.unfocus();
                  },
                  onEditingComplete: () async {
                    penSignatureStoreButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = true;
                    update();
                    fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.unfocus();
                  },
                  onChangeSignatureLookUp: (val) async {
                    await signatureSearchExtended(
                      strFormFieldId: rowsData[i][j]["columns"][k]["id"].toString(),
                      searchTerm: val.toString(),
                      currentSignatureRecordId: rowsData[i][j]["columns"][k]["signatureTableId"].toString(),
                    );
                  },
                  signaturePenAllData: signaturePenAllData,
                  signaturePenData: signaturePenData,
                  penSignatureDateTime: penSignatureDateTime[rowsData[i][j]["columns"][k]["id"].toString()] ?? false,
                  penSignatureDateTimeValue: penSignatureDateTimeValue[rowsData[i][j]["columns"][k]["id"].toString()],
                  signatureUserPointDataOnTap: (item) async {
                    LoaderHelper.loaderWithGif();

                    await signatureLoadSaved(
                      strFormFieldId: rowsData[i][j]["columns"][k]["id"].toString(),
                      currentSignatureRecordId: rowsData[i][j]["columns"][k]["signatureTableId"].toString(),
                      strSignatureIdSelected: item["id"].toString(),
                    );
                    signatureController.putIfAbsent(
                      rowsData[i][j]["columns"][k]["id"].toString(),
                      () => SignatureController(penStrokeWidth: 2, penColor: ColorConstants.red, exportBackgroundColor: Colors.blue),
                    );

                    signatureController[rowsData[i][j]["columns"][k]["id"].toString()]?.points = signaturePointLists[rowsData[i][j]["columns"][k]["id"].toString()] as List<Point>;

                    penSignatureClearButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = true;
                    signaturePenAllData.clear();
                    signaturePenData.clear();
                    fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = item["signatureName"].toString();
                    penSignatureDateTimeValue[rowsData[i][j]["columns"][k]["id"].toString()] = item["savedAt"].toString();
                    penSignatureDateTime[rowsData[i][j]["columns"][k]["id"].toString()] = true;
                    fillOutSignatureLookUpController[rowsData[i][j]["columns"][k]["id"].toString()]!.clear();
                    Get.back();
                    update();
                    EasyLoading.dismiss();
                  },
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  hintText: rowsData[i][j]["columns"][k]["placeHolder"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                      penSignatureStoreButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = true;
                      update();
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                      penSignatureStoreButtonEnable[rowsData[i][j]["columns"][k]["id"].toString()] = false;
                      update();
                    }
                    updateSignatureName(signatureRecordID: rowsData[i][j]["columns"][k]["signatureTableId"].toString(), strName: val);
                  },
                );
              },
            ),
          );
          break;

        //Automation Fields
        case 153: //"GENERATE AUTOMATIC ID (YYYYDDMM###)":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            FormWidgets.generateAutomaticID(
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              req: rowsData[i][j]["columns"][k]["formFieldRequired"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              controller: fillOutInputControllers.putIfAbsent(
                rowsData[i][j]["columns"][k]["id"].toString(),
                () => TextEditingController(text: values[rowsData[i][j]["columns"][k]["id"].toString()]),
              ),
              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
              defaultValue:
                  rowsData[i][j]["columns"][k]["defaultValue"] != values[rowsData[i][j]["columns"][k]["id"].toString()] ? rowsData[i][j]["columns"][k]["defaultValue"] : "",
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;
        case 144: //"RISK ASSESSMENT CHOOSER":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.riskAssessmentChooser(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: riskAssessmentDropDownData[rowsData[i][j]["columns"][k]["id"].toString()] ?? rowsData[i][j]["columns"][k]["elementData"],
                  dropDownKey: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  dropDownController: fillOutDropDownControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  onClick: () async {
                    LoaderHelper.loaderWithGif();
                    await riskAssessmentCallBack(value: "0", onClick: true, onChange: false)?.then((value) async {
                      selectedDropDown[rowsData[i][j]["columns"][k]["id"]] =
                          riskAssessmentDropDownData[rowsData[i][j]["columns"][k]["id"].toString()]?.firstWhere(
                            (element) => element["id"] == attribute[rowsData[i][j]["columns"][k]["id"].toString()]?["rel"],
                            orElse: () => riskAssessmentDropDownData[rowsData[i][j]["columns"][k]["id"].toString()]?.first,
                          )["name"];
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = attribute[rowsData[i][j]["columns"][k]["id"].toString()]!["rel"]!;
                      fillOutDropDownControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = selectedDropDown[rowsData[i][j]["columns"][k]["id"]];
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                    });
                    EasyLoading.dismiss();
                  },
                  onChanged: (val) async {
                    LoaderHelper.loaderWithGif();
                    riskAssessmentCallBack(value: val["id"], onChange: true, onClick: false)?.then((riskId) async {
                      selectedDropDown[rowsData[i][j]["columns"][k]["id"]] =
                          riskAssessmentDropDownData[rowsData[i][j]["columns"][k]["id"].toString()]?.firstWhere(
                            (element) => element["id"] == (riskId ?? val["id"]),
                            orElse: () => riskAssessmentDropDownData[rowsData[i][j]["columns"][k]["id"].toString()]?.first,
                          )["name"];
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = riskId ?? val["id"];
                      fillOutDropDownControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text = selectedDropDown[rowsData[i][j]["columns"][k]["id"]];
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                    });
                    EasyLoading.dismiss();
                  },
                );
              },
            ),
          );
          break;
        case 143: //"FAA LASER STRIKE REPORTING":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormCheckBox(
                  fieldType: "faaLaserStrikeReporting",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  currentValue:
                      values[rowsData[i][j]["columns"][k]["id"].toString()] != null
                          ? (values[rowsData[i][j]["columns"][k]["id"].toString()] == "on" ? true : false)
                          : (rowsData[i][j]["columns"][k]["defaultValue"] == "Checked" ? true : false),
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"] ?? false,
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  multiple: rowsData[i][j]["columns"].length > 1 ? true : false,
                  onChanged: (val) async {
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = (val == true ? "off" : "on");
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await showHideText(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        //User Roles
        case 1000: //"UR: (ANY PILOT)"/"UR: ALL PILOTS":
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormWidgets.urAllPilots(
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  key: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        case >= 200 && < 250: // DropDown UR: User Roles (200-249)
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormDropDown(
                  fieldType: "dropDownUR",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  dropDownKey: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        case > 262 && < 350: // Accessory Type Fields (263-349)
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            TitleOnly(
              fieldType: "accessoryTypeFields",
              id: rowsData[i][j]["columns"][k]["id"],
              rowColor: rowsData[i][j]["formRowBgColor"],
              name: rowsData[i][j]["columns"][k]["formFieldName"],
              acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
              previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
              defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
              showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
              hidden: rowsData[i][j]["columns"][k]["columnHidden"],
            ),
          );
          break;

        case >= 350 && < 450: // DropDown Form Chooser (350-449)
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormDropDown(
                  fieldType: "dropDownFormChooser",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name: rowsData[i][j]["columns"][k]["formFieldName"],
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                  dropDownKey: rowsData[i][j]["columns"][k]["key"] ?? "name",
                  selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  onChanged: (val) async {
                    selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                    values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                  },
                );
              },
            ),
          );
          break;

        case 1100 || 1101 || 1102: // Flight Log (From, Via, To)
          widgetsForEachRow.addIf(
            !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
            GetBuilder<FillOutFormLogic>(
              init: FillOutFormLogic(),
              builder: (controller) {
                return FormTextField(
                  fieldType: "flightLogFromViaTo",
                  id: rowsData[i][j]["columns"][k]["id"],
                  rowColor: rowsData[i][j]["formRowBgColor"],
                  name:
                      rowsData[i][j]["columns"][k]["formFieldName"] != ""
                          ? "${rowsData[i][j]["columns"][k]["formFieldName"]}${(rowsData[i][j]["columns"][k]["formFieldName"].toLowerCase().contains("from") || rowsData[i][j]["columns"][k]["formFieldName"].toLowerCase().contains("via") || rowsData[i][j]["columns"][k]["formFieldName"].toLowerCase().contains("to")) ? "" : " (${rowsData[i][j]["columns"][k]["formFieldType"] == 1100
                                  ? "From"
                                  : rowsData[i][j]["columns"][k]["formFieldType"] == 1101
                                  ? "Via"
                                  : "To"})"}"
                          : "",
                  req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                  showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                  acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j]["columns"][k]["id"].toString(), () => FocusNode()),
                  numberOnly: property[rowsData[i][j]["columns"][k]["id"].toString()]?["numberOnly"],
                  defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                  hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                  maxSize: rowsData[i][j]["columns"][k]["formMaxLength"],
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j]["columns"][k]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val;
                    } else {
                      values.remove(rowsData[i][j]["columns"][k]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j]["columns"].length > k + 1) {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j]["columns"][k + 1]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + 1) {
                      fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + 1]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j]["columns"][k]["id"].toString()]?.nextFocus();
                    }
                  },
                );
              },
            ),
          );
          break;

        default:
          if (rowsData[i][j]["columns"][k]["fieldName"] == "" && rowsData[i][j]["columns"][k]["elementType"].toString() == "select") {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              GetBuilder<FillOutFormLogic>(
                init: FillOutFormLogic(),
                builder: (controller) {
                  return FormDropDown(
                    fieldType: "default",
                    id: rowsData[i][j]["columns"][k]["id"],
                    rowColor: rowsData[i][j]["formRowBgColor"],
                    name: rowsData[i][j]["columns"][k]["formFieldName"],
                    req: rowsData[i][j]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                    dropDownData: rowsData[i][j]["columns"][k]["elementData"],
                    dropDownKey: rowsData[i][j]["columns"][k]["key"] ?? "name",
                    selectedValue: selectedDropDown[rowsData[i][j]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][j]["columns"][k]["id"].toString()],
                    defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j]["columns"][k]["columnHidden"],
                    onChanged: (val) async {
                      selectedDropDown.addIf(val != null, rowsData[i][j]["columns"][k]["id"], val[rowsData[i][j]["columns"][k]["key"] ?? "name"]);
                      values[rowsData[i][j]["columns"][k]["id"].toString()] = val["id"];
                      await checkForm(doSave: false, fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                    },
                  );
                },
              ),
            );
          } else if (rowsData[i][j]["columns"][k]["fieldName"] == "" && rowsData[i][j]["columns"][k]["formFieldType"] == 0) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              TitleOnly(
                fieldType: "default",
                id: rowsData[i][j]["columns"][k]["id"],
                rowColor: rowsData[i][j]["formRowBgColor"],
                name: rowsData[i][j]["columns"][k]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][k]["acronymTitle"],
                previousValue: formFieldPreValues[rowsData[i][j]["columns"][k]["id"].toString()],
                defaultValue: rowsData[i][j]["columns"][k]["defaultValue"],
                showField: showField[rowsData[i][j]["columns"][k]["id"].toString()],
                hidden: rowsData[i][j]["columns"][k]["columnHidden"],
              ),
            );
          } else if (kDebugMode) {
            widgetsForEachRow.addIf(
              !createdFields.contains(rowsData[i][j]["columns"][k]["id"].toString()),
              Text(
                "Field -${rowsData[i][j]["columns"][k]["formFieldName"]}- is not created.\n"
                "Field Type (${rowsData[i][j]["columns"][k]["formFieldType"]}): -${rowsData[i][j]["columns"][k]["fieldName"]}-\n",
                style: const TextStyle(color: ColorConstants.red),
              ),
            );
          }
      }
    }
    return widgetsForEachRow;
  }

  List<Widget> multiHeaderFields(i, j, k) {
    var m = 0;
    var n = rowsData[i].length - (j + 1);
    var multiHeaderFieldWidgets = <Widget>[];
    while (m < n && rowsData[i][j]["columns"][0]["cssClassName"] != rowsData[i][j + (m + 1)]["columns"][0]["cssClassName"]) {
      var l = m;
      if (rowsData[i][j + (l + 1)]["columns"].length > k && rowsData[i][j + (l + 1)]["columns"][k]["elementType"] == 'text') {
        createdFields.addIf(!createdFields.contains(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()), rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
        multiHeaderFieldWidgets.add(
          FormTextField(
            fieldType: "textFieldStandard",
            id: rowsData[i][j + (l + 1)]["columns"][k]["id"],
            rowColor: rowsData[i][j + (l + 1)]["formRowBgColor"],
            name: rowsData[i][j + (l + 1)]["columns"][k]["formFieldName"],
            req: rowsData[i][j + (l + 1)]["columns"][k]["formFieldRequired"],
            showField: showField[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()],
            acronymTitle: rowsData[i][j + (l + 1)]["columns"][k]["acronymTitle"],
            previousValue: formFieldPreValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()],
            controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString(), () => TextEditingController()),
            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString(), () => FocusNode()),
            numberOnly: property[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?["numberOnly"],
            defaultValue: rowsData[i][j + (l + 1)]["columns"][k]["defaultValue"],
            disableUserEditing: property[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + (l + 1)]["columns"][k]["readOnlyDisabled"],
            hidden: rowsData[i][j + (l + 1)]["columns"][k]["columnHidden"],
            maxSize: rowsData[i][j + (l + 1)]["columns"][k]["formMaxLength"],
            onTap: () {
              switch (fillOutInputControllers[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?.text) {
                case "0":
                case "0.0":
                case "0.00":
                case "0.000":
                  fillOutInputControllers[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?.clear();
              }
            },
            onChanged: (val) {
              if (val != '') {
                values[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] = val;
              } else {
                values.remove(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
              }
              checkForm(doSave: false, fieldId: rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
            },
            onEditingComplete: () async {
              await checkForm(doSave: false, fieldId: rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
              await updateFieldValues();
              update();
              if (rowsData[i][j + (l + 1)]["columns"].length > k + 1) {
                fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][k + 1]["id"].toString()] != null
                    ? fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][k + 1]["id"].toString()]?.requestFocus()
                    : fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?.nextFocus();
              } else if (rowsData[i].length > j + (l + 2)) {
                fillOutFocusNodes[rowsData[i][j + (l + 2)]["columns"][0]["id"].toString()] != null
                    ? fillOutFocusNodes[rowsData[i][j + (l + 2)]["columns"][0]["id"].toString()]?.requestFocus()
                    : fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?.nextFocus();
              } else {
                fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?.nextFocus();
              }
            },
          ),
        );
      } else if (rowsData[i][j + (l + 1)]["columns"].length > k && rowsData[i][j + (l + 1)]["columns"][k]["elementType"] == 'checkbox') {
        createdFields.addIf(!createdFields.contains(rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()), rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
        multiHeaderFieldWidgets.add(
          GetBuilder<FillOutFormLogic>(
            init: FillOutFormLogic(),
            builder: (controller) {
              return FormCheckBox(
                fieldType: "checkBoxYesNo",
                id: rowsData[i][j + (l + 1)]["columns"][k]["id"],
                rowColor: rowsData[i][j + (l + 1)]["formRowBgColor"],
                name: rowsData[i][j + (l + 1)]["columns"][k]["formFieldName"],
                req: rowsData[i][j + (l + 1)]["columns"][k]["formFieldRequired"],
                showField: showField[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()],
                acronymTitle: rowsData[i][j + (l + 1)]["columns"][k]["acronymTitle"],
                previousValue: formFieldPreValues[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()],
                defaultValue: rowsData[i][j + (l + 1)]["columns"][k]["defaultValue"],
                currentValue:
                    values[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] != null
                        ? (values[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] == "on" ? true : false)
                        : (rowsData[i][j + (l + 1)]["columns"][k]["defaultValue"] == "Checked" ? true : false),
                disableUserEditing:
                    property[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + (l + 1)]["columns"][k]["readOnlyDisabled"] ?? false,
                hidden: rowsData[i][j + (l + 1)]["columns"][k]["columnHidden"],
                multiple: rowsData[i][j + (l + 1)]["columns"].length > 1 ? true : false,
                onChanged: (val) async {
                  values[rowsData[i][j + (l + 1)]["columns"][k]["id"].toString()] = (val == true ? "off" : "on");
                  await checkForm(doSave: false, fieldId: rowsData[i][j + (l + 1)]["columns"][k]["id"].toString());
                  await showHideText(fieldId: rowsData[i][j]["columns"][k]["id"].toString());
                  await updateFieldValues();
                  update();
                },
              );
            },
          ),
        );
      }
      m++;
    }
    return multiHeaderFieldWidgets;
  }

  Widget exceptionalFormTabularDesign(i, j, k) {
    switch (Get.parameters["masterFormId"].toString()) {
      case "493": //Arizona DPS RW(46)_Z- Do not use-Employee Daily Summary - 160hr(493)
      case "498": //Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 40hr(498)
      case "503": //Arizona DPS FW(55)_Z- Do not use-Employee Daily Summary - 160hr(503)
      case "504": //Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 160hr(504)
      case "506": //Arizona DPS RW(46)_Z-Do not use - Employee Payroll Form - 160hr(506)
      case "517": //Arizona DPS FW(55)_Z-Do not use - Employee Payroll Form - 40hr(517)
        var m = j;

        while (m < rowsData[i].length && rowsData[i][m]["columns"][1]["formFieldType"] != 99) {
          for (var l = 0; l < rowsData[i][m]["columns"].length; l++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][m]["columns"][k + l]["id"].toString()), rowsData[i][m]["columns"][k + l]["id"].toString());
          }
          m++;
        }

        List<Widget> tableRowWidgets(l) {
          var rowWidgetList = <Widget>[];
          for (var m = 1; m <= 8; m++) {
            rowWidgetList.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                child: FormTextField(
                  fieldType: "numberDecimal_1Place",
                  id: rowsData[i][j + l]["columns"][k + m]["id"],
                  rowColor: rowsData[i][j + l]["formRowBgColor"],
                  name: rowsData[i][j + l]["columns"][k + m]["formFieldName"],
                  req: rowsData[i][j + l]["columns"][k + m]["formFieldRequired"],
                  showField: showField[rowsData[i][j + l]["columns"][k + m]["id"].toString()],
                  acronymTitle: rowsData[i][j + l]["columns"][k + m]["acronymTitle"],
                  previousValue: formFieldPreValues[rowsData[i][j + l]["columns"][k + m]["id"].toString()],
                  controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + l]["columns"][k + m]["id"].toString(), () => TextEditingController()),
                  focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + l]["columns"][k + m]["id"].toString(), () => FocusNode()),
                  defaultValue: rowsData[i][j + l]["columns"][k + m]["defaultValue"],
                  disableUserEditing: property[rowsData[i][j + l]["columns"][k + m]["id"].toString()]?["disabled"] ?? rowsData[i][j + l]["columns"][k + m]["readOnlyDisabled"],
                  hidden: rowsData[i][j + l]["columns"][k + m]["columnHidden"],
                  maxSize: rowsData[i][j + l]["columns"][k + m]["formMaxLength"],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+\.?\d?)?')),
                  onTap: () {
                    switch (fillOutInputControllers[rowsData[i][j + l]["columns"][k + m]["id"].toString()]?.text) {
                      case "0":
                      case "0.0":
                      case "0.00":
                      case "0.000":
                        fillOutInputControllers[rowsData[i][j + l]["columns"][k + m]["id"].toString()]?.clear();
                    }
                  },
                  onChanged: (val) {
                    if (val != '') {
                      values[rowsData[i][j + l]["columns"][k + m]["id"].toString()] = double.parse(val).toStringAsFixed(1);
                    } else {
                      values.remove(rowsData[i][j + l]["columns"][k + m]["id"].toString());
                    }
                    checkForm(doSave: false, fieldId: rowsData[i][j + l]["columns"][k + m]["id"].toString());
                  },
                  onEditingComplete: () async {
                    await checkForm(doSave: false, fieldId: rowsData[i][j + l]["columns"][k + m]["id"].toString());
                    await updateFieldValues();
                    update();
                    if (rowsData[i][j + l]["columns"].length > k + (m + 1)) {
                      fillOutFocusNodes[rowsData[i][j + l]["columns"][k + (m + 1)]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + l]["columns"][k + (m + 1)]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j + l]["columns"][k + m]["id"].toString()]?.nextFocus();
                    } else if (rowsData[i].length > j + (l + 1)) {
                      fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][0]["id"].toString()] != null
                          ? fillOutFocusNodes[rowsData[i][j + (l + 1)]["columns"][0]["id"].toString()]?.requestFocus()
                          : fillOutFocusNodes[rowsData[i][j + l]["columns"][k + m]["id"].toString()]?.nextFocus();
                    } else {
                      fillOutFocusNodes[rowsData[i][j + l]["columns"][k + m]["id"].toString()]?.nextFocus();
                    }
                  },
                ),
              ),
            );
          }

          return rowWidgetList;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 1
                          : 2
                      : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Align(alignment: Alignment.centerRight, child: Icon(Icons.swipe, color: Colors.white, size: 28 * Get.textScaleFactor)),
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 1]["formRowBgColor"],
                    name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 1]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 2]["formRowBgColor"],
                    name: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 2]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 2]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 3]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 3]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 3]["formRowBgColor"],
                    name: rowsData[i][j + 3]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 3]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 3]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 4]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 4]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 4]["formRowBgColor"],
                    name: rowsData[i][j + 4]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 4]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 4]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 5]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 5]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 5]["formRowBgColor"],
                    name: rowsData[i][j + 5]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 5]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 5]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 6]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 6]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 6]["formRowBgColor"],
                    name: rowsData[i][j + 6]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 6]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 6]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 7]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 7]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 7]["formRowBgColor"],
                    name: rowsData[i][j + 7]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 7]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 7]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.headerCustom(
                    showField: showField[rowsData[i][j + 8]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][j + 8]["columns"][k]["columnHidden"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    name: rowsData[i][j + 8]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][j + 8]["columns"][k]["acronymTitle"],
                    nameAlign: rowsData[i][j + 8]["columns"][k]["formFieldAlign"],
                    height: ((28 * Get.textScaleFactor).ceilToDouble() + 56.0),
                    multiple: false,
                  ),
                  FormWidgets.spacer(showField: showField[rowsData[i][j]["columns"][k]["id"].toString()], hidden: rowsData[i][j]["columns"][k]["columnHidden"], height: 5.0),
                ],
              ),
            ),
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 4
                          : 6
                      : 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: const FixedColumnWidth(180),
                    children: <TableRow>[
                      rowsData[i][j]["columns"][k + 1]["formFieldType"] == 50
                          ? TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                              color:
                                  rowsData[i][j]["formRowBgColor"] != ""
                                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 3]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 3]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 3]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 3]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 4]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 4]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 4]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 4]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 5]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 5]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 5]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 5]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 6]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 6]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 6]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 6]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 7]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 7]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 7]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 7]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredBlue(
                                  showField: showField[rowsData[i][j]["columns"][k + 8]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 8]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 8]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 8]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                            ],
                          )
                          : rowsData[i][j]["columns"][k + 1]["formFieldType"] == 52
                          ? TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                              color:
                                  rowsData[i][j]["formRowBgColor"] != ""
                                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 3]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 3]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 3]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 3]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 4]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 4]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 4]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 4]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 5]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 5]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 5]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 5]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 6]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 6]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 6]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 6]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 7]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 7]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 7]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 7]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredGreen(
                                  showField: showField[rowsData[i][j]["columns"][k + 8]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 8]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 8]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 8]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                            ],
                          )
                          : TableRow(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                              color:
                                  rowsData[i][j]["formRowBgColor"] != ""
                                      ? rowsData[i][j]["formRowBgColor"].toString().length == 4
                                          ? hexToColor("${rowsData[i][j]["formRowBgColor"]}000")
                                          : hexToColor(rowsData[i][j]["formRowBgColor"])
                                      : ThemeColorMode.isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 1]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 1]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 1]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 1]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 2]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 2]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 2]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 2]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 3]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 3]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 3]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 3]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 4]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 4]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 4]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 4]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 5]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 5]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 5]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 5]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 6]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 6]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 6]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 6]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 7]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 7]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 7]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 7]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: FormWidgets.headerCenteredCustom(
                                  showField: showField[rowsData[i][j]["columns"][k + 8]["id"].toString()],
                                  hidden: rowsData[i][j]["columns"][k + 8]["columnHidden"],
                                  name: rowsData[i][j]["columns"][k + 8]["formFieldName"],
                                  acronymTitle: rowsData[i][j]["columns"][k + 8]["acronymTitle"],
                                  multiple: true,
                                ),
                              ),
                            ],
                          ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 1]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 1]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 1]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 1]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(1),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 2]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 2]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 2]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 2]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(2),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 3]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 3]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 3]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 3]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(3),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 4]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 4]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 4]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 4]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(4),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 5]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 5]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 5]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 5]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(5),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 6]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 6]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 6]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 6]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(6),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 7]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 7]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 7]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 7]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(7),
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color:
                              rowsData[i][j + 8]["formRowBgColor"] != ""
                                  ? rowsData[i][j + 8]["formRowBgColor"].toString().length == 4
                                      ? hexToColor("${rowsData[i][j + 8]["formRowBgColor"]}000")
                                      : hexToColor(rowsData[i][j + 8]["formRowBgColor"])
                                  : ThemeColorMode.isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                        ),
                        children: tableRowWidgets(8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case "408": //NC HIGHWAY PATROL(68)_Mission Request or Flight Plan(408)
        var m = j;
        Map<int, FixedColumnWidth> columnWidths = {};
        var columnWidgets = <Widget>[];
        var tableWidgets = <TableRow>[];

        for (m; m < rowsData[i].length && rowsData[i][m]["columns"].length > 14; m++) {
          var tableRowWidgets = <Widget>[];
          for (var n = 0; n < rowsData[i][m]["columns"].length; n++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][m]["columns"][n]["id"].toString()), rowsData[i][m]["columns"][n]["id"].toString());
            switch (rowsData[i][m]["columns"][n]["formFieldType"] as int) {
              case 10: //"SPACER":
                if (m == j && n == 0) {
                  columnWidgets.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.swipe, color: ThemeColorMode.isDark ? Colors.white : Colors.black, size: 28, applyTextScaling: true),
                      ),
                    ),
                  );
                } else if (m != j) {
                  tableRowWidgets.add(
                    FormWidgets.spacer(showField: showField[rowsData[i][j]["columns"][k]["id"].toString()], hidden: rowsData[i][j]["columns"][k]["columnHidden"]),
                  );
                }
                break;
              case 51: //"HEADER CENTERED (WHITE)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredWhite(
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredWhite(
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                break;
              case 127: //"HEADER (CUSTOM)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCustom(
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          nameAlign: "R",
                          height: ((28 * Get.textScaleFactor).ceilToDouble() + 50.0),
                          multiple: false,
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCustom(
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          nameAlign: "R",
                          height: ((28 * Get.textScaleFactor).ceilToDouble() + 50.0),
                          multiple: false,
                        ),
                      ),
                    );
                break;
              case 52: //"HEADER CENTERED (GREEN)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                break;
              case 1: //"TEXT FIELD (STANDARD)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormTextField(
                          fieldType: "textFieldStandard",
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormTextField(
                          fieldType: "textFieldStandard",
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                break;
              case 69: //"INSTRUMENT TIME (SIMULATED)":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.instrumentTimeSimulated(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.instrumentTimeSimulated(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                break;
              case 64: //"DAY FLIGHT TIME":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.dayFlightTime(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.dayFlightTime(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                break;
              case 65: //"NIGHT FLIGHT TIME":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.nightFlightTime(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.nightFlightTime(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                break;
              case 63: //"NVG TIME":
                n == 0
                    ? columnWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.nvgTime(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    )
                    : tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.nvgTime(
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][n]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                break;
            }
          }
          tableWidgets.add(
            TableRow(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                color:
                    rowsData[i][m]["formRowBgColor"] != ""
                        ? rowsData[i][m]["formRowBgColor"].toString().length == 4
                            ? hexToColor("${rowsData[i][m]["formRowBgColor"]}000")
                            : hexToColor(rowsData[i][m]["formRowBgColor"])
                        : ThemeColorMode.isDark
                        ? Colors.grey[900]
                        : Colors.white,
              ),
              children: tableRowWidgets,
            ),
          );
        }

        for (var o = 0; o < rowsData[i][j]["columns"].length - 2; o++) {
          columnWidths.addIf(true, o, o % 2 == 0 ? const FixedColumnWidth(180) : const FixedColumnWidth(80));
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 1
                          : 2
                      : 1,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: columnWidgets),
            ),
            Expanded(
              flex:
                  Get.width > 480
                      ? Get.width > 980
                          ? 4
                          : 6
                      : 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, columnWidths: columnWidths, children: tableWidgets),
                ),
              ),
            ),
          ],
        );

      default:
        return Text(
          "Contact with Digital AirWare.\n System Name: ${UserSessionInfo.systemName},Form Name: ${Get.parameters["formName"]}",
          style: const TextStyle(color: Colors.red),
        );
    }
  }

  void exceptionalFormManualDesigns(i, j, k) {
    switch (Get.parameters["masterFormId"].toString()) {
      case "660": //Airtec Inc(90)_Daily Fuel Log(660)
      case "700": //EXPLORAIR(100)_CONTROL COMBUSTIBLES AOG(700)
        var l = j + 1;

        for (l; l < rowsData[i].length && rowsData[i][l]["columns"][0]["formFieldType"] != 11; l++) {
          for (var id in rowsData[i][l]["columns"]) {
            createdFields.addIf(!createdFields.contains(id["id"].toString()), id["id"].toString());
          }
        }

        switch (j) {
          case 2:
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][j + 1]["columns"][k]["id"].toString()],
                      hidden: rowsData[i][j + 1]["columns"][k]["columnHidden"],
                      name: rowsData[i][j + 1]["columns"][k]["formFieldName"],
                      acronymTitle: rowsData[i][j + 1]["columns"][k]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 2]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 2]["formRowBgColor"],
                    name: rowsData[i][j + 2]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 2]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 2]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 2]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 2]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 2]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 2]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 2]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 2]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 2]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 2]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 2]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 2]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 2]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 2]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 2]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 2]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 3) {
                        fillOutFocusNodes[rowsData[i][j + 3]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 3]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 2]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 3]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 3]["formRowBgColor"],
                    name: rowsData[i][j + 3]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 3]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 3]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 3]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 3]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 3]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 3]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 3]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 3]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 3]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 3]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 3]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 3]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 3]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 3]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 3]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 3]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 3]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 3]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 3]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 3]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 4) {
                        fillOutFocusNodes[rowsData[i][j + 4]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 4]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 3]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 3]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][j + 1]["columns"][k + 2]["id"].toString()],
                      hidden: rowsData[i][j + 1]["columns"][k + 2]["columnHidden"],
                      name: rowsData[i][j + 1]["columns"][k + 2]["formFieldName"],
                      acronymTitle: rowsData[i][j + 1]["columns"][k + 2]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 2]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 2]["formRowBgColor"],
                    name: rowsData[i][j + 2]["columns"][k + 2]["formFieldName"],
                    req: rowsData[i][j + 2]["columns"][k + 2]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()],
                    acronymTitle: rowsData[i][j + 2]["columns"][k + 2]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 2]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 2]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 2]["columns"][k + 2]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?["disabled"] ?? rowsData[i][j + 2]["columns"][k + 2]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 2]["columns"][k + 2]["columnHidden"],
                    maxSize: rowsData[i][j + 2]["columns"][k + 2]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 2]["columns"][k + 2]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 2]["columns"][k + 2]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 2]["columns"][k + 2]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 2]["columns"].length > k + 3) {
                        fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 3]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 3]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 3) {
                        fillOutFocusNodes[rowsData[i][j + 3]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 3]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 2]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 3]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 3]["formRowBgColor"],
                    name: rowsData[i][j + 3]["columns"][k + 2]["formFieldName"],
                    req: rowsData[i][j + 3]["columns"][k + 2]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()],
                    acronymTitle: rowsData[i][j + 3]["columns"][k + 2]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 3]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 3]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 3]["columns"][k + 2]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?["disabled"] ?? rowsData[i][j + 3]["columns"][k + 2]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 3]["columns"][k + 2]["columnHidden"],
                    maxSize: rowsData[i][j + 3]["columns"][k + 2]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 3]["columns"][k + 2]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 3]["columns"][k + 2]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 3]["columns"][k + 2]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 3]["columns"].length > k + 3) {
                        fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 3]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 3]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 4) {
                        fillOutFocusNodes[rowsData[i][j + 4]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 4]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 3]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 4]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 4]["formRowBgColor"],
                    name: rowsData[i][j + 4]["columns"][k + 1]["formFieldName"],
                    req: rowsData[i][j + 4]["columns"][k + 1]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()],
                    acronymTitle: rowsData[i][j + 4]["columns"][k + 1]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 4]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 4]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 4]["columns"][k + 1]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?["disabled"] ?? rowsData[i][j + 4]["columns"][k + 1]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 4]["columns"][k + 1]["columnHidden"],
                    maxSize: rowsData[i][j + 4]["columns"][k + 1]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 4]["columns"][k + 1]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 4]["columns"][k + 1]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 4]["columns"][k + 1]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 4]["columns"].length > k + 2) {
                        fillOutFocusNodes[rowsData[i][j + 4]["columns"][k + 2]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 4]["columns"][k + 2]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 5) {
                        fillOutFocusNodes[rowsData[i][j + 5]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 5]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 4]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 5]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 5]["formRowBgColor"],
                    name: rowsData[i][j + 5]["columns"][k + 1]["formFieldName"],
                    req: rowsData[i][j + 5]["columns"][k + 1]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()],
                    acronymTitle: rowsData[i][j + 5]["columns"][k + 1]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 5]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 5]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 5]["columns"][k + 1]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?["disabled"] ?? rowsData[i][j + 5]["columns"][k + 1]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 5]["columns"][k + 1]["columnHidden"],
                    maxSize: rowsData[i][j + 5]["columns"][k + 1]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 5]["columns"][k + 1]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 5]["columns"][k + 1]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 5]["columns"][k + 1]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 5]["columns"].length > k + 2) {
                        fillOutFocusNodes[rowsData[i][j + 5]["columns"][k + 2]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 5]["columns"][k + 2]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 6) {
                        fillOutFocusNodes[rowsData[i][j + 6]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 6]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 5]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 6]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 6]["formRowBgColor"],
                    name: rowsData[i][j + 6]["columns"][k + 1]["formFieldName"],
                    req: rowsData[i][j + 6]["columns"][k + 1]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()],
                    acronymTitle: rowsData[i][j + 6]["columns"][k + 1]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 6]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 6]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 6]["columns"][k + 1]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?["disabled"] ?? rowsData[i][j + 6]["columns"][k + 1]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 6]["columns"][k + 1]["columnHidden"],
                    maxSize: rowsData[i][j + 6]["columns"][k + 1]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 6]["columns"][k + 1]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 6]["columns"][k + 1]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 6]["columns"][k + 1]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 6]["columns"].length > k + 2) {
                        fillOutFocusNodes[rowsData[i][j + 6]["columns"][k + 2]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 6]["columns"][k + 2]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 7) {
                        fillOutFocusNodes[rowsData[i][j + 7]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 7]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 6]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(FormWidgets.newLine(hidden: false));
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][j + 7]["columns"][k]["id"].toString()],
                      hidden: rowsData[i][j + 7]["columns"][k]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 8]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    name: rowsData[i][j + 8]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 8]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 8]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 8]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 8]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 8]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 8]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 8]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 8]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 8]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 8]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 8]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 8]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 8]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 8]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 8]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 8]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 8]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 9) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 9]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    name: rowsData[i][j + 9]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 9]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 9]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 9]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 9]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 9]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 9]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 9]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 9]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 9]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 9]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 9]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 9]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 9]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 9]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 9]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 9]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 9]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 10) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k + 1]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k + 1]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k + 1]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k + 1]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k + 1]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k + 1]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k + 1]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k + 1]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 1]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 1]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 2) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 2]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 2]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 11]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    name: rowsData[i][j + 11]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 11]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 11]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 11]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 11]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 11]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 11]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 11]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 11]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 11]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 11]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 11]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 11]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 11]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 11]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 11]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 11]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 11]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 12) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 11]["columns"][k + 1]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    name: rowsData[i][j + 11]["columns"][k + 1]["formFieldName"],
                    req: rowsData[i][j + 11]["columns"][k + 1]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()],
                    acronymTitle: rowsData[i][j + 11]["columns"][k + 1]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 11]["columns"][k + 1]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 11]["columns"][k + 1]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 11]["columns"][k + 1]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?["disabled"] ?? rowsData[i][j + 11]["columns"][k + 1]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 11]["columns"][k + 1]["columnHidden"],
                    maxSize: rowsData[i][j + 11]["columns"][k + 1]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 11]["columns"][k + 1]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 1]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 1]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 11]["columns"].length > k + 2) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 2]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 2]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 12) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 1]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 12]["columns"][k]["id"],
                    rowColor: rowsData[i][j + 12]["formRowBgColor"],
                    name: rowsData[i][j + 12]["columns"][k]["formFieldName"],
                    req: rowsData[i][j + 12]["columns"][k]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 12]["columns"][k]["id"].toString()],
                    acronymTitle: rowsData[i][j + 12]["columns"][k]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 12]["columns"][k]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 12]["columns"][k]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 12]["columns"][k]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 12]["columns"][k]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 12]["columns"][k]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 12]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][j + 12]["columns"][k]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 12]["columns"][k]["columnHidden"],
                    maxSize: rowsData[i][j + 12]["columns"][k]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 12]["columns"][k]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 12]["columns"][k]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 12]["columns"][k]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 12]["columns"][k]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 12]["columns"][k]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 12]["columns"][k]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 12]["columns"].length > k + 1) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 1]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 1]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 12]["columns"][k]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 13) {
                        fillOutFocusNodes[rowsData[i][j + 13]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 13]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 12]["columns"][k]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][k]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][j + 7]["columns"][k + 2]["id"].toString()],
                      hidden: rowsData[i][j + 7]["columns"][k + 2]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k + 2]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k + 2]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 8]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    name: rowsData[i][j + 8]["columns"][k + 2]["formFieldName"],
                    req: rowsData[i][j + 8]["columns"][k + 2]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()],
                    acronymTitle: rowsData[i][j + 8]["columns"][k + 2]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 8]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 8]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 8]["columns"][k + 2]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?["disabled"] ?? rowsData[i][j + 8]["columns"][k + 2]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 8]["columns"][k + 2]["columnHidden"],
                    maxSize: rowsData[i][j + 8]["columns"][k + 2]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 8]["columns"][k + 2]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k + 2]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k + 2]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 8]["columns"].length > k + 3) {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 3]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 3]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 9) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 9]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    name: rowsData[i][j + 9]["columns"][k + 2]["formFieldName"],
                    req: rowsData[i][j + 9]["columns"][k + 2]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()],
                    acronymTitle: rowsData[i][j + 9]["columns"][k + 2]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 9]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 9]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 9]["columns"][k + 2]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?["disabled"] ?? rowsData[i][j + 9]["columns"][k + 2]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 9]["columns"][k + 2]["columnHidden"],
                    maxSize: rowsData[i][j + 9]["columns"][k + 2]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 9]["columns"][k + 2]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k + 2]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k + 2]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 9]["columns"].length > k + 3) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 3]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 3]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 10) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k + 3]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k + 3]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k + 3]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k + 3]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k + 3]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k + 3]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k + 3]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k + 3]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k + 3]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k + 3]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k + 3]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 3]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 3]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 4) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 3]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k + 4]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k + 4]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k + 4]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k + 4]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k + 4]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k + 4]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k + 4]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k + 4]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k + 4]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k + 4]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 4]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 4]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 5) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 5]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 5]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 11]["columns"][k + 3]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    name: rowsData[i][j + 11]["columns"][k + 3]["formFieldName"],
                    req: rowsData[i][j + 11]["columns"][k + 3]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()],
                    acronymTitle: rowsData[i][j + 11]["columns"][k + 3]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 11]["columns"][k + 3]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 11]["columns"][k + 3]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 11]["columns"][k + 3]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?["disabled"] ?? rowsData[i][j + 11]["columns"][k + 3]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 11]["columns"][k + 3]["columnHidden"],
                    maxSize: rowsData[i][j + 11]["columns"][k + 3]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 11]["columns"][k + 3]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 3]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 3]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 11]["columns"].length > k + 4) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 12) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 3]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 11]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    name: rowsData[i][j + 11]["columns"][k + 4]["formFieldName"],
                    req: rowsData[i][j + 11]["columns"][k + 4]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()],
                    acronymTitle: rowsData[i][j + 11]["columns"][k + 4]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 11]["columns"][k + 4]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 11]["columns"][k + 4]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 11]["columns"][k + 4]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?["disabled"] ?? rowsData[i][j + 11]["columns"][k + 4]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 11]["columns"][k + 4]["columnHidden"],
                    maxSize: rowsData[i][j + 11]["columns"][k + 4]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 11]["columns"][k + 4]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 4]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 4]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 11]["columns"].length > k + 5) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 5]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 5]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 12) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 12]["columns"][k + 2]["id"],
                    rowColor: rowsData[i][j + 12]["formRowBgColor"],
                    name: rowsData[i][j + 12]["columns"][k + 2]["formFieldName"],
                    req: rowsData[i][j + 12]["columns"][k + 2]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()],
                    acronymTitle: rowsData[i][j + 12]["columns"][k + 2]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 12]["columns"][k + 2]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 12]["columns"][k + 2]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 12]["columns"][k + 2]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?["disabled"] ?? rowsData[i][j + 12]["columns"][k + 2]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 12]["columns"][k + 2]["columnHidden"],
                    maxSize: rowsData[i][j + 12]["columns"][k + 2]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 12]["columns"][k + 2]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 12]["columns"][k + 2]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 12]["columns"][k + 2]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 12]["columns"].length > k + 3) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 3]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 3]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 13) {
                        fillOutFocusNodes[rowsData[i][j + 13]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 13]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 2]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][j + 7]["columns"][k + 4]["id"].toString()],
                      hidden: rowsData[i][j + 7]["columns"][k + 4]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k + 4]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k + 4]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 8]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    name: rowsData[i][j + 8]["columns"][k + 4]["formFieldName"],
                    req: rowsData[i][j + 8]["columns"][k + 4]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()],
                    acronymTitle: rowsData[i][j + 8]["columns"][k + 4]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 8]["columns"][k + 4]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 8]["columns"][k + 4]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 8]["columns"][k + 4]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?["disabled"] ?? rowsData[i][j + 8]["columns"][k + 4]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 8]["columns"][k + 4]["columnHidden"],
                    maxSize: rowsData[i][j + 8]["columns"][k + 4]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 8]["columns"][k + 4]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k + 4]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k + 4]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 8]["columns"].length > k + 5) {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 5]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 5]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 9) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 9]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    name: rowsData[i][j + 9]["columns"][k + 4]["formFieldName"],
                    req: rowsData[i][j + 9]["columns"][k + 4]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()],
                    acronymTitle: rowsData[i][j + 9]["columns"][k + 4]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 9]["columns"][k + 4]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 9]["columns"][k + 4]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 9]["columns"][k + 4]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?["disabled"] ?? rowsData[i][j + 9]["columns"][k + 4]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 9]["columns"][k + 4]["columnHidden"],
                    maxSize: rowsData[i][j + 9]["columns"][k + 4]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 9]["columns"][k + 4]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k + 4]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k + 4]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 9]["columns"].length > k + 5) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 5]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 5]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 10) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k + 6]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k + 6]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k + 6]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k + 6]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k + 6]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k + 6]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k + 6]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k + 6]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k + 6]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k + 6]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 6]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 6]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 7) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k + 7]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k + 7]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k + 7]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k + 7]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k + 7]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k + 7]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k + 7]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k + 7]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k + 7]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k + 7]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k + 7]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 7]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 7]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 8) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 8]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 8]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 7]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 11]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    name: rowsData[i][j + 11]["columns"][k + 6]["formFieldName"],
                    req: rowsData[i][j + 11]["columns"][k + 6]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()],
                    acronymTitle: rowsData[i][j + 11]["columns"][k + 6]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 11]["columns"][k + 6]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 11]["columns"][k + 6]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 11]["columns"][k + 6]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?["disabled"] ?? rowsData[i][j + 11]["columns"][k + 6]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 11]["columns"][k + 6]["columnHidden"],
                    maxSize: rowsData[i][j + 11]["columns"][k + 6]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 11]["columns"][k + 6]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 6]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 6]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 11]["columns"].length > k + 7) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 12) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 11]["columns"][k + 7]["id"],
                    rowColor: rowsData[i][j + 11]["formRowBgColor"],
                    name: rowsData[i][j + 11]["columns"][k + 7]["formFieldName"],
                    req: rowsData[i][j + 11]["columns"][k + 7]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()],
                    acronymTitle: rowsData[i][j + 11]["columns"][k + 7]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 11]["columns"][k + 7]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 11]["columns"][k + 7]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 11]["columns"][k + 7]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?["disabled"] ?? rowsData[i][j + 11]["columns"][k + 7]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 11]["columns"][k + 7]["columnHidden"],
                    maxSize: rowsData[i][j + 11]["columns"][k + 7]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 11]["columns"][k + 7]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 7]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 11]["columns"][k + 7]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 11]["columns"].length > k + 8) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 8]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 8]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 12) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][k + 7]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 12]["columns"][k + 4]["id"],
                    rowColor: rowsData[i][j + 12]["formRowBgColor"],
                    name: rowsData[i][j + 12]["columns"][k + 4]["formFieldName"],
                    req: rowsData[i][j + 12]["columns"][k + 4]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()],
                    acronymTitle: rowsData[i][j + 12]["columns"][k + 4]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 12]["columns"][k + 4]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 12]["columns"][k + 4]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 12]["columns"][k + 4]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?["disabled"] ?? rowsData[i][j + 12]["columns"][k + 4]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 12]["columns"][k + 4]["columnHidden"],
                    maxSize: rowsData[i][j + 12]["columns"][k + 4]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 12]["columns"][k + 4]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 12]["columns"][k + 4]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 12]["columns"][k + 4]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 12]["columns"].length > k + 5) {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 5]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 5]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 13) {
                        fillOutFocusNodes[rowsData[i][j + 13]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 13]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 12]["columns"][k + 4]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                ],
              ),
            );
            widgetsForEachRow.add(
              Column(
                children: [
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][j + 7]["columns"][k + 6]["id"].toString()],
                      hidden: rowsData[i][j + 7]["columns"][k + 6]["columnHidden"],
                      name: rowsData[i][j + 7]["columns"][k + 6]["formFieldName"],
                      acronymTitle: rowsData[i][j + 7]["columns"][k + 6]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 8]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 8]["formRowBgColor"],
                    name: rowsData[i][j + 8]["columns"][k + 6]["formFieldName"],
                    req: rowsData[i][j + 8]["columns"][k + 6]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()],
                    acronymTitle: rowsData[i][j + 8]["columns"][k + 6]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 8]["columns"][k + 6]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 8]["columns"][k + 6]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 8]["columns"][k + 6]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?["disabled"] ?? rowsData[i][j + 8]["columns"][k + 6]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 8]["columns"][k + 6]["columnHidden"],
                    maxSize: rowsData[i][j + 8]["columns"][k + 6]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 8]["columns"][k + 6]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k + 6]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 8]["columns"][k + 6]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 8]["columns"].length > k + 7) {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 7]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 7]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 9) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 8]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 9]["columns"][k + 6]["id"],
                    rowColor: rowsData[i][j + 9]["formRowBgColor"],
                    name: rowsData[i][j + 9]["columns"][k + 6]["formFieldName"],
                    req: rowsData[i][j + 9]["columns"][k + 6]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()],
                    acronymTitle: rowsData[i][j + 9]["columns"][k + 6]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 9]["columns"][k + 6]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 9]["columns"][k + 6]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 9]["columns"][k + 6]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?["disabled"] ?? rowsData[i][j + 9]["columns"][k + 6]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 9]["columns"][k + 6]["columnHidden"],
                    maxSize: rowsData[i][j + 9]["columns"][k + 6]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 9]["columns"][k + 6]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k + 6]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 9]["columns"][k + 6]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 9]["columns"].length > k + 7) {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 7]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 7]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 10) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 9]["columns"][k + 6]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                  FormTextField(
                    fieldType: "textFieldStandard",
                    id: rowsData[i][j + 10]["columns"][k + 9]["id"],
                    rowColor: rowsData[i][j + 10]["formRowBgColor"],
                    name: rowsData[i][j + 10]["columns"][k + 9]["formFieldName"],
                    req: rowsData[i][j + 10]["columns"][k + 9]["formFieldRequired"],
                    showField: showField[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()],
                    acronymTitle: rowsData[i][j + 10]["columns"][k + 9]["acronymTitle"],
                    previousValue: formFieldPreValues[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()],
                    controller: fillOutInputControllers.putIfAbsent(rowsData[i][j + 10]["columns"][k + 9]["id"].toString(), () => TextEditingController()),
                    focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][j + 10]["columns"][k + 9]["id"].toString(), () => FocusNode()),
                    numberOnly: property[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?["numberOnly"],
                    defaultValue: rowsData[i][j + 10]["columns"][k + 9]["defaultValue"],
                    disableUserEditing: property[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?["disabled"] ?? rowsData[i][j + 10]["columns"][k + 9]["readOnlyDisabled"],
                    hidden: rowsData[i][j + 10]["columns"][k + 9]["columnHidden"],
                    maxSize: rowsData[i][j + 10]["columns"][k + 9]["formMaxLength"],
                    onTap: () {
                      switch (fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?.text) {
                        case "0":
                        case "0.0":
                        case "0.00":
                        case "0.000":
                          fillOutInputControllers[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?.clear();
                      }
                    },
                    onChanged: (val) {
                      if (val != '') {
                        values[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()] = val;
                      } else {
                        values.remove(rowsData[i][j + 10]["columns"][k + 9]["id"].toString());
                      }
                      checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 9]["id"].toString());
                    },
                    onEditingComplete: () async {
                      await checkForm(doSave: false, fieldId: rowsData[i][j + 10]["columns"][k + 9]["id"].toString());
                      await updateFieldValues();
                      update();
                      if (rowsData[i][j + 10]["columns"].length > k + 10) {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 10]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 10]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?.nextFocus();
                      } else if (rowsData[i].length > j + 11) {
                        fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()] != null
                            ? fillOutFocusNodes[rowsData[i][j + 11]["columns"][0]["id"].toString()]?.requestFocus()
                            : fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?.nextFocus();
                      } else {
                        fillOutFocusNodes[rowsData[i][j + 10]["columns"][k + 9]["id"].toString()]?.nextFocus();
                      }
                    },
                  ),
                ],
              ),
            );
          case 15:
            var m = j;
            var n = j + 7;
            var tableWidgets1 = <TableRow>[];
            var tableWidgets2 = <TableRow>[];

            while (m < rowsData[i].length && rowsData[i][16]["columns"][1]["cssClassName"] != rowsData[i][m + 1]["columns"][0]["cssClassName"]) {
              var tableRowWidgets = <Widget>[];
              for (var o = 0; o < rowsData[i][m + 1]["columns"].length; o++) {
                switch (rowsData[i][m + 1]["columns"][o]["formFieldType"] as int) {
                  case 10: //"SPACER":
                    break;
                  case 52: //"HEADER CENTERED (GREEN)":
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          showField: showField[rowsData[i][m + 1]["columns"][o]["id"].toString()],
                          hidden: rowsData[i][m + 1]["columns"][o]["columnHidden"],
                          name: rowsData[i][m + 1]["columns"][o]["formFieldName"],
                          acronymTitle: rowsData[i][m + 1]["columns"][o]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                    break;
                  case 1: //"TEXT FIELD (STANDARD)":
                    var p = m;
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormTextField(
                          fieldType: "textFieldStandard",
                          id: rowsData[i][p + 1]["columns"][o]["id"],
                          rowColor: rowsData[i][p + 1]["formRowBgColor"],
                          name: rowsData[i][p + 1]["columns"][o]["formFieldName"],
                          req: rowsData[i][p + 1]["columns"][o]["formFieldRequired"],
                          showField: showField[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                          acronymTitle: rowsData[i][p + 1]["columns"][o]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][p + 1]["columns"][o]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][p + 1]["columns"][o]["id"].toString(), () => FocusNode()),
                          numberOnly: property[rowsData[i][p + 1]["columns"][o]["id"].toString()]?["numberOnly"],
                          defaultValue: rowsData[i][p + 1]["columns"][o]["defaultValue"],
                          disableUserEditing: property[rowsData[i][p + 1]["columns"][o]["id"].toString()]?["disabled"] ?? rowsData[i][p + 1]["columns"][o]["readOnlyDisabled"],
                          hidden: rowsData[i][p + 1]["columns"][o]["columnHidden"],
                          maxSize: rowsData[i][p + 1]["columns"][o]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) async {
                            if (val != '') {
                              values[rowsData[i][p + 1]["columns"][o]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][p + 1]["columns"][o]["id"].toString());
                            }
                            await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][p + 1]["columns"].length > o + 1) {
                              fillOutFocusNodes[rowsData[i][p + 1]["columns"][o + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][p + 1]["columns"][o + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > p + 2) {
                              fillOutFocusNodes[rowsData[i][p + 2]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][p + 2]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                    break;
                  case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
                    var p = m;
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: GetBuilder<FillOutFormLogic>(
                          init: FillOutFormLogic(),
                          builder: (controller) {
                            return FormWidgets.dropDownViaServiceTableValues(
                              id: rowsData[i][p + 1]["columns"][o]["id"],
                              rowColor: rowsData[i][p + 1]["formRowBgColor"],
                              name: rowsData[i][p + 1]["columns"][o]["formFieldName"],
                              dropDownData: rowsData[i][p + 1]["columns"][o]["elementData"],
                              searchDataList: addChoiceServiceTableData,
                              key: rowsData[i][p + 1]["columns"][o]["key"] ?? "name",
                              specificDataType: rowsData[i][p + 1]["columns"][o]["serviceTableName"],
                              addChoices: rowsData[i][p + 1]["columns"][o]["formFieldAbilityToAdd"],
                              selectMultiple: rowsData[i][p + 1]["columns"][o]["formFieldStSelectMany"],
                              req: rowsData[i][p + 1]["columns"][o]["formFieldRequired"],
                              showField: showField[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                              acronymTitle: rowsData[i][p + 1]["columns"][o]["acronymTitle"],
                              previousValue:
                                  rowsData[i][p + 1]["columns"][o]["formFieldAbilityToAdd"]
                                      ? formFieldPreValues[rowsData[i][p + 1]["columns"][o]["id"].toString()]
                                      : rowsData[i][p + 1]["columns"][o]["formFieldStSelectMany"]
                                      ? extendedFieldsValue[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.replaceAll("^^^#", ", ")
                                      : dropDownFieldValues[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                              selectedValue:
                                  rowsData[i][p + 1]["columns"][o]["formFieldStSelectMany"]
                                      ? selectedDropDown[rowsData[i][p + 1]["columns"][o]["id"]] ??
                                          extendedFieldsValue[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.replaceAll("^^^#", ", ")
                                      : selectedDropDown[rowsData[i][p + 1]["columns"][o]["id"]] ?? dropDownFieldValues[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                              controller: fillOutInputControllers.putIfAbsent(rowsData[i][p + 1]["columns"][o]["id"].toString(), () => TextEditingController()),
                              focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][p + 1]["columns"][o]["id"].toString(), () => FocusNode()),
                              defaultValue: rowsData[i][p + 1]["columns"][o]["defaultValue"],
                              hintText: rowsData[i][p + 1]["columns"][o]["placeHolder"] ?? "",
                              disableUserEditing: property[rowsData[i][p + 1]["columns"][o]["id"].toString()]?["disabled"] ?? rowsData[i][p + 1]["columns"][o]["readOnlyDisabled"],
                              hidden: rowsData[i][p + 1]["columns"][o]["columnHidden"],
                              maxSize: rowsData[i][p + 1]["columns"][o]["formMaxLength"],
                              onTap: () {
                                switch (fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.text) {
                                  case "0":
                                  case "0.0":
                                  case "0.00":
                                  case "0.000":
                                    fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.clear();
                                }
                              },
                              onChanged: (val) async {
                                if (rowsData[i][p + 1]["columns"][o]["formFieldAbilityToAdd"]) {
                                  if (val != '') {
                                    LoaderHelper.loaderWithGif();
                                    values[rowsData[i][p + 1]["columns"][o]["id"].toString()] = val;
                                    await searchFormFieldValues(
                                      strFormFieldType: rowsData[i][p + 1]["columns"][o]["serviceTableName"],
                                      strValue: val,
                                      liveSearchID: rowsData[i][p + 1]["columns"][o]["id"].toString(),
                                    );
                                    update();
                                    EasyLoading.dismiss();
                                  } else {
                                    values.remove(rowsData[i][p + 1]["columns"][o]["id"].toString());
                                    addChoiceServiceTableData[rowsData[i][p + 1]["columns"][o]["id"].toString()] = [];
                                  }
                                  await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                                } else {
                                  selectedDropDown.addIf(val != null, rowsData[i][p + 1]["columns"][o]["id"], val[rowsData[i][p + 1]["columns"][o]["key"] ?? "name"]);
                                  values[rowsData[i][p + 1]["columns"][o]["id"].toString()] = val["id"];
                                  await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                                  await updateFieldValues();
                                  update();
                                }
                              },
                              onEditingComplete: () async {
                                LoaderHelper.loaderWithGif();
                                addChoiceServiceTableData[rowsData[i][p + 1]["columns"][o]["id"].toString()] = [];
                                await setChoiceFromSearch(
                                  strFieldId: rowsData[i][p + 1]["columns"][o]["id"].toString(),
                                  strValue: fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.text,
                                  requestToAdd: fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.text != "" ? "1" : "0",
                                  serviceTableToAddTo: rowsData[i][p + 1]["columns"][o]["serviceTableName"],
                                );
                                await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                                await updateFieldValues();
                                update();
                                EasyLoading.dismiss();
                                if (rowsData[i][p + 1]["columns"].length > o + 1) {
                                  fillOutFocusNodes[rowsData[i][p + 1]["columns"][o + 1]["id"].toString()] != null
                                      ? fillOutFocusNodes[rowsData[i][p + 1]["columns"][o + 1]["id"].toString()]?.requestFocus()
                                      : fillOutFocusNodes[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.nextFocus();
                                } else if (rowsData[i].length > p + 2) {
                                  fillOutFocusNodes[rowsData[i][p + 2]["columns"][0]["id"].toString()] != null
                                      ? fillOutFocusNodes[rowsData[i][p + 2]["columns"][0]["id"].toString()]?.requestFocus()
                                      : fillOutFocusNodes[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.nextFocus();
                                } else {
                                  fillOutFocusNodes[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.nextFocus();
                                }
                              },
                              onSelect: (val, requestToAdd) async {
                                fillOutInputControllers[rowsData[i][p + 1]["columns"][o]["id"].toString()]?.text = val;
                                Keyboard.close();
                                await setChoiceFromSearch(
                                  strFieldId: rowsData[i][p + 1]["columns"][o]["id"].toString(),
                                  strValue: val,
                                  requestToAdd: requestToAdd,
                                  serviceTableToAddTo: rowsData[i][p + 1]["columns"][o]["serviceTableName"],
                                );
                                await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                                await updateFieldValues();
                                update();
                              },
                              onDialogPopUp: () async {
                                LoaderHelper.loaderWithGif();
                                await loadExtendedField(
                                  strFieldID: rowsData[i][p + 1]["columns"][o]["id"].toString(),
                                  strNarrativeID: formFieldPreValues[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                                  strFieldTypeID: rowsData[i][p + 1]["columns"][o]["formFieldType"].toString(),
                                );
                                EasyLoading.dismiss();

                                var selectedData = "".obs;
                                var selectedDataList = [].obs;
                                var selectAllCheckBox = false.obs;
                                var checkBoxStatus = [].obs;

                                if (loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()] != null) {
                                  for (int n = 0; n < loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]!.length; n++) {
                                    if (extendedFieldsValue[rowsData[i][p + 1]["columns"][o]["id"].toString()] != null) {
                                      if (extendedFieldsValue[rowsData[i][p + 1]["columns"][o]["id"].toString()]!.contains(
                                        loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![n]["name"],
                                      )) {
                                        selectedDataList.add(loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![n]["name"]);
                                        checkBoxStatus.add(true);
                                      } else {
                                        checkBoxStatus.add(false);
                                        selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![n]["name"]);
                                      }
                                    } else {
                                      checkBoxStatus.add(false);
                                    }
                                  }
                                }
                                update();
                                showDialog(
                                  useSafeArea: true,
                                  useRootNavigator: false,
                                  barrierDismissible: true,
                                  context: Get.context!,
                                  builder: (BuildContext context) {
                                    return ResponsiveBuilder(
                                      builder: (context, sizingInformation) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                          child: Dialog(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                              side: const BorderSide(color: ColorConstants.primary, width: 2),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                        onTap: () {
                                                          selectAllCheckBox.value = !selectAllCheckBox.value;
                                                          checkBoxStatus.clear();
                                                          selectedDataList.clear();
                                                          for (int n = 0; n < loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]!.length; n++) {
                                                            checkBoxStatus.add(selectAllCheckBox.value);
                                                            if (selectAllCheckBox.value == true) {
                                                              selectedDataList.add(loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![n]["name"]);
                                                            } else {
                                                              selectedDataList.clear();
                                                            }
                                                          }
                                                        },
                                                      ),
                                                      Obx(() {
                                                        return IconButton(
                                                          icon: Icon(
                                                            selectAllCheckBox.value == false ? Icons.select_all : Icons.deselect,
                                                            size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                          ),
                                                          color:
                                                              selectAllCheckBox.value == false
                                                                  ? ColorConstants.grey
                                                                  : ThemeColorMode.isDark
                                                                  ? ColorConstants.white
                                                                  : ColorConstants.black,
                                                          onPressed: () {
                                                            selectAllCheckBox.value = !selectAllCheckBox.value;
                                                            checkBoxStatus.clear();
                                                            selectedDataList.clear();
                                                            for (int n = 0; n < loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]!.length; n++) {
                                                              checkBoxStatus.add(selectAllCheckBox.value);
                                                              if (selectAllCheckBox.value == true) {
                                                                selectedDataList.add(loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![n]["name"]);
                                                              } else {
                                                                selectedDataList.clear();
                                                              }
                                                            }
                                                          },
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]!.length,
                                                            itemBuilder: (context, l) {
                                                              return Obx(() {
                                                                return CheckboxListTile(
                                                                  activeColor: ColorConstants.primary,
                                                                  side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                                  value: checkBoxStatus[l],
                                                                  dense: true,
                                                                  title: Text(
                                                                    loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![l]["name"],
                                                                    style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w400,
                                                                      color:
                                                                          selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                                      letterSpacing: 0.5,
                                                                    ),
                                                                  ),
                                                                  selected: checkBoxStatus[l],
                                                                  onChanged: (val) async {
                                                                    checkBoxStatus[l] = val!;
                                                                    if (val == true) {
                                                                      selectedDataList.add(loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![l]["name"]);
                                                                    } else {
                                                                      selectedDataList.removeWhere((item) {
                                                                        return item == loadExtendedFieldData[rowsData[i][p + 1]["columns"][o]["id"].toString()]![l]["name"];
                                                                      });
                                                                      selectAllCheckBox.value = false;
                                                                    }
                                                                  },
                                                                );
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: SizeConstants.rootContainerSpacing),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      ButtonConstant.dialogButton(
                                                        title: "Cancel",
                                                        borderColor: ColorConstants.red,
                                                        onTapMethod: () {
                                                          Get.back();
                                                        },
                                                      ),
                                                      const SizedBox(width: SizeConstants.contentSpacing),
                                                      ButtonConstant.dialogButton(
                                                        title: "Save & Close",
                                                        btnColor: ColorConstants.primary,
                                                        onTapMethod: () async {
                                                          LoaderHelper.loaderWithGif();

                                                          selectedData.value = "";
                                                          for (int n = 0; n < selectedDataList.length; n++) {
                                                            if (n + 1 == selectedDataList.length) {
                                                              selectedData.value += "${selectedDataList[n]}";
                                                            } else {
                                                              selectedData.value += "${selectedDataList[n]}^^^#";
                                                            }
                                                          }
                                                          Get.back();
                                                          selectedDropDown.addIf(true, rowsData[i][p + 1]["columns"][o]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                                          await saveSelectMultipleFinal(
                                                            strFormFieldID: rowsData[i][p + 1]["columns"][o]["id"].toString(),
                                                            strFormFieldNarrativeID: formFieldPreValues[rowsData[i][p + 1]["columns"][o]["id"].toString()],
                                                            strData: selectedData.value,
                                                          );
                                                          await checkForm(doSave: false, fieldId: rowsData[i][p + 1]["columns"][o]["id"].toString());
                                                          await updateFieldValues();
                                                          update();
                                                          EasyLoading.dismiss();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                    break;
                }
              }
              tableWidgets1.add(
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    color:
                        rowsData[i][m + 1]["formRowBgColor"] != ""
                            ? rowsData[i][m + 1]["formRowBgColor"].toString().length == 4
                                ? hexToColor("${rowsData[i][m + 1]["formRowBgColor"]}000")
                                : hexToColor(rowsData[i][m + 1]["formRowBgColor"])
                            : ThemeColorMode.isDark
                            ? Colors.grey[900]
                            : Colors.white,
                  ),
                  children: tableRowWidgets,
                ),
              );
              m++;
            }

            while (n < rowsData[i].length) {
              var tableRowWidgets = <Widget>[];
              for (var o = 0; o < rowsData[i][n]["columns"].length; o++) {
                switch (rowsData[i][n]["columns"][o]["formFieldType"] as int) {
                  case 10: //"SPACER":
                    break;
                  case 52: //"HEADER CENTERED (GREEN)":
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormWidgets.headerCenteredGreen(
                          showField: showField[rowsData[i][n]["columns"][o]["id"].toString()],
                          hidden: rowsData[i][n]["columns"][o]["columnHidden"],
                          name: rowsData[i][n]["columns"][o]["formFieldName"],
                          acronymTitle: rowsData[i][n]["columns"][o]["acronymTitle"],
                          multiple: false,
                        ),
                      ),
                    );
                    break;
                  case 1: //"TEXT FIELD (STANDARD)":
                    var p = n;
                    tableRowWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FormTextField(
                          fieldType: "textFieldStandard",
                          id: rowsData[i][p]["columns"][o]["id"],
                          rowColor: rowsData[i][p]["formRowBgColor"],
                          name: rowsData[i][p]["columns"][o]["formFieldName"],
                          req: rowsData[i][p]["columns"][o]["formFieldRequired"],
                          acronymTitle: rowsData[i][p]["columns"][o]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][p]["columns"][o]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][p]["columns"][o]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][p]["columns"][o]["id"].toString(), () => FocusNode()),
                          numberOnly: property[rowsData[i][p]["columns"][o]["id"].toString()]?["numberOnly"],
                          defaultValue: rowsData[i][p]["columns"][o]["defaultValue"],
                          disableUserEditing: property[rowsData[i][p]["columns"][o]["id"].toString()]?["disabled"] ?? rowsData[i][p]["columns"][o]["readOnlyDisabled"],
                          hidden: rowsData[i][p]["columns"][o]["columnHidden"],
                          maxSize: rowsData[i][p]["columns"][o]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][p]["columns"][o]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][p]["columns"][o]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][p]["columns"][o]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][p]["columns"][o]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][p]["columns"][o]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][p]["columns"][o]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][p]["columns"].length > o + 1) {
                              fillOutFocusNodes[rowsData[i][p]["columns"][o + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][p]["columns"][o + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][p]["columns"][o]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > p + 1) {
                              fillOutFocusNodes[rowsData[i][p + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][p + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][p]["columns"][o]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][p]["columns"][o]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    );
                    break;
                }
              }
              tableWidgets2.add(
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    color:
                        rowsData[i][n]["formRowBgColor"] != ""
                            ? rowsData[i][n]["formRowBgColor"].toString().length == 4
                                ? hexToColor("${rowsData[i][n]["formRowBgColor"]}000")
                                : hexToColor(rowsData[i][n]["formRowBgColor"])
                            : ThemeColorMode.isDark
                            ? Colors.grey[900]
                            : Colors.white,
                  ),
                  children: tableRowWidgets,
                ),
              );
              n++;
            }

            widgetsForEachRow.add(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: FixedColumnWidth(
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 4.1)
                              : (Get.width / 4.16)
                          : (Get.width / 2.3),
                    ),
                    children: tableWidgets1,
                  ),
                ),
              ),
            );
            widgetsForEachRow.add(FormWidgets.newLine(hidden: false));
            widgetsForEachRow.add(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: FixedColumnWidth(
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3.07)
                              : (Get.width / 3.12)
                          : (Get.width / 2.3),
                    ),
                    children: tableWidgets2,
                  ),
                ),
              ),
            );
        }
        break;
      case "90": //Hillsborough County Sheriffs Aviation(3)_Weekly Fuel Farm Inspection(90)
      case "297": //LEE County Sheriff(48)_Fuel Farm Inspection(297)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];

        for (l; l < rowsData[i].length && rowsData[i][l]["columns"].length > 1; l++) {
          for (var id in rowsData[i][l]["columns"]) {
            createdFields.addIf(!createdFields.contains(id["id"].toString()), id["id"].toString());
          }
          for (var n = 0; n < rowsData[i][l]["columns"].length; n++) {
            switch (rowsData[i][l]["columns"][n]["formFieldType"] as int) {
              case 50: //"HEADER CENTERED (BLUE)":
                columnWidgets1.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredBlue(
                      showField: showField[rowsData[i][l]["columns"][n]["id"].toString()],
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 54: //"HEADER CENTERED (ORANGE)":
                columnWidgets2.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredOrange(
                      showField: showField[rowsData[i][l]["columns"][n]["id"].toString()],
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 10: //"SPACER":
                break;
              case 1: //"TEXT FIELD (STANDARD)":
                var m = l;
                n == 0
                    ? columnWidgets1.add(
                      FormTextField(
                        fieldType: "textFieldStandard",
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        name: rowsData[i][m]["columns"][n]["formFieldName"],
                        req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                        showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                        acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                        previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                        focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                        numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                        defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                        disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                        onTap: () {
                          switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                            case "0":
                            case "0.0":
                            case "0.00":
                            case "0.000":
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                          }
                        },
                        onChanged: (val) {
                          if (val != '') {
                            values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                          } else {
                            values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                          }
                          checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                        },
                        onEditingComplete: () async {
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          await updateFieldValues();
                          update();
                          if (rowsData[i][m]["columns"].length > n + 1) {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else if (rowsData[i].length > m + 1) {
                            fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          }
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      FormTextField(
                        fieldType: "textFieldStandard",
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        name: rowsData[i][m]["columns"][n]["formFieldName"],
                        req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                        showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                        acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                        previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                        focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                        numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                        defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                        disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                        onTap: () {
                          switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                            case "0":
                            case "0.0":
                            case "0.00":
                            case "0.000":
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                          }
                        },
                        onChanged: (val) {
                          if (val != '') {
                            values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                          } else {
                            values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                          }
                          checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                        },
                        onEditingComplete: () async {
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          await updateFieldValues();
                          update();
                          if (rowsData[i][m]["columns"].length > n + 1) {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else if (rowsData[i].length > m + 1) {
                            fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          }
                        },
                      ),
                    );
                break;
              case 5: //"DATE (OTHER DATE)":
                var m = l;
                n == 0
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormDateTime(
                            fieldType: "dateOtherDate",
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            hintText: rowsData[i][m]["columns"][n]["placeHolder"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"] ?? false,
                            disableKeyboard: dateTimeDisableKeyboard.value,
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                              }
                            },
                            onChanged: (val) {
                              if (val != '') {
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                              } else {
                                values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                              }
                              checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            },
                            onConfirm: (date) async {
                              dateTimeDisableKeyboard.value = true;
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text = DateTimeHelper.dateFormatDefault.format(date);
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = DateTimeHelper.dateFormatDefault.format(date);
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                            onCancel: () {
                              dateTimeDisableKeyboard.value = false;
                              update();
                            },
                            onEditingComplete: () async {
                              if (isDate(date: values[rowsData[i][m]["columns"][n]["id"].toString()].toString()) == false &&
                                  values[rowsData[i][m]["columns"][n]["id"].toString()] != null &&
                                  values[rowsData[i][m]["columns"][n]["id"].toString()].toString() != '') {
                                SnackBarHelper.openSnackBar(
                                  isError: true,
                                  message: "This Date Appears Invalid!\nPlease Check Your Date and Ensure It is in mm/dd/yyyy Format or Blank.",
                                );
                                await Future.delayed(const Duration(milliseconds: 10), () {
                                  fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.requestFocus();
                                });
                              } else {
                                await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                                await updateFieldValues();
                                dateTimeDisableKeyboard.value = true;
                                update();
                                if (rowsData[i][m]["columns"].length > n + 1) {
                                  fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                      ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                      : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                                } else if (rowsData[i].length > m + 1) {
                                  fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                      ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                      : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                                } else {
                                  fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                                }
                              }
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormDateTime(
                            fieldType: "dateOtherDate",
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            hintText: rowsData[i][m]["columns"][n]["placeHolder"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"] ?? false,
                            disableKeyboard: dateTimeDisableKeyboard.value,
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                              }
                            },
                            onChanged: (val) {
                              if (val != '') {
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                              } else {
                                values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                              }
                              checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            },
                            onConfirm: (date) async {
                              dateTimeDisableKeyboard.value = true;
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text = DateTimeHelper.dateFormatDefault.format(date);
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = DateTimeHelper.dateFormatDefault.format(date);
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                            onCancel: () {
                              dateTimeDisableKeyboard.value = false;
                              update();
                            },
                            onEditingComplete: () async {
                              if (isDate(date: values[rowsData[i][m]["columns"][n]["id"].toString()].toString()) == false &&
                                  values[rowsData[i][m]["columns"][n]["id"].toString()] != null &&
                                  values[rowsData[i][m]["columns"][n]["id"].toString()].toString() != '') {
                                SnackBarHelper.openSnackBar(
                                  isError: true,
                                  message: "This Date Appears Invalid!\nPlease Check Your Date and Ensure It is in mm/dd/yyyy Format or Blank.",
                                );
                                await Future.delayed(const Duration(milliseconds: 10), () {
                                  fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.requestFocus();
                                });
                              } else {
                                await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                                await updateFieldValues();
                                dateTimeDisableKeyboard.value = true;
                                update();
                                if (rowsData[i][m]["columns"].length > n + 1) {
                                  fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                      ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                      : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                                } else if (rowsData[i].length > m + 1) {
                                  fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                      ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                      : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                                } else {
                                  fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                                }
                              }
                            },
                          );
                        },
                      ),
                    );
                break;
            }
          }
        }

        widgetsForEachRow.add(Column(children: columnWidgets1));
        widgetsForEachRow.add(Column(children: columnWidgets2));
        break;
      case "888": //MARTIN COUNTY SHERIFF(118)_Flight Activity Form(888)
        if (rowsData[i][j]["columns"].length == 3) {
          for (var id in rowsData[i][j]["columns"]) {
            createdFields.addIf(!createdFields.contains(id["id"].toString()), id["id"].toString());
          }

          widgetsForEachRow.addIf(
            k == 1,
            SizedBox(
              width:
                  Get.width > 480
                      ? Get.width > 980
                          ? (Get.width / 3) - ((12 / 3) * 9)
                          : (Get.width / 2) - ((12 / 2) * 8)
                      : Get.width - 5,
              child: FormWidgets.headerCenteredBlue(
                showField: showField[rowsData[i][j]["columns"][1]["id"].toString()],
                hidden: rowsData[i][j]["columns"][1]["columnHidden"],
                name: rowsData[i][j]["columns"][1]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][1]["acronymTitle"],
                multiple: false,
              ),
            ),
          );
          widgetsForEachRow.addIf(
            k == 2,
            SizedBox(
              width:
                  Get.width > 480
                      ? Get.width > 980
                          ? (Get.width / 3) - ((12 / 3) * 9)
                          : (Get.width / 2) - ((12 / 2) * 8)
                      : Get.width - 5,
              child: FormWidgets.headerCenteredBlue(
                showField: showField[rowsData[i][j]["columns"][2]["id"].toString()],
                hidden: rowsData[i][j]["columns"][2]["columnHidden"],
                name: rowsData[i][j]["columns"][2]["formFieldName"],
                acronymTitle: rowsData[i][j]["columns"][2]["acronymTitle"],
                multiple: false,
              ),
            ),
          );
        }
        break;
      case "412": //Orange County Sheriffs Office(53)_TFO Trainee Daily Observation Report(412)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];
        var columnWidgets3 = <Widget>[];

        for (l; l < rowsData[i].length && (l != j ? rowsData[i][j]["columns"][0]["formFieldType"] != rowsData[i][l]["columns"][0]["formFieldType"] : true); l++) {
          createdFields.addIf(!createdFields.contains(rowsData[i][l]["columns"][k]["id"].toString()), rowsData[i][l]["columns"][k]["id"].toString());
          switch (rowsData[i][l]["columns"][k]["formFieldType"] as int) {
            case 50: //"HEADER CENTERED (BLUE)":
              columnWidgets1.addIf(
                k == 0,
                SizedBox(
                  width:
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3) - ((12 / 3) * 9)
                              : (Get.width / 2) - ((12 / 2) * 8)
                          : Get.width - 5,
                  child: FormWidgets.headerCenteredBlue(
                    showField: showField[rowsData[i][l]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][l]["columns"][k]["columnHidden"],
                    name: rowsData[i][l]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][l]["columns"][k]["acronymTitle"],
                    multiple: false,
                  ),
                ),
              );
              columnWidgets2.addIf(
                k == 1,
                SizedBox(
                  width:
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3) - ((12 / 3) * 9)
                              : (Get.width / 2) - ((12 / 2) * 8)
                          : Get.width - 5,
                  child: FormWidgets.headerCenteredBlue(
                    showField: showField[rowsData[i][l]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][l]["columns"][k]["columnHidden"],
                    name: rowsData[i][l]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][l]["columns"][k]["acronymTitle"],
                    multiple: false,
                  ),
                ),
              );
              columnWidgets3.addIf(
                k == 2,
                SizedBox(
                  width:
                      Get.width > 480
                          ? Get.width > 980
                              ? (Get.width / 3) - ((12 / 3) * 9)
                              : (Get.width / 2) - ((12 / 2) * 8)
                          : Get.width - 5,
                  child: FormWidgets.headerCenteredBlue(
                    showField: showField[rowsData[i][l]["columns"][k]["id"].toString()],
                    hidden: rowsData[i][l]["columns"][k]["columnHidden"],
                    name: rowsData[i][l]["columns"][k]["formFieldName"],
                    acronymTitle: rowsData[i][l]["columns"][k]["acronymTitle"],
                    multiple: false,
                  ),
                ),
              );
              break;
            case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
              var m = l;
              columnWidgets1.addIf(
                k == 0,
                GetBuilder<FillOutFormLogic>(
                  init: FillOutFormLogic(),
                  builder: (controller) {
                    return FormWidgets.dropDownViaServiceTableValues(
                      id: rowsData[i][m]["columns"][k]["id"],
                      rowColor: rowsData[i][m]["formRowBgColor"],
                      name:
                          rowsData[i][m]["columns"][k]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                              ? "COMPLETED"
                              : rowsData[i][m]["columns"][k]["formFieldName"],
                      dropDownData: rowsData[i][m]["columns"][k]["elementData"],
                      searchDataList: addChoiceServiceTableData,
                      key: rowsData[i][m]["columns"][k]["key"] ?? "name",
                      specificDataType: rowsData[i][m]["columns"][k]["serviceTableName"],
                      addChoices: rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"],
                      selectMultiple: rowsData[i][m]["columns"][k]["formFieldStSelectMany"],
                      req: rowsData[i][m]["columns"][k]["formFieldRequired"],
                      showField: showField[rowsData[i][m]["columns"][k]["id"].toString()],
                      acronymTitle:
                          rowsData[i][m]["columns"][k]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                              ? "COMPLETED"
                              : rowsData[i][m]["columns"][k]["acronymTitle"],
                      previousValue:
                          rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]
                              ? formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()]
                              : rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                              ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : dropDownFieldValues[rowsData[i][m]["columns"][k]["id"].toString()],
                      selectedValue:
                          rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                              ? selectedDropDown[rowsData[i][m]["columns"][k]["id"]] ?? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : selectedDropDown[rowsData[i][m]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][k]["id"].toString()],
                      controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][k]["id"].toString(), () => TextEditingController()),
                      focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][k]["id"].toString(), () => FocusNode()),
                      defaultValue: rowsData[i][m]["columns"][k]["defaultValue"],
                      hintText: rowsData[i][m]["columns"][k]["placeHolder"] ?? "",
                      disableUserEditing: property[rowsData[i][m]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][k]["readOnlyDisabled"],
                      hidden: rowsData[i][m]["columns"][k]["columnHidden"] ?? "",
                      maxSize: rowsData[i][m]["columns"][k]["formMaxLength"],
                      onTap: () {
                        switch (fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text) {
                          case "0":
                          case "0.0":
                          case "0.00":
                          case "0.000":
                            fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.clear();
                        }
                      },
                      onChanged: (val) async {
                        if (rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]) {
                          if (val != '') {
                            LoaderHelper.loaderWithGif();
                            values[rowsData[i][m]["columns"][k]["id"].toString()] = val;
                            await searchFormFieldValues(
                              strFormFieldType: rowsData[i][m]["columns"][k]["serviceTableName"],
                              strValue: val,
                              liveSearchID: rowsData[i][m]["columns"][k]["id"].toString(),
                            );
                            update();
                            EasyLoading.dismiss();
                          } else {
                            values.remove(rowsData[i][m]["columns"][k]["id"].toString());
                            addChoiceServiceTableData[rowsData[i][m]["columns"][k]["id"].toString()] = [];
                          }
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        } else {
                          selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][k]["id"], val[rowsData[i][m]["columns"][k]["key"] ?? "name"]);
                          values[rowsData[i][m]["columns"][k]["id"].toString()] = val["id"];
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                          await updateFieldValues();
                          update();
                        }
                      },
                      onEditingComplete: () async {
                        LoaderHelper.loaderWithGif();
                        addChoiceServiceTableData[rowsData[i][m]["columns"][k]["id"].toString()] = [];
                        await setChoiceFromSearch(
                          strFieldId: rowsData[i][m]["columns"][k]["id"].toString(),
                          strValue: fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text,
                          requestToAdd: fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text != "" ? "1" : "0",
                          serviceTableToAddTo: rowsData[i][m]["columns"][k]["serviceTableName"],
                        );
                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        await updateFieldValues();
                        update();
                        EasyLoading.dismiss();
                        if (rowsData[i][m]["columns"].length > k + 1) {
                          fillOutFocusNodes[rowsData[i][m]["columns"][k + 1]["id"].toString()] != null
                              ? fillOutFocusNodes[rowsData[i][m]["columns"][k + 1]["id"].toString()]?.requestFocus()
                              : fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        } else if (rowsData[i].length > m + 1) {
                          fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                              ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                              : fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        } else {
                          fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        }
                      },
                      onSelect: (val, requestToAdd) async {
                        fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text = val;
                        Keyboard.close();
                        await setChoiceFromSearch(
                          strFieldId: rowsData[i][m]["columns"][k]["id"].toString(),
                          strValue: val,
                          requestToAdd: requestToAdd,
                          serviceTableToAddTo: rowsData[i][m]["columns"][k]["serviceTableName"],
                        );
                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        await updateFieldValues();
                        update();
                      },
                      onDialogPopUp: () async {
                        LoaderHelper.loaderWithGif();
                        await loadExtendedField(
                          strFieldID: rowsData[i][m]["columns"][k]["id"].toString(),
                          strNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()],
                          strFieldTypeID: rowsData[i][m]["columns"][k]["formFieldType"].toString(),
                        );
                        EasyLoading.dismiss();

                        var selectedData = "".obs;
                        var selectedDataList = [].obs;
                        var selectAllCheckBox = false.obs;
                        var checkBoxStatus = [].obs;

                        if (loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()] != null) {
                          for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                            if (extendedFieldsValue[rowsData[i][n]["columns"][k]["id"].toString()] != null) {
                              if (extendedFieldsValue[rowsData[i][n]["columns"][k]["id"].toString()]!.contains(
                                loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"],
                              )) {
                                selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                checkBoxStatus.add(true);
                              } else {
                                checkBoxStatus.add(false);
                                selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                              }
                            } else {
                              checkBoxStatus.add(false);
                            }
                          }
                        }
                        update();
                        showDialog(
                          useSafeArea: true,
                          useRootNavigator: false,
                          barrierDismissible: true,
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return ResponsiveBuilder(
                              builder: (context, sizingInformation) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Dialog(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                      side: const BorderSide(color: ColorConstants.primary, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              InkWell(
                                                child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                onTap: () {
                                                  selectAllCheckBox.value = !selectAllCheckBox.value;
                                                  checkBoxStatus.clear();
                                                  selectedDataList.clear();
                                                  for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                                                    checkBoxStatus.add(selectAllCheckBox.value);
                                                    if (selectAllCheckBox.value == true) {
                                                      selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                                    } else {
                                                      selectedDataList.clear();
                                                    }
                                                  }
                                                },
                                              ),
                                              Obx(() {
                                                return IconButton(
                                                  icon: Icon(
                                                    selectAllCheckBox.value == false ? Icons.select_all : Icons.deselect,
                                                    size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                  ),
                                                  color:
                                                      selectAllCheckBox.value == false
                                                          ? ColorConstants.grey
                                                          : ThemeColorMode.isDark
                                                          ? ColorConstants.white
                                                          : ColorConstants.black,
                                                  onPressed: () {
                                                    selectAllCheckBox.value = !selectAllCheckBox.value;
                                                    checkBoxStatus.clear();
                                                    selectedDataList.clear();
                                                    for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                                                      checkBoxStatus.add(selectAllCheckBox.value);
                                                      if (selectAllCheckBox.value == true) {
                                                        selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                                      } else {
                                                        selectedDataList.clear();
                                                      }
                                                    }
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]!.length,
                                                    itemBuilder: (context, l) {
                                                      return Obx(() {
                                                        return CheckboxListTile(
                                                          activeColor: ColorConstants.primary,
                                                          side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                          value: checkBoxStatus[l],
                                                          dense: true,
                                                          title: Text(
                                                            loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"],
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w400,
                                                              color: selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                              letterSpacing: 0.5,
                                                            ),
                                                          ),
                                                          selected: checkBoxStatus[l],
                                                          onChanged: (val) async {
                                                            checkBoxStatus[l] = val!;
                                                            if (val == true) {
                                                              selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"]);
                                                            } else {
                                                              selectedDataList.removeWhere((item) {
                                                                return item == loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"];
                                                              });
                                                              selectAllCheckBox.value = false;
                                                            }
                                                          },
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: SizeConstants.rootContainerSpacing),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ButtonConstant.dialogButton(
                                                title: "Cancel",
                                                borderColor: ColorConstants.red,
                                                onTapMethod: () {
                                                  Get.back();
                                                },
                                              ),
                                              const SizedBox(width: SizeConstants.contentSpacing),
                                              ButtonConstant.dialogButton(
                                                title: "Save & Close",
                                                btnColor: ColorConstants.primary,
                                                onTapMethod: () async {
                                                  LoaderHelper.loaderWithGif();

                                                  selectedData.value = "";
                                                  for (int n = 0; n < selectedDataList.length; n++) {
                                                    if (n + 1 == selectedDataList.length) {
                                                      selectedData.value += "${selectedDataList[n]}";
                                                    } else {
                                                      selectedData.value += "${selectedDataList[n]}^^^#";
                                                    }
                                                  }
                                                  Get.back();
                                                  selectedDropDown.addIf(true, rowsData[i][m]["columns"][k]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                                  await saveSelectMultipleFinal(
                                                    strFormFieldID: rowsData[i][m]["columns"][k]["id"].toString(),
                                                    strFormFieldNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()],
                                                    strData: selectedData.value,
                                                  );
                                                  await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                                                  await updateFieldValues();
                                                  update();
                                                  EasyLoading.dismiss();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
              columnWidgets2.addIf(
                k == 1,
                GetBuilder<FillOutFormLogic>(
                  init: FillOutFormLogic(),
                  builder: (controller) {
                    return FormWidgets.dropDownViaServiceTableValues(
                      id: rowsData[i][m]["columns"][k]["id"],
                      rowColor: rowsData[i][m]["formRowBgColor"],
                      name:
                          rowsData[i][m]["columns"][k]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                              ? "COMPLETED"
                              : rowsData[i][m]["columns"][k]["formFieldName"],
                      dropDownData: rowsData[i][m]["columns"][k]["elementData"],
                      searchDataList: addChoiceServiceTableData,
                      key: rowsData[i][m]["columns"][k]["key"] ?? "name",
                      specificDataType: rowsData[i][m]["columns"][k]["serviceTableName"],
                      addChoices: rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"],
                      selectMultiple: rowsData[i][m]["columns"][k]["formFieldStSelectMany"],
                      req: rowsData[i][m]["columns"][k]["formFieldRequired"],
                      showField: showField[rowsData[i][m]["columns"][k]["id"].toString()],
                      acronymTitle:
                          rowsData[i][m]["columns"][k]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                              ? "COMPLETED"
                              : rowsData[i][m]["columns"][k]["acronymTitle"],
                      previousValue:
                          rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]
                              ? formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()]
                              : rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                              ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : dropDownFieldValues[rowsData[i][m]["columns"][k]["id"].toString()],
                      selectedValue:
                          rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                              ? selectedDropDown[rowsData[i][m]["columns"][k]["id"]] ?? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : selectedDropDown[rowsData[i][m]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][k]["id"].toString()],
                      controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][k]["id"].toString(), () => TextEditingController()),
                      focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][k]["id"].toString(), () => FocusNode()),
                      defaultValue: rowsData[i][m]["columns"][k]["defaultValue"],
                      hintText: rowsData[i][m]["columns"][k]["placeHolder"] ?? "",
                      disableUserEditing: property[rowsData[i][m]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][k]["readOnlyDisabled"],
                      hidden: rowsData[i][m]["columns"][k]["columnHidden"],
                      maxSize: rowsData[i][m]["columns"][k]["formMaxLength"],
                      onTap: () {
                        switch (fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text) {
                          case "0":
                          case "0.0":
                          case "0.00":
                          case "0.000":
                            fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.clear();
                        }
                      },
                      onChanged: (val) async {
                        if (rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]) {
                          if (val != '') {
                            LoaderHelper.loaderWithGif();
                            values[rowsData[i][m]["columns"][k]["id"].toString()] = val;
                            await searchFormFieldValues(
                              strFormFieldType: rowsData[i][m]["columns"][k]["serviceTableName"],
                              strValue: val,
                              liveSearchID: rowsData[i][m]["columns"][k]["id"].toString(),
                            );
                            update();
                            EasyLoading.dismiss();
                          } else {
                            values.remove(rowsData[i][m]["columns"][k]["id"].toString());
                            addChoiceServiceTableData[rowsData[i][m]["columns"][k]["id"].toString()] = [];
                          }
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        } else {
                          selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][k]["id"], val[rowsData[i][m]["columns"][k]["key"] ?? "name"]);
                          values[rowsData[i][m]["columns"][k]["id"].toString()] = val["id"];
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                          await updateFieldValues();
                          update();
                        }
                      },
                      onEditingComplete: () async {
                        LoaderHelper.loaderWithGif();
                        addChoiceServiceTableData[rowsData[i][m]["columns"][k]["id"].toString()] = [];
                        await setChoiceFromSearch(
                          strFieldId: rowsData[i][m]["columns"][k]["id"].toString(),
                          strValue: fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text,
                          requestToAdd: fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text != "" ? "1" : "0",
                          serviceTableToAddTo: rowsData[i][m]["columns"][k]["serviceTableName"],
                        );
                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        await updateFieldValues();
                        update();
                        EasyLoading.dismiss();
                        if (rowsData[i][m]["columns"].length > k + 1) {
                          fillOutFocusNodes[rowsData[i][m]["columns"][k + 1]["id"].toString()] != null
                              ? fillOutFocusNodes[rowsData[i][m]["columns"][k + 1]["id"].toString()]?.requestFocus()
                              : fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        } else if (rowsData[i].length > m + 1) {
                          fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                              ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                              : fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        } else {
                          fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        }
                      },
                      onSelect: (val, requestToAdd) async {
                        fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text = val;
                        Keyboard.close();
                        await setChoiceFromSearch(
                          strFieldId: rowsData[i][m]["columns"][k]["id"].toString(),
                          strValue: val,
                          requestToAdd: requestToAdd,
                          serviceTableToAddTo: rowsData[i][m]["columns"][k]["serviceTableName"],
                        );
                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        await updateFieldValues();
                        update();
                      },
                      onDialogPopUp: () async {
                        LoaderHelper.loaderWithGif();
                        await loadExtendedField(
                          strFieldID: rowsData[i][m]["columns"][k]["id"].toString(),
                          strNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()],
                          strFieldTypeID: rowsData[i][m]["columns"][k]["formFieldType"].toString(),
                        );
                        EasyLoading.dismiss();

                        var selectedData = "".obs;
                        var selectedDataList = [].obs;
                        var selectAllCheckBox = false.obs;
                        var checkBoxStatus = [].obs;

                        if (loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()] != null) {
                          for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                            if (extendedFieldsValue[rowsData[i][n]["columns"][k]["id"].toString()] != null) {
                              if (extendedFieldsValue[rowsData[i][n]["columns"][k]["id"].toString()]!.contains(
                                loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"],
                              )) {
                                selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                checkBoxStatus.add(true);
                              } else {
                                checkBoxStatus.add(false);
                                selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                              }
                            } else {
                              checkBoxStatus.add(false);
                            }
                          }
                        }
                        update();
                        showDialog(
                          useSafeArea: true,
                          useRootNavigator: false,
                          barrierDismissible: true,
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return ResponsiveBuilder(
                              builder: (context, sizingInformation) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Dialog(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                      side: const BorderSide(color: ColorConstants.primary, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              InkWell(
                                                child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                onTap: () {
                                                  selectAllCheckBox.value = !selectAllCheckBox.value;
                                                  checkBoxStatus.clear();
                                                  selectedDataList.clear();
                                                  for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                                                    checkBoxStatus.add(selectAllCheckBox.value);
                                                    if (selectAllCheckBox.value == true) {
                                                      selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                                    } else {
                                                      selectedDataList.clear();
                                                    }
                                                  }
                                                },
                                              ),
                                              Obx(() {
                                                return IconButton(
                                                  icon: Icon(
                                                    selectAllCheckBox.value == false ? Icons.select_all : Icons.deselect,
                                                    size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                  ),
                                                  color:
                                                      selectAllCheckBox.value == false
                                                          ? ColorConstants.grey
                                                          : ThemeColorMode.isDark
                                                          ? ColorConstants.white
                                                          : ColorConstants.black,
                                                  onPressed: () {
                                                    selectAllCheckBox.value = !selectAllCheckBox.value;
                                                    checkBoxStatus.clear();
                                                    selectedDataList.clear();
                                                    for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                                                      checkBoxStatus.add(selectAllCheckBox.value);
                                                      if (selectAllCheckBox.value == true) {
                                                        selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                                      } else {
                                                        selectedDataList.clear();
                                                      }
                                                    }
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]!.length,
                                                    itemBuilder: (context, l) {
                                                      return Obx(() {
                                                        return CheckboxListTile(
                                                          activeColor: ColorConstants.primary,
                                                          side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                          value: checkBoxStatus[l],
                                                          dense: true,
                                                          title: Text(
                                                            loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"],
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w400,
                                                              color: selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                              letterSpacing: 0.5,
                                                            ),
                                                          ),
                                                          selected: checkBoxStatus[l],
                                                          onChanged: (val) async {
                                                            checkBoxStatus[l] = val!;
                                                            if (val == true) {
                                                              selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"]);
                                                            } else {
                                                              selectedDataList.removeWhere((item) {
                                                                return item == loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"];
                                                              });
                                                              selectAllCheckBox.value = false;
                                                            }
                                                          },
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: SizeConstants.rootContainerSpacing),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ButtonConstant.dialogButton(
                                                title: "Cancel",
                                                borderColor: ColorConstants.red,
                                                onTapMethod: () {
                                                  Get.back();
                                                },
                                              ),
                                              const SizedBox(width: SizeConstants.contentSpacing),
                                              ButtonConstant.dialogButton(
                                                title: "Save & Close",
                                                btnColor: ColorConstants.primary,
                                                onTapMethod: () async {
                                                  LoaderHelper.loaderWithGif();

                                                  selectedData.value = "";
                                                  for (int n = 0; n < selectedDataList.length; n++) {
                                                    if (n + 1 == selectedDataList.length) {
                                                      selectedData.value += "${selectedDataList[n]}";
                                                    } else {
                                                      selectedData.value += "${selectedDataList[n]}^^^#";
                                                    }
                                                  }
                                                  Get.back();
                                                  selectedDropDown.addIf(true, rowsData[i][m]["columns"][k]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                                  await saveSelectMultipleFinal(
                                                    strFormFieldID: rowsData[i][m]["columns"][k]["id"].toString(),
                                                    strFormFieldNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()],
                                                    strData: selectedData.value,
                                                  );
                                                  await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                                                  await updateFieldValues();
                                                  update();
                                                  EasyLoading.dismiss();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
              columnWidgets3.addIf(
                k == 2,
                GetBuilder<FillOutFormLogic>(
                  init: FillOutFormLogic(),
                  builder: (controller) {
                    return FormWidgets.dropDownViaServiceTableValues(
                      id: rowsData[i][m]["columns"][k]["id"],
                      rowColor: rowsData[i][m]["formRowBgColor"],
                      name:
                          rowsData[i][m]["columns"][k]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                              ? "COMPLETED"
                              : rowsData[i][m]["columns"][k]["formFieldName"],
                      dropDownData: rowsData[i][m]["columns"][k]["elementData"],
                      searchDataList: addChoiceServiceTableData,
                      key: rowsData[i][m]["columns"][k]["key"] ?? "name",
                      specificDataType: rowsData[i][m]["columns"][k]["serviceTableName"],
                      addChoices: rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"],
                      selectMultiple: rowsData[i][m]["columns"][k]["formFieldStSelectMany"],
                      req: rowsData[i][m]["columns"][k]["formFieldRequired"],
                      showField: showField[rowsData[i][m]["columns"][k]["id"].toString()],
                      acronymTitle:
                          rowsData[i][m]["columns"][k]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                              ? "COMPLETED"
                              : rowsData[i][m]["columns"][k]["acronymTitle"],
                      previousValue:
                          rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]
                              ? formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()]
                              : rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                              ? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : dropDownFieldValues[rowsData[i][m]["columns"][k]["id"].toString()],
                      selectedValue:
                          rowsData[i][m]["columns"][k]["formFieldStSelectMany"]
                              ? selectedDropDown[rowsData[i][m]["columns"][k]["id"]] ?? extendedFieldsValue[rowsData[i][m]["columns"][k]["id"].toString()]?.replaceAll("^^^#", ", ")
                              : selectedDropDown[rowsData[i][m]["columns"][k]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][k]["id"].toString()],
                      controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][k]["id"].toString(), () => TextEditingController()),
                      focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][k]["id"].toString(), () => FocusNode()),
                      defaultValue: rowsData[i][m]["columns"][k]["defaultValue"],
                      hintText: rowsData[i][m]["columns"][k]["placeHolder"] ?? "",
                      disableUserEditing: property[rowsData[i][m]["columns"][k]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][k]["readOnlyDisabled"],
                      hidden: rowsData[i][m]["columns"][k]["columnHidden"],
                      maxSize: rowsData[i][m]["columns"][k]["formMaxLength"],
                      onTap: () {
                        switch (fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text) {
                          case "0":
                          case "0.0":
                          case "0.00":
                          case "0.000":
                            fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.clear();
                        }
                      },
                      onChanged: (val) async {
                        if (rowsData[i][m]["columns"][k]["formFieldAbilityToAdd"]) {
                          if (val != '') {
                            LoaderHelper.loaderWithGif();
                            values[rowsData[i][m]["columns"][k]["id"].toString()] = val;
                            await searchFormFieldValues(
                              strFormFieldType: rowsData[i][m]["columns"][k]["serviceTableName"],
                              strValue: val,
                              liveSearchID: rowsData[i][m]["columns"][k]["id"].toString(),
                            );
                            update();
                            EasyLoading.dismiss();
                          } else {
                            values.remove(rowsData[i][m]["columns"][k]["id"].toString());
                            addChoiceServiceTableData[rowsData[i][m]["columns"][k]["id"].toString()] = [];
                          }
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        } else {
                          selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][k]["id"], val[rowsData[i][m]["columns"][k]["key"] ?? "name"]);
                          values[rowsData[i][m]["columns"][k]["id"].toString()] = val["id"];
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                          await updateFieldValues();
                          update();
                        }
                      },
                      onEditingComplete: () async {
                        LoaderHelper.loaderWithGif();
                        addChoiceServiceTableData[rowsData[i][m]["columns"][k]["id"].toString()] = [];
                        await setChoiceFromSearch(
                          strFieldId: rowsData[i][m]["columns"][k]["id"].toString(),
                          strValue: fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text,
                          requestToAdd: fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text != "" ? "1" : "0",
                          serviceTableToAddTo: rowsData[i][m]["columns"][k]["serviceTableName"],
                        );
                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        await updateFieldValues();
                        update();
                        EasyLoading.dismiss();
                        if (rowsData[i][m]["columns"].length > k + 1) {
                          fillOutFocusNodes[rowsData[i][m]["columns"][k + 1]["id"].toString()] != null
                              ? fillOutFocusNodes[rowsData[i][m]["columns"][k + 1]["id"].toString()]?.requestFocus()
                              : fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        } else if (rowsData[i].length > m + 1) {
                          fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                              ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                              : fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        } else {
                          fillOutFocusNodes[rowsData[i][m]["columns"][k]["id"].toString()]?.nextFocus();
                        }
                      },
                      onSelect: (val, requestToAdd) async {
                        fillOutInputControllers[rowsData[i][m]["columns"][k]["id"].toString()]?.text = val;
                        Keyboard.close();
                        await setChoiceFromSearch(
                          strFieldId: rowsData[i][m]["columns"][k]["id"].toString(),
                          strValue: val,
                          requestToAdd: requestToAdd,
                          serviceTableToAddTo: rowsData[i][m]["columns"][k]["serviceTableName"],
                        );
                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                        await updateFieldValues();
                        update();
                      },
                      onDialogPopUp: () async {
                        LoaderHelper.loaderWithGif();
                        await loadExtendedField(
                          strFieldID: rowsData[i][m]["columns"][k]["id"].toString(),
                          strNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()],
                          strFieldTypeID: rowsData[i][m]["columns"][k]["formFieldType"].toString(),
                        );
                        EasyLoading.dismiss();

                        var selectedData = "".obs;
                        var selectedDataList = [].obs;
                        var selectAllCheckBox = false.obs;
                        var checkBoxStatus = [].obs;

                        if (loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()] != null) {
                          for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                            if (extendedFieldsValue[rowsData[i][n]["columns"][k]["id"].toString()] != null) {
                              if (extendedFieldsValue[rowsData[i][n]["columns"][k]["id"].toString()]!.contains(
                                loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"],
                              )) {
                                selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                checkBoxStatus.add(true);
                              } else {
                                checkBoxStatus.add(false);
                                selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                              }
                            } else {
                              checkBoxStatus.add(false);
                            }
                          }
                        }
                        update();
                        showDialog(
                          useSafeArea: true,
                          useRootNavigator: false,
                          barrierDismissible: true,
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return ResponsiveBuilder(
                              builder: (context, sizingInformation) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Dialog(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                      side: const BorderSide(color: ColorConstants.primary, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              InkWell(
                                                child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                onTap: () {
                                                  selectAllCheckBox.value = !selectAllCheckBox.value;
                                                  checkBoxStatus.clear();
                                                  selectedDataList.clear();
                                                  for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                                                    checkBoxStatus.add(selectAllCheckBox.value);
                                                    if (selectAllCheckBox.value == true) {
                                                      selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                                    } else {
                                                      selectedDataList.clear();
                                                    }
                                                  }
                                                },
                                              ),
                                              Obx(() {
                                                return IconButton(
                                                  icon: Icon(
                                                    selectAllCheckBox.value == false ? Icons.select_all : Icons.deselect,
                                                    size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                  ),
                                                  color:
                                                      selectAllCheckBox.value == false
                                                          ? ColorConstants.grey
                                                          : ThemeColorMode.isDark
                                                          ? ColorConstants.white
                                                          : ColorConstants.black,
                                                  onPressed: () {
                                                    selectAllCheckBox.value = !selectAllCheckBox.value;
                                                    checkBoxStatus.clear();
                                                    selectedDataList.clear();
                                                    for (int n = 0; n < loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]!.length; n++) {
                                                      checkBoxStatus.add(selectAllCheckBox.value);
                                                      if (selectAllCheckBox.value == true) {
                                                        selectedDataList.add(loadExtendedFieldData[rowsData[i][n]["columns"][k]["id"].toString()]![n]["name"]);
                                                      } else {
                                                        selectedDataList.clear();
                                                      }
                                                    }
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]!.length,
                                                    itemBuilder: (context, l) {
                                                      return Obx(() {
                                                        return CheckboxListTile(
                                                          activeColor: ColorConstants.primary,
                                                          side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                          value: checkBoxStatus[l],
                                                          dense: true,
                                                          title: Text(
                                                            loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"],
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w400,
                                                              color: selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                              letterSpacing: 0.5,
                                                            ),
                                                          ),
                                                          selected: checkBoxStatus[l],
                                                          onChanged: (val) async {
                                                            checkBoxStatus[l] = val!;
                                                            if (val == true) {
                                                              selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"]);
                                                            } else {
                                                              selectedDataList.removeWhere((item) {
                                                                return item == loadExtendedFieldData[rowsData[i][m]["columns"][k]["id"].toString()]![l]["name"];
                                                              });
                                                              selectAllCheckBox.value = false;
                                                            }
                                                          },
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: SizeConstants.rootContainerSpacing),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ButtonConstant.dialogButton(
                                                title: "Cancel",
                                                borderColor: ColorConstants.red,
                                                onTapMethod: () {
                                                  Get.back();
                                                },
                                              ),
                                              const SizedBox(width: SizeConstants.contentSpacing),
                                              ButtonConstant.dialogButton(
                                                title: "Save & Close",
                                                btnColor: ColorConstants.primary,
                                                onTapMethod: () async {
                                                  LoaderHelper.loaderWithGif();

                                                  selectedData.value = "";
                                                  for (int n = 0; n < selectedDataList.length; n++) {
                                                    if (n + 1 == selectedDataList.length) {
                                                      selectedData.value += "${selectedDataList[n]}";
                                                    } else {
                                                      selectedData.value += "${selectedDataList[n]}^^^#";
                                                    }
                                                  }
                                                  Get.back();
                                                  selectedDropDown.addIf(true, rowsData[i][m]["columns"][k]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                                  await saveSelectMultipleFinal(
                                                    strFormFieldID: rowsData[i][m]["columns"][k]["id"].toString(),
                                                    strFormFieldNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][k]["id"].toString()],
                                                    strData: selectedData.value,
                                                  );
                                                  await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][k]["id"].toString());
                                                  await updateFieldValues();
                                                  update();
                                                  EasyLoading.dismiss();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
              break;
          }
        }

        widgetsForEachRow.add(Column(children: columnWidgets1));
        widgetsForEachRow.add(Column(children: columnWidgets2));
        widgetsForEachRow.add(Column(children: columnWidgets3));
        break;
      case "77": //Miami Dade Fire Rescue(5)_Daily Cmdr or Pilot(77)
      case "79": //Miami Dade Fire Rescue(5)_OIC FM(79)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];

        for (
          l;
          l < rowsData[i].length &&
              !(rowsData[i][l]["columns"][k]["formFieldName"].toString().contains("Risk") || rowsData[i][l]["columns"][k]["formFieldName"].toString().contains("Daily"));
          l++
        ) {
          for (var n = 0; n < rowsData[i][l]["columns"].length; n++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][l]["columns"][n]["id"].toString()), rowsData[i][l]["columns"][n]["id"].toString());
            switch (rowsData[i][l]["columns"][n]["formFieldType"] as int) {
              case 10: //"SPACER":
                break;
              case 52: //"HEADER CENTERED (GREEN)":
                columnWidgets1.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredGreen(
                      showField: showField[rowsData[i][l]["columns"][n]["id"].toString()],
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 54: //"HEADER CENTERED (ORANGE)":
                columnWidgets2.add(
                  SizedBox(
                    width:
                        Get.width > 480
                            ? Get.width > 980
                                ? (Get.width / 3) - ((12 / 3) * 9)
                                : (Get.width / 2) - ((12 / 2) * 8)
                            : Get.width - 5,
                    child: FormWidgets.headerCenteredOrange(
                      showField: showField[rowsData[i][l]["columns"][n]["id"].toString()],
                      hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                      name: rowsData[i][l]["columns"][n]["formFieldName"],
                      acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                      multiple: false,
                    ),
                  ),
                );
                break;
              case 250: //"ACCESSORIES SELECTOR":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.accessoriesSelector(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            selectedValue: selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onChanged: (val) async {
                              selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                              if (rowsData[i][m]["columns"][n]["serviceTableName"] == "Fuel Farm") {
                                LoaderHelper.loaderWithGif();
                                await loadCurrentFuelFarmGallons(thisFuelFarmId: val["id"].toString());
                              }
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                              EasyLoading.dismiss();
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.accessoriesSelector(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            selectedValue: selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onChanged: (val) async {
                              selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                              if (rowsData[i][m]["columns"][n]["serviceTableName"] == "Fuel Farm") {
                                LoaderHelper.loaderWithGif();
                                await loadCurrentFuelFarmGallons(thisFuelFarmId: val["id"].toString());
                              }
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                              EasyLoading.dismiss();
                            },
                          );
                        },
                      ),
                    );
                break;
              case 4: //"DROP DOWN - ACCESSIBLE AIRCRAFT":
                var m = l;

                n == 0 || n == 1
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.dropDownAccessibleAircraft(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            selectedValue: selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onChanged: (val) async {
                              LoaderHelper.loaderWithGif();
                              selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(rowsData[i][m]["columns"][n]["id"].toString()) == false, rowsData[i][m]["columns"][n]["id"].toString());
                              await loadACData(id: val["id"]);
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                              EasyLoading.dismiss();
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.dropDownAccessibleAircraft(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            selectedValue: selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onChanged: (val) async {
                              LoaderHelper.loaderWithGif();
                              selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                              jsClass["sn"]?.addIf(jsClass["sn"]?.contains(rowsData[i][m]["columns"][n]["id"].toString()) == false, rowsData[i][m]["columns"][n]["id"].toString());
                              await loadACData(id: val["id"]);
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                              EasyLoading.dismiss();
                            },
                          );
                        },
                      ),
                    );

                break;
              case 8: //"AIRCRAFT FLT HOBBS (START)":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][m]["columns"][n]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              if (val != '') {
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][m]["columns"][n]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][m]["columns"][n]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }

                              await updateFieldValues();
                              if (rowsData[i][m]["columns"].length > n + 1) {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else if (rowsData[i].length > m + 1) {
                                fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              }
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.closeOutFieldsStart(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            fieldType: htmlValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                              }
                              updateFlightCalculations(strType: rowsData[i][m]["columns"][n]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onChanged: (val) {
                              if (val != '') {
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                              } else {
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = "0";
                              }
                              updateFlightCalculations(strType: rowsData[i][m]["columns"][n]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                            },
                            onEditingComplete: () async {
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              updateFlightCalculations(strType: rowsData[i][m]["columns"][n]["typeToCalculate"], strMode: 1);
                              if (fillOutFormAllData["systemId"] == 14) {
                                switch (rowsData[i][j]["columns"][k]["formFieldType"]) {
                                  case 8 || 16 || 55 || 9 || 17 || 56:
                                    changePICTime();
                                    break;
                                }
                              }
                              await updateFieldValues();
                              if (rowsData[i][m]["columns"].length > n + 1) {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else if (rowsData[i].length > m + 1) {
                                fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              }
                            },
                          );
                        },
                      ),
                    );
                break;
              case 1: //"TEXT FIELD (STANDARD)":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      FormTextField(
                        fieldType: "textFieldStandard",
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        name: rowsData[i][m]["columns"][n]["formFieldName"],
                        req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                        showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                        acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                        previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                        focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                        numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                        defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                        disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                        onTap: () {
                          switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                            case "0":
                            case "0.0":
                            case "0.00":
                            case "0.000":
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                          }
                        },
                        onChanged: (val) {
                          if (val != '') {
                            values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                          } else {
                            values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                          }
                          checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                        },
                        onEditingComplete: () async {
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          await updateFieldValues();
                          update();
                          if (rowsData[i][m]["columns"].length > n + 1) {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else if (rowsData[i].length > m + 1) {
                            fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          }
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      FormTextField(
                        fieldType: "textFieldStandard",
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        name: rowsData[i][m]["columns"][n]["formFieldName"],
                        req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                        showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                        acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                        previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                        focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                        numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                        defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                        disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                        onTap: () {
                          switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                            case "0":
                            case "0.0":
                            case "0.00":
                            case "0.000":
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                          }
                        },
                        onChanged: (val) {
                          if (val != '') {
                            values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                          } else {
                            values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                          }
                          checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                        },
                        onEditingComplete: () async {
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          await updateFieldValues();
                          update();
                          if (rowsData[i][m]["columns"].length > n + 1) {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else if (rowsData[i].length > m + 1) {
                            fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          }
                        },
                      ),
                    );
                break;
              case 199: //"DROP DOWN VIA SERVICE TABLE VALUES":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.dropDownViaServiceTableValues(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name:
                                rowsData[i][m]["columns"][n]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                                    ? "COMPLETED"
                                    : rowsData[i][m]["columns"][n]["formFieldName"],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            searchDataList: addChoiceServiceTableData,
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            specificDataType: rowsData[i][m]["columns"][n]["serviceTableName"],
                            addChoices: rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"],
                            selectMultiple: rowsData[i][m]["columns"][n]["formFieldStSelectMany"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle:
                                rowsData[i][m]["columns"][n]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                                    ? "COMPLETED"
                                    : rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue:
                                rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"]
                                    ? formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()]
                                    : rowsData[i][m]["columns"][n]["formFieldStSelectMany"]
                                    ? extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]?.replaceAll("^^^#", ", ")
                                    : dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            selectedValue:
                                rowsData[i][m]["columns"][n]["formFieldStSelectMany"]
                                    ? selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ??
                                        extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]?.replaceAll("^^^#", ", ")
                                    : selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            hintText: rowsData[i][m]["columns"][n]["placeHolder"] ?? "",
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                              }
                            },
                            onChanged: (val) async {
                              if (rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"]) {
                                if (val != '') {
                                  LoaderHelper.loaderWithGif();
                                  values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                                  await searchFormFieldValues(
                                    strFormFieldType: rowsData[i][m]["columns"][n]["serviceTableName"],
                                    strValue: val,
                                    liveSearchID: rowsData[i][m]["columns"][n]["id"].toString(),
                                  );
                                  update();
                                  EasyLoading.dismiss();
                                } else {
                                  values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                                  addChoiceServiceTableData[rowsData[i][m]["columns"][n]["id"].toString()] = [];
                                }
                                await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              } else {
                                selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                                await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                                await updateFieldValues();
                                update();
                              }
                            },
                            onEditingComplete: () async {
                              LoaderHelper.loaderWithGif();
                              addChoiceServiceTableData[rowsData[i][m]["columns"][n]["id"].toString()] = [];
                              await setChoiceFromSearch(
                                strFieldId: rowsData[i][m]["columns"][n]["id"].toString(),
                                strValue: fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text,
                                requestToAdd: fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text != "" ? "1" : "0",
                                serviceTableToAddTo: rowsData[i][m]["columns"][n]["serviceTableName"],
                              );
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                              EasyLoading.dismiss();
                              if (rowsData[i][m]["columns"].length > n + 1) {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else if (rowsData[i].length > m + 1) {
                                fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              }
                            },
                            onSelect: (val, requestToAdd) async {
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text = val;
                              Keyboard.close();
                              await setChoiceFromSearch(
                                strFieldId: rowsData[i][m]["columns"][n]["id"].toString(),
                                strValue: val,
                                requestToAdd: requestToAdd,
                                serviceTableToAddTo: rowsData[i][m]["columns"][n]["serviceTableName"],
                              );
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                            onDialogPopUp: () async {
                              LoaderHelper.loaderWithGif();
                              await loadExtendedField(
                                strFieldID: rowsData[i][m]["columns"][n]["id"].toString(),
                                strNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                                strFieldTypeID: rowsData[i][m]["columns"][n]["formFieldType"].toString(),
                              );
                              EasyLoading.dismiss();

                              var selectedData = "".obs;
                              var selectedDataList = [].obs;
                              var selectAllCheckBox = false.obs;
                              var checkBoxStatus = [].obs;

                              if (loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()] != null) {
                                for (int m = 0; m < loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length; m++) {
                                  if (extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()] != null) {
                                    if (extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]!.contains(
                                      loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"],
                                    )) {
                                      selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                      checkBoxStatus.add(true);
                                    } else {
                                      checkBoxStatus.add(false);
                                      selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                    }
                                  } else {
                                    checkBoxStatus.add(false);
                                  }
                                }
                              }
                              update();
                              showDialog(
                                useSafeArea: true,
                                useRootNavigator: false,
                                barrierDismissible: true,
                                context: Get.context!,
                                builder: (BuildContext context) {
                                  return ResponsiveBuilder(
                                    builder: (context, sizingInformation) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: Dialog(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                            side: const BorderSide(color: ColorConstants.primary, width: 2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                      onTap: () {
                                                        selectAllCheckBox.value = !selectAllCheckBox.value;
                                                        checkBoxStatus.clear();
                                                        selectedDataList.clear();
                                                        for (int m = 0; m < loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length; m++) {
                                                          checkBoxStatus.add(selectAllCheckBox.value);
                                                          if (selectAllCheckBox.value == true) {
                                                            selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                                          } else {
                                                            selectedDataList.clear();
                                                          }
                                                        }
                                                      },
                                                    ),
                                                    Obx(() {
                                                      return IconButton(
                                                        icon: Icon(
                                                          selectAllCheckBox.value == false ? Icons.select_all : Icons.deselect,
                                                          size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                        ),
                                                        color:
                                                            selectAllCheckBox.value == false
                                                                ? ColorConstants.grey
                                                                : ThemeColorMode.isDark
                                                                ? ColorConstants.white
                                                                : ColorConstants.black,
                                                        onPressed: () {
                                                          selectAllCheckBox.value = !selectAllCheckBox.value;
                                                          checkBoxStatus.clear();
                                                          selectedDataList.clear();
                                                          for (int m = 0; m < loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length; m++) {
                                                            checkBoxStatus.add(selectAllCheckBox.value);
                                                            if (selectAllCheckBox.value == true) {
                                                              selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                                            } else {
                                                              selectedDataList.clear();
                                                            }
                                                          }
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length,
                                                          itemBuilder: (context, l) {
                                                            return Obx(() {
                                                              return CheckboxListTile(
                                                                activeColor: ColorConstants.primary,
                                                                side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                                value: checkBoxStatus[l],
                                                                dense: true,
                                                                title: Text(
                                                                  loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![l]["name"],
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w400,
                                                                    color:
                                                                        selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                                    letterSpacing: 0.5,
                                                                  ),
                                                                ),
                                                                selected: checkBoxStatus[l],
                                                                onChanged: (val) async {
                                                                  checkBoxStatus[l] = val!;
                                                                  if (val == true) {
                                                                    selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![l]["name"]);
                                                                  } else {
                                                                    selectedDataList.removeWhere((item) {
                                                                      return item == loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![l]["name"];
                                                                    });
                                                                    selectAllCheckBox.value = false;
                                                                  }
                                                                },
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: SizeConstants.rootContainerSpacing),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ButtonConstant.dialogButton(
                                                      title: "Cancel",
                                                      borderColor: ColorConstants.red,
                                                      onTapMethod: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                    const SizedBox(width: SizeConstants.contentSpacing),
                                                    ButtonConstant.dialogButton(
                                                      title: "Save & Close",
                                                      btnColor: ColorConstants.primary,
                                                      onTapMethod: () async {
                                                        LoaderHelper.loaderWithGif();

                                                        selectedData.value = "";
                                                        for (int n = 0; n < selectedDataList.length; n++) {
                                                          if (n + 1 == selectedDataList.length) {
                                                            selectedData.value += "${selectedDataList[n]}";
                                                          } else {
                                                            selectedData.value += "${selectedDataList[n]}^^^#";
                                                          }
                                                        }
                                                        Get.back();
                                                        selectedDropDown.addIf(true, rowsData[i][m]["columns"][n]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                                        await saveSelectMultipleFinal(
                                                          strFormFieldID: rowsData[i][m]["columns"][n]["id"].toString(),
                                                          strFormFieldNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                                                          strData: selectedData.value,
                                                        );
                                                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                                                        await updateFieldValues();
                                                        update();
                                                        EasyLoading.dismiss();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.dropDownViaServiceTableValues(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name:
                                rowsData[i][m]["columns"][n]["formFieldName"] == "" && Get.parameters["masterFormId"].toString() == "710"
                                    ? "COMPLETED"
                                    : rowsData[i][m]["columns"][n]["formFieldName"],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            searchDataList: addChoiceServiceTableData,
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            specificDataType: rowsData[i][m]["columns"][n]["serviceTableName"],
                            addChoices: rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"],
                            selectMultiple: rowsData[i][m]["columns"][n]["formFieldStSelectMany"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle:
                                rowsData[i][m]["columns"][n]["acronymTitle"] == "" && Get.parameters["masterFormId"].toString() == "710"
                                    ? "COMPLETED"
                                    : rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue:
                                rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"]
                                    ? formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()]
                                    : rowsData[i][m]["columns"][n]["formFieldStSelectMany"]
                                    ? extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]?.replaceAll("^^^#", ", ")
                                    : dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            selectedValue:
                                rowsData[i][m]["columns"][n]["formFieldStSelectMany"]
                                    ? selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ??
                                        extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]?.replaceAll("^^^#", ", ")
                                    : selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            hintText: rowsData[i][m]["columns"][n]["placeHolder"] ?? "",
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                            onTap: () {
                              switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                                case "0":
                                case "0.0":
                                case "0.00":
                                case "0.000":
                                  fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                              }
                            },
                            onChanged: (val) async {
                              if (rowsData[i][m]["columns"][n]["formFieldAbilityToAdd"]) {
                                if (val != '') {
                                  LoaderHelper.loaderWithGif();
                                  values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                                  await searchFormFieldValues(
                                    strFormFieldType: rowsData[i][m]["columns"][n]["serviceTableName"],
                                    strValue: val,
                                    liveSearchID: rowsData[i][m]["columns"][n]["id"].toString(),
                                  );
                                  update();
                                  EasyLoading.dismiss();
                                } else {
                                  values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                                  addChoiceServiceTableData[rowsData[i][m]["columns"][n]["id"].toString()] = [];
                                }
                                await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              } else {
                                selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                                values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                                await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                                await updateFieldValues();
                                update();
                              }
                            },
                            onEditingComplete: () async {
                              LoaderHelper.loaderWithGif();
                              addChoiceServiceTableData[rowsData[i][m]["columns"][n]["id"].toString()] = [];
                              await setChoiceFromSearch(
                                strFieldId: rowsData[i][m]["columns"][n]["id"].toString(),
                                strValue: fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text,
                                requestToAdd: fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text != "" ? "1" : "0",
                                serviceTableToAddTo: rowsData[i][m]["columns"][n]["serviceTableName"],
                              );
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                              EasyLoading.dismiss();
                              if (rowsData[i][m]["columns"].length > n + 1) {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else if (rowsData[i].length > m + 1) {
                                fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                    ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                    : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              } else {
                                fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                              }
                            },
                            onSelect: (val, requestToAdd) async {
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text = val;
                              Keyboard.close();
                              await setChoiceFromSearch(
                                strFieldId: rowsData[i][m]["columns"][n]["id"].toString(),
                                strValue: val,
                                requestToAdd: requestToAdd,
                                serviceTableToAddTo: rowsData[i][m]["columns"][n]["serviceTableName"],
                              );
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                            onDialogPopUp: () async {
                              LoaderHelper.loaderWithGif();
                              await loadExtendedField(
                                strFieldID: rowsData[i][m]["columns"][n]["id"].toString(),
                                strNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                                strFieldTypeID: rowsData[i][m]["columns"][n]["formFieldType"].toString(),
                              );
                              EasyLoading.dismiss();

                              var selectedData = "".obs;
                              var selectedDataList = [].obs;
                              var selectAllCheckBox = false.obs;
                              var checkBoxStatus = [].obs;

                              if (loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()] != null) {
                                for (int m = 0; m < loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length; m++) {
                                  if (extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()] != null) {
                                    if (extendedFieldsValue[rowsData[i][m]["columns"][n]["id"].toString()]!.contains(
                                      loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"],
                                    )) {
                                      selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                      checkBoxStatus.add(true);
                                    } else {
                                      checkBoxStatus.add(false);
                                      selectedDataList.removeWhere((item) => item == loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                    }
                                  } else {
                                    checkBoxStatus.add(false);
                                  }
                                }
                              }
                              update();
                              showDialog(
                                useSafeArea: true,
                                useRootNavigator: false,
                                barrierDismissible: true,
                                context: Get.context!,
                                builder: (BuildContext context) {
                                  return ResponsiveBuilder(
                                    builder: (context, sizingInformation) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: Dialog(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(SizeConstants.dialogBoxRadius),
                                            side: const BorderSide(color: ColorConstants.primary, width: 2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(SizeConstants.rootContainerSpacing - 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Center(child: TextWidget(text: "Available Options", size: SizeConstants.largeText - 2)),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      child: const TextWidget(text: "Select All / Remove All", size: SizeConstants.largeText - 5),
                                                      onTap: () {
                                                        selectAllCheckBox.value = !selectAllCheckBox.value;
                                                        checkBoxStatus.clear();
                                                        selectedDataList.clear();
                                                        for (int m = 0; m < loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length; m++) {
                                                          checkBoxStatus.add(selectAllCheckBox.value);
                                                          if (selectAllCheckBox.value == true) {
                                                            selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                                          } else {
                                                            selectedDataList.clear();
                                                          }
                                                        }
                                                      },
                                                    ),
                                                    Obx(() {
                                                      return IconButton(
                                                        icon: Icon(
                                                          selectAllCheckBox.value == false ? Icons.select_all : Icons.deselect,
                                                          size: SizeConstants.iconSizes(type: SizeConstants.largeIcon),
                                                        ),
                                                        color:
                                                            selectAllCheckBox.value == false
                                                                ? ColorConstants.grey
                                                                : ThemeColorMode.isDark
                                                                ? ColorConstants.white
                                                                : ColorConstants.black,
                                                        onPressed: () {
                                                          selectAllCheckBox.value = !selectAllCheckBox.value;
                                                          checkBoxStatus.clear();
                                                          selectedDataList.clear();
                                                          for (int m = 0; m < loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length; m++) {
                                                            checkBoxStatus.add(selectAllCheckBox.value);
                                                            if (selectAllCheckBox.value == true) {
                                                              selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![m]["name"]);
                                                            } else {
                                                              selectedDataList.clear();
                                                            }
                                                          }
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]!.length,
                                                          itemBuilder: (context, l) {
                                                            return Obx(() {
                                                              return CheckboxListTile(
                                                                activeColor: ColorConstants.primary,
                                                                side: const BorderSide(color: ColorConstants.grey, width: 2),
                                                                value: checkBoxStatus[l],
                                                                dense: true,
                                                                title: Text(
                                                                  loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![l]["name"],
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w400,
                                                                    color:
                                                                        selectAllCheckBox.value == true || checkBoxStatus[l] == true ? ColorConstants.black : ColorConstants.grey,
                                                                    letterSpacing: 0.5,
                                                                  ),
                                                                ),
                                                                selected: checkBoxStatus[l],
                                                                onChanged: (val) async {
                                                                  checkBoxStatus[l] = val!;
                                                                  if (val == true) {
                                                                    selectedDataList.add(loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![l]["name"]);
                                                                  } else {
                                                                    selectedDataList.removeWhere((item) {
                                                                      return item == loadExtendedFieldData[rowsData[i][m]["columns"][n]["id"].toString()]![l]["name"];
                                                                    });
                                                                    selectAllCheckBox.value = false;
                                                                  }
                                                                },
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: SizeConstants.rootContainerSpacing),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ButtonConstant.dialogButton(
                                                      title: "Cancel",
                                                      borderColor: ColorConstants.red,
                                                      onTapMethod: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                    const SizedBox(width: SizeConstants.contentSpacing),
                                                    ButtonConstant.dialogButton(
                                                      title: "Save & Close",
                                                      btnColor: ColorConstants.primary,
                                                      onTapMethod: () async {
                                                        LoaderHelper.loaderWithGif();

                                                        selectedData.value = "";
                                                        for (int n = 0; n < selectedDataList.length; n++) {
                                                          if (n + 1 == selectedDataList.length) {
                                                            selectedData.value += "${selectedDataList[n]}";
                                                          } else {
                                                            selectedData.value += "${selectedDataList[n]}^^^#";
                                                          }
                                                        }
                                                        Get.back();
                                                        selectedDropDown.addIf(true, rowsData[i][m]["columns"][n]["id"], selectedData.value.replaceAll("^^^#", ", "));
                                                        await saveSelectMultipleFinal(
                                                          strFormFieldID: rowsData[i][m]["columns"][n]["id"].toString(),
                                                          strFormFieldNarrativeID: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                                                          strData: selectedData.value,
                                                        );
                                                        await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                                                        await updateFieldValues();
                                                        update();
                                                        EasyLoading.dismiss();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                break;
              case 27: //"DROP DOWN - NUMBERS 0-50":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.dropDownNumbers0_50(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            selectedValue: selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onChanged: (val) async {
                              selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormWidgets.dropDownNumbers0_50(
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            dropDownData: rowsData[i][m]["columns"][n]["elementData"],
                            key: rowsData[i][m]["columns"][n]["key"] ?? "name",
                            selectedValue: selectedDropDown[rowsData[i][m]["columns"][n]["id"]] ?? dropDownFieldValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            onChanged: (val) async {
                              selectedDropDown.addIf(val != null, rowsData[i][m]["columns"][n]["id"], val[rowsData[i][m]["columns"][n]["key"] ?? "name"]);
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val["id"];
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                          );
                        },
                      ),
                    );
                break;
              case 2: //"CHECK BOX (YES/NO)":
                var m = l;
                n == 0 || n == 1
                    ? columnWidgets1.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormCheckBox(
                            fieldType: "checkBoxYesNo",
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            currentValue:
                                values[rowsData[i][m]["columns"][n]["id"].toString()] != null
                                    ? (values[rowsData[i][m]["columns"][n]["id"].toString()] == "on" ? true : false)
                                    : (rowsData[i][m]["columns"][n]["defaultValue"] == "Checked" ? true : false),
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"] ?? false,
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            multiple: true,
                            onChanged: (val) async {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = (val == true ? "off" : "on");
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await showHideText(fieldId: rowsData[i][n]["columns"][m]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                          );
                        },
                      ),
                    )
                    : columnWidgets2.add(
                      GetBuilder<FillOutFormLogic>(
                        init: FillOutFormLogic(),
                        builder: (controller) {
                          return FormCheckBox(
                            fieldType: "checkBoxYesNo",
                            id: rowsData[i][m]["columns"][n]["id"],
                            rowColor: rowsData[i][m]["formRowBgColor"],
                            name: rowsData[i][m]["columns"][n]["formFieldName"],
                            req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                            showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                            acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"],
                            previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                            defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                            currentValue:
                                values[rowsData[i][m]["columns"][n]["id"].toString()] != null
                                    ? (values[rowsData[i][m]["columns"][n]["id"].toString()] == "on" ? true : false)
                                    : (rowsData[i][m]["columns"][n]["defaultValue"] == "Checked" ? true : false),
                            disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"] ?? false,
                            hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                            multiple: true,
                            onChanged: (val) async {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = (val == true ? "off" : "on");
                              await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                              await showHideText(fieldId: rowsData[i][n]["columns"][m]["id"].toString());
                              await updateFieldValues();
                              update();
                            },
                          );
                        },
                      ),
                    );
                break;
            }
          }
        }

        widgetsForEachRow.add(Column(children: columnWidgets1));
        widgetsForEachRow.add(Column(children: columnWidgets2));
        break;
      case "1030": //HeliService USA(141)_AIRCRAFT DFL(1030)
        var l = j;
        var columnWidgets1 = <Widget>[];
        var columnWidgets2 = <Widget>[];

        for (l; l < rowsData[i].length && rowsData[i][j - 1]["columns"][0]["formFieldType"] != rowsData[i][l]["columns"][0]["formFieldType"]; l++) {
          for (var n = 0; n < rowsData[i][l]["columns"].length; n++) {
            createdFields.addIf(!createdFields.contains(rowsData[i][l]["columns"][n]["id"].toString()), rowsData[i][l]["columns"][n]["id"].toString());
            if (rowsData[i][j]["columns"][0]["formFieldName"].contains("ENGINE")) {
              switch (rowsData[i][l]["columns"][n]["formFieldType"] as int) {
                case 10: //"SPACER":
                  break;
                case 52: //"HEADER CENTERED (GREEN)":
                  columnWidgets1.addIf(
                    k == 0 && n == 0,
                    SizedBox(
                      width:
                          Get.width > 480
                              ? Get.width > 980
                                  ? (Get.width / 3) - ((12 / 3) * 9)
                                  : (Get.width / 2) - ((12 / 2) * 8)
                              : Get.width - 5,
                      child: FormWidgets.headerCenteredGreen(
                        showField: showField[rowsData[i][l]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                        name: rowsData[i][l]["columns"][n]["formFieldName"],
                        acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                        multiple: false,
                      ),
                    ),
                  );
                  columnWidgets2.addIf(
                    k == 1 && n == 1,
                    SizedBox(
                      width:
                          Get.width > 480
                              ? Get.width > 980
                                  ? (Get.width / 3) - ((12 / 3) * 9)
                                  : (Get.width / 2) - ((12 / 2) * 8)
                              : Get.width - 5,
                      child: FormWidgets.headerCenteredGreen(
                        showField: showField[rowsData[i][l]["columns"][n]["id"].toString()],
                        hidden: rowsData[i][l]["columns"][n]["columnHidden"],
                        name: rowsData[i][l]["columns"][n]["formFieldName"],
                        acronymTitle: rowsData[i][l]["columns"][n]["acronymTitle"],
                        multiple: false,
                      ),
                    ),
                  );
                  break;
                case 50: //"HEADER CENTERED (BLUE)":
                  break;
                case 1: //"TEXT FIELD (STANDARD)":
                  var m = l;
                  columnWidgets1.addIf(
                    k == 0 && n == 2,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][l]["formRowBgColor"] != ""
                                ? rowsData[i][l]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][l]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][l]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: FormTextField(
                          fieldType: "textFieldStandard",
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][0]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][0]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                  columnWidgets2.addIf(
                    k == 1 && n == 4,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            rowsData[i][l]["formRowBgColor"] != ""
                                ? rowsData[i][l]["formRowBgColor"].toString().length == 4
                                    ? hexToColor("${rowsData[i][l]["formRowBgColor"]}000")
                                    : hexToColor(rowsData[i][l]["formRowBgColor"])
                                : ThemeColorMode.isDark
                                ? Colors.grey[900]
                                : Colors.white,
                        child: FormTextField(
                          fieldType: "textFieldStandard",
                          id: rowsData[i][m]["columns"][n]["id"],
                          rowColor: rowsData[i][m]["formRowBgColor"],
                          name: rowsData[i][m]["columns"][0]["formFieldName"],
                          req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                          showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                          acronymTitle: rowsData[i][m]["columns"][0]["acronymTitle"],
                          previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                          controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                          focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                          numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                          defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                          disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                          hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                          maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                          onTap: () {
                            switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                              case "0":
                              case "0.0":
                              case "0.00":
                              case "0.000":
                                fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                            }
                          },
                          onChanged: (val) {
                            if (val != '') {
                              values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                            } else {
                              values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                            }
                            checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          },
                          onEditingComplete: () async {
                            await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                            await updateFieldValues();
                            update();
                            if (rowsData[i][m]["columns"].length > n + 1) {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else if (rowsData[i].length > m + 1) {
                              fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                  ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                  : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            } else {
                              fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                  break;
              }
            } else {
              if (k == 0 && rowsData[i][l]["columns"][n]["formFieldType"] == 1) {
                var m = l;
                widgetsForEachRow.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          rowsData[i][l]["formRowBgColor"] != ""
                              ? rowsData[i][l]["formRowBgColor"].toString().length == 4
                                  ? hexToColor("${rowsData[i][l]["formRowBgColor"]}000")
                                  : hexToColor(rowsData[i][l]["formRowBgColor"])
                              : ThemeColorMode.isDark
                              ? Colors.grey[900]
                              : Colors.white,
                      child: FormTextField(
                        fieldType: "textFieldStandard",
                        id: rowsData[i][m]["columns"][n]["id"],
                        rowColor: rowsData[i][m]["formRowBgColor"],
                        name: rowsData[i][m]["columns"][n]["formFieldName"] == "" ? "No. ${n == 2 ? 1 : 2} BEARING ERROR" : rowsData[i][m]["columns"][n]["formFieldName"],
                        req: rowsData[i][m]["columns"][n]["formFieldRequired"],
                        showField: showField[rowsData[i][m]["columns"][n]["id"].toString()],
                        acronymTitle: rowsData[i][m]["columns"][n]["acronymTitle"] == "" ? "No. ${n == 2 ? 1 : 2} BEARING ERROR" : rowsData[i][m]["columns"][n]["acronymTitle"],
                        previousValue: formFieldPreValues[rowsData[i][m]["columns"][n]["id"].toString()],
                        controller: fillOutInputControllers.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => TextEditingController()),
                        focusNode: fillOutFocusNodes.putIfAbsent(rowsData[i][m]["columns"][n]["id"].toString(), () => FocusNode()),
                        numberOnly: property[rowsData[i][m]["columns"][n]["id"].toString()]?["numberOnly"],
                        defaultValue: rowsData[i][m]["columns"][n]["defaultValue"],
                        disableUserEditing: property[rowsData[i][m]["columns"][n]["id"].toString()]?["disabled"] ?? rowsData[i][m]["columns"][n]["readOnlyDisabled"],
                        hidden: rowsData[i][m]["columns"][n]["columnHidden"],
                        maxSize: rowsData[i][m]["columns"][n]["formMaxLength"],
                        onTap: () {
                          switch (fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.text) {
                            case "0":
                            case "0.0":
                            case "0.00":
                            case "0.000":
                              fillOutInputControllers[rowsData[i][m]["columns"][n]["id"].toString()]?.clear();
                          }
                        },
                        onChanged: (val) {
                          if (val != '') {
                            values[rowsData[i][m]["columns"][n]["id"].toString()] = val;
                          } else {
                            values.remove(rowsData[i][m]["columns"][n]["id"].toString());
                          }
                          checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                        },
                        onEditingComplete: () async {
                          await checkForm(doSave: false, fieldId: rowsData[i][m]["columns"][n]["id"].toString());
                          await updateFieldValues();
                          update();
                          if (rowsData[i][m]["columns"].length > n + 1) {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m]["columns"][n + 1]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else if (rowsData[i].length > m + 1) {
                            fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()] != null
                                ? fillOutFocusNodes[rowsData[i][m + 1]["columns"][0]["id"].toString()]?.requestFocus()
                                : fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          } else {
                            fillOutFocusNodes[rowsData[i][m]["columns"][n]["id"].toString()]?.nextFocus();
                          }
                        },
                      ),
                    ),
                  ),
                );
              }
            }
          }
        }

        if (rowsData[i][j]["columns"][0]["formFieldName"].contains("ENGINE")) {
          widgetsForEachRow.add(Column(children: columnWidgets1));
          widgetsForEachRow.add(Column(children: columnWidgets2));
        }
        break;
      default:
        break;
    }
  }
}
