import 'package:flutter/material.dart';
import 'package:wintek/utils/router/app_roouter.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/constants/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: RoutesNames.bottombar,
      initialRoute: RoutesNames.home,
      // initialRoute: RoutesNames.loginWithPhone,
      onGenerateRoute: AppRouter.generateRoute,
      title: 'Winket',
      theme: theme,
      // home: dummy(),
    );
  }
}
