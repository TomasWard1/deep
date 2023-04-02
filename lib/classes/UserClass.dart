import 'BookClass.dart';
import 'SpaceClass.dart';

enum UserType { Autor, Lector, Editor }

class User {
  final String id;
  final String fullName;
  final String pseudonym;
  final String? imageUrl;
  final List<Book>? books;
  final List<Space> spaces;
  final UserType type;

  int get spaceCount => spaces.length;

  int get bookCount => books?.length ?? 0;

  int get totalContributions => 100; //hacer esta cuenta

  bool get isAuthor => type == UserType.Autor;

  bool get hasBooks => bookCount > 0;

  User(
      {required this.id,
      required this.pseudonym,
      required this.fullName,
      required this.type,
      required this.imageUrl,
      required this.books,
      required this.spaces});

  toJson() => {
        'id': id,
        'name': fullName,
        'pseudonym': pseudonym,
        'image_url': imageUrl,
        'type': type.toString(),
      };

  static User fromMap(Map map, String key) {
    return User(
        id: key,
        pseudonym: map['pseudonym'] as String,
        fullName: map['name'] as String,
        type: UserType.values.singleWhere((element) => element.toString() == map['type'] as String),
        imageUrl: map['image_url'],
        books: [],
        spaces: []);
  }

  //author getters
  int totalLikesForSpace(Space s) {
    List<Book> booksForSpace = books!.where((book) => book.space == s).toList();
    return booksForSpace.fold(0, (previousValue, element) => previousValue += element.likes);
  }
}
