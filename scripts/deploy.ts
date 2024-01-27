const { ethers, upgrades } = require("hardhat");

async function main() {
   const NFTContract = await ethers.getContractFactory("AstraNovaNFT");
   console.log("Deploying NFTContract...");
   const astranovaNFT = await upgrades.deployProxy(NFTContract, {
      initializer: "initialize",
   });
   await astranovaNFT.waitForDeployment();
   console.log("V1 Contract deployed to:", astranovaNFT.address);
}

main().catch((error) => {
   console.error(error);
   process.exitCode = 1;
 });