import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipfs_client_flutter/ipfs_client_flutter.dart';
import 'package:uuid/uuid.dart';

import '../classes/UserClass.dart';
import '../controllers/SpacesController.dart';
import '../screens/NavBar.dart';

class Functions {
  SpacesController get sc => Get.find<SpacesController>();

  Future saveProfileInfo(String fullName, String pseudonym, File? image,UserType type) async {
    String? imageUrl;
    String userId = const Uuid().v4();
    // if (image != null) {
    //   imageUrl = await uploadImageIPFS(image, userId);
    // }

    //replace id with wallet address
    User toAdd = User(
        id: userId,
        pseudonym: pseudonym,
        fullName: fullName,
        bio: '',
        imageUrl: imageUrl,
        books: [],
        spaces: [],
        type: type);
    sc.currentUser.value = toAdd;

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

  Future<String> uploadImageIPFS(File image, String userId) async {
    IpfsClient ipfsClient = IpfsClient(url: 'http://10.0.2.2:8000');
    String response1 = await ipfsClient.mkdir(dir: 'profile_images');
    print(response1);

    var response =
        await ipfsClient.write(dir: 'profile_images/sample.png', filePath: image.path, fileName: "sample.png");

    print(response);
    //
    // Response response2 = await ipfsClient.ls(dir: 'profile_images');
    // print(response2.body);
    return '';
  }
}
