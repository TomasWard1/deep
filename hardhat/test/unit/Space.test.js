const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Space Unit Test", () => {
          let space, spaceContract, bookNft, bookNftContract;
          const PRICE = ethers.utils.parseEther("0.01");
          const TOKEN_ID = 0;
          const UNITS = 5;

          beforeEach(async () => {
              accounts = await ethers.getSigners(); // could also do with getNamedAccounts
              deployer = accounts[0];
              user = accounts[1];
              await deployments.fixture(["all"]);
              spaceContract = await ethers.getContract("Space");
              space = spaceContract.connect(deployer);
              bookNftContract = await ethers.getContract("BookNft");
              bookNft = bookNftContract.connect(deployer);
              await bookNft.mintNft("tokenURIencoded");
          });

          describe("List Item", function () {
              it("emits an event after listing a book", async () => {
                  expect(await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE)).to.emit(
                      "ItemListed"
                  );
              });

              it("exclusively list items that haven't been listed", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  const error = `AlreadyListed("${bookNft.address}", ${TOKEN_ID})`;
                  await expect(
                      space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE)
                  ).to.be.revertedWith(`AlreadyListed("${bookNft.address}", ${TOKEN_ID})`);
              });

              it("exclusively allows owners to list", async () => {
                  space = spaceContract.connect(user);
                  await bookNft.approve(user.address, TOKEN_ID);
                  await expect(
                      space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE)
                  ).to.be.revertedWith("NotOwner");
              });

              it("updates listing with author, units, unitPrice", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  const listing = await space.getListing(bookNft.address, TOKEN_ID);
                  expect(listing.unitPrice.toString()).to.equal(PRICE.toString());
                  expect(listing.author).to.equal(deployer.address);
                  expect(listing.units.toString()).to.equal(UNITS.toString());
              });
              it("initializes the proceeds to 0", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  const proceeds = await space.getProceeds(
                      deployer.address,
                      bookNft.address,
                      TOKEN_ID
                  );
                  expect(proceeds.toString()).to.equal("0");
              });
          });

          describe("Cancel listing", function () {
              it("reverts if not listed", async () => {
                  const error = `NotListed("${bookNft.address}", ${TOKEN_ID})`;
                  await expect(space.cancelListing(bookNft.address, TOKEN_ID)).to.be.revertedWith(
                      error
                  );
              });

              it("reverts if anyone but the owner tries to call", async () => {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  space = spaceContract.connect(user);
                  await bookNft.approve(user.address, TOKEN_ID);
                  await expect(space.cancelListing(bookNft.address, TOKEN_ID)).to.be.revertedWith(
                      "NotOwner"
                  );
              });

              it("emits event and removes listing", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  expect(await space.cancelListing(bookNft.address, TOKEN_ID)).to.emit(
                      "ItemCanceled"
                  );
                  const listing = await space.getListing(bookNft.address, TOKEN_ID);
                  assert(listing.unitPrice.toString() == "0");
              });
          });
      });
