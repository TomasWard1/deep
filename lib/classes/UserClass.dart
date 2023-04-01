import 'BookClass.dart';
import 'SpaceClass.dart';

class User {
  final String id;
  final String username;
  final String bio;
  final String? imageUrl;
  final List<Book>? books;
  final List<Space> spaces;

  User(
      {required this.id,
      required this.username,
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
