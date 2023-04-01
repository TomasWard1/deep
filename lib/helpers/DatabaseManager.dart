import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';

import '../classes/UserClass.dart';

class DatabaseManager {
  DatabaseReference databaseRoot = FirebaseDatabase.instance.ref();
  Reference storageRoot = FirebaseStorage.instance.ref();

  SpacesController get sc => Get.find<SpacesController>();

  Future saveUser(User user) async {
    await databaseRoot.child('users').child(user.id).set(user.toJson());
  }

  Future<String> uploadImage(File image, String uid) async {
    TaskSnapshot t = await storageRoot.child('profile_images').child(uid).putFile(image);
    String imageUrl = await t.ref.getDownloadURL();
    return imageUrl;
  }

  getAllUsers() {
    print('getting all users');

    databaseRoot.child('users').onValue.listen((event) {
      Map userMap = event.snapshot.value as Map;

      List<User> l = userMap.entries.map((e) {
        return User.fromMap(e.value as Map, e.key as String);
      }).toList();
      sc.allUsers.value = l;
      sc.allUsers.refresh();

    });
  }
}
