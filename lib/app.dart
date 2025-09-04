import 'package:flutter/material.dart';
import 'package:wintek/utils/router/app_roouter.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: RoutesNames.bottombar,
      initialRoute: RoutesNames.bottombar,
      // initialRoute: RoutesNames.loginWithPhone,
      onGenerateRoute: AppRouter.generateRoute,
      title: 'Winket',
      theme: theme,
    );
  }
}
