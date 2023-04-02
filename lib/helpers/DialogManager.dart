import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/helpers/DeepWidgets.dart';

import '../classes/BookClass.dart';
import '../classes/SpaceClass.dart';
import '../controllers/SpacesController.dart';
import 'Functions.dart';

class DialogManager {
  final DeepWidgets dw = DeepWidgets();

  SpacesController get sc => Get.find<SpacesController>();

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

  void listItem(Space s) {
    Get.bottomSheet(
        Container(
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
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.bookmark_add_rounded, color: dw.textColor, size: 40),
                    ),
                    dw.titleText('Publicá', dw.textColor, TextAlign.left),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                // padding: const EdgeInsets.all(30),
                                width: 70,
                                height: 100,
                                decoration:
                                    BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Icon(Icons.image, color: dw.textColor)),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: dw.textFormField(sc.titleC, 'Titulo', true, 30, TextAlign.left, 1)),
                                SizedBox(
                                    width: double.infinity,
                                    child: dw.textFormField(sc.descC, 'Descripción', false, 20, TextAlign.left, 3)),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: dw.actionButton('Mandar', Icons.send, () {
                    if (sc.titleC.text.isNotEmpty && sc.descC.text.isNotEmpty && sc.coverImage.value != null) {
                      Functions().sendBookProcess(sp);
                    }
                  }))
            ],
          ),
        ),
        isScrollControlled: false,
        ignoreSafeArea: false);
  }
}
