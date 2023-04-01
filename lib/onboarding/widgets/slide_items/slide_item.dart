/*
En este archivo está el widget que se encarga de mostrar cada slide
*/

import 'package:flutter/cupertino.dart';
import 'package:deep_prueba/constants/constants.dart';
import 'package:deep_prueba/model/slider.dart';

class SlideItem extends StatelessWidget {
  final int index;
  const SlideItem(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    // Este widget es el que se encarga de mostrar cada slide
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          // Contenedor que contiene la imagen del slide
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(sliderArrayList[index].sliderImageUrl))),
        ),
        const SizedBox(
          height: 60.0,
        ),
        Text(
          // Texto que contiene el título del slide
          sliderArrayList[index].sliderHeading,
          style: const TextStyle(
            fontFamily: Constants.NUNITO,
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Center(
          // Texto que contiene la descripción del slide
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index].sliderSubHeading,
              style: const TextStyle(
                fontFamily: Constants.NUNITO,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
