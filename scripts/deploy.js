// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
require("@nomiclabs/hardhat-ethers");

const hre = require("hardhat");


async function main() {
  // We get the contract to deploy
  const ERC4907 = await hre.ethers.getContractFactory("ERC4907")
  const eRC4907 = await ERC4907.deploy("T", "T");

  await eRC4907.deployed();

  console.log("eRC4907 deployed to:", eRC4907.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
