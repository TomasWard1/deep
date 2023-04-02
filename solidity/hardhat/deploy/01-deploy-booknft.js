const {
    developmentChains,
    VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config");
const { network } = require("hardhat");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    let args = [];
    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS;

    log("---------------------------------------");
    const bookNft = await deploy("BookNft", {
        from: deployer,
        log: true,
        args: args,
        waitConfirmations: waitBlockConfirmations,
    });
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...");
        await verify(bookNft.address, args);
    }
    log("---------------------------------------");
};

module.exports.tags = ["all", "booknft"];
