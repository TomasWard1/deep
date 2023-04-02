/*
En este archivo está el widget que se encarga de mostrar cada slide
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackitba/helpers/DeepWidgets.dart';

import '../../../controllers/SpacesController.dart';
import '../../model/slider.dart';

class SlideItem extends StatelessWidget {
  final int index;
  final DeepWidgets dw = DeepWidgets();

  SpacesController get sc => Get.find<SpacesController>();

  SlideItem(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    // Este widget es el que se encarga de mostrar cada slide
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        Container(
          // Contenedor que contiene la imagen del slide
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(sliderArrayList[index].sliderImageUrl))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: dw.titleText(sliderArrayList[index].sliderHeading, dw.textColor, TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(
            sliderArrayList[index].sliderSubHeading,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 19, color: dw.textColor)),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
