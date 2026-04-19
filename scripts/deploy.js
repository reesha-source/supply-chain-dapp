import { network } from "hardhat";

async function main() {
  const { ethers } = await network.connect("amoy");

  const contract = await ethers.deployContract("reesha_supplychain");
  await contract.waitForDeployment();

  console.log("Contract deployed to:", await contract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
