import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hackitba/classes/BookClass.dart';
import 'package:hackitba/controllers/SpacesController.dart';
import 'package:hackitba/helpers/DatabaseManager.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'DialogManager.dart';

class Web3Controller extends GetxController {
  SpacesController get sc => Get.find<SpacesController>();

  //web3 vars
  late Client httpClient;
  late Web3Client ethClient;

  late Credentials _credentials;

  //functions and vars from spaceContract
  late ContractFunction _listItem;
  late ContractFunction _fundBook;
  late ContractFunction _withdrawProceeds;
  late ContractFunction _likeBook;
  late ContractFunction _dislikeBook;
  late ContractFunction _getListing;
  late ContractFunction _getProceeds;
  late ContractFunction _getContributorAmountFunded;
  late ContractFunction _getContributors;

  //events
  late ContractEvent _itemListedEvent;
  late ContractEvent _bookFundedEvent;
  late ContractEvent _bookRemovedEvent;
  late ContractEvent _bookLiked;
  late ContractEvent _bookDisliked;

  //contract
  late DeployedContract spaceContract;

  //functions and vars from bookNFTContract
  late DeployedContract bookNFTContract;
  late ContractFunction _mintNft;
  late ContractFunction _modifyTokenURI;
  late ContractFunction _getTokenCounter;

  //events
  late ContractEvent _nftMintedEvent;

  EthereumAddress get myEthAddress => EthereumAddress.fromHex(myAddress);

  String get myAddress => _testPublicKey;
  final String _testPublicKey = '0x17d1F86a0Db1d949635B4eE2Ef2f2BF35332c789';
  final String _testPrivateKey = '59bb2d62bc891c38b4c9f4eac4433c49583d0343184aa7bf198047e2ed28b099';

  init() async {
    httpClient = Client();
    ethClient = Web3Client('https://sepolia.infura.io/v3/cee3051950074064af65e2244b0cc0b2', httpClient);
    spaceContract = await loadSpaceContract();
    bookNFTContract = await loadBookNFTContract();
    listenToEvents();
  }

  Future<DeployedContract> loadSpaceContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = '0x51FF5920E31BD0e2944d4DBC18DC413d779164B0';
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'Space'), EthereumAddress.fromHex(contractAddress));

    //extract all the functions
    _listItem = contract.function("listItem");
    _fundBook = contract.function("fundBook");
    _withdrawProceeds = contract.function("withdrawProceeds");
    _likeBook = contract.function("likeBook");
    _dislikeBook = contract.function("dislikeBook");
    _getListing = contract.function("getListing");
    _getProceeds = contract.function("getProceeds");
    _getContributorAmountFunded = contract.function("getContributorAmountFunded");

    //extract the events
    _itemListedEvent = contract.event('ItemListed');
    _bookFundedEvent = contract.event('BookFunded');
    _bookRemovedEvent = contract.event('BookRemoved');
    _bookLiked = contract.event('BookLiked');
    _bookDisliked = contract.event('BookDisliked');

    getCredentials();

    return contract;
  }

  Future<DeployedContract> loadBookNFTContract() async {
    String abi = await rootBundle.loadString('assets/abi2.json');
    String contractAddress = '0xF34F226BFFCadF0CB92f59514eDe055ea97caE3C';
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'BookNft'), EthereumAddress.fromHex(contractAddress));

    //extract all the functions
    _mintNft = contract.function("mintNft");
    _modifyTokenURI = contract.function("modifyTokenURI");
    _getTokenCounter = contract.function("getTokenCounter");
    _nftMintedEvent = contract.event('NftMinted');

    return contract;
  }

  getCredentials() {
    _credentials = EthPrivateKey.fromHex(_testPrivateKey);
  }

  listItem(EthereumAddress nftAddress, int tokenId, int units, int unitPrice) async {
    /*
     address nftAddress,
        uint256 tokenId,
        uint256 units,
        uint256 unitPrice
     */
    int chainId = (await ethClient.getChainId()).toInt();
    String response = await ethClient.sendTransaction(
      _credentials,
      chainId: chainId,
      Transaction.callContract(
        contract: spaceContract,
        function: _listItem,
        parameters: [
          nftAddress,
          BigInt.parse(tokenId.toString()),
          BigInt.parse(units.toString()),
          BigInt.parse(unitPrice.toString())
        ],
      ),
    );

    String imageUrl = await DatabaseManager().uploadBookImage(sc.coverImage.value!, tokenId.toString());
    sc.currentSpace.refresh();
    Book b = Book(
        id: tokenId.toString(),
        title: sc.titleC.text,
        description: sc.descC.text,
        authorId: myEthAddress.hex,
        space: sc.spaces.singleWhere((element) => element.name == 'Misterio'),
        likes: 0,
        coverImageUrl: imageUrl,
        units: units,
        unitPrice: unitPrice,
        unitType: sc.publishingUnitType.value);

    //hosteamos algunos datos no sensible en una base centralizada para facil acceso y reduccion de transacciones
    await DatabaseManager().saveBook(b);
    Get.back();
    sc.resetPublishingFields();

    //pueden agarrar el transaction id del response y ver en etherscan que el contrato funciono para emitir el evento
    print(response);
  }

  listenToEvents() {
    //nft minted
    ethClient.events(FilterOptions.events(contract: bookNFTContract, event: _nftMintedEvent)).take(1).listen((event) {
      final decoded = _nftMintedEvent.decodeResults(event.topics ?? [], event.data ?? '');

      int tokenId = (decoded[0] as BigInt).toInt();
      sc.setLoading(false);
      Get.back();
      DialogManager().askListingDetails(tokenId);
    });
  }

  mintBookNft(String encoded) async {
    /*
    string memory tokenURI
     */
    int chainId = (await ethClient.getChainId()).toInt();

    String response = await ethClient.sendTransaction(
      _credentials,
      chainId: chainId,
      Transaction.callContract(
        contract: bookNFTContract,
        function: _mintNft,
        parameters: [encoded],
      ),
    );

    //pueden agarrar el transaction id del response y ver en etherscan que el contrato funciono para emitir el evento
    print(response);
  }

  fundBook(EthereumAddress nftAddress, int tokenId, int units, int priceInEth) async {
    /*
        address nftAddress,
        uint256 tokenId,
        uint256 units
     */

    int chainId = (await ethClient.getChainId()).toInt();
    print(BigInt.parse((priceInEth * 1000000000000000000).toString()));
    //llamar a la funcion
    String response1 = await ethClient.sendTransaction(
      _credentials,
      chainId: chainId,
      Transaction.callContract(
        contract: spaceContract,
        function: _fundBook,
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        parameters: [
          bookNFTContract.address,
          BigInt.parse(tokenId.toString()),
          BigInt.parse(units.toString()),
        ],
      ),
    );

    print(response1);
    //hacer la transaccion
    // String response2 = await ethClient.sendTransaction(
    //   _credentials,
    //   chainId: chainId,
    //   Transaction(to: nftAddress, from: myEthAddress, value: EtherAmount.fromInt(EtherUnit.ether, priceInEth)),
    // );
    // print(response2);

    sc.fundAmountC.clear();
    Get.back();
    DialogManager().success('Successfully sent $priceInEth ETH');
  }

  BigInt ethToWei(int ethValue) {
    return BigInt.parse((ethValue * pow(10, 18)).round().toString());
  }
}
