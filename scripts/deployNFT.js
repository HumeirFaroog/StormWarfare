// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
require("@nomiclabs/hardhat-ethers");

const hre = require("hardhat");


async function main() {
  // We get the contract to deploy
  const NFT = await hre.ethers.getContractFactory("NFT")
  const nFT = await NFT.deploy();

  await nFT.deployed();

  console.log("NFT deployed to:", nFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });