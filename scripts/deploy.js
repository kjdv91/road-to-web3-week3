
const hre = require("hardhat");

async function main() {
 
  const Cryptomano = await hre.ethers.getContractFactory("CryptomanoBattle");
  const cryptomano = await Cryptomano.deploy();

  await cryptomano.deployed();

  console.log('Contract Address deployed' , cryptomano.address);
  
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
