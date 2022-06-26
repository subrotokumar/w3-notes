const { ethers } = require("hardhat");

async function main() {
  const NoteContract = await ethers.getContractFactory("NoteContract");
  const noteContract = await NoteContract.deploy();

  await noteContract.deployed();

  console.log("NoteContract deployed to:", noteContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
