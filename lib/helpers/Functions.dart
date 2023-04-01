import 'dart:io';

import 'package:get/get.dart';
import 'package:hackitba/helpers/DatabaseManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipfs_client_flutter/ipfs_client_flutter.dart';
import 'package:uuid/uuid.dart';

import '../classes/UserClass.dart';
import '../controllers/SpacesController.dart';
import '../screens/NavBar.dart';

class Functions {
  SpacesController get sc => Get.find<SpacesController>();

  Future saveProfileInfo(String fullName, String pseudonym, File? image, UserType type) async {
    sc.setLoading(true);
    String? imageUrl;
    String userId = const Uuid().v4();
    if (image != null) {
      imageUrl = await DatabaseManager().uploadImage(
        image,
        userId,
      );
    }

    //replace id with wallet address
    User toAdd = User(
        id: userId, pseudonym: pseudonym, fullName: fullName, imageUrl: imageUrl, books: [], spaces: [], type: type);

    await DatabaseManager().saveUser(toAdd);
    sc.setLoading(false);
    Get.to(() => NavBar());
    //add user json to ipfs. For now, store locally
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      sc.profileImage.value = File(image.path);
    }
  }

}
