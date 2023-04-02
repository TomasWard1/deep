import 'dart:convert';

import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';

import 'SpaceClass.dart';
import 'UserClass.dart';

class Book {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String coverImageUrl;
  final int likes;
  final int units;
  final int unitPrice;
  final Space space;

  Book(
      {required this.id,
      required this.units,
      required this.unitPrice,
      required this.title,
      required this.description,
      required this.authorId,
      required this.space,
      required this.likes,
      required this.coverImageUrl});

  toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'authorId': authorId,
        'space': space.id,
        'likes': likes,
        'cover_image_url': coverImageUrl,
        'units': units,
        'unit_price': unitPrice
      };

  SpacesController get sc => Get.find<SpacesController>();

  static Book fromMap(Map map, String key) {
    return Book(
      id: key,
      units: map['units'] as int,
      unitPrice: map['unit_price'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      authorId: map['authorId'] as String,
      space: Get.find<SpacesController>().spaces.singleWhere((element) => element.id == map['space'] as String),
      likes: map['likes'] as int,
      coverImageUrl: map['cover_image_url'] as String,
    );
  }

  User get author => sc.allUsers.singleWhere((author) => author.id == authorId);

  String encodeJsonBas64(Map j) {
    String encoded = base64.encode(utf8.encode(json.encode(j)));
    return encoded;
  }
}
