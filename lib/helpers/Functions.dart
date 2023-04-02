import 'dart:io';

import 'package:get/get.dart';
import 'package:hackitba/helpers/DatabaseManager.dart';
import 'package:hackitba/helpers/DialogManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../classes/BookClass.dart';
import '../classes/SpaceClass.dart';
import '../classes/UserClass.dart';
import '../controllers/SpacesController.dart';
import '../screens/NavBar.dart';
import 'Web3Manager.dart';

class Functions {
  SpacesController get sc => Get.find<SpacesController>();

  Web3Controller get wc => Get.find<Web3Controller>();

  Future saveProfileInfo(String fullName, String pseudonym, File? image, UserType type) async {
    sc.setLoading(true);
    String? imageUrl;
    String userId = sc.accountId;
    if (image != null) {
      imageUrl = await DatabaseManager().uploadUserImage(
        image,
        userId,
      );
    }

    //replace id with wallet address
    User toAdd = User(
        id: userId, pseudonym: pseudonym, fullName: fullName, imageUrl: imageUrl, books: [], spaces: [], type: type);

    await DatabaseManager().saveUser(toAdd);
    sc.uidForLogin = toAdd.id;
    sc.setLoading(false);
    Get.to(() => NavBar());
    //add user json to ipfs. For now, store locally
  }

  pickImage(bool profile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (profile) {
        sc.profileImage.value = File(image.path);
      } else {
        sc.coverImage.value = File(image.path);
      }
    }
  }

  // void loginWithMetamask(bool fromProfile) async {
  //   if (!wc.walletConnector.connected) {
  //     try {
  //       var session = await wc.walletConnector.createSession(
  //           chainId: 4,
  //           onDisplayUri: (uri) async {
  //             sc.uriGlobal.value = uri;
  //             await launchUrlString(uri, mode: LaunchMode.externalApplication);
  //           });
  //
  //       sc.sessionGlobal.value = session;
  //
  //       if (session.accounts.isNotEmpty) {
  //         print(session.accounts);
  //         sc.accountId = session.accounts[0];
  //
  //         if (!fromProfile) {
  //           await sc.setOnboarding(true);
  //           await Get.to(() => UserForm());
  //         }
  //         await wc.init();
  //       }
  //     } catch (exp) {
  //       print(exp);
  //     }
  //   }
  // }

  sendBookProcess(Space s) async {
    sc.setLoading(true);

    String bookId = const Uuid().v4();
    String imageUrl = await DatabaseManager().uploadBookImage(sc.coverImage.value!, bookId);

    Book toMint = Book(
        id: bookId,
        title: sc.titleC.text,
        description: sc.descC.text,
        authorId: sc.currentUser.id,
        space: s,
        likes: 0,
        coverImageUrl: imageUrl,
        units: 0,
        unitPrice: 0);

    Map j = toMint.toJson();
    print(j);

    String encoded = toMint.encodeJsonBas64(j);
    try {
      await wc.mintBookNft(encoded);
    } catch (e, s) {
      print(e);
      print(s);
      sc.setLoading(false);
      Get.back();
      DialogManager().error('Error minting NFT');
    }
  }
}
