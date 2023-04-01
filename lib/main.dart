import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';
import 'package:hackitba/screens/NavBar.dart';
import 'package:hackitba/screens/UserForm.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(SpacesController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  SpacesController get sc => Get.find<SpacesController>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (sc.uidForLogin.isNotEmpty) ? NavBar() : UserForm(),
    );
  }
}
