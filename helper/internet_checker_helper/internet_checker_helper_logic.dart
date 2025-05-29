import 'dart:async';

import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetCheckerHelperLogic extends GetxController {
  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<ConnectivityResult> _connectionStatus = <ConnectivityResult>[];

  static bool internetConnected = false;

  //-1 = No Internet, 0 = initial/null, 1 = Mobile Data Connected, 2 = WIFI Connected, 3 = Ethernet, 4 = VPN, 5 = Bluetooth, 6 = Other.
  int _connectionType = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _connectivity.checkConnectivity().then((List<ConnectivityResult> connectivityResults) {
      _connectionStatus = connectivityResults;
      internetConnected = !_connectionStatus.contains(ConnectivityResult.none);
    });
  }

  @override
  void onReady() {
    super.onReady();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResults) async {
      await _updateConnectionStatus(connectivityResults);
    });
  }

  @override
  Future<void> onClose() async {
    await _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> connectivityResults) async {
    await _connectivity.checkConnectivity().then((List<ConnectivityResult> connectivityResults) async {
      _connectionStatus = connectivityResults;
      internetConnected = !_connectionStatus.contains(ConnectivityResult.none);

      if (connectivityResults.contains(ConnectivityResult.mobile)) {
        // Mobile network available.
        if (_connectionType == -1) {
          await SnackBarHelper.openSnackBar(message: 'Internet Connected!');
        }
        _connectionType = 1;
      } else if (connectivityResults.contains(ConnectivityResult.wifi)) {
        // Wi-fi is available.
        // Note for Android:
        // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
        if (_connectionType == -1) {
          await SnackBarHelper.openSnackBar(message: 'Internet Connected!');
        }
        _connectionType = 2;
      } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
        // Ethernet connection available.
        if (_connectionType == -1) {
          await SnackBarHelper.openSnackBar(message: 'Internet Connected!');
        }
        _connectionType = 3;
      } else if (connectivityResults.contains(ConnectivityResult.vpn)) {
        // Vpn connection active.
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
        if (_connectionType == -1) {
          await SnackBarHelper.openSnackBar(message: 'Internet Connected!');
        }
        _connectionType = 4;
      } else if (connectivityResults.contains(ConnectivityResult.bluetooth)) {
        // Bluetooth connection available.
        if (_connectionType == -1) {
          await SnackBarHelper.openSnackBar(message: 'Internet Connected!');
        }
        _connectionType = 5;
      } else if (connectivityResults.contains(ConnectivityResult.other)) {
        // Connected to a network which is not in the above mentioned networks.
        if (_connectionType == -1) {
          await SnackBarHelper.openSnackBar(message: 'Internet Connected!');
        }
        _connectionType = 6;
      } else if (connectivityResults.contains(ConnectivityResult.none)) {
        // No available network types
        if (_connectionType != -1 && _connectionType != 0) {
          await SnackBarHelper.openSnackBar(message: 'No Internet!', isError: true);
        }
        _connectionType = -1;
      } else {
        // Connection type not available.
        await SnackBarHelper.openSnackBar(message: 'Failed to get connection type!', isError: true);
        _connectionType = 0;
      }
    });
  }
}
