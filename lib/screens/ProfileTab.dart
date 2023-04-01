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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(65),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                            image: (controller.currentUser.imageUrl != null)
                                ? DecorationImage(
                                    image: NetworkImage(controller.currentUser.imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                        child: (controller.currentUser.imageUrl != null)
                            ? Container()
                            : Icon(Icons.person, color: dw.textColor, size: 40),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                dw.headingText(controller.currentUser.fullName, dw.textColor),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: dw.bodyText(
                      '${controller.currentUser.pseudonym} - ${controller.currentUser.type.toString().split('.')[1]}',
                      dw.textColor,
                      1),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: dw.profileStats(),
                ),
                if (controller.currentUser.hasBooks)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 25, left: 5),
                    child: dw.headingText(
                      'Preliminares',
                      dw.textColor,
                    ),
                  ),
                Expanded(child: dw.preliminares()),
              ],
            ),
          ),
        ));
  }
}
