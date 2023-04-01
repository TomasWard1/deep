import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deep_prueba/screens/landing_page.dart';

void main() => runApp(const Deep());

class Deep extends StatelessWidget {
  const Deep({super.key});
  @override
  Widget build(BuildContext context) {
    // <--- build
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // <--- SystemChrome
      statusBarColor: Colors.transparent, // Status bar transparente
      statusBarIconBrightness: Brightness.dark, // Iconos de la barra de estado
      statusBarBrightness: // Modo de la barra de estado
          Platform.isAndroid
              ? Brightness.dark
              : Brightness.light, // <--- Platform
      systemNavigationBarColor: Colors.white, // Color de la barra de navegación
      systemNavigationBarDividerColor:
          Colors.grey, // Color del divisor de la barra de navegación
      systemNavigationBarIconBrightness:
          Brightness.dark, // Iconos de la barra de navegación
    ));
    return MaterialApp(
      // <--- MaterialApp
      title: 'Deep',
      debugShowCheckedModeBanner:
          false, // Esto es para quitar el banner de debug
      theme: ThemeData(
        primarySwatch: Colors.blue, //
        platform: TargetPlatform.iOS,
      ),
      home: LandingPage(),
    );
  }
}
