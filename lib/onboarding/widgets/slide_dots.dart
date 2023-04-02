import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    // Este es el widget que se encarga de mostrar los puntos de la barra de progreso
    return AnimatedContainer(
      duration: const Duration(
          milliseconds:
              150), // Acá defino el tiempo que tarda en cambiar de color
      margin: const EdgeInsets.symmetric(
          horizontal: 3.3), // Acá defino el margen entre los puntos
      height:
          isActive ? 10 : 6, // Acá defino el alto del punto cuando está activo
      width:
          isActive ? 10 : 6, // Acá defino el ancho del punto cuando está activo
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : Colors.grey, // Acá defino el color del punto cuando está activo
        border: isActive
            ? Border.all(
                color: Color.fromRGBO(218, 170, 99, 1),
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ), // Acá defino el borde del punto cuando está activo
        borderRadius: BorderRadius.all(Radius.circular(12)), // Radio esquinas
      ),
    );
  }
}
