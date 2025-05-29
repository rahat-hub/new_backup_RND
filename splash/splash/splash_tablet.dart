import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/constant_assets.dart';
import '../../../shared/constants/constant_sizes.dart';
import '../../../shared/services/device_orientation.dart';
import '../splash_logic.dart';

class SplashTablet extends GetView<SplashLogic> {
  const SplashTablet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashLogic>();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(padding: const EdgeInsets.only(left: SizeConstants.contentSpacing), child: Image.asset(AssetConstants.logo, gaplessPlayback: true)),
          ),
          Center(
            child: Padding(
                padding: EdgeInsets.only(bottom: SizeConstants.contentSpacing * 3, right: DeviceOrientation.isLandscape ? SizeConstants.contentSpacing * 10 : 0.0),
                child: const CupertinoActivityIndicator()),
          )
        ]),
      ),
    );
  }
}
