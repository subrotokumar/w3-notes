require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.6.0",
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
      accounts: [
        "0xa9b604aaca5e7115c9bd9be7ff31a672f0fccece1c0eee5b8e0307854007e3f4",
      ],
    },
  },
};
