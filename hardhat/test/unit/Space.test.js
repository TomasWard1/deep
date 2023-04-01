const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");
const { BigNumber } = require("ethers");

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Space Unit Test", () => {
          let space, spaceContract, bookNft, bookNftContract;
          const PRICE = ethers.utils.parseEther("0.01");
          const TOKEN_ID = 0;
          const UNITS = 5;
          const UNITS_FUNDED = 2;

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
          describe("fundBook", function () {
              it("reverts if the item isnt listed", async function () {
                  await expect(
                      space.fundBook(bookNft.address, TOKEN_ID, UNITS)
                  ).to.be.revertedWith("NotListed");
              });
              it("reverts if the price isnt met", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  await expect(
                      space.fundBook(bookNft.address, TOKEN_ID, UNITS_FUNDED)
                  ).to.be.revertedWith("PriceNotMet");
              });
              it("reverts if the units are not in range", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  const INCORRECT_UNITS = 10;
                  await expect(
                      space.fundBook(bookNft.address, TOKEN_ID, INCORRECT_UNITS, {
                          value: PRICE.mul(INCORRECT_UNITS),
                      })
                  ).to.be.revertedWith("UnitsNotInRange");
              });
              it("updates internal proceeds record, the listing units, the contributors", async function () {
                  // list by deployer
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);

                  // fund by user
                  space = spaceContract.connect(user);
                  const TOTAL_FUNDED = PRICE.mul(UNITS_FUNDED);
                  expect(
                      await space.fundBook(bookNft.address, TOKEN_ID, UNITS_FUNDED, {
                          value: TOTAL_FUNDED,
                      })
                  ).to.emit("BookFunded");
                  const deployerProceeds = await space.getProceeds(
                      deployer.address,
                      bookNft.address,
                      TOKEN_ID
                  );
                  const listing = await space.getListing(bookNft.address, TOKEN_ID);
                  const fundedByContributor = await space.getContributorAmountFunded(user.address);

                  const REMAINING_UNITS = UNITS - UNITS_FUNDED;

                  expect(listing.units.toString()).to.equal(REMAINING_UNITS.toString());
                  expect(deployerProceeds.toString()).to.equal(TOTAL_FUNDED.toString());
                  expect(fundedByContributor.toString()).to.equal(TOTAL_FUNDED.toString());
              });

              it("deletes book from listing if fully funded", async function () {
                  await space.listItem(bookNft.address, TOKEN_ID, UNITS, PRICE);
                  space = spaceContract.connect(user);
                  expect(
                      await space.fundBook(bookNft.address, TOKEN_ID, UNITS, {
                          value: PRICE.mul(UNITS),
                      })
                  ).to.emit("BookRemoved");
                  const listing = await space.getListing(bookNft.address, TOKEN_ID);
                  expect(listing.unitPrice.toString()).to.equal("0");
              });
          });
      });
