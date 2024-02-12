import 'package:admo_train/root_tap.dart';
import 'package:admo_train/screens/native_ad_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: routes);

List<GoRoute> routes = [
  GoRoute(
      path: "/",
      name: RootTap.routeName,
      builder: (_, __) => RootTap(),
      routes: [
        GoRoute(
            path: "native",
            name: NativeAdScreen.routeName,
            builder: (_, __) => NativeAdScreen())
      ]),
];
