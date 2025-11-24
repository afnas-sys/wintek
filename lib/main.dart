import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/firebase_options.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/router/app_roouter.dart';
import 'package:wintek/core/router/routes_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //initialRoute: RoutesNames.bottombar,
        initialRoute: RoutesNames.splash,
        // initialRoute: RoutesNames.loginWithPhone,
        onGenerateRoute: AppRouter.generateRoute,
        title: 'Wintek',
        theme: theme,
        // home: dummy(),
      ),
    );
  }
}
