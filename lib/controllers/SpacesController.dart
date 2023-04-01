import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/SpaceClass.dart';

class SpacesController extends GetxController {
  RxList<Space> spaces = RxList<Space>([]);

  @override
  void onInit() {
    addTestSpaces();
    super.onInit();
  }

  addTestSpaces() {
    Space misterio = Space(
        name: 'Misterio',
        color: Colors.purple.shade300,
        description:
            'una obra de ficción que se enfoca en la resolución de un crimen o misterio a través de la investigación y la deducción',
        id: '1',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']);

    Space drama = Space(
        name: 'Drama',
        color: Colors.red.shade300,
        description:
            'una obra de teatro que representa la vida humana y las relaciones entre personajes a través del diálogo y la acción',
        id: '2',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g']);

    Space fantasia = Space(
        name: 'Fantasía',
        color: Colors.green.shade300,
        description: 'un género que presenta un mundo imaginario con elementos mágicos y sobrenaturales',
        id: '3',
        imageUrl: '',
        participantIds: ['e', 'f', 'g', 'h', 'i']);

    Space thriller = Space(
        name: 'Thriller',
        color: Colors.teal.shade300,
        description:
            'un género que se enfoca en crear suspense y tensión emocional en el lector a través de una trama llena de giros y sorpresas',
        id: '4',
        imageUrl: '',
        participantIds: ['a', 'd', 'e']);

    Space cuentos = Space(
        name: 'Cuentos',
        color: Colors.lime.shade300,
        description: 'una obra de ficción breve que narra una historia con un inicio, un nudo y un desenlace',
        id: '5',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']);

    Space historia = Space(
        name: 'Historia',
        color: Colors.orange.shade300,
        description:
            'un relato que documenta y analiza eventos pasados en la sociedad, la política, la cultura y otros aspectos de la vida humana',
        id: '6',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']);

    spaces.value = [misterio, drama, fantasia, thriller, cuentos, historia];
    spaces.refresh();
  }
}
