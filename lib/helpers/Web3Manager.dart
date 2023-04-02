import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';
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
  late DeployedContract _spaceContract;

  //functions and vars from bookNFTContract
  late DeployedContract bookNFTContract;
  late ContractFunction _mintNft;
  late ContractFunction _modifyTokenURI;
  late ContractFunction _getTokenCounter;

  //events
  late ContractEvent _nftMintedEvent;

  EthereumAddress get myEthAddress => EthereumAddress.fromHex(myAddress);

  String get myAddress => sc.accountId;
  final String _testPrivateKey = '59bb2d62bc891c38b4c9f4eac4433c49583d0343184aa7bf198047e2ed28b099';

  init() async {
    httpClient = Client();
    ethClient = Web3Client('https://sepolia.infura.io/v3/cee3051950074064af65e2244b0cc0b2', httpClient);
    _spaceContract = await loadSpaceContract();
    _bookNFTContract = await loadBookNFTContract();
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

  listItem(String nftAddress, int tokenId, int units, int unitPrice) async {
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
        contract: _spaceContract,
        function: _listItem,
        parameters: [nftAddress, tokenId, units, unitPrice],
      ),
    );
    print(response);
  }

  listenToEvents() {
    //nft minted
    ethClient.events(FilterOptions.events(contract: bookNFTContract, event: _nftMintedEvent)).take(1).listen((event) {
      final decoded = _nftMintedEvent.decodeResults(event.topics ?? [], event.data ?? '');

      print(event);
      print(decoded);

      int tokenId = decoded[0] as int;
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
    print(response);

    //getNFT address

    // String response2 = await listItem(nftAddress, tokenId, units, unitPrice);
    // print(response2);
  }
}
