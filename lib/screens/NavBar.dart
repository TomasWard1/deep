import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/screens/SpacesTab.dart';

import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';
import 'ProfileTab.dart';

class NavBar extends GetView<SpacesController> {
  final DeepWidgets dw = DeepWidgets();

  NavBar({super.key});

  bool get onSpace => controller.navIndex.value == 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
            backgroundColor: dw.bgColor,
            extendBody: true,
            body: (onSpace) ? const SpacesTab() : const ProfileTab(),
            bottomNavigationBar:
                BottomNavigationBar(
                  onTap: (val) {
                    controller.navIndex.value = val;
                  },
                    currentIndex: controller.navIndex.value,
                    selectedItemColor: dw.textColor, backgroundColor: dw.accentColor, items: [
              BottomNavigationBarItem(
                icon: Icon((onSpace) ? Icons.workspaces : Icons.workspaces_outline, color: dw.textColor),
                label: 'Spaces',
              ),
              BottomNavigationBarItem(
                  icon: Icon((onSpace) ? Icons.person_outline : Icons.person, color: dw.textColor), label: 'Profile'),
            ])),
      ),
    );
  }
}
