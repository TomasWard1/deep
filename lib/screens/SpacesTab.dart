import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/SpaceClass.dart';
import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';

class SpacesTab extends GetView<SpacesController> {
  const SpacesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: DeepWidgets().titleText('Spaces', DeepWidgets().textColor, TextAlign.left)),
            ],
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 50),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: controller.spaces.length,
                itemBuilder: (c, i) {
                  Space s = controller.spaces[i];
                  return DeepWidgets().spaceListTile(s);
                }),
          )
        ],
      ),
    );
  }
}
