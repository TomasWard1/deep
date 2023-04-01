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
}
