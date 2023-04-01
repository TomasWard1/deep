import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/classes/BookClass.dart';
import 'package:hackitba/classes/ContributionClass.dart';

import '../classes/SpaceClass.dart';

class SpacesController extends GetxController {
  RxList<Space> spaces = RxList<Space>([]);
  RxInt navIndex = 0.obs;

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
        },
        books: []);

    misterio.books.add(Book(
        id: '1',
        title: 'El Silencio de la Ciudad',
        description: 'Una ciudad queda en silencio después de una serie de extrañas desapariciones',
        authorId: 'r',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'La Habitación Vacía',
        description: 'Una mujer alquila una habitación en una casa encantada y comienza a sospechar que no está sola',
        authorId: 'a',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'La Puerta Abierta',
        description:
            'Una mujer regresa a su hogar después de estar ausente durante años y descubre que la puerta estaba abierta para ella',
        authorId: 'b',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'La Última Noche',
        description:
            'Una mujer desaparece después de una fiesta, y su esposo debe descubrir la verdad antes de que sea demasiado tarde',
        authorId: 'c',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'El Pasado Oculto',
        description:
            'Un hombre descubre secretos oscuros sobre su pasado mientras investiga la misteriosa muerte de su padre',
        authorId: 'd',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'La Sombra Negra',
        description:
            ' Un detective debe perseguir a un asesino en serie conocido como "La Sombra Negra" antes de que vuelva a atacar',
        authorId: 'e',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'El Secreto Mortal',
        description:
            'Un grupo de amigos descubren un oscuro secreto mientras investigan la extraña muerte de uno de ellos',
        authorId: 'f',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'El Misterio del Lago',
        description: 'Un cuerpo es encontrado en un lago y una detective debe descubrir quién lo mató y por qué',
        authorId: 'g',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'El Círculo Oscuro',
        description: 'Una joven se adentra en un círculo secreto de magia negra y comienza a temer por su vida',
        authorId: 'h',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    misterio.books.add(Book(
        id: '1',
        title: 'El Cuarto Cerrado',
        description:
            'Un asesinato ocurre en una habitación cerrada por dentro, y un detective debe descubrir cómo el asesino lo hizo.',
        authorId: 'i',
        space: misterio,
        likes: 100,
        coverImageUrl: ''));

    Space drama = Space(
        name: 'Drama',
        color: Colors.red.shade300,
        description: 'Entrar solo si queres llorar.',
        id: '2',
        imageUrl: 'j',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
        contributors: {},
        books: []);

    Space fantasia = Space(
        name: 'Fantasía',
        color: Colors.green.shade300,
        description: 'Un mundo sin fronteras. Las obras aca no tienen limite.',
        id: '3',
        imageUrl: 'k',
        participantIds: ['e', 'f', 'g', 'h', 'i'],
        contributors: {},
        books: []);

    Space thriller = Space(
        name: 'Thriller',
        color: Colors.teal.shade300,
        description: 'Como dijo Michael Jackson: \'With such confusions don\'t it make you wanna scream?\'',
        id: '4',
        imageUrl: 'l',
        participantIds: ['a', 'd', 'e'],
        contributors: {},
        books: []);

    Space cuentos = Space(
        name: 'Cuentos',
        color: Colors.lime.shade300,
        description: 'Cuentos cortos de menos de 1500 palabras.',
        id: '5',
        imageUrl: 'm',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
        contributors: {},
        books: []);

    Space historia = Space(
        name: 'Historia',
        color: Colors.orange.shade300,
        description: 'Ensayos, biografias, y investigaciones actuales sobre la historia de la humanidad.',
        id: '6',
        imageUrl: 'n',
        participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
        contributors: {},
        books: []);

    spaces.value = [misterio, drama, fantasia, thriller, cuentos, historia];
    spaces.refresh();
  }
}
