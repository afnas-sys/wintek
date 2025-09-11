import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/router/app_roouter.dart';
import 'package:wintek/utils/router/routes_names.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: RoutesNames.bottombar,
      initialRoute: RoutesNames.splash,
      // initialRoute: RoutesNames.loginWithPhone,
      onGenerateRoute: AppRouter.generateRoute,
      title: 'Wintek',
      theme: theme,
      // home: dummy(),
    );
  }
}
