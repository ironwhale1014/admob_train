import 'dart:io';

import 'package:admo_train/admob/visible_provider.dart';
import 'package:admo_train/common/util/logger.dart';
import 'package:admo_train/screens/countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A simple app that loads a rewarded ad.
class RewardedExample extends ConsumerStatefulWidget {
  const RewardedExample({super.key});

  @override
  ConsumerState createState() => RewardedExampleState();
}

class RewardedExampleState extends ConsumerState<RewardedExample> {
  final CountdownTimer _countdownTimer = CountdownTimer();
  var _showWatchVideoButton = false;
  var _coins = 0;
  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    super.initState();

    _countdownTimer.addListener(() => setState(() {
          if (_countdownTimer.isComplete) {
            _showWatchVideoButton = true;
            _coins += 1;
          } else {
            _showWatchVideoButton = false;
          }
        }));
    _startNewGame();
  }

  void _startNewGame() {
    _loadAd();
    _countdownTimer.start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rewarded Example',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Rewarded Example'),
          ),
          body: Stack(
            children: [
              const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'The Impossible Game',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_countdownTimer.isComplete
                          ? 'Game over!'
                          : '${_countdownTimer.timeLeft} seconds left!'),
                      Visibility(
                        visible: _countdownTimer.isComplete,
                        child: TextButton(
                          onPressed: () {
                            _startNewGame();
                          },
                          child: const Text('Play Again'),
                        ),
                      ),
                      Visibility(
                          visible: _showWatchVideoButton &&
                              ref.watch(admobVisibleNotifier),
                          child: TextButton(
                            onPressed: () async {
                              setState(() => _showWatchVideoButton = false);

                              _rewardedAd?.show(onUserEarnedReward:
                                  (AdWithoutView ad,
                                      RewardItem rewardItem) async {
                                // ignore: avoid_print
                                logger.d('Reward amount: ${rewardItem.amount}');
                                logger.d('Reward type: ${rewardItem.type}');
                                await ref
                                    .read(admobVisibleNotifier.notifier)
                                    .prefs!
                                    .setString('savedDateTime',
                                    DateTime.now().toString());
                                ref
                                    .read(admobVisibleNotifier.notifier)
                                    .toggle(isVisible: false);

                                setState(
                                    () => _coins += rewardItem.amount.toInt());
                              });
                            },
                            child: const Text(
                                'Watch video for additional 10 coins'),
                          ))
                    ],
                  )),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text('Coins: $_coins')),
              ),
            ],
          )),
    );
  }

  /// Loads a rewarded ad.
  void _loadAd() {
    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _countdownTimer.dispose();
    super.dispose();
  }
}
