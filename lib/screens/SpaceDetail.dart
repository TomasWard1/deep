import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/SpaceClass.dart';
import '../controllers/SpacesController.dart';
import '../helpers/DeepWidgets.dart';
import '../helpers/DialogManager.dart';

class SpaceDetail extends GetView<SpacesController> {
  final String id;

  const SpaceDetail({super.key, required this.id});

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
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                      child: Icon(Icons.workspaces_outlined, size: 35, color: DeepWidgets().textColor),
                      //Image.asset('assets/deepLogo.jpg',width: 50,height: 50,),
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
        ));
  }
}
