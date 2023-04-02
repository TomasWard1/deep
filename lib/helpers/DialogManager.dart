import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/helpers/DeepWidgets.dart';

import '../classes/BookClass.dart';
import '../classes/SpaceClass.dart';
import '../controllers/SpacesController.dart';
import 'Functions.dart';
import 'Web3Manager.dart';

class DialogManager {
  final DeepWidgets dw = DeepWidgets();

  SpacesController get sc => Get.find<SpacesController>();

  Web3Controller get wc => Get.find<Web3Controller>();

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
        GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
          },
          child: Obx(
            () => Container(
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
                                  GestureDetector(
                                    onTap: () {
                                      Functions().pickImage(false);
                                    },
                                    child: Obx(
                                      () => Container(
                                        margin: const EdgeInsets.only(right: 15),
                                        // padding: const EdgeInsets.all(30),
                                        width: 70,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(10),
                                            image: (sc.coverImage.value != null)
                                                ? DecorationImage(
                                                    image: FileImage(sc.coverImage.value!), fit: BoxFit.fill)
                                                : null),
                                        child: (sc.coverImage.value != null)
                                            ? null
                                            : Center(child: Icon(Icons.image, color: dw.textColor)),
                                      ),
                                    ),
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
                  if (sc.loading.value) ...[
                    CircularProgressIndicator(color: dw.accentColor),
                    dw.bodyText('Cargando a blockchain...', dw.textColor, 1)
                  ] else ...[
                    SizedBox(
                        width: double.infinity,
                        child: dw.actionButton('Mandar', Icons.send, () {
                          if (sc.titleC.text.isNotEmpty && sc.descC.text.isNotEmpty && sc.coverImage.value != null) {
                            Functions().sendBookProcess(s);
                          } else {
                            error('Completar todo');
                          }
                        }))
                  ]
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: false,
        ignoreSafeArea: false);
  }

  needToConnectWallet() {
    Get.showSnackbar(GetSnackBar(
      title: 'Error',
      message: 'Please connect Wallet',
      backgroundColor: Colors.red,
      mainButton: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GestureDetector(
          onTap: () {
            //Get.find<Web3Controller>().loginWithMetamask();
            //Functions().loginWithMetamask(true);
          },
          child: dw.headingText('Go', Colors.white),
        ),
      ),
    ));
  }

  void askListingDetails(int tokenId) {
    Get.bottomSheet(
        GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
          },
          child: Obx(
            () => Container(
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
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(Icons.list, color: dw.textColor, size: 40),
                        ),
                        dw.titleText('Detalles', dw.textColor, TextAlign.left),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Obx(() {
                        bool esEjemplares = sc.typeIndex.value == 0;

                        return Column(children: [
                          SizedBox(
                              width: double.infinity,
                              child: CupertinoSlidingSegmentedControl<int>(
                                backgroundColor: dw.accentColor,
                                thumbColor: dw.textColor,
                                padding: const EdgeInsets.all(8),
                                groupValue: sc.typeIndex.value,
                                children: {
                                  0: Container(
                                    child: Text(
                                      'Ejemplares',
                                      style: TextStyle(fontSize: 17, color: (esEjemplares) ? dw.bgColor : dw.textColor),
                                    ),
                                  ),
                                  1: Container(
                                    child: Text(
                                      'Horas',
                                      style: TextStyle(fontSize: 17, color: (esEjemplares) ? dw.textColor : dw.bgColor),
                                    ),
                                  ),
                                },
                                onValueChanged: (value) {
                                  sc.typeIndex.value = value!;
                                },
                              )),
                          Container(
                              margin: const EdgeInsets.only(top: 30),
                              width: double.infinity,
                              child: dw.headingText(
                                  (esEjemplares) ? 'Precio por ejemplar' : 'Precio por hora (ETH)', dw.textColor)),
                          dw.textFormField(sc.precioUnitC, 'Ingresar...', false, 16, TextAlign.left, 1),
                          Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: dw.headingText(
                                  (esEjemplares) ? 'Cantidad de ejemplares' : 'Cantidad de horas', dw.textColor)),
                          dw.textFormField(sc.cantidadUnitC, 'Ingresar...', false, 16, TextAlign.left, 1)
                        ]);
                      }),
                    ),
                  ),
                  if (sc.loading.value) ...[
                    CircularProgressIndicator(color: dw.accentColor),
                    dw.bodyText('Cargando a blockchain...', dw.textColor, 1)
                  ] else ...[
                    SizedBox(
                        width: double.infinity,
                        child: dw.actionButton('Terminar', Icons.done, () async {
                          if (sc.cantidadUnitC.text.isNotEmpty && sc.precioUnitC.text.isNotEmpty) {
                            sc.setLoading(true);
                            int units = int.parse(sc.cantidadUnitC.text);
                            int unitPrice = int.parse(sc.precioUnitC.text);
                            await wc.listItem(wc.bookNFTContract.address.hex, tokenId, units, unitPrice);
                            sc.setLoading(false);
                          } else {
                            error('Completar todo');
                          }
                        }))
                  ]
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: false,
        ignoreSafeArea: false);
  }
}
