require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
// require("@nomicfoundation/hardhat-ethers");
require("dotenv/config")


const ALCHEMY_URL = process.env.ALCHEMY_URL;
const MUMBAI_KEY = process.env.PRIVATE_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN;


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.10",

  networks:{
    mumbai:{
      url: ALCHEMY_URL,
      accounts:[MUMBAI_KEY],
    },
  },
  etherscan:{
    apiKey: POLYGONSCAN_API_KEY
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
