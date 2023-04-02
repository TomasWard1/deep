import 'dart:convert';

import 'SpaceClass.dart';

class Book {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String coverImageUrl;
  final int likes;
  final Space space;

  Book(
      {required this.id,
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
        'cover_image_url': coverImageUrl
      };

  String encodeJsonBas64(Map j) {
    String encoded = base64.encode(utf8.encode(json.encode(j)));
    return encoded;
  }
}
