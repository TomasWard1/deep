const { ethers, network } = require("hardhat");
const { moveBlocks } = require("../utils/move-blocks");

async function mintAndList() {
    const PRICE = ethers.utils.parseEther("1");
    const UNITS = 3;
    const bookNft = await ethers.getContract("BookNft");
    const space = await ethers.getContract("Space");

    console.log("Minting Book NFT...");
    const mintTx = await bookNft.mintNft("banana");
    const mintTxReceipt = await mintTx.wait(1);
    const tokenId = mintTxReceipt.events[0].args.tokenId;
    const tokenURI = await bookNft.tokenURI(tokenId);
    console.log(`Token ID: ${tokenId}`);
    console.log(`NFT Address: ${bookNft.address}`);
    console.log(`Token URI: ${tokenURI}`);

    console.log("Listing NFT...");
    const listTx = await space.listItem(bookNft.address, tokenId, UNITS, PRICE);
    await listTx.wait(1);
    console.log(`Listed!! TokenId ${tokenId}`);

    if (network.config.chainId == 31337) {
        await moveBlocks(1, (sleepAmount = 1000));
    }
}

mintAndList()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
