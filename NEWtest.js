const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AITUSE2327MOD Token", function () {
    let Token, token, owner, addr1, addr2;
    const initialSupply = ethers.parseUnits("5000", 18); // Custom supply

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        Token = await ethers.getContractFactory("AITUSE2327MOD");
        token = await Token.deploy(owner.address, initialSupply);
        await token.deployed();
    });

    it("Should set the correct owner", async function () {
        expect(await token.getOwner()).to.equal(owner.address);
    });

    it("Should mint the correct initial supply to the owner", async function () {
        const ownerBalance = await token.balanceOf(owner.address);
        expect(ownerBalance).to.equal(initialSupply);
    });

    it("Should return the correct total supply", async function () {
        expect(await token.getTotalSupply()).to.equal(initialSupply);
    });

    it("Should transfer tokens and log transaction details", async function () {
        const transferAmount = ethers.parseUnits("10", 18);
        await expect(token.transfer(addr1.address, transferAmount))
            .to.emit(token, "TransactionDetails")
            .withArgs(owner.address, addr1.address, transferAmount, anyValue);

        expect(await token.balanceOf(addr1.address)).to.equal(transferAmount);
    });

    it("Should store transaction details in history", async function () {
        const transferAmount = ethers.parseUnits("10", 18);
        await token.transfer(addr1.address, transferAmount);
        const transactions = await token.retrieveTransactionInformation();

        expect(transactions.length).to.equal(1);
        expect(transactions[0].sender).to.equal(owner.address);
        expect(transactions[0].receiver).to.equal(addr1.address);
        expect(transactions[0].amount).to.equal(transferAmount);
    });
});
