const { ethers, network } = require("hardhat");
const { moveBlocks } = require("../utils/move-blocks");

async function mint() {
    const profileNft = await ethers.getContract("ProfileNft");

    console.log("Minting Profile NFT...");
    const mintTx = await profileNft.mintNft("banana");
    const mintTxReceipt = await mintTx.wait(1);
    const tokenId = mintTxReceipt.events[0].args.tokenId;
    const tokenURI = await profileNft.tokenURI(tokenId);
    console.log(`Token ID: ${tokenId}`);
    console.log(`NFT Address: ${profileNft.address}`);
    console.log(`Token URI: ${tokenURI}`);

    if (network.config.chainId == 31337) {
        await moveBlocks(1, (sleepAmount = 1000));
    }
}

mint()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
