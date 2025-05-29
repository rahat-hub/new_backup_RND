import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class LoaderHelper {
  LoaderHelper._();

  static Future<void> loaderWithGif() {
    EasyLoading.instance.loadingStyle = ThemeColorMode.isDark ? EasyLoadingStyle.dark : EasyLoadingStyle.light;
    EasyLoading.instance.dismissOnTap = false;
    EasyLoading.instance.userInteractions = false;

    return EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      indicator: Image.asset(
        AssetConstants.loaderGif,
        height: 80,
        width: 80,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => const CircularProgressIndicator(),
      ),
    );
  }

  static Future<void> loaderWithGifAndText(String? text) {
    EasyLoading.instance.loadingStyle = ThemeColorMode.isDark ? EasyLoadingStyle.dark : EasyLoadingStyle.light;
    EasyLoading.instance.dismissOnTap = false;
    EasyLoading.instance.userInteractions = false;

    return EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      indicator: Column(
        children: <Widget>[
          Image.asset(AssetConstants.loaderGif, height: 80, width: 80),
          if (text != null || text != "")
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(text ?? "", style: TextStyle(color: ThemeColorMode.isDark ? Colors.white : Colors.black)),
            ),
        ],
      ),
    );
  }
}
