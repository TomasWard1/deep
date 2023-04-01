import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/helpers/DeepWidgets.dart';

import '../classes/BookClass.dart';

class DialogManager {
  Future success(String title) async {
    await Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      title: title,
      messageText: Container(),
      duration: const Duration(seconds:3),
      backgroundColor: Colors.green,
    ));

  }

  bookDetail(Book b) {
    Get.bottomSheet(DeepWidgets().bookDetail(b));
  }

  Future error(String title) async {
    await Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      title: title,
      messageText: Container(),
      duration: const Duration(seconds:3),
      backgroundColor: Colors.red,
    ));

  }
}
