import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarManager {
  Future success(String title) async {
    await Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      title: title,
      messageText: Container(),
      duration: const Duration(seconds:3),
      backgroundColor: Colors.green,
    ));

  }
}
