import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/classes/ContributionClass.dart';

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
        participantIds: [
          'a',
          'b',
          'c',
          'd',
          'e',
          'f',
          'g',
          'h',
          'i'
        ],
        contributors: {
          'a': Contribution(totalBooks: 10, totalAmount: 500),
          'b': Contribution(totalBooks: 7, totalAmount: 345),
          'c': Contribution(totalBooks: 5, totalAmount: 233),
          'd': Contribution(totalBooks: 3, totalAmount: 120),
          'e': Contribution(totalBooks: 1, totalAmount: 10)
        });

    Space drama = Space(
        name: 'Drama',
        color: Colors.red.shade300,
        description: 'Entrar solo si queres llorar.',
        id: '2',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
        contributors: {});

    Space fantasia = Space(
        name: 'Fantasía',
        color: Colors.green.shade300,
        description: 'Un mundo sin fronteras. Las obras aca no tienen limite.',
        id: '3',
        imageUrl: '',
        participantIds: ['e', 'f', 'g', 'h', 'i'],
        contributors: {});

    Space thriller = Space(
        name: 'Thriller',
        color: Colors.teal.shade300,
        description: 'Como dijo Michael Jackson: \'With such confusions don\'t it make you wanna scream?\'',
        id: '4',
        imageUrl: '',
        participantIds: ['a', 'd', 'e'],
        contributors: {});

    Space cuentos = Space(
        name: 'Cuentos',
        color: Colors.lime.shade300,
        description: 'Cuentos cortos de menos de 1500 palabras.',
        id: '5',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
        contributors: {});

    Space historia = Space(
        name: 'Historia',
        color: Colors.orange.shade300,
        description: 'Ensayos, biografias, y investigaciones actuales sobre la historia de la humanidad.',
        id: '6',
        imageUrl: '',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
        contributors: {});

    spaces.value = [misterio, drama, fantasia, thriller, cuentos, historia];
    spaces.refresh();
  }
}
