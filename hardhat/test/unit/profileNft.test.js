const { assert } = require("chai");
const { network, deployments, ethers } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("ProfileNft test", function () {
          let profileNft, deployer;
          beforeEach(async function () {
              accounts = await ethers.getSigners();
              deployer = accounts[0];
              await deployments.fixture(["profilenft"]);
              profileNft = await ethers.getContract("ProfileNft", deployer);
          });
          describe("Constructor", () => {
              it("Initializes the NFT Correctly", async () => {
                  const name = await profileNft.name();
                  const symbol = await profileNft.symbol();
                  const tokenCounter = await profileNft.getTokenCounter();
                  assert.equal(name, "ProfileNft");
                  assert.equal(symbol, "PNFT");
                  assert.equal(tokenCounter.toString(), "0");
              });
          });
          describe("Mint NFT", () => {
              beforeEach(async () => {
                  const txResponse = await profileNft.mintNft("hola");
                  await txResponse.wait(1);
              });
              it("Allows users to mint an NFT, and updates appropriately", async () => {
                  const tokenURI = await profileNft.tokenURI(0);
                  const tokenCounter = await profileNft.getTokenCounter();
                  assert.equal(tokenURI, "data:application/json;base64,hola");
                  assert.equal(tokenCounter.toString(), "1");
              });
              it("Show the correct balance and owner of an NFT", async () => {
                  const owner = await profileNft.ownerOf("0");
                  const deployerAddress = deployer.address;
                  const deployerBalance = await profileNft.balanceOf(deployerAddress);

                  assert.equal(deployerBalance.toString(), "1");
                  assert.equal(owner, deployerAddress);
              });
          });
          describe("Modify Token URI", () => {
              beforeEach(async () => {
                  const txResponse = await profileNft.mintNft("hola");
                  await txResponse.wait(1);
              });
              it("Allows users to modify Token URI", async () => {
                  await profileNft.modifyTokenURI(0, "chau");
                  const tokenURI = await profileNft.tokenURI(0);
                  assert.equal(tokenURI, "data:application/json;base64,chau");
              });
          });
      });
