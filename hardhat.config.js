require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan"); 
require("dotenv").config()

// const { API_URL, } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    mantle: {
      url: "https://rpc.testnet.mantle.xyz/",
      accounts: [process.env.PRIV_KEY] // Uses the private key from the .env file
    }
  },
  etherscan: {
    apiKey: {
     mantle: "https://explorer.testnet.mantle.xyz/api"
    },
    customChains: [
      {
        network: "mantle",
        chainId: 5001,
        urls: {
          apiURL: "https://explorer.testnet.mantle.xyz/api",
          browserURL: "https://explorer.testnet.mantle.xyz"
        }
      }
    ]
  }
};




