import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/constant_assets.dart';
import '../splash_logic.dart';

class SplashMobilePortrait extends GetView<SplashLogic> {
  const SplashMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashLogic>();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(padding: const EdgeInsets.only(left: 10), child: Image.asset(AssetConstants.logo, gaplessPlayback: true)),
          ),
          const Center(
            child: Padding(padding: EdgeInsets.only(bottom: 30), child: CupertinoActivityIndicator()),
          )
        ]),
      ),
    );
  }
}

class SplashMobileLandscape extends GetView<SplashLogic> {
  const SplashMobileLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashLogic>();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Image.asset(AssetConstants.logo, gaplessPlayback: true)),
          ),
          const Center(
            child: Padding(padding: EdgeInsets.only(bottom: 10, right: 80), child: CupertinoActivityIndicator()),
          )
        ]),
      ),
    );
  }
}
