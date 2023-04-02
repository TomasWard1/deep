import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/SpaceClass.dart';
import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';
import '../helpers/DialogManager.dart';

class SpaceDetail extends GetView<SpacesController> {
  final String id;
  final String imageUrl;

  const SpaceDetail({super.key, required this.id,required this.imageUrl});

  Space get space => controller.spaces.singleWhere((element) => element.id == id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: (controller.currentUser.isAuthor)
            ? FloatingActionButton.extended(
                backgroundColor: DeepWidgets().accentColor,
                onPressed: () {
                  DialogManager().listItem(space);
                },
                label: Text('Publicar', style: TextStyle(color: DeepWidgets().textColor)),
                icon: Icon(Icons.bookmark_add_outlined, color: DeepWidgets().textColor))
            : null,
        backgroundColor: DeepWidgets().bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black12,
                          backgroundImage: AssetImage(imageUrl),
                        ),
                      ),
                      Expanded(
                          child: Hero(
                              tag: id,
                              child: DeepWidgets().titleText(space.name, DeepWidgets().textColor, TextAlign.left))),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: DeepWidgets().topContributors(space),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: DeepWidgets().topAuthors(space),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 20, left: 5, bottom: 10),
                              width: double.infinity,
                              child: DeepWidgets().headingText('Books', DeepWidgets().textColor)),
                          DeepWidgets().bookList(space)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
