import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hackitba/controllers/SpacesController.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Web3Manager {
  //general vars
  String sepoliaRpcUrl = 'https://eth-sepolia.g.alchemy.com/v2/aIn5jBhiYhnOdKOqlf0DLtM3cDLvIoX0';

  SpacesController get sc => Get.find<SpacesController>();

  //web3 vars
  late Client httpClient;
  late Web3Client ethClient;
  late Credentials _credentials; //creds of the deployer of the contract

  //functions and vars from contract
  late ContractFunction _listItem;
  late ContractFunction _fundBook;
  late ContractFunction _withdrawProceeds;
  late ContractFunction _likeBook;
  late ContractFunction _dislikeBook;
  late ContractFunction _getListing;
  late ContractFunction _getProceeds;
  late ContractFunction _getContributorAmountFunded;
  late ContractFunction _getContributors;
  late DeployedContract _spaceContract;
  late DeployedContract _bookNFTContract;

  EthereumAddress get myEthAddress => EthereumAddress.fromHex(myAddress);

  //require address!!!!
  String get myAddress => sc.sessionGlobal.value!.accounts.first;

  init() async {
    httpClient = Client();
    ethClient = Web3Client('https://sepolia.infura.io/v3/cee3051950074064af65e2244b0cc0b2', httpClient);
    _spaceContract = await loadContract();
  }

  Future<DeployedContract> loadContract() async {
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

    getCredentials();

    return contract;
  }

  getCredentials() {
    _credentials = EthPrivateKey.fromHex(myAddress);
  }

  listItem(String nftAddress, int tokenId, int units, int unitPrice) async {
    /*
     address nftAddress,
        uint256 tokenId,
        uint256 units,
        uint256 unitPrice
     */
    String response = await ethClient.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _spaceContract,
        function: _listItem,
        parameters: [nftAddress, tokenId, units, unitPrice],
      ),
    );

    print(response);
  }

  mintBook() {

  }
}
