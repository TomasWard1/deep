import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/UserClass.dart';
import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';

class ChooseUserType extends GetView<SpacesController> {
  final DeepWidgets dw = DeepWidgets();

  ChooseUserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: DeepWidgets().bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(width: double.infinity, child: dw.titleText('Una cosa más...', dw.textColor, TextAlign.left)),
                SizedBox(width: double.infinity, child: dw.headingText('¿Qué rol cumplis?', dw.textColor)),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 30),
                  child: Row(
                    children: [
                      const Spacer(),
                      dw.cuadradoRol('assets/autor.png', 'Autor', UserType.Autor),
                      const Spacer(),
                      dw.cuadradoRol('assets/lector.png', 'Lector', UserType.Lector),
                      const Spacer(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    dw.cuadradoRol('assets/editores.png', 'Editor', UserType.Editor),
                    const Spacer()
                  ],
                ),
                const Spacer(),
                Obx(
                  () => Visibility(
                      visible: controller.loading.value, child: CircularProgressIndicator(color: dw.accentColor)),
                ),
                const Spacer(),
              ],
            ),
          ),
        ));
  }
//
}
