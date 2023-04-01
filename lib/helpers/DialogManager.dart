import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/helpers/DeepWidgets.dart';

import '../classes/BookClass.dart';

class DialogManager {
  final DeepWidgets dw = DeepWidgets();

  Future success(String title) async {
    await Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      title: title,
      messageText: Container(),
      duration: const Duration(seconds: 3),
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
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ));
  }

  void listItem() {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
          color: dw.bgColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Divider(
            height: 5,
            indent: Get.size.width * 0.4,
            endIndent: Get.size.width * 0.4,
            color: dw.accentColor,
            thickness: 4,
          ),
          Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: dw.titleText('Publicá', dw.textColor, TextAlign.left)),
            dw.textFormField(c, hintText, bold, size)
        ],
      ),
    ));
  }
}
