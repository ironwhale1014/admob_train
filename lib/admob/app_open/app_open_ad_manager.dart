import 'dart:io';

import 'package:admo_train/admob/const_value.dart';
import 'package:admo_train/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final appOpenAdManagerProvider = Provider<AppOpenAdManager>((ref) {
  return AppOpenAdManager();
});

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;

  bool get _isAppOpenNull => _appOpenAd != null;
  bool _isShowAd = false;
  String whichOs = Platform.isAndroid ? "android" : "ios";

  void _load() {
    AppOpenAd.load(
        adUnitId: APP_OPENNING_ID[whichOs]!,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (AppOpenAd ad) {
          _appOpenAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          logger.e(error.message);
        }),
        orientation: AppOpenAd.orientationPortrait);
  }

  void showAdIfAvailable() {
    logger.d("showAdIfAvailable start _isAppOpenNull: $_isAppOpenNull");
    if (!_isAppOpenNull) {
      _load();
      return;
    }

    if (_isShowAd) {
      return;
    }

    logger.d("showAdIfAvailable");
    logger.d(_appOpenAd);

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (Ad ad) {
        _isShowAd = true;
      },
      onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
        ad.dispose();
        _appOpenAd = null;
        _isShowAd = false;
      },
      onAdDismissedFullScreenContent: (Ad ad) {
        ad.dispose();
        _appOpenAd = null;
        _isShowAd = false;
        _load();
      },
    );
    _appOpenAd!.show();
  }
}
