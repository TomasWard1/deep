import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';

import '../classes/BookClass.dart';
import '../classes/UserClass.dart';

class DatabaseManager {
  DatabaseReference databaseRoot = FirebaseDatabase.instance.ref();
  Reference storageRoot = FirebaseStorage.instance.ref();

  SpacesController get sc => Get.find<SpacesController>();

  Future saveUser(User user) async {
    await databaseRoot.child('users').child(user.id).set(user.toJson());
  }

  Future<String> uploadUserImage(File image, String uid) async {
    TaskSnapshot t = await storageRoot.child('profile_images').child(uid).putFile(image);
    String imageUrl = await t.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadBookImage(File image, String bookId) async {
    TaskSnapshot t = await storageRoot.child('book_images').child(bookId).putFile(image);
    String imageUrl = await t.ref.getDownloadURL();
    return imageUrl;
  }

  getAllUsers() {
    databaseRoot.child('users').onValue.listen((event) {
      Map userMap = event.snapshot.value as Map;
      List<User> l = userMap.entries.map((e) {
        return User.fromMap(e.value as Map, e.key as String);
      }).toList();
      sc.allUsers.value = l;
      sc.allUsers.refresh();
    });
  }

  getAllBooks() {
    databaseRoot.child('books').onValue.listen((event) {
      Map bookMap = event.snapshot.value as Map;
      List<Book> l = bookMap.entries.map((e) {
        return Book.fromMap(e.value as Map, e.key as String);
      }).toList();
      sc.allBooks.value = l;
      sc.allBooks.refresh();
    });
  }

  Future saveBook(Book b) async {
    await databaseRoot.child('books').child(b.id).set(b.toJson());
  }
}
