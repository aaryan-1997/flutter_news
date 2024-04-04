import 'package:flutter/material.dart';
import 'package:flutter_news/app/news/screens/splashscreen.dart';
import 'package:get/get.dart';

import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinNEWS',
      // initialBinding: ApplicationBindings(),
      // initialRoute: AppPages.initial,
      // getPages: AppPages.routes,
      home: SplashScreen(),
    );
  }
}
