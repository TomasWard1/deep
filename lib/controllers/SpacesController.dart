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
        description: 'Novelas misteriosas que te atrapan sin que te lo esperes.',
        id: '1',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']);

    Space drama = Space(
        name: 'Drama',
        color: Colors.red.shade300,
        description: 'Entrar solo si queres llorar.',
        id: '2',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g']);

    Space fantasia = Space(
        name: 'Fantasía',
        color: Colors.green.shade300,
        description: 'Un mundo sin fronteras. Las obras aca no tienen limite.',
        id: '3',
        imageUrl: '',
        participantIds: ['e', 'f', 'g', 'h', 'i']);

    Space thriller = Space(
        name: 'Thriller',
        color: Colors.teal.shade300,
        description: 'Como dijo Michael Jackson: \'With such confusions don\'t it make you wanna scream?\'',
        id: '4',
        imageUrl: '',
        participantIds: ['a', 'd', 'e']);

    Space cuentos = Space(
        name: 'Cuentos',
        color: Colors.lime.shade300,
        description: 'Cuentos cortos de menos de 1500 palabras.',
        id: '5',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']);

    Space historia = Space(
        name: 'Historia',
        color: Colors.orange.shade300,
        description:
            'Ensayos, biografias, y investigaciones actuales sobre la historia de la humanidad.',
        id: '6',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']);

    spaces.value = [misterio, drama, fantasia, thriller, cuentos, historia];
    spaces.refresh();
  }
}
