import 'dart:io';

import 'package:aviation_rnd/modules/device_reg_info/device_reg_info/device_reg_info_logic.dart';
import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:aviation_rnd/shared/services/device_orientation.dart';
import 'package:aviation_rnd/widgets/discrepancy_and_work_order_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../helper/device_reg_info_helper.dart';
import '../../../../shared/utils/device_type.dart';
import '../../../../widgets/appbar.dart';

class DeviceRegInfoPageView extends GetView<DeviceRegInfoLogic> {
  const DeviceRegInfoPageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<DeviceRegInfoLogic>();

    // print("HELLOEOWOEWOWEOWEOWEOWEOWEO");
    // print(AppInfoHelper.appName.toString());
    // print("HELLOEOWOEWOWEOWEOWEOWEOWEO");

    return Obx(() {
      return controller.isLoading.isFalse
          ? PopScope(
            onPopInvokedWithResult: (didPop, result) => EasyLoading.dismiss(),
            child: Scaffold(
              appBar: AppbarConstant.customAppBar(context: context, title: 'Device Registration Info', backTap: () => Get.back()),
              body: SafeArea(
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 10.0,
                        children: [
                          Center(
                            child: Text(
                              'User Registration Information: ${Platform.isIOS ? 'iOS' : 'Android'}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ColorConstants.primary),
                            ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 20.0,
                            runSpacing: 5.0,
                            children: [
                              //---------------Device Information
                              Column(
                                spacing: 5.0,
                                children: [
                                  const Text('Device Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstants.grey)),
                                  Container(
                                    width:
                                        DeviceType.isTablet
                                            ? DeviceOrientation.isLandscape
                                                ? Get.width / 3.5
                                                : Get.width / 2.5
                                            : Get.width,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: ColorConstants.button)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 5.0,
                                        children: [
                                          controller.returnInformationTextData(title: 'Manufacture', value: DeviceInfoHelper.deviceManufacturer),
                                          controller.returnInformationTextData(title: 'Operating System', value: DeviceInfoHelper.operatingSystem),
                                          controller.returnInformationTextData(title: 'Device Name', value: DeviceInfoHelper.deviceName),
                                          controller.returnInformationTextData(title: 'Model', value: DeviceInfoHelper.model),
                                          controller.returnInformationTextData(title: 'Model Name', value: DeviceInfoHelper.modelName),
                                          controller.returnInformationTextData(title: 'System Version', value: DeviceInfoHelper.systemOSVersion),
                                          controller.returnInformationTextData(title: 'Id', value: DeviceInfoHelper.identifierForVendor),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ), //---------------App Information
                              Column(
                                spacing: 5.0,
                                children: [
                                  const Text('App Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstants.grey)),
                                  Container(
                                    width:
                                        DeviceType.isTablet
                                            ? DeviceOrientation.isLandscape
                                                ? Get.width / 3.5
                                                : Get.width / 2.5
                                            : Get.width,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: ColorConstants.button)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 5.0,
                                        children: [
                                          controller.returnInformationTextData(title: 'App Name', value: AppInfoHelper.appName),
                                          controller.returnInformationTextData(title: 'Package Name', value: AppInfoHelper.packageName),
                                          controller.returnInformationTextData(title: 'Version', value: AppInfoHelper.version),
                                          controller.returnInformationTextData(title: 'Build Number', value: AppInfoHelper.buildNumber),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ), //---------------GPS Information
                              Column(
                                spacing: 5.0,
                                children: [
                                  const Text('GPS Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstants.grey)),
                                  Container(
                                    width:
                                        DeviceType.isTablet
                                            ? DeviceOrientation.isLandscape
                                                ? Get.width / 3.5
                                                : Get.width / 2.5
                                            : Get.width,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: ColorConstants.button)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 5.0,
                                        children: [
                                          controller.returnInformationTextData(title: 'Latitude', value: DeviceGPSInfoHelper.latitude.toString()),
                                          controller.returnInformationTextData(title: 'Longitude', value: DeviceGPSInfoHelper.longitude.toString()),
                                          controller.returnInformationTextData(title: 'Altitude', value: DeviceGPSInfoHelper.altitude.toString()),
                                          controller.returnInformationTextData(title: 'Street', value: DeviceGPSInfoHelper.street.toString()),
                                          controller.returnInformationTextData(title: 'Sub Locality', value: DeviceGPSInfoHelper.subLocality.toString()),
                                          controller.returnInformationTextData(title: 'Locality', value: DeviceGPSInfoHelper.locality.toString()),
                                          controller.returnInformationTextData(title: 'City', value: DeviceGPSInfoHelper.city.toString()),
                                          controller.returnInformationTextData(title: 'Postal Code', value: DeviceGPSInfoHelper.postalCode.toString()),
                                          controller.returnInformationTextData(title: 'State', value: DeviceGPSInfoHelper.state.toString()),
                                          controller.returnInformationTextData(title: 'Country', value: DeviceGPSInfoHelper.country.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ), //---------------IP Address Information
                              Column(
                                spacing: 5.0,
                                children: [
                                  const Text('IP Address Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstants.grey)),
                                  Container(
                                    width:
                                        DeviceType.isTablet
                                            ? DeviceOrientation.isLandscape
                                                ? Get.width / 3.5
                                                : Get.width / 2.5
                                            : Get.width,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: ColorConstants.button)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 5.0,
                                        children: [
                                          controller.returnInformationTextData(title: 'ip', value: DeviceIpAddressHelper.ip.toString()),
                                          controller.returnInformationTextData(title: 'city', value: DeviceIpAddressHelper.city.toString()),
                                          controller.returnInformationTextData(title: 'region', value: DeviceIpAddressHelper.region.toString()),
                                          controller.returnInformationTextData(title: 'country', value: DeviceIpAddressHelper.country.toString()),
                                          controller.returnInformationTextData(title: 'loc', value: DeviceIpAddressHelper.loc.toString()),
                                          controller.returnInformationTextData(title: 'org', value: DeviceIpAddressHelper.org.toString()),
                                          controller.returnInformationTextData(title: 'postal', value: DeviceIpAddressHelper.postal.toString()),
                                          controller.returnInformationTextData(title: 'timezone', value: DeviceIpAddressHelper.timezone.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DiscrepancyAndWorkOrdersMaterialButton(
                                buttonText: 'Get Information',
                                borderColor: Colors.blue,
                                buttonColor: ColorConstants.button,
                                onPressed: () {
                                  if (kDebugMode) print(controller.deviceRegistrationDemoJson);
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
            ),
          )
          : const SizedBox();
    });
  }
}
