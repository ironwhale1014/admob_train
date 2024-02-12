import 'package:admo_train/common/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final admobVisibleNotifier =
    StateNotifierProvider<VisibleNotifier, bool>((ref) => VisibleNotifier());

class VisibleNotifier extends StateNotifier<bool> {
  SharedPreferences? prefs;

  VisibleNotifier() : super(false) {
    logger.d("VisibleNotifier");
    load();
  }

  void load() async {
    if (prefs == null) {
      logger.d("prefs == null");
      prefs = await SharedPreferences.getInstance();
      state = true;
    }

    if (!prefs!.containsKey('savedDateTime')) {
      logger.d("!prefs!.containsKey('savedDateTime')");
      state = true;
    } else {
      DateTime savedTime = DateTime.parse(prefs!.getString('savedDateTime')!);
      logger.d(DateTime.now().difference(savedTime).inMinutes.remainder(60));
      state = DateTime.now().difference(savedTime).inMinutes.remainder(60) > 5;
    }
  }

  void toggle({required bool isVisible}) {
    state = isVisible;
  }
}
