// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ProfileNft is ERC721URIStorage {
    uint256 private s_tokenCounter;

    event NftMinted(uint256 indexed tokenId);

    constructor() ERC721("ProfileNft", "PNFT") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenURI) public {
        _safeMint(msg.sender, s_tokenCounter);
        _setTokenURI(s_tokenCounter, tokenURI);
        emit NftMinted(s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
