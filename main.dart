import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:aviation_rnd/helper/internet_checker_helper/internet_checker_helper_binding.dart';
import 'package:aviation_rnd/routes/app_pages.dart';
import 'package:aviation_rnd/shared/constants/constant_assets.dart';
import 'package:aviation_rnd/shared/constants/constant_storages.dart';
import 'package:aviation_rnd/shared/services/storage_prefs.dart';
import 'package:aviation_rnd/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/localization/intl/messages.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() async {
  configLoading();
  WidgetsFlutterBinding.ensureInitialized();
  InternetCheckerHelperBinding().dependencies();

  // if (kReleaseMode) {
  //   FlutterError.onError = (errorDetails) {
  //     FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  //   };
  //   // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  //   PlatformDispatcher.instance.onError = (error, stack) {
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //     return true;
  //   };
  // }

  //Loggy.initLoggy(logPrinter: (kReleaseMode) ? const PrettyPrinter() : const PrettyPrinter()); //CrashlyticsPrinter());

  await GetStorage.init();
  // await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('shopping_box');
  // await appDBCollectionInit();

  ResponsiveSizingConfig.instance.setCustomBreakpoints(const ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200));

  if (!StoragePrefs().lsHasData(key: StorageConstants.currentThemeMode)) {
    await StoragePrefs().lsWrite(key: StorageConstants.currentThemeMode, value: WidgetsBinding.instance.platformDispatcher.platformBrightness.name);
  }

  if (!await StoragePrefs().ssHasData(key: StorageConstants.checkSsData)) {
    await StoragePrefs().ssDeleteAll();
    await StoragePrefs().ssWrite(key: StorageConstants.checkSsData, value: "initial_data_added");
  } else {
    await StoragePrefs()
        .ssRead(key: StorageConstants.checkSsData)
        .then((String? data) async {
          if (data != null) {
            await StoragePrefs().ssWrite(key: StorageConstants.checkSsData, value: "data_checked");
          } else {
            await StoragePrefs().ssDeleteAll();
          }
        })
        .catchError((_) async {
          await StoragePrefs().ssDeleteAll();
        });
  }

  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorWidget = Image.asset(AssetConstants.loaderGif, height: 100, width: 100)
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

/*appDBCollectionInit() async{
  // await Hive.deleteBoxFromDisk('shopping_box');
  await Hive.openBox(DBKeyData.employee).then((value) => print(value.values));
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => AdaptiveTheme(
    initial: AdaptiveThemeMode.system,
    overrideMode: StoragePrefs().lsRead(key: StorageConstants.currentThemeMode) == "light" ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark,
    light: ThemeConfig.lightTheme,
    dark: ThemeConfig.darkTheme,
    builder: (ThemeData light, ThemeData dark) => GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      initialRoute: AppPages.initial,
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      smartManagement: SmartManagement.keepFactory,
      title: 'Digital AirWare',
      localizationsDelegates: const <LocalizationsDelegate<FormBuilderLocalizationsImpl>>[FormBuilderLocalizations.delegate],
    ),
  );
}
