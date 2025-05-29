import 'dart:ui';

import 'package:aviation_rnd/shared/shared.dart';
import 'package:aviation_rnd/widgets/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class PermissionHelper {
  PermissionHelper._();

  static bool get specialPermissionAccess =>
      kDebugMode ? UserPermission.dawSystemAdmin.value : (UserSessionInfo.userId == 4218 || UserSessionInfo.userId == 50 || UserSessionInfo.userId == 38);

  static Future<void> storagePermissionAccess({BuildContext? context}) => showDialog<void>(
    useRootNavigator: false,
    context: context ?? Get.context!,
    builder: (BuildContext context) => ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: ColorConstants.primary, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Enable File Access Permission",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Grant DAW with the file access permission to open , edit and save files.",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SizeConstants.rootContainerSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonConstant.dialogButton(title: "Not Now", borderColor: ColorConstants.red, onTapMethod: () => Get.back(closeOverlays: true)),
                    const SizedBox(width: SizeConstants.contentSpacing),
                    ButtonConstant.dialogButton(
                      title: "Grant",
                      onTapMethod: () async {
                        Get.back(closeOverlays: true);
                        await Permission.manageExternalStorage.request();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

extension HasUserPermission on UserPermission {
  bool get value => (name == "showDutyTime" || name == "showFuelFarm")
      ? (StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.userPermissionData)?[name] == "Yes")
      : StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.userPermissionData)?[name] ?? false;
  bool get hasAccess => value;
  bool get isTrue => value;
  bool get isFalse => !value;
}

///Count Except showDutyTime, showFuelFarm,
enum UserPermission {
  showDutyTime,
  showFuelFarm,
  dawSystemAdmin,
  sysOp,
  superUser,
  changeUsers,
  usersAdmin,
  mechanic,
  mechanicAdmin,
  pilot,
  pilotAdmin,
  eng,
  engAdmin,
  operationalControl,
  formAuditor,
  coSignAcLogs,
  reports,
  discrepanciesWo,
  forms,
  inventory,
  schedulerEditor,
  accessFlightOps,
  shiftReleaseForOthers,
  partsRequestApprovalLevel1,
  partsRequestApprovalLevel2,
  trainingAdmin,
  trainingViewAll,
  editOwnTimeStamps,
  operationalExpenses,
  faaViewOnly,
  safetyOfficer,
  billing,
  vendor,
  teamLeader,
  trainingSysop,
  trainingSuperUser,
  trainingUserAdmin,
  sarLinkAdmin,
  development,
  weightBalance,
  googleCalendar,
}

extension BodyChecksValue on BodyChecks {
  int get value => (StoragePrefs().lsRead<Map<String, dynamic>>(key: StorageConstants.userPermissionData)?["bodyChecks"] as Map<String, dynamic>)[name];
}

enum BodyChecks {
  isUserDutyTimedIn,
  helpDeskTickets,
  flightOpsDueNow,
  flightOpsRequiredButNotDueNow,
  hazardAssessmentsDueNow,
  hazardAssessmentsRequiredButNotDueNow,
  useDutyTime,
  useDutyTimePreventNewForms,
  moduleFlightTracker,
  moduleShiftRelease,
  moduleTimeCards,
  moduleFlightRequest,
  moduleFixedWingRequest,
  moduleEarthsCapeLink,
  moduleSARLink,
  moduleSR3Training,
  moduleTFOTraining,
}
