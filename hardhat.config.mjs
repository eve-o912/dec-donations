import{HardhatUserConfig}from'hardhat/config';
import"@nomicfoundation/hardhat-toolbox";

/** @type {HardhatUserConfig} */

const config = {
  solidity: "0.8.28",
  networks: { sepolia: {
    https://eth-sepolia.alchemyapi.io/v2/YOUR_API_KEY.

    accounts: [`0x${process.env.PRIVATE_KEY}`], // Replace with your private key
  },
    hardhat: {}
  }
};

export default config;
