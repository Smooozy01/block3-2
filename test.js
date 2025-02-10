const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AITUSE2327 Token", function () {
    let Token, token, owner, addr1, addr2;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("AITUSE2327");
        [owner, addr1, addr2] = await ethers.getSigners();
        token = await Token.deploy();
        await token.deployed();
    });

    it("Should have correct name and symbol", async function () {
        expect(await token.name()).to.equal("AITUSE2327");
        expect(await token.symbol()).to.equal("AITUSE");
    });

    it("Should mint 2000 tokens to the deployer", async function () {
        const ownerBalance = await token.balanceOf(owner.address);
        expect(ownerBalance).to.equal(ethers.parseUnits("2000", 18));
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

    it("Should return latest transaction timestamp", async function () {
        const timestampString = await token.getLatestTransactionTimestamp();
        expect(timestampString).to.include("Timestamp: ");
    });

    it("Should return transaction sender address", async function () {
        expect(await token.getTransactionSender()).to.equal(owner.address);
    });

    it("Should return transaction receiver address", async function () {
        expect(await token.getTransactionReceiver(addr1.address)).to.equal(addr1.address);
    });
});
