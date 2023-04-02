const { ethers, network } = require("hardhat");
const { moveBlocks, sleep } = require("../utils/move-blocks");
const { BigNumber } = require("ethers");

const TOKEN_ID = 0;
const UNITS_FUNDED = 2;

async function fundBook() {
    const space = await ethers.getContract("Space");
    const bookNft = await ethers.getContract("BookNft");

    const listing = await space.getListing(bookNft.address, TOKEN_ID);
    const unitPrice = listing.unitPrice;
    const units = listing.units;

    if (UNITS_FUNDED <= units) {
        console.log(`Funding ${UNITS_FUNDED} book copies with ${unitPrice}...`);
        const TOTAL_FUNDED = BigNumber.from(unitPrice).mul(UNITS_FUNDED);
        console.log(`Total Funded: ${TOTAL_FUNDED}`);
        const fundTx = await space.fundBook(bookNft.address, TOKEN_ID, UNITS_FUNDED, {
            value: TOTAL_FUNDED,
        });
        const fundTxReceipt = await fundTx.wait(1);
        const events = fundTxReceipt.events;
        console.log(events);
        console.log("Funded NFT!!");
        if (network.config.chainId == "31337") {
            await moveBlocks(1, (sleepAmount = 1000));
        }
    }
}

fundBook()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
