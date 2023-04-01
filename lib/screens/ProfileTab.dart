import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';

class ProfileTab extends GetView<SpacesController> {
  ProfileTab({super.key});

  final DeepWidgets dw = DeepWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: dw.bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(width: double.infinity, child: dw.titleText('Perfil', dw.textColor, TextAlign.left)),
                const Spacer(),
                dw.headingText(controller.currentUser.fullName, dw.textColor)
              ],
            ),
          ),
        ));
  }
}
