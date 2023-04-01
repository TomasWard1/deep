import 'BookClass.dart';
import 'SpaceClass.dart';

class User {
  final String id;
  final String fullName;
  final String pseudonym;
  final String bio;
  final String? imageUrl;
  final List<Book>? books;
  final List<Space> spaces;

  User(
      {required this.id,
      required this.pseudonym,
      required this.fullName,
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
