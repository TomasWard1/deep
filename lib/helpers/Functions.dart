import 'dart:io';

import 'package:get/get.dart';
import 'package:hackitba/classes/BookClass.dart';
import 'package:hackitba/helpers/DatabaseManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../classes/SpaceClass.dart';
import '../classes/UserClass.dart';
import '../controllers/SpacesController.dart';
import '../screens/NavBar.dart';
import '../screens/UserForm.dart';
import 'Web3Manager.dart';

class Functions {
  SpacesController get sc => Get.find<SpacesController>();

  WalletConnect connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'Deep',
          description: 'La Editorial Descentralizada',
          url: 'https://walletconnect.org',
          icons: [
            'https://firebasestorage.googleapis.com/v0/b/deep-25ff5.appspot.com/o/deepLogo-removebg-preview.png?alt=media&token=7847ac11-0004-47d6-9ef6-5a03c7b0f7b2'
          ]));

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
        id: userId,
        pseudonym: pseudonym,
        fullName: fullName,
        imageUrl: imageUrl,
        books: [],
        spaces: [],
        type: type);

    await DatabaseManager().saveUser(toAdd);
    sc.uidForLogin = toAdd.id;
    sc.setLoading(false);
    Get.to(() => NavBar());
    //add user json to ipfs. For now, store locally
  }

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 11155111:
        return 'Sepolia Testnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      sc.profileImage.value = File(image.path);
    }
  }

  void loginWithMetamask(bool fromProfile) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(
            chainId: 4,
            onDisplayUri: (uri) async {
              sc.uriGlobal.value = uri;
              await launchUrlString(uri, mode: LaunchMode.externalApplication);
            });

        sc.sessionGlobal.value = session;

        if (session.accounts.isNotEmpty) {
          sc.accountId = session.accounts[0];

          if (!fromProfile) {
            await sc.setOnboarding(true);
            await Get.to(() => UserForm());
          }
          await Web3Manager().init();
        }
      } catch (exp) {
        print(exp);
      }
    }
  }

  sendBookProcess(Space s) async {
    String bookId = const Uuid().v4();
    String imageUrl = await DatabaseManager().uploadBookImage(sc.coverImage.value!, bookId);


    Book toMint = Book(id: bookId,
        title: sc.titleC.text,
        description: sc.descC.text,
        authorId: sc.currentUser.id,
        space: s,
        likes: 0,
        coverImageUrl: imageUrl);

    String encoded = toMint.encodeJsonBas64(toMint.toJson());

    await Web3Manager().mintBookNft(encoded);
  }
}
