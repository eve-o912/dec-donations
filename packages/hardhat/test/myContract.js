const { expect } = require("chai");

describe("MyContract", function () {
  let MyContract;
  let myContract;
  let owner;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    MyContract = await ethers.getContractFactory("MyContract");
    [owner] = await ethers.getSigners();

    // Deploy the contract
    myContract = await MyContract.deploy();
  });

  it("should deploy the contract correctly", async function () {
    // Check if the contract was deployed
    expect(await myContract.greeting()).to.equal("Hello, Hardhat!");
  });

  it("should have the correct owner address", async function () {
    // Check the owner of the contract
    expect(await myContract.owner()).to.equal(owner.address);
  });
});
