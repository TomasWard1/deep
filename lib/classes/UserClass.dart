import 'BookClass.dart';
import 'SpaceClass.dart';

enum UserType { Autor, Lector, Editor }

class User {
  final String id;
  final String fullName;
  final String pseudonym;
  final String bio;
  final String? imageUrl;
  final List<Book>? books;
  final List<Space> spaces;
  final UserType type;

  User(
      {required this.id,
      required this.pseudonym,
      required this.fullName,
      required this.type,
      required this.bio,
      required this.imageUrl,
      required this.books,
      required this.spaces});

  //author getters
  int totalLikesForSpace(Space s) {
    List<Book> booksForSpace = books!.where((book) => book.space == s).toList();
    return booksForSpace.fold(0, (previousValue, element) => previousValue += element.likes);
  }
}
