import 'package:admo_train/admob/banner/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NativeAdScreen extends ConsumerStatefulWidget {
  const NativeAdScreen({super.key});

  static String get routeName => "NativeAdScreen";

  @override
  ConsumerState createState() => _NativeAdScreenState();
}

class _NativeAdScreenState extends ConsumerState<NativeAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
          ),
        ),
        BannerAdWidget()
      ],
    );
  }
}
