// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/*
 * @title Space for crowdfunding books
 * @notice Space is a crowdfunding platform for publishing books
 * @dev Authors can list their books with a price and units (books or hours) to sell
 * @dev Readers can fund authors by units (books or hours)
 * @dev Authors can withdraw their proceeds
 * @dev Authors can cancel their listings
 * @dev Readers can like or dislike books
 */

error PriceMustBeAboveZero();
error UnitsMustBeAboveZero();
error IncorrectRange(
    address nftAddress,
    uint256 tokenId,
    uint256 unitsListed,
    uint256 unitsFunded
);
error AlreadyListed(address nftAddress, uint256 tokenId);
error NotListed(address nftAddress, uint256 tokenId);
error NotOwner();
error PriceNotMet(address nftAddress, uint256 tokenId, uint256 price, uint256 unit);
error NoProceeds();
error TransferFailed();

contract Space is ReentrancyGuard {
    // units: books or hours. Represent the limit of books or hours that the author wants to sell
    struct Listing {
        address author;
        uint256 units;
        uint256 unitPrice;
        uint256 likes;
    }

    /////////////////////
    //     Events     //
    ///////////////////
    event ItemListed(
        address indexed author,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 units,
        uint256 unitPrice
    );

    event ItemCanceled(
        address indexed author,
        address indexed nftAddress,
        uint256 indexed tokenId
    );

    event BookFunded(
        address indexed funder,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 units,
        uint256 unitPrice
    );

    event BookLiked(address nftAddress, uint256 tokenId);

    event BookDisliked(address nftAddress, uint256 tokenId);

    //////////////////////
    // Data Structures //
    ////////////////////

    // NFT Contract address => NFT TokenID (Book) => Listing (author, units , unitPrice, likes)
    mapping(address => mapping(uint256 => Listing)) private s_listings;

    // Author address => NFT address => NFT TokenId => amount earned
    mapping(address => mapping(address => mapping(uint256 => uint256))) private s_proceeds;

    // Funder address => amount funded
    mapping(address => uint256) private s_contributors;

    /////////////////////
    //   Modifiers    //
    ///////////////////

    modifier notListed(
        address nftAddress,
        uint256 tokenId,
        address owner
    ) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.unitPrice > 0) {
            revert AlreadyListed(nftAddress, tokenId);
        }
        _;
    }

    modifier isOwner(
        address nftAddress,
        uint256 tokenId,
        address spender
    ) {
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if (spender != owner) {
            revert NotOwner();
        }
        _;
    }

    modifier isListed(address nftAddress, uint256 tokenId) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.unitPrice <= 0) {
            revert NotListed(nftAddress, tokenId);
        }
        _;
    }

    ////////////////////
    // Main Functions //
    ////////////////////

    /*
     * @notice Method for listing Book NFT with units and unit price associated
     * @param nftAddress: Address of NFT contract
     * @param tokenId: Token ID of Book NFT
     * @param units: limit of units to be funded
     * @param unitPrice: sale price for each unit
     */
    function listItem(
        address nftAddress,
        uint256 tokenId,
        uint256 units,
        uint256 unitPrice
    )
        external
        notListed(nftAddress, tokenId, msg.sender)
        isOwner(nftAddress, tokenId, msg.sender)
    {
        if (unitPrice <= 0) {
            revert PriceMustBeAboveZero();
        }
        if (units <= 0) {
            revert UnitsMustBeAboveZero();
        }

        //Update listings (author, units, unitPrice, likes)
        s_listings[nftAddress][tokenId] = Listing(msg.sender, units, unitPrice, 0);
        //Initialize proceeds
        s_proceeds[msg.sender][nftAddress][tokenId] = 0;

        emit ItemListed(msg.sender, nftAddress, tokenId, unitPrice, units);
    }

    /*
     * @notice Method for funding authors by units
     * @param nftAddress: Address of NFT contract
     * @param tokenId: Token ID of Book NFT
     * @param units: number of units to be funded
     */

    function fundBook(
        address nftAddress,
        uint256 tokenId,
        uint256 units
    ) external payable nonReentrant isListed(nftAddress, tokenId) {
        Listing memory listedItem = s_listings[nftAddress][tokenId];

        // 0 < units funded <= listedItem.units
        if ((units > listedItem.units) || (units <= 0)) {
            revert IncorrectRange(nftAddress, tokenId, listedItem.units, units);
        }

        // check if value sent is equal to units * unitPrice
        if (msg.value != (listedItem.unitPrice * units)) {
            revert PriceNotMet(nftAddress, tokenId, listedItem.unitPrice, units);
        }

        // Update author's proceeds
        s_proceeds[listedItem.author][nftAddress][tokenId] += msg.value;
        //Update number of fund copies
        s_listings[nftAddress][tokenId].units -= units;

        // Update contributor
        s_contributors[msg.sender] += msg.value;

        // Re-asign value to listItem
        listedItem = s_listings[nftAddress][tokenId];
        if (listedItem.units == 0) {
            delete (s_listings[nftAddress][tokenId]);
        }

        emit BookFunded(msg.sender, nftAddress, tokenId, listedItem.unitPrice, units);
    }

    /*
     * @notice Method for canceling listing of a bookNft
     * @param nftAddress: Address of NFT contract
     * @param tokenId: Token ID of Book NFT
     */

    function cancelListing(
        address nftAddress,
        uint256 tokenId
    ) external isOwner(nftAddress, tokenId, msg.sender) isListed(nftAddress, tokenId) {
        delete (s_listings[nftAddress][tokenId]);
        emit ItemCanceled(msg.sender, nftAddress, tokenId);
    }

    /*
     * @notice Method for withdrawing proceeds of a bookNft
     * @param nftAddress: Address of NFT contract
     * @param tokenId: Token ID of Book NFT
     */
    function withdrawProceeds(address nftAddress, uint256 tokenId) external nonReentrant {
        uint256 proceeds = s_proceeds[msg.sender][nftAddress][tokenId];

        if (proceeds <= 0) {
            revert NoProceeds();
        }

        // Update proceeds of author associated with bookNft to 0
        s_proceeds[msg.sender][nftAddress][tokenId] = 0;
        // Transfer proceeds to author
        (bool success, ) = payable(msg.sender).call{value: proceeds}("");

        if (!success) {
            revert TransferFailed();
        }
    }

    function likeBook(address nftAddress, uint256 tokenId) public isListed(nftAddress, tokenId) {
        s_listings[nftAddress][tokenId].likes += 1;
        emit BookLiked(nftAddress, tokenId);
    }

    function dislikeBook(
        address nftAddress,
        uint256 tokenId
    ) public isListed(nftAddress, tokenId) {
        s_listings[nftAddress][tokenId].likes -= 1;
        emit BookDisliked(nftAddress, tokenId);
    }

    ///////////////////////
    // Getter Functions //
    /////////////////////
    function getListing(
        address nftAddress,
        uint256 tokenId
    ) external view returns (Listing memory) {
        return s_listings[nftAddress][tokenId];
    }

    function getProceeds(
        address author,
        address nftAddress,
        uint256 tokenId
    ) external view returns (uint256) {
        return s_proceeds[author][nftAddress][tokenId];
    }

    function getContributors(
        address nftAddress,
        uint256 tokenId
    ) external view returns (Listing memory) {
        return s_listings[nftAddress][tokenId];
    }
}
