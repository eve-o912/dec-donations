require('dotenv').config();
const { ethers } = require("ethers");

const alchemyApiUrl = process.env.ALCHEMY_API_URL;
const provider = new ethers.providers.JsonRpcProvider(alchemyApiUrl);

async function main() {
  const blockNumber = await provider.getBlockNumber();
  console.log("Current block number:", blockNumber);
}

main().catch(console.error);
