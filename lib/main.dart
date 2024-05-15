import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/app/news/screens/splashscreen.dart';
import 'package:get/get.dart';

// A23FE8D684B70D0A659F65660BB97D15
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  // Add a list of test ids.
  Admob.initialize(testDeviceIds: ['a8914598-1ce5-4dee-9311-10ca1ad1abe1']);
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
