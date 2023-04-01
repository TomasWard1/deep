import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';
import '../helpers/SnackbarManager.dart';
import 'ChooseUserType.dart';

class UserForm extends GetView<SpacesController> {
  final DeepWidgets dw = DeepWidgets();

  UserForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: DeepWidgets().bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: dw.titleText('Hey!', dw.textColor, TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.asset(
                          'assets/deepLogo.jpg',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 80, right: 50),
                      width: double.infinity,
                      child: dw.bodyText('Ya casi estamos para comenzar tu experiencia en Deep.', dw.textColor, 2)),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Form(
                      key: controller.userFormKey,
                      child: Column(
                        children: [
                          dw.profileImageSelector,
                          dw.textFormField(controller.fullNameController, '¿Cómo te llamas?', true, 25),
                          dw.textFormField(controller.pseudonymController, '¿Y tu pseudónimo?', false, 19),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                      width: double.infinity,
                      child: dw.actionButton('Continuar', Icons.done, () {
                        if (controller.userFormKey.currentState!.validate()) {
                          Get.to(() => ChooseUserType());
                        } else {
                          DialogManager().error('Fill in all fields');
                        }
                      }))
                ],
              ),
            ),
          )),
    );
  }
}
