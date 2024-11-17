import { expect } from "chai";
import { ethers } from "hardhat";
import { DegenToken } from "../typechain-types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("DegenToken", function () {
  let degenToken: DegenToken;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];

  beforeEach(async function () {
    // Get the SignerWithAddress objects
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    // Deploy the contract
    const DegenToken = await ethers.getContractFactory("DegenToken");
    degenToken = await DegenToken.deploy("DegenToken", "DGN");
    await degenToken.deployed();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await degenToken.owner()).to.equal(owner.address);
    });

    it("Should set the right token name and symbol", async function () {
      expect(await degenToken.name()).to.equal("DegenToken");
      expect(await degenToken.symbol()).to.equal("DGN");
    });

    it("Should set the right decimals", async function () {
      expect(await degenToken.decimals()).to.equal(1);
    });
  });

  describe("Minting", function () {
    it("Should allow owner to mint tokens", async function () {
      await degenToken.mint(addr1.address, 100);
      expect(await degenToken.balanceOf(addr1.address)).to.equal(100);
    });

    it("Should fail if non-owner tries to mint", async function () {
      await expect(
        degenToken.connect(addr1).mint(addr2.address, 100)
      ).to.be.revertedWithCustomError(degenToken, "NotOwner");
    });
  });

  describe("Store Operations", function () {
    it("Should allow owner to add store items", async function () {
      await degenToken.addStoreItem("Sword", 50);
      const item = await degenToken.getStoreItem(0);
      expect(item.name).to.equal("Sword");
      expect(item.price).to.equal(50);
      expect(item.exists).to.be.true;
      expect(item.isRedeemed).to.be.false;
    });

    it("Should fail if non-owner tries to add store items", async function () {
      await expect(
        degenToken.connect(addr1).addStoreItem("Sword", 50)
      ).to.be.revertedWithCustomError(degenToken, "NotOwner");
    });
  });

  describe("Token Redemption", function () {
    beforeEach(async function () {
      await degenToken.addStoreItem("Sword", 50);
      await degenToken.mint(addr1.address, 100);
    });

    it("Should allow users to redeem tokens for items", async function () {
      await degenToken.connect(addr1).redeemTokenForItem(0);
      const item = await degenToken.getStoreItem(0);
      expect(item.isRedeemed).to.be.true;
      expect(await degenToken.balanceOf(addr1.address)).to.equal(50);
    });

    it("Should fail if item does not exist", async function () {
      await expect(
        degenToken.connect(addr1).redeemTokenForItem(99)
      ).to.be.revertedWithCustomError(degenToken, "ItemNotAvailable");
    });

    it("Should fail if item is already redeemed", async function () {
      await degenToken.connect(addr1).redeemTokenForItem(0);
      await expect(
        degenToken.connect(addr1).redeemTokenForItem(0)
      ).to.be.revertedWithCustomError(degenToken, "ItemAlreadyRedeemed");
    });

    it("Should fail if user has insufficient balance", async function () {
      await degenToken.addStoreItem("Expensive Item", 200);
      await expect(
        degenToken.connect(addr1).redeemTokenForItem(1)
      ).to.be.revertedWithCustomError(degenToken, "InsufficientBalance");
    });
  });

  describe("Token Transfers", function () {
    beforeEach(async function () {
      await degenToken.mint(addr1.address, 100);
    });

    it("Should transfer tokens between accounts", async function () {
      await degenToken.connect(addr1).transferTokens(addr2.address, 50);
      expect(await degenToken.balanceOf(addr1.address)).to.equal(50);
      expect(await degenToken.balanceOf(addr2.address)).to.equal(50);
    });

    it("Should fail if sender has insufficient balance", async function () {
      await expect(
        degenToken.connect(addr1).transferTokens(addr2.address, 150)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
    });
  });
});