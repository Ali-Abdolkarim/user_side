import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_side/controller/simple_ui_controller.dart';
import 'package:user_side/views/home_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(SimpleUIController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        // if (snapshot.connectionState == ConnectionState.done &&
        //     snapshot.data != null) {
        return const HomePage();
        // } else {
        //   return const LoginView();
        // }
      }),
    );
  }
}
