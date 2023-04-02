import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackitba/classes/BookClass.dart';
import 'package:hackitba/classes/ContributionClass.dart';
import 'package:hackitba/helpers/DatabaseManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../classes/SpaceClass.dart';
import '../classes/UserClass.dart';
import '../helpers/Web3Manager.dart';

enum UnitType { Horas, Ejemplares }

class SpacesController extends GetxController {
  RxList<Space> spaces = RxList<Space>([]);

  //variables de detalle de publicar
  Rx<UnitType> publishingUnitType = Rx<UnitType>(UnitType.Ejemplares);
  RxInt typeIndex = RxInt(0);
  final TextEditingController precioUnitC = TextEditingController();
  final TextEditingController cantidadUnitC = TextEditingController();

  //variables para detalle de fundear
  final TextEditingController fundAmountC = TextEditingController();

//otras
  final RxString uriGlobal = RxString('');
  RxInt navIndex = 0.obs;
  RxInt stepIndex = 0.obs;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController pseudonymController = TextEditingController();
  String accountId = '';
  Rxn<File> profileImage = Rxn<File>(null);
  final userFormKey = GlobalKey<FormState>();
  RxBool loading = false.obs;
  RxList<User> allUsers = RxList<User>([]);
  RxList<Book> allBooks = RxList<Book>([]);
  String uidForLogin = '38c501a7-8e47-4da9-b3fe-dae5575ed9f1';
  Rxn<Space> currentSpace = Rxn<Space>();

  Web3Controller get wc => Get.find<Web3Controller>();

  //variables para publicar libro
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  Rxn<File> coverImage = Rxn<File>(null);

  @override
  void onInit() async {
    addTestSpaces();
    DatabaseManager().getAllUsers();
    DatabaseManager().getAllBooks();

    await wc.init();
    //setOnboarding(true);
    super.onInit();
  }

  User get currentUser {
    return allUsers.singleWhere((element) => element.id == uidForLogin);
  }

  resetPublishingFields() {
    titleC.clear();
    descC.clear();
    typeIndex.value = 0;
    precioUnitC.clear();
    cantidadUnitC.clear();
    coverImage.value = null;
    coverImage.refresh();
  }

  setLoading(bool value) {
    loading.value = value;
  }

  addTestSpaces() {
    Space misterio = Space(
      name: 'Misterio',
      color: Colors.purple.shade300,
      description: 'Novelas misteriosas que te atrapan sin que te lo esperes.',
      id: '1',
      imageUrl: '',
      participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
      contributors: {
        'a': Contribution(totalBooks: 10, totalAmount: 500),
        'b': Contribution(totalBooks: 7, totalAmount: 345),
        'c': Contribution(totalBooks: 5, totalAmount: 233),
        'd': Contribution(totalBooks: 3, totalAmount: 120),
        'e': Contribution(totalBooks: 1, totalAmount: 10)
      },
    );

    Space drama = Space(
      name: 'Drama',
      color: Colors.red.shade300,
      description: 'Entrar solo si queres llorar.',
      id: '2',
      imageUrl: 'j',
      participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
      contributors: {},
    );

    Space fantasia = Space(
      name: 'Fantasía',
      color: Colors.green.shade300,
      description: 'Un mundo sin fronteras. Las obras aca no tienen limite.',
      id: '3',
      imageUrl: 'k',
      participantIds: ['e', 'f', 'g', 'h', 'i'],
      contributors: {},
    );

    Space thriller = Space(
      name: 'Thriller',
      color: Colors.teal.shade300,
      description: 'Como dijo Michael Jackson: \'With such confusions don\'t it make you wanna scream?\'',
      id: '4',
      imageUrl: 'l',
      participantIds: ['a', 'd', 'e'],
      contributors: {},
    );

    Space cuentos = Space(
      name: 'Cuentos',
      color: Colors.lime.shade300,
      description: 'Cuentos cortos de menos de 1500 palabras.',
      id: '5',
      imageUrl: 'm',
      participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
      contributors: {},
    );

    Space historia = Space(
      name: 'Historia',
      color: Colors.orange.shade300,
      description: 'Ensayos, biografias, y investigaciones actuales sobre la historia de la humanidad.',
      id: '6',
      imageUrl: 'n',
      participantIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
      contributors: {},
    );

    spaces.value = [misterio, drama, fantasia, thriller, cuentos, historia];
    spaces.refresh();
  }

  setOnboarding(bool set) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboard', set);
  }

  Future<bool> didOnboard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? didOnboard = prefs.getBool('onboard');
    print(didOnboard);
    return didOnboard ?? false;
  }
}
