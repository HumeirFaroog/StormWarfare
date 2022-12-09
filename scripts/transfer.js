// import ERC721 from ""
import 'dotenv/config'
import { ethers } from 'hardhat';

//node provider 

const nodeProvider = "avaclach";
const customerAddress = new ethers.providers.JsonRpcProvider(nodeProvider);

//my  wallets addesses

const  contractAddress = "";
const myWalletAddress = "";

const signer = new ethers.Wallet(process.env.PRICATE_KEY,customerAddress);

const contract = new ethers.Contract(contractAddress, ERC721.abi, signer);

const result = await contract.transfer(myWalletAddress, 1)

console.log(`Transfer: ${JSON.stringify(result)}`)
