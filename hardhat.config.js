//require("@nomicfoundation/hardhat-toolbox");
/**
 * @type import(‘hardhat/config’).HardhatUserConfig
 */
 require("dotenv").config();
 require("@nomiclabs/hardhat-ethers");
 const { API_URL, PRIVATE_KEY } = process.env;
 module.exports = {
  solidity: {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    defaultNetwork: "fuji",
    networks: {
      hardhat: {},
      fuji: {
        url: API_URL,
        accounts: [`0x${PRIVATE_KEY}`],
      },
    },
 };


// /** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: {
//     version: "0.8.9",
//     settings: {
//       optimizer: {
//         enabled: true,
//         runs: 1000,
//       },
//     },
//   },
  
// };


