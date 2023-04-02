import 'dart:ui';

import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';

import 'BookClass.dart';
import 'ContributionClass.dart';

class Space {
  //variables
  final String name;
  final String description;
  final String id;
  final String imageUrl;
  final List<String> participantIds;
  final Color color;

  // final List<Book> books;
  final Map<String, Contribution> contributors;

  //initialization
  Space(
      {required this.name,
      required this.description,
      required this.id,
      required this.color,
      // required this.books,
      required this.contributors,
      required this.imageUrl,
      required this.participantIds});

  //getters
  int get participantCount => participantIds.length;

  List<Book> get books => Get.find<SpacesController>().allBooks.where((Book e) => e.space.id == id).toList();
}
