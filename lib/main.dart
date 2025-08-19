import 'package:flutter/material.dart';
import 'package:winket/utils/router/app_roouter.dart';
import 'package:winket/utils/router/routes_names.dart';
import 'package:winket/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesNames.loginWithPhone,
      onGenerateRoute: AppRouter.generateRoute,
      title: 'Winket',
      theme: theme,
     // home: dummy(),
    );
  }
}
