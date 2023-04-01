/*
En este archivo está la clase slider que tiene los atributos que usamos en cada silde
*/
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:deep_prueba/constants/constants.dart';

class ConnectWalletButton extends StatelessWidget {
  const ConnectWalletButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Conectar wallet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class Slider {
  // Esta clase es la que se encarga de crear los objetos que se usan en cada slide
  final String
      sliderImageUrl; // Acá defino el atributo que va a tener la imagen del slide
  final String
      sliderHeading; // Acá defino el atributo que va a tener el título del slide
  final String
      sliderSubHeading; // Acá defino el atributo que va a tener la descripción del slide

  Slider(
      {required this.sliderImageUrl, // Acá defino el constructor de la clase
      required this.sliderHeading,
      required this.sliderSubHeading});
}

final List<Slider> sliderArrayList = [
// Acá defino los objetos que se van a usar en cada slide
  Slider(
      sliderImageUrl: 'assets/images/slider_1.png',
      sliderHeading: Constants.TITULO1,
      sliderSubHeading: Constants.DESCRIPCION1),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: Constants.TITULO2,
      sliderSubHeading: Constants.DESCRIPCION2),
  Slider(
      sliderImageUrl: 'assets/images/slider_3.png',
      sliderHeading: Constants.TITULO3,
      sliderSubHeading: Constants.DESCRIPCION3),
  // Agregar botón de
  // Botón ConnectWalletButton // ARREGLAR ESTO
];
