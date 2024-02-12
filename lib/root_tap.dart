import 'package:admo_train/admob/banner/banner_widget.dart';
import 'package:admo_train/common/util/logger.dart';
import 'package:admo_train/screens/home_screen.dart';
import 'package:admo_train/screens/native_ad_screen.dart';
import 'package:admo_train/screens/reward_ads_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootTap extends ConsumerStatefulWidget {
  const RootTap({super.key});

  static String get routeName => "homePage";

  @override
  ConsumerState createState() => _RootTapState();
}

class _RootTapState extends ConsumerState<RootTap> {
  int _selectedIndex = 0;

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
        selectedIcon: Icon(Icons.home_outlined),
        icon: Icon(Icons.home),
        label: 'home'),
    const NavigationDestination(icon: Icon(Icons.telegram), label: 'telegram'),
    const NavigationDestination(icon: Icon(Icons.face_sharp), label: 'face'),
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const NativeAdScreen(),
    const RewardedExample(),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            logger.d(_selectedIndex);
          });
        },
        elevation: 0,
        backgroundColor: Colors.white,
        destinations: _destinations,
      ),
    );
  }
}
