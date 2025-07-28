import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _checkInitialStatus();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // Convert the list to a boolean (true if there's any connection)
      final hasConnection =
          results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);

      _updateStatus(hasConnection);
    });
  }

  bool get isOnline => _isOnline;

  Future<void> _checkInitialStatus() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result.isNotEmpty);
  }

  void _updateStatus(bool isConnected) {
    _isOnline = isConnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
