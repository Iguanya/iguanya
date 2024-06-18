// lib/services/sync.dart

import 'package:connectivity/connectivity.dart';
import 'storage.dart';
import 'api.dart';
import '../models/account.dart';

class SyncService {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  SyncService({required this.apiService, required this.localStorageService});

  Future<void> syncData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      List<Account> localAccounts = await localStorageService.getAccounts();
      for (Account account in localAccounts) {
        await apiService.syncAccount(account);
      }

      List<Account> remoteAccounts = await apiService.fetchAccounts();
      for (Account account in remoteAccounts) {
        await localStorageService.insertAccount(account);
      }
    }
  }
}
