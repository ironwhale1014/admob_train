import 'dart:io';

import 'package:admo_train/admob/const_value.dart';
import 'package:admo_train/admob/visible_provider.dart';
import 'package:admo_train/common/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void dispose() {
    // TODO: implement dispose
    logger.d("_bannerAd dispose");
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String whichOs = Platform.isAndroid ? "android" : "ios";

    logger.d("start");
    BannerAd(
            size: AdSize.banner,
            adUnitId: BANNER_ID[whichOs]!,
            listener: BannerAdListener(onAdLoaded: (Ad ad) {
              _bannerAd = ad as BannerAd;
              setState(() {});
            }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              logger.e(error);
              _bannerAd = null;
            }, onAdWillDismissScreen: (Ad ad) {
              ad.dispose();
              logger.d("onAdWillDismissScreen");
              _bannerAd!.load();
            }),
            request: const AdRequest())
        .load();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ref.watch(admobVisibleNotifier),
      child: Container(
          color: Colors.white,
          height: 60,
          child: (_bannerAd != null) ? AdWidget(ad: _bannerAd!) : Container()),
    );
  }
}
