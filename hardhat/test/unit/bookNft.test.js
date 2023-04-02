const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("bookNft test", function () {
          let bookNft, deployer;
          beforeEach(async function () {
              accounts = await ethers.getSigners();
              deployer = accounts[0];
              await deployments.fixture(["booknft"]);
              bookNft = await ethers.getContract("BookNft", deployer);
          });
          describe("Constructor", () => {
              it("Initializes the NFT Correctly", async () => {
                  const name = await bookNft.name();
                  const symbol = await bookNft.symbol();
                  const tokenCounter = await bookNft.getTokenCounter();
                  assert.equal(name, "BookNft");
                  assert.equal(symbol, "BNFT");
                  assert.equal(tokenCounter.toString(), "0");
              });
          });
          describe("Mint NFT", () => {
              beforeEach(async () => {
                  const txResponse = await bookNft.mintNft("hola");
                  await txResponse.wait(1);
              });
              it("Allows users to mint an NFT, and updates appropriately", async () => {
                  const tokenURI = await bookNft.tokenURI(0);
                  const tokenCounter = await bookNft.getTokenCounter();
                  assert.equal(tokenURI, "data:application/json;base64,hola");
                  assert.equal(tokenCounter.toString(), "1");
              });
              it("Show the correct balance and owner of an NFT", async () => {
                  const owner = await bookNft.ownerOf("0");
                  const deployerAddress = deployer.address;
                  const deployerBalance = await bookNft.balanceOf(deployerAddress);

                  assert.equal(deployerBalance.toString(), "1");
                  assert.equal(owner, deployerAddress);
              });
          });
          describe("Mint NFT Incorrectly", () => {
              it("reverts if tokenURI is empty", async () => {
                  await expect(bookNft.mintNft("")).to.be.revertedWith("URINotProvided");
              });
          });
          describe("Modify Token URI", () => {
              beforeEach(async () => {
                  const txResponse = await bookNft.mintNft("hola");
                  await txResponse.wait(1);
              });
              it("Allows users to modify Token URI", async () => {
                  await bookNft.modifyTokenURI(0, "chau");
                  const tokenURI = await bookNft.tokenURI(0);
                  assert.equal(tokenURI, "data:application/json;base64,chau");
              });
          });
      });
