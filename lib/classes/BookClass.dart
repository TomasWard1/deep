import 'dart:convert';

import 'SpaceClass.dart';

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

  String encodeJsonBas64(Map j) {
    String encoded = base64.encode(utf8.encode(json.encode(j)));
    return encoded;
  }
}
