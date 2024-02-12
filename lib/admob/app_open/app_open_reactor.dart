import 'package:admo_train/admob/app_open/app_open_ad_manager.dart';
import 'package:admo_train/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final appOpenReactorProvider = Provider<AppOpenReactor>((ref) {
  final adManager = ref.read(appOpenAdManagerProvider);

  return AppOpenReactor(adManager);
});

class AppOpenReactor {
  final AppOpenAdManager _adManager;

  AppOpenReactor(this._adManager) {
    listenToAppState();
  }

  void listenToAppState() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((AppState state) {
      logger.d(state);
      if (state == AppState.foreground) {
        _adManager.showAdIfAvailable();
      }
    });
  }
}
